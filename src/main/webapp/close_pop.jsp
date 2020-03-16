<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%int Type = getIntParameter(request,"Type");
String	returnValue		= getParameter(request,"returnValue");
String	alertMessage	= getParameter(request,"alertMessage");
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<%if(Type<5){%>
<script language="javascript">
<%if(!alertMessage.equals("")){%>alert("<%=alertMessage%>");<%}%>
window.returnValue = "<%=returnValue%>";
<%if(Type==1){%>try{if(opener){opener.location.reload();}}catch(er){}<%}%>
<%if(Type==2){%>try{if(opener){opener.history.go(0);}}catch(er){}<%}%>
self.close();
</script>
<%}else
{
	if(Type==5) 
		out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
}%>
</body>
</html>