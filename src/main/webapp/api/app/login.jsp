<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.text.SimpleDateFormat,
				org.json.JSONObject,
				java.text.ParseException,
				java.util.regex.Pattern,
				 java.util.regex.Matcher,
				java.sql.*"%>
<%@ page import="tidemedia.app.system.appUserInfo" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%@ include file="common.jsp"%>
<%
    //APP 用户登录
%>
<%
    JSONObject o = new JSONObject();
    try {
        String phone = getParameter(request,"username");
        String password = getParameter(request,"password");
        String code = getParameter(request,"code");//验证码
        int site = getIntParameter(request,"site");//站点名称
        
        int channelid=(int)TIDE.get("app_user_channelid");//获取用户所在频道，用于注册用户的信息修改
      
        int login_mode=0;
        java.util.Date date = new java.util.Date();
        long time= date.getTime()/1000;//获取当前时间戳

        //判断参数
        if(phone.equals("")){
            o.put("message","手机号不能为空");
            out.println(o);
            return;
        }
        if(password.equals("")&&code.equals("")){
            o.put("message","参数缺失");
            out.println(o);
            return;
        }

        //通过用户名查找用户
        String cms_register=(String)TIDE.get("cms_register"); //获取用户所数据库
        String channel_code=(String)TIDE.get("code");  //获取验证码数据库
        String sql="select id,Title,avatar,password from "+cms_register+" where siteflag="+site+" and  Active=1 and phone="+phone;
        TableUtil tu=new TableUtil();
        ResultSet RS=tu.executeQuery(sql);
        if(!RS.next()){
            String sql1="select Title,Time from "+channel_code+" where siteflag="+site+" and  Active=1 and Tel="+phone+" order by Time desc limit 1 ";
            TableUtil tu1=new TableUtil();
            ResultSet RS1=tu1.executeQuery(sql1);
            if(RS1.next()) {
                String Title = RS1.getString("Title");
                //out.println(Title);
                int time1 = RS1.getInt("Time");
                if (!Title.equals(code)) {
                    o.put("message", "对不起！验证码错误");
                    out.println(o);
                    return;
                }
                if (time1 + 300 < time) {//与发送验证码时间对比，超过5分钟则失效
                    o.put("message", "对不起！验证码失效");
                    out.println(o);
                    return;
                }
            }else {//超过五分钟则失效
                o.put("message", "对不起！未查询到验证码");
                out.println(o);
                return;
            }
                
            String title = phone.substring(0, 3) + "****" + phone.substring(7, phone.length());
            String ip = request.getRemoteAddr();

            HashMap map=new HashMap();
            map.put("Title",title);
            map.put("password",StringUtils.getMD5(password));
            map.put("siteflag",site+"");
            // map.put("OrderNumber",OrderNumber+"");
            map.put("phone",phone);
            map.put("IP",ip);
            map.put("Category",0+"");
            map.put("Status",1+"");

            int gid2 = ItemUtil.addItemGetGlobalID(channelid, map);
            if(gid2!=0){
                //更新用户为登录状态
                //把用户数据保存在appUseInfo对象中

                //得到sessionid
                Document document=new Document(gid2);
                int userid=document.getId();//用户id
                String sessionId = session.getId();//sessionId
                appUserInfo appUserInfo=new appUserInfo(userid,cms_register);
                appUserInfo.setId(userid);
                appUserInfo.setTitle(title);
                appUserInfo.setTruename(title);
                session.setAttribute("appUserInfo", appUserInfo);

                ////更新用户的最后登录时间
                HashMap updatemap=new HashMap();
                updatemap.put("sessionTime",time+"");
                updatemap.put("session",sessionId);
                ItemUtil.updateItemByGid( channelid,updatemap, gid2,1);
                //输出用户登录成功信息
                o.put("message","用户登录成功");
                o.put("id",userid);
                o.put("username",title);
                o.put("login_mode",login_mode);
                o.put("sessionId",sessionId);
                o.put("avatar","");
                o.put("status",200);
                
            }else {
                o.put("status","500");
                o.put("message","登录失败");
            }
           
        }else {
            if (!password.equals("")){
                String password1=RS.getString("password");
               
               // if(!password.equals(password1)){
                if(!StringUtils.getMD5(password).equals(password1)){
                    o.put("message","对不起！密码不正确");
                    out.println(o);
                    login_mode=2;
                    return;
                    }
                }   
            if (!code.equals("")){
                String sql1="select Title,Time from "+channel_code+" where siteflag="+site+" and  Active=1 and Tel="+phone+" order by Time desc limit 1 ";
                TableUtil tu1=new TableUtil();
                ResultSet RS1=tu1.executeQuery(sql1);
                //验证码是否正确
                if(RS1.next()){
                    String Title=RS1.getString("Title");
                   // out.println(Title);
                    int time1=RS1.getInt("Time");
                     //out.println("发送验证码时间"+time1);
                    //out.println("目前时间时间"+time);
                    if (!Title.equals(code)){
                        o.put("message","对不起！验证码错误");
                        out.println(o);
                        return;
                    }
                    if(time1+300<time){
                        o.put("message","对不起！验证码失效");
                        out.println(o);
                        return;
                    }
                }else{
                    o.put("message", "对不起！未查询到验证码");
                    out.println(o);
                    login_mode=1;
                    return;
                }

                int itemid=RS.getInt("id");
                String username	= convertNull(RS.getString("Title"));//昵称
                String avatar=convertNull(RS.getString("avatar"));//头像
                Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
                if(pattern.matcher(username).matches()&&username.length()==11){
                    username = username.substring(0, 3) + "****" + username.substring(7, username.length());
                }
                //把用户数据保存在session域对象中
                appUserInfo appUserInfo=new appUserInfo(itemid,cms_register);
                appUserInfo.setTitle(username);
                appUserInfo.setTruename(username);
                appUserInfo.setId(itemid);
                session.setAttribute("appUserInfo", appUserInfo);

                //得到sessionid
                String sessionId = session.getId();
                ////更新用户的最后登录时间
                HashMap map=new HashMap();
                map.put("sessionTime",time+"");
                map.put("session",sessionId+"");
                ItemUtil.updateItemById(channelid,map,itemid,1);
                
                o.put("message","登录成功");
                o.put("username",username);
                o.put("userid",itemid);
                o.put("avatar",avatar);
                o.put("login_mode",login_mode);
            }
        }
        tu.closeRs(RS);
       
    }catch (Exception e){

        o.put("status","500");
        o.put("message","程序异常"+e.toString());
    }


    out.println(o);

%>
