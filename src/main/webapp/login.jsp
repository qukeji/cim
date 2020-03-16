<%@ page import="tidemedia.cms.user.UserInfo,java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config1.jsp"%>
 
<%
String Username		= getParameter(request,"Username");
String Password		= getParameter(request,"Password");
String Url			= getParameter(request,"Url");

//int	   Role		= getIntParameter(request,"Role");

int result = 0 ;
if(!Username.equals(""))
{
	if(!Password.equals(""))
	{
		UserInfo userinfo = new UserInfo();

		Cookie cookie = new Cookie("Username",URLEncoder.encode(Username,"UTF-8"));
		cookie.setMaxAge(365*24*60*60);
		response.addCookie(cookie);
		
		byte[] bytes =Password.getBytes("UTF-8");
	    byte[] decoded = java.util.Base64.getDecoder().decode(bytes);
		Password = new String(decoded);

		result = userinfo.Authorization(request,response,Username,Password);
		//0 登录失败 1登录成功 2登录失败，帐号过期 3登陆次数太多
		
	}
	else
	{
		result = 4 ;//请输入密码
	}
}
else
{
	result = 5 ;//请输入用户名
}

out.println(result);
%>