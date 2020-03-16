<%@ page import="java.io.File,tidemedia.cms.util.Util,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms7.css" rel="stylesheet" />
<script src="../common/common.js"></script>
<script type="text/javascript">
function init()
{

}

function check()
{
	if(isEmpty(document.form.id,"请输入频道ID."))
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
<form name="form" action="channel_xml2.jsp" method="get" onSubmit="return check();">
<table width="100%" border="0" height="100%" >
  <tr height="100%"><td>
<table border="0" height="100%" width="100%" cellspacing="0" cellpadding="0">
<tr height="8"><td height="8"><div class="form_top"><div class="left"></div><div class="right"></div></div></td></tr>
<tr><td>
    <div class="form_main" style="height:100%">
    	<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">频道ID：</td>
    <td valign="middle"><input type="text" name="id" id="id" class="textfield"/></td>
  </tr>
   <tr>
    <td align="right" valign="middle"><input name="startButton" type="submit" class="button" value="确定" id="startButton"/></td>
    <td valign="middle"><input name="btnCancel1" type="button" class="button" value="关闭"  id="btnCancel1"  onclick="window.close()"/></td>
  </tr>
</table>
		</div>
    </div>
</td></tr>
<tr height="8"><td>
    <div class="form_bottom">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
</td></tr>
</table>
</td></tr></table>
</form>
</body>
</html>