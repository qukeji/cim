<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int 	ItemID			=Util.getIntParameter(request,"ItemID");
int 	GroupID			=Util.getIntParameter(request,"GroupID");
TemplateFile tf = new TemplateFile(ItemID);
TemplateGroup	group=new TemplateGroup(GroupID);

String	FileName		= getParameter(request,"FileName");
String NewFileName = getParameter(request,"NewFileName");
if(!NewFileName.equals(""))
{
	tf.setFileName(NewFileName);
	tf.Update();
	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<script  type="text/javascript">
function check()
{
	if(isEmpty(document.form.NewFileName,"请输入文件名."))
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
<form name="form" action="renamefile.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
   <tr>
    <td align="right" valign="middle">上级目录：</td>
    <td valign="middle"><%=group.getName()%></td>
  </tr>
      <tr>
    <td align="right" valign="middle">原文件名：</td>
    <td valign="middle"><%=tf.getFileName()%></td>
  </tr>
      <tr>
    <td align="right" valign="middle">新文件名：</td>
    <td valign="middle"><input type=text name="NewFileName" class="textfield" value="<%=tf.getFileName()%>"></td>
  </tr> 
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input type="hidden" name="ItemID" value="<%=ItemID%>">
	<input type="hidden" name="GroupID" value="<%=GroupID%>">
	<input name="startButton" type="submit" class="button" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>