<%@ page import="tidemedia.cms.util.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
*		修改人		修改时间		备注
*		郭庆光		20130625		从服务器中选择视频文件，进行转码并添加到cms中。
*
*
**/
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int ChannelID = Util.getIntParameter(request,"ChannelID");
String FolderName =Util.getParameter(request,"FolderName");
int SiteId = Util.getIntParameter(request,"SiteId");
int userid = userinfo_session.getId();
String filename = getParameter(request,"filename");
String filepath = getParameter(request,"filepath");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style> 
.file_upload_dir,.file_upload_over,.file_upload_choose,.file_upload_choose_txt{float:left;}
.file_upload_over{margin:0 15px;*margin:-4px 15px 0;}
.file_upload_over label{vertical-align:middle;cursor:pointer;margin:0 0 0 2px;*margin:0;}
.file_upload_choose .swfupload{margin:-5px 0 0;}
</style>

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../swfupload/swfupload.js"></script>
<script type="text/javascript" src="../swfupload/fileprogress_2010.js"></script>
<script type="text/javascript" src="../swfupload/handlers.js"></script>
</head>
<body>
<form action="video_upload_choose_submit.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check();">
<div class="iframe_form">
	<div class="form_top">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="form_main">
    	<div class="form_main_m"  style="height:290px;">
<table  border="0">
   <tr>
	<td valign="middle" width="380">
	<span>转码格式：</span>

	<input type="checkbox" value="1" name="videotype" id="videotype_0"><label for="videotype_0">标清(250k)</label>
	<input type="checkbox" value="2" name="videotype" id="videotype_1"><label for="videotype_1">高清(482k)</label>
	<input type="checkbox" value="3" name="videotype" id="videotype_2"><label for="videotype_2">超清(1047k)</label>
	<input type="checkbox" value="4" name="videotype" id="videotype_3"><label for="videotype_3">iphone(480*320)</label>
	<input type="checkbox" value="5" name="videotype" id="videotype_4"><label for="videotype_4">ipad</label>

	</td>
  </tr>
</table>
		</div>
    </div>
    <div class="form_bottom">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
</div>
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
<input type="hidden" name="userid" value="<%=userid%>">
<input type="hidden" name="filename" value="<%=filename%>">
<input type="hidden" name="filepath" value="<%=filepath%>">

<div class="form_button">

	<input name="startButton" type="button" class="tidecms_btn2" value="确定" id="startButton"  onclick="startSWFU();"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('-2');"/>
</div>
</form>
</body>
</html>