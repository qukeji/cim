<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.io.File,tidemedia.cms.dict.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String	suffix		=Util.getParameter(request,"suffix");//关闭弹出框使用
int 	GroupID			=Util.getIntParameter(request,"GroupID");
int		ItemID			=Util.getIntParameter(request,"ItemID");
TemplateFile tf;
if(ItemID==0){
	tf = new TemplateFile();
}else{
	tf=new TemplateFile(ItemID);
}
DictGroup	group=new DictGroup(GroupID);

String Name =getParameter(request,"Name");

if(!Name.equals(""))
{
	Dict dict = new Dict();
	
	dict.setName(Name);
	dict.setGroup(GroupID);

	dict.Add();

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
<script  type="text/javascript">
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
<form name="form" action="dict_add.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
   <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type="text" name="Name" id="Name" class="textfield" value="<%=tf.getName()%>"/></td>
  </tr>

</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input type="hidden" name="suffix" value="<%=suffix%>">
	<input type="hidden" name="FolderName" value="">
	<input type="hidden" name="GroupID" id="GroupID" value="<%=GroupID%>">
	<input type="hidden" name="ItemID" value="<%=ItemID%>">
	<input type="hidden" name="Action" value="Add">
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose({suffix:'<%=suffix%>'});"/>

</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>