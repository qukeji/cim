<%@ page import="tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
String Target = getParameter(request,"target");
String Scrolling = getParameter(request,"scrolling");
if(Scrolling.equals("")) Scrolling = "no";
String OtherParameters = "";

java.util.Enumeration names = request.getParameterNames();
while(names.hasMoreElements())
{
	String name = (String) names.nextElement(); 
	if(!name.equals("target") && !name.equals("scrolling"))
	{
		OtherParameters += "&" + name + "=" + java.net.URLEncoder.encode(getParameter(request,name),"utf-8");
	}
}
//System.out.println(Scrolling);
%>
<body>
<iframe src="<%=Target%>?<%=OtherParameters%>" id="Target" style="width:100%;height:100%;border:none;scrolling:<%=Scrolling%>">
</iframe>
</body> 
<script language=javascript>
var Obj = window.dialogArguments;
if(Obj)
	document.title = Obj.title;
else
	document.title = "TideCMS";
</script>
