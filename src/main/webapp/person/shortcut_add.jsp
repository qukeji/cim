<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String	Description		= getParameter(request,"Description");
String	type		= getParameter(request,"type");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

if(!Description.equals(""))
{
	String	Href			= getParameter(request,"Href");
	String	Target			= getParameter(request,"Target");
	String	Icon			= getParameter(request,"Icon");

	ShortCut sc = new ShortCut();

	sc.setDescription(Description);
	sc.setHref(Href);
	sc.setTarget(Target);
	sc.setIcon(Icon);
	sc.setUser(userinfo_session.getId());

	sc.Add();

	if(ContinueAdd==0)
	{
	//	out.println("top.TideDialogClose({refresh:'"+type+"'});");
		out.println("<script>top.TideDialogClose({refresh:'"+type+"'});</script>");
		return;
	}
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="favicon.ico">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" rel="stylesheet"/>
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>

function check()
{
	if(isEmpty(document.form.Description,"请输入名称."))
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
<form name="form" action="shortcut_add.jsp" method="post" onSubmit="return check();">
<div class="form_main">
<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type="text" name="Description" size="32" class="textfield"></td>
  </tr>

   <tr>
    <td align="right" valign="middle">链接地址：</td>
    <td valign="middle"><input type="text" name="Href" size="32" class="textfield" value="http://"></td>
  </tr>

   <tr>
    <td align="right" valign="middle">打开窗口方式：</td>
    <td valign="middle">   <select name="Target">
                <option value="_blank" selected>新窗口</option>
                <option value="_self">本窗口</option>
              </select></td>
  </tr>
  <tr>
    <td align="right" valign="middle">图标：</td>
    <td valign="middle"><table border="0" cellspacing="3" cellpadding="0">
		  <tr align="center">
		  <td>
            <img src="../images/icon_32_link.gif" width="32" height="32">
		  </td>
		  <td>
            <img src="../images/icon_32_survey.gif" width="32" height="32">
		  </td>
		  <td>
            <img src="../images/icon_32_take.gif" width="32" height="32">
		  </td>
		  <td>
            <img src="../images/icon_32_user.gif" width="32" height="32">
		  </td>
		  </tr>
		  <tr align="center">
		  <td>
			<input type="radio" name="Icon" value="images/icon_32_link.gif">
		  </td>
		  <td>
			<input type="radio" name="Icon" value="images/icon_32_survey.gif">
		  </td>
		  <td>
			<input type="radio" name="Icon" value="images/icon_32_take.gif">
		  </td>
		  <td>
			<input type="radio" name="Icon" value="images/icon_32_user.gif">
		  </td>
		  </tr>
		  </table></td>
  </tr>
   <tr>
    <td align="right" valign="middle"> <input type=checkbox id="s1" name="ContinueAdd" value="1" class="textfield" <%=ContinueAdd==1?"checked":""%>></td>
    <td valign="middle">   
	<label for="s1">继续新建</label>
<input type="hidden" name="Parent" value="0">
</td>
  </tr>
</table>
</div>
</div>

<div class="form_button">
	<input type="hidden" name="type" value="<%=type%>"/>
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="Submit" value="Submit">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>