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
	int		Width					= getIntParameter(request,"Width");
	int		Height					= getIntParameter(request,"Height");
	String	Name					= getParameter(request,"Name");
	
	PhotoScheme ps = new PhotoScheme();

	ps.setName(Name);
	ps.setHeight(Height);
	ps.setWidth(Width);
	 
	ps.Add();

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
 
</script>
</head>
<body>
<form name="form" action="photo_scheme_add.jsp" method="post">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">

   <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type=text name="Name" size="32" class="textfield"></td>
  </tr>

  <tr>
    <td align="right" valign="middle">宽：</td>
    <td valign="middle"><input type=text name="Width" size="32" class="textfield"></td>
  </tr>
    <tr>
    <td align="right" valign="middle">高：</td>
    <td valign="middle"><input type=text name="Height" size="32" class="textfield"></td>
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