<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<frameset id="mainFrm" cols="180,*"  frameborder="0" framespacing="0">
  <frame name="menu" src="left.jsp" scrolling="NO">
  <frame name="main" src="setup.jsp?SiteId=<%=CmsCache.getDefaultSite().getId()%>">
<noframes><body bgcolor="#FFFFFF" text="#000000">

</body></noframes>
</frameset>

</html>
