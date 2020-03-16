<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	int		IsInt					= getIntParameter(request,"IsInt");
	int		IsJson					= getIntParameter(request,"IsJson");
	int		IsTemplate				= getIntParameter(request,"IsTemplate");
	String	Name					= getParameter(request,"Name");
	String	Code					= getParameter(request,"Code");
	String	Content					= getParameter(request,"Content");
	String	Comment					= getParameter(request,"Comment");
	
	Parameter p = new Parameter();

	p.setName(Name);
	p.setCode(Code);
	p.setIsJson(IsJson);
	p.setComment(Comment);
	p.setIsTemplate(IsTemplate);
	if(IsInt==1)
	{
		p.setType2(2);
		p.setIntValue(getIntParameter(request,"Content"));
	}
	else
	{
		p.setContent(Content);	
	}

	p.Add();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>
$(document).ready(function() {
	document.form.Code.focus();
});

function check()
{
	if(isEmpty(document.form.Code,"请输入代码."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
}
</script>
</head>
<body>
<form name="form" action="parameter_add.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">代码：</td>
    <td valign="middle"><input type=text name="Code" size="32" class="textfield"></td>
  </tr>

   <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type=text name="Name" size="32" class="textfield"></td>
  </tr>

  <tr>
    <td align="right" valign="middle">内容：</td>
    <td valign="middle"><textarea name="Content" cols=60 rows=4 class="textfield"></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle">备注：</td>
    <td valign="middle"><textarea name="Comment" cols=60 rows=4 class="textfield"></textarea></td>
  </tr>
  <tr>
    <td align="right" valign="middle"></td>
    <td valign="middle">模板<input type="checkbox" name="IsTemplate" id="IsTemplate" value="1" class="textfield">
	&nbsp;数字<input type="checkbox" name="IsInt" id="IsInt" value="1" class="textfield">
	&nbsp;JSON<input type="checkbox" name="IsJson" id="IsJson" value="1" class="textfield">
	</td>
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
<input type="hidden" name="Submit" value="Submit">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>