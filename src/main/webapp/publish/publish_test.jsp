<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.PublishScheme,
				java.io.*,
				org.apache.commons.net.ftp.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%//禁止编辑发布方案
if(userinfo_session.hasPermission("DisableEditPublishScheme"))
{	out.close();return;}

int id = getIntParameter(request,"id");

//PublishScheme publishscheme = new PublishScheme(id);
PublishScheme ps =CmsCache.getPublishScheme(id);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">

//$("#start").click(function(){
function startTest(){
	/*
 var file = $("#file").val();
 if(file!=null||file.match("/(^/)\.([a-zA-Z]){1,}")==null){
	alert("输入格式为：/a.zip");
	return false;
 }*/

	$.ajax({
	 type: "POST",
	 url: "publish_test_submit.jsp",
	 data: {'siteId':'<%=id%>','file':$('#file').val()},
	 error:function(XMLHttpRequest, textStatus, errorThrown){
		 $("#result").html("<tr> <td align='left' colspan='2'>"+XMLHttpRequest.responseText+"</td></tr>");
	 },
	 success: function(data){
		var html ="<tr> <td align='left' colspan='2'>"+data+"</td></tr>";
		$("#result").html(html);
	 } 
	});
}
 
 
 
function init()
{
	document.form.Code.focus();
} 

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
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main" style="overflow:hidden;">
<div class="form_main_m">
<table  border="0" width="100%">
  <tr>
    <td align="left" valign="middle" width="30%">名称：</td>
    <td valign="middle" width="70%"><%=ps.getName()%></td>
  </tr>
  <tr>
    <td align="left" valign="middle" >FTP服务器：</td>
    <td valign="middle"><%=ps.getServer()%></td>
  </tr>
  <tr>
    <td align="left" valign="middle" >用户名：</td>
    <td valign="middle"><%=ps.getUsername()%></td>
  </tr>
  <tr>
   <td align="left" valign="middle" colspan="2" >   
	指定文件(比如：/tidecms_test.html):
   </td>
  </tr>
  <tr>
    <td align="left" valign="middle" colspan="2" >   
	<input type="text" name="file" id="file" value="/tidecms_test.html" size="40"/>
	<input type="hidden" name="channelid" value="<%=id%>">  
   </td>
  </tr>  
</table>
</div>
<div class="form_main_m">
<table  border="0">
<thead>
	<tr><th align='left' colspan='2'>结果：</th></tr>
</thead>
<tbody id="result">
<tbody>
</table>
</div>
</div>
 
<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="关闭" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
	
    <input type="button" id="start" value="开始测试"class="tidecms_btn2" onclick="startTest();"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</body>
</html>