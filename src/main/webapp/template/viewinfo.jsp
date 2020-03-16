<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id =Util.getIntParameter(request,"id");
TemplateFile tf =new TemplateFile(id);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/form-common.css" rel="stylesheet" />
<link href="../style/dialog.css" type="text/css" rel="stylesheet" />
<script  type="text/javascript">
function check()
{
	if(isEmpty(document.form.Name,"请输入文件名."))
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
<form>
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">文件名：</td>
    <td valign="middle"><%=tf.getFileName()%></td>
  </tr>
   <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><%=tf.getName()%></td>
  </tr>
   <tr>
    <td align="right" valign="middle">模板描述：</td>
    <td valign="middle"><%=tidemedia.cms.util.Util.convertNewlines(tf.getDescription())%></td>
  </tr> 
   <tr>
    <td align="right" valign="middle">预览图片：</td>
    <td valign="middle"></td>
  </tr>
   <tr>
    <td align="right" valign="middle">使用的频道：</td>
    <td valign="middle"><%=tf.listChannelUse()%></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>