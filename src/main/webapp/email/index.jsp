<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

int	Back		=	getIntParameter(request,"Back");
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<frameset id="mainFrm" cols="180,*"  frameborder="0" framespacing="0">
  <frame name="menu" src="left.jsp?Back=<%=Back%>" scrolling="NO">
  <frame name="main" src="list.jsp">
<noframes><body bgcolor="#FFFFFF" text="#000000">

</body></noframes>
</frameset>

</html>
