<%@ page import="tidemedia.cms.user.UserInfo,
									java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config1.jsp"%>
 <%!
	public void ClearSession(String userName,HttpSession session){
		
		Util.postHttpUrl("http://127.0.0.1:888/cms/outsession.jsp?username="+userName+"&sessionid="+session.getId(),"");
		Util.postHttpUrl("http://127.0.0.1:888/vms/outsession.jsp?username="+userName+"&sessionid="+session.getId(),"");
		Util.postHttpUrl("http://127.0.0.1:888/tcenter/outsession.jsp?username="+userName+"&sessionid="+session.getId(),"");
		Util.postHttpUrl("http://127.0.0.1:888/live/outsession.jsp?username="+userName+"&sessionid="+session.getId(),"");
		//Util.postHttpUrl("http://127.0.0.1:888/cms/outsession.jsp?username="+UserName+"&sessionid="+session.getId());
	
	}
%>
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

		Cookie cookie = new Cookie("Username",URLEncoder.encode(Username,"UTF-8"));
		cookie.setMaxAge(365*24*60*60);
		response.addCookie(cookie);
		int result = userinfo.Authorization(request,response,Username,Password);
		Cookie cookie_Tcenter = new Cookie("tcenter_token", session.getId());
		cookie_Tcenter.setPath("/");
		cookie_Tcenter.setMaxAge(-1);
		response.addCookie(cookie_Tcenter);
		//0 登录失败 1登录成功 2登录失败，帐号过期
		if(result==3)
		{//登陆次数太多
		%>
			<script language="javascript">
		alert("尝试次数太多，稍后再试!");
		history.back();
		</script>
		<%
		return ;
		}
		if( result==1)
		{
			if(Url.equals("")){
				UserInfo userinfo_session = null;
				if (session.getAttribute("CMSUserInfo") != null) {
					userinfo_session = (UserInfo)session.getAttribute(
							"CMSUserInfo");
					String UserName = userinfo_session.getUsername();// 以UserName为Key
					ClearSession(UserName,session);//清理各个系统的Session
					this.getServletContext()
						.setAttribute(UserName, session);// 以UserName为Key
				}
				response.sendRedirect("main.jsp");
			}
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
