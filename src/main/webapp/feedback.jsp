<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String refer = request.getHeader("referer");
int i = refer.lastIndexOf("/");
if(i!=-1)
	refer = refer.substring(0,i+1);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	int channelid = 4881;
	String	Name					= getParameter(request,"Name");
	String	Email					= getParameter(request,"Email");
	String	Contact					= getParameter(request,"Contact");
	String	Subject					= getParameter(request,"Subject");
	String	Content					= getParameter(request,"Content");

	HashMap map = new HashMap();
	map.put("Title",Subject);
	map.put("Content",Content);

	ItemUtil util = new ItemUtil();
	util.addItem(channelid,map);	

	out.println("<script>alert(\"谢谢，您的反馈已经提交!\");top.TideDialogClose();</script>");
	return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="./style/9/form-common.css" rel="stylesheet" />
<link href="./style/9/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="./common/common.js"></script>
<script language=javascript>

function check()
{
	if(isEmpty(document.form.Name,"请输入姓名."))
		return false;
	if(isEmpty(document.form.Subject,"请输入标题."))
		return false;
	if(isEmpty(document.form.Content,"请输入内容."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
}

function closeD()
{
	//alert(top.document.location.href);
	document.location.href="<%=refer%>cross.jsp?js=top.TideDialogClose('')";
}
</script>
</head>
<body>
<form name="form" action="feedback.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
  <tr>
    <td align="right" valign="middle">类型：</td>
    <td valign="middle"><select name="Type">
			<option value="0">请选择</option>
			<option value="1">建议</option>
			<option value="2">咨询</option>
			<option value="3">提交BUG</option>
			</select></td>
  </tr>
   <tr>
    <td align="right" valign="middle">姓名：</td>
    <td valign="middle"><input type=text name="Name" size="32" class="textfield"></td>
  </tr>

  <tr>
    <td align="right" valign="middle">邮箱：</td>
    <td valign="middle"><input type=text name="Email" size="32" class="textfield"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">联系方式：</td>
    <td valign="middle"><input type=text name="Contact" size="32" class="textfield"></td>
  </tr>

  <tr>
    <td align="right" valign="middle">附件：</td>
    <td valign="middle"><input type=text name="File" size="32" class="textfield"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">标题：</td>
    <td valign="middle"><input type=text name="Subject" size="32" class="textfield"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">内容：</td>
    <td valign="middle">
	<textarea id="Content" name="Content" cols=58 rows=10 class="textfield"></textarea>
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
	<input name="startButton" type="submit" class="button" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="closeD()"/>
<input type="hidden" name="Submit" value="Submit">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>