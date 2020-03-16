 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config1.jsp"%>
<%
	String phone = getParameter(request,"phone");

	JSONObject json = new JSONObject();

	if(phone==null||phone.equals("")){
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
			
			//插入登录日志
			String Sql = "insert into login_log(Username,User,IsSuccess,IsCookie,IP,Host,Date) values('"+tu_user.SQLQuote(Username)+"',"+id+",1,0,'"+ip+"','"+ tu_user.SQLQuote(request.getRemoteHost()) + "',now())";
			tu.executeUpdate(Sql);

			//更新登录时间
			Sql = "update userinfo set LastLoginDate=now() where id="+id;
			tu_user.executeUpdate(Sql);

			//用户存在，存入session
			UserInfo userinfo = new UserInfo(id);
			session.setAttribute("CMSUserInfo",userinfo);
			session.setMaxInactiveInterval(12*30*24*3600);//以时为单位，即在没有活动360天后，session将失效


		}else{
			json.put("status",500);
			json.put("message","用户不存在");
		}
		tu_user.closeRs(rs);
	}

	out.println(json);

%>