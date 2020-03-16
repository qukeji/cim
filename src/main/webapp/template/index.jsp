<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<frameset id="mainFrm" cols="180,*"  frameborder="0" framespacing="0">
  <frame name="menu" src="left.jsp" scrolling="NO">
  <frame name="main" src="template_list.jsp">
<noframes><body bgcolor="#FFFFFF" text="#000000">

</body></noframes>
</frameset>

</html>
