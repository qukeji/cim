<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="tidemedia.app.system.appUserInfo" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>

<%@ include file="config1.jsp"%>
<%@ include file="common.jsp"%>

<%
    //APP 用户密码修改
%>
<%
    int site = getIntParameter(request,"site");//站点名称
    String phone = getParameter(request,"phone");//手机号
    String password = getParameter(request,"password");//新密码
    String yzm = getParameter(request,"yzm");//
    appUserInfo appUserInfo=(appUserInfo) session.getAttribute("appUserInfo");
    int userid=0;//用户id
    java.util.Date date = new java.util.Date();
    long time= date.getTime()/1000;//获取当前时间戳
    String cms_register=(String)TIDE.get("cms_register"); //获取用户所数据库
    String channel_code=(String)TIDE.get("code");  //获取验证码数据库
    int siteflag=0;//用户siteflag
    String phone_user="";//用户电话
    JSONObject json=new JSONObject();
    //判断传值  1.如果用户登录修改判断session中的值
    if(appUserInfo!=null){
        userid=appUserInfo.getId();//获取session中的用户id
        if (password.equals("")||yzm.equals("")){
            json.put("message","密码或者验证码不能为空");
            out.println(json);
            return;
        }
        if (userid==0){
            json.put("message","对不起！请登录后再执行此操作");
            out.println(json);
            return;
        }
        //判断传值的site和session所属的用户是否在一致
        String sql_session="select id,siteflag,password,phone from "+cms_register+" where  Active=1 and id="+userid;
        TableUtil tu=new TableUtil();
        ResultSet rs=tu.executeQuery(sql_session);
        if (rs.next()){
            siteflag=rs.getInt("siteflag");
            phone_user=convertNull(rs.getString("phone"));

            if(siteflag!=site){
                json.put("message","请登录后在操作");
                out.println(json);
                return;
            }
            if(phone_user.equals("")||phone_user.length()==0){
                json.put("messagge","未绑定手机账号的用户不能进行密码修改操作");
                out.println(json);
                return;
            }
        }else{
            json.put("message","该用户不存在");
            out.println(json);
            return;
        }
        tu.closeRs(rs);  
    }else {
        if(password.equals("")||yzm.equals("")||phone.equals("")){
            json.put("message","密码，手机号。验证码都不能为空");
            out.println(json);
            return;
        }
        //判断手机号所在的用户是否存在
        String sql_phone="select id,siteflag,phone from "+cms_register+" where Active=1 and phone="+phone+"";
        TableUtil tu_phone=new TableUtil();
        ResultSet rs_phone=tu_phone.executeQuery(sql_phone);
        if (rs_phone.next()){
            siteflag=rs_phone.getInt("siteflag");
            phone_user=convertNull(rs_phone.getString("phone"));
            if(siteflag!=site){
                json.put("message","请登录后在操作");
                out.println(json);
                return;
            }
            if(phone_user.equals("")||phone_user.length()==0){
                json.put("messagge","未绑定手机账号的用户不能进行密码修改操作");
                out.println(json);
                return;
            }
        }else{
            json.put("message","该用户不存在");
            out.println(json);
            return;
        }
        tu_phone.closeRs(rs_phone);
    }
    //密码格式校验
    String regEx = "^[a-zA-Z][a-zA-Z0-9_-]{5,19}$";
    if (!password.matches(regEx)){
        json.put("message","密码为必须为字母开头6-20为字母数字下划线");
        out.println(json);
        return;
    }
    //判断验证码是否正确
    String sql_code="select Title,Time from "+channel_code+" where siteflag="+site+" and Active=1 and Tel="+phone_user+" order by Time desc limit 1";
    TableUtil tu_code=new TableUtil();
    ResultSet rs_code=tu_code.executeQuery(sql_code);
    String Title="";
    int Time=0;
    if(rs_code.next()){
        Title=convertNull(rs_code.getString("Title"));
        Time=rs_code.getInt("Time");
        if(!Title.equals(yzm)){
            json.put("message","对不起！验证码不正确");
            out.println(json);
            return;
        }
        if (Time+300<time){
            json.put("message","对不起！验证码已失效");
            out.println(json);
            return;
        }
    }else {
        json.put("message","对不起！没有查询到验证码");
        out.println(json);
        return;
    }
    tu_code.closeRs(rs_code);
    password=StringUtils.getMD5(StringUtils.getMD5(password));//密码采用MD5双加密方式
    //更新
    String sql_update="update "+cms_register+" set password='"+password+"' where siteflag='"+site+"' and Active=1 and phone='"+phone_user+"'";
    TableUtil tu_update=new TableUtil();
    int gid=tu_update.executeUpdate(sql_update);
    if(gid!=0){
        json.put("message","修改成功");
        json.put("status","200");
    }else {
        json.put("message","修改失败");
        json.put("status","500");
    }
    out.println(json);

%>
