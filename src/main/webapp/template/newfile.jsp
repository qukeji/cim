<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String	FolderName		=Util.getParameter(request,"FolderName");
String	suffix			=Util.getParameter(request,"suffix");//关闭弹出框使用
int 	GroupID			=Util.getIntParameter(request,"GroupID");
int		ItemID			=Util.getIntParameter(request,"ItemID");
TemplateFile tf;
if(ItemID==0){
	tf = new TemplateFile();
}else{
	tf=new TemplateFile(ItemID);
}
TemplateGroup	group=new TemplateGroup(GroupID);
String URL = request.getRequestURL().toString();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/form-common.css" rel="stylesheet" />
<link href="../style/dialog.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>

<script type="text/javascript" src="../editor/fckeditor.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/jquery-ui-1.8.2.datepicker.min.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script  type="text/javascript">
function check()
{
	if(isEmpty(document.form.FileName,"请输入文件名."))
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
function selectImage(fieldname)
{
	var dialog = new TideDialog();
	dialog.setWidth(500);
	dialog.setHeight(240);
	dialog.setLayer(2);
	dialog.setUrl("../content/insertfile.jsp?ChannelID=11454&Type=Image&fieldname="+fieldname);
	dialog.setTitle("上传图片");
	dialog.show();
} 
function previewFile(fieldname)
{
	var name = document.getElementById(fieldname).value;
	if(name=="") 
		return;
	if(name.indexOf("http://")!=-1)
		window.open(name);
	else{
		var url = document.URL.split("template/")[0];
		
		window.open(url+"images/template/"+ name);
	}
		

		
}
function uploadFile()
{
	tidecms.dialog("template/template_image_upload.jsp",600,400,"上传图片");
}
function setReturnValue(o){ 
	//alert(o.photo);
	//return; 	
	if(o.photo!=null){
		$("#Photo").val(o.photo); 
		//$("#Icon").val(o.icon);
	} 
}

function init(){
}
</script>
</head>
<body>
<form name="form" action="newfile_submit.jsp" enctype="multipart/form-data" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
<%if(ItemID==0){%>
<tr>
    <td align="right" valign="middle">上级目录：</td>
    <td valign="middle"><%=group.getName()%></td>
  </tr>
    <tr>
    <td align="right" valign="middle">文件名：</td>
    <td valign="middle"><input type="text" name="FileName" id="FileName" class="textfield" value=""/></td>
  </tr>
 <%}else{%>
    <tr>
    <td align="right" valign="middle">文件名：</td>
    <td valign="middle"><%=tf.getFileName()%></td>
  </tr>
 <%}%>
   <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type="text" name="Name" id="Name" class="textfield" value="<%=tf.getName()%>"/></td>
  </tr>
      <tr>
    <td id="uploadimg" align="right" valign="middle">上传图片：</td>
    <td valign="middle">
		<div id="field_Photo" class="line">
			<input type="text" size="80" class="textfield upload w250" value="<%=tf.getPhoto().replace("../images/template/","")%>" id="Photo" name="Photo">
			<input type="button" class="tidecms_btn3" onclick="uploadFile()" value="选择"> 
			<input type="button" class="tidecms_btn3" onclick="previewFile('Photo')" value="预览">
		</div>
	    <br>注:为空使用系统默认图片</td>
  </tr>
      <tr>
    <td align="right" valign="middle">模板描述：</td>
    <td valign="middle"><textarea name="Description" cols="30" rows="5" class="textfield" id="Description"><%=tf.getDescription()%></textarea></td>
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
	<%if(!(ItemID==0)){%>
	<input type="hidden" name="Action" value="Edit">
	<input type="hidden" name="FileName" value="<%=tf.getFileName()%>">
	<%}else{%>
	<input type="hidden" name="Action" value="Add">
	<%}%>
	<input name="startButton" type="submit" class="button" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose({suffix:'<%=suffix%>'});"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>