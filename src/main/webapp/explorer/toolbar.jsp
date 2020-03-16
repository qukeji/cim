<%@ page import="java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String	Charset		= getParameter(request,"Charset");
%>
<html>
<head>

<script type="text/javascript">

window.onerror = function () { return true;}

function insert_file()
{
//	alert("ok");
}
</script>
</head>
<body onselectstart="return false" oncontextmenu="return false;">

<script language=javascript>
<%if(!Charset.equals("")){%>
document.all("Charset").value = "<%=Charset%>";
<%}%>
</script>
</body>
</html>
