<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String Submit	= getParameter(request,"Submit");
int		PageID	= getIntParameter(request,"PageID");

if(!Submit.equals(""))
{
	Page p = new Page(PageID);


	p.GenerateTargetFile();

	out.println("<script>top.TideDialogClose({refresh:'left'});</script>");
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript">
function init()
{
}

function check()
{
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
<body  onload="init();">
<form name="form" action="page_targetfile.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
<tr>
    <td align="right" valign="middle">对应页面文件已经存在，是否覆盖该文件？</td>
    <td valign="middle"></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input type="hidden" name="SuperChannel" value="0"/>
  	<input type="hidden" name="PageID" value="<%=PageID%>"/>
	<input type="hidden" name="Submit" value="Submit"/>
	<input name="submitButton" type="submit" class="button" value="确定" id="submitButton"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>