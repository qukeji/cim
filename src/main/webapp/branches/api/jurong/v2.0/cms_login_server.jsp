<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				tidemedia.app.system.*,
				java.net.URLEncoder,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*"%>
<%@ page import="static tidemedia.cms.user.UserInfoUtil.SaveTokenCookie" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config1.jsp"%>
<%
    String phone = getParameter(request,"phone");
    String access_token = getParameter(request,"access_token");
    JSONObject json = new JSONObject();



    if(phone==null||phone.equals("")||access_token.equals("")){
        json.put("status",501);
        json.put("message","参数缺少");
    }else{

            String ip = request.getHeader("HTTP_X_FORWARDED_FOR");
            if (ip  == null)
                ip = request.getRemoteAddr();

            TableUtil tu = new TableUtil();
            TableUtil tu_user = new TableUtil("user");

            String sql = "select * from userinfo where Tel='"+phone+"'";
            ResultSet rs = tu_user.executeQuery(sql);

            if(rs.next()){
                json.put("status",200);
                json.put("message","成功");

                int id = rs.getInt("id");
                String Username = tu_user.convertNull(rs.getString("Username"));
               
                UserInfo userinfo = new UserInfo(id);
                JSONObject json_access_token= UserInfoUtil.getJuxianInfo(userinfo);
                if (!access_token.equals(json_access_token.getString("JuxianToken"))){
                    json.put("message","验证失败");
                }else {
                     //插入登录日志
                    String Sql = "insert into login_log(Username,User,IsSuccess,IsCookie,IP,Host,Date) values('"+tu_user.SQLQuote(Username)+"',"+id+",1,0,'"+ip+"','"+ tu_user.SQLQuote(request.getRemoteHost()) + "',now())";
                    tu.executeUpdate(Sql);
    
                    //更新登录时间
                    Sql = "update userinfo set LastLoginDate=now() where id="+id;
                    tu_user.executeUpdate(Sql);
                    
                    userinfo.setUsername2(Username);
                    session.setAttribute("CMSUserInfo", userinfo);
                    session.setMaxInactiveInterval(12 * 30 * 24 * 3600);//以时为单位，即在没有活动360天后，session将失效
                    json.put("sessionid", session.getId());
                    appUserInfo appUserInfo = new appUserInfo();
                    appUserInfo.setId(id);
                    appUserInfo.setTitle(Username);
                    appUserInfo.setTruename(Username);
                    session.setAttribute("appUserInfo", appUserInfo);
                    json.put("userid", id);
                    json.put("message","验证成功");
                }
            }else{
                json.put("status",500);
                json.put("message","用户不存在");
            }
            tu_user.closeRs(rs);

    }
    out.println(json);

%>
