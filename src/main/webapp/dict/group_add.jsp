<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.dict.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String Name =getParameter(request,"Name");
String Code =getParameter(request,"Code");

if(!Name.equals(""))
{
	DictGroup group2 = new DictGroup();
	
	group2.setName(Name);
	group2.setCode(Code);

	group2.Add();

	out.println("<script>top.TideDialogClose({refresh:'left'});</script>");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script language=javascript>
function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
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
<body>
<form name="form" action="group_add.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type="text" name="Name" id="Name" class="textfield"/></td>
  </tr>
    <tr>
    <td align="right" valign="middle">代码：</td>
    <td valign="middle"><input type="text" name="Code" id="Code" class="textfield"/></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>

</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>