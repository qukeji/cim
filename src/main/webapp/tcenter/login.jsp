<%@ page import="tidemedia.cms.user.UserInfo,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config1.jsp"%>
<%
String Username		= getParameter(request,"Username");
String Password		= getParameter(request,"Password");
String Url			= getParameter(request,"Url");
//int	   Role		= getIntParameter(request,"Role");

if(!Username.equals(""))
{
	if(!Password.equals(""))
	{
		UserInfo userinfo = new UserInfo();

		Cookie cookie = new Cookie("Username",java.net.URLEncoder.encode(Username,"UTF-8"));
		cookie.setMaxAge(365*24*60*60);
		response.addCookie(cookie);

		int result = userinfo.Authorization(request,response,Username,Password);
                //System.out.println(result+"===="+userinfo.getUsername2());
		//0 登录失败 1登录成功 2登录失败，帐号过期
		if(result==1)
		{
			if(Url.equals(""))
				response.sendRedirect("main.jsp");
			else
			{
				if(Url.endsWith("/index.jsp"))
					response.sendRedirect("main.jsp");
				else
					response.sendRedirect(Url);
			}
			return;
		}
		else
		{
		Cookie passwordcookie = new Cookie("Password",java.net.URLEncoder.encode("","UTF-8"));
		passwordcookie.setMaxAge(365*24*60*60);
		response.addCookie(passwordcookie);
	%>
		<script language="javascript">
		alert("用户名或密码错误!");
		history.back();
		</script>
	<%
		}
	}
	else
	{
	%>
		<script language="javascript">
		alert("请输入密码!");
		history.back();
		</script>
	<%
	}
}
else
{
	%>
		<script language="javascript">
		alert("请输入用户名!");
		history.back();
		</script>
	<%
}
%>
