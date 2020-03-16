<%@ page import="java.io.File,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Name = getParameter(request,"Name");
if(!Name.equals(""))
{
	String TemplateFolder =CmsCache.getDefaultSite().getTemplateFolder();

	String	FolderName		= getParameter(request,"FolderName");
	String  Path			= TemplateFolder + "/" + FolderName + "/" + Name;

	String RealPath = (Path);
	File file = new File(RealPath);
	file.mkdir();

	response.sendRedirect("../close_pop.jsp");return;
}
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../common/pop_window.css" />
<script language=javascript>
function init()
{
	var Obj = top.Obj;
	if(Obj)
	{
		//alert(Obj.ChannelName);
		document.all("FolderNameLabel").innerText = Obj.FolderName;
		document.form.FolderName.value = Obj.FolderName;
	}
	document.form.Name.focus();
}

function check()
{
	if(isEmpty(document.form.Name,"请输入目录名."))
		return false;

	return true;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}
</script>
</head>
<body onload="init();">
<br>
<table align="center">
<form name="form" action="newfolder.jsp" method="post" onSubmit="return check();">
<tr>
	<td align="right">上级目录：</td>
	<td><label id="FolderNameLabel"></label></td>
</tr>
<tr>
	<td align="right">目录名：</td>
	<td><input type=text name="Name" size="32"></td>
</tr>
<tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
<tr>
	<td colspan=2 align="center">
<input type="submit" value = "  确认  ">
<input type="button" value = "  取消  " onclick="self.close();">
<input type="hidden" name="FolderName" value="">
	</td>
</tr>
</form>
</table>
</body>
</html>
