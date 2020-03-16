<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				tidemedia.cms.spider.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
String submitButton = getParameter(request,"submitButton");

if(!submitButton.equals(""))
{
	int		Status		= getIntParameter(request,"Status");
	int		Time		= getIntParameter(request,"Time");

	new Spider().Config(Status,Time);

	{out.println("<script>top.TideDialogClose();</script>");return;}
}

Parameter p1 = new Parameter("sys_spider_status");
Parameter p2 = new Parameter("sys_spider_time");
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
	document.form.Name.focus();
}

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
<body  onload="init();">
<form name="form" action="spider_config.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">开启/关闭：</td>
    <td valign="middle">
	<input id="s004" name="Status" type="radio" value="1" <%=p1.getIntValue()==1?"checked":""%>>
	<label for="s004">开启</label>
	<input type="radio" id="s005" name="Status" value="2" <%=p1.getIntValue()==2?"checked":""%>>
	<label for="s005">关闭</label> </td>
	</td>
  </tr>
    <tr>
    <td align="right" valign="middle">采集周期：</td>
    <td valign="middle"><input type="text" name="Time" id="Time" class="textfield" value="<%=p2.getIntValue()%>"/></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input name="submitButton" type="submit" class="button" value="确定" id="submitButton"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>