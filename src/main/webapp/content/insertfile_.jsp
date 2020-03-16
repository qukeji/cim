<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Type			= getParameter(request,"Type");
String fieldname			= getParameter(request,"fieldname");
int ChannelID		= getIntParameter(request,"ChannelID");

String file_types = "*.*";
String file_types_description = "所有文件";
if(Type.equals("Image"))
{
	file_types = "*.gif;*.jpg;*.png;*.jpeg";
	file_types_description = "图片文件";
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/form-iframe.css" rel="stylesheet" />
<style>
label{margin:0 0 0 2px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../swfupload/swfupload.js"></script>
<script type="text/javascript" src="../swfupload/fileprogress.js"></script>
<script type="text/javascript" src="../swfupload/handlers.js"></script>
	<script type="text/javascript">
		var swfu;
	window.onload = function() {
			var settings = {
				flash_url : "<%=request.getContextPath()%>/swfupload/swfupload.swf",
				upload_url: "<%=request.getContextPath()%>/content/insertfile_submit_.jsp",	// Relative to the SWF file
				post_params: {},
				file_size_limit : "0",
				file_types : "<%=file_types%>",
				file_types_description : "<%=file_types_description%>",
				file_upload_limit : 1,
				file_queue_limit :1,
				custom_settings : {
					progressTarget : "fsUploadProgress",
					cancelButtonId : "btnCancel1",
					startButton:"startButton",
					percentage:"percentage",
					oneormore:"0", //o单选 1 多选
					action:"document_upload",
					fileinput:"fileinput"
				},
				debug: false,
				// Button settings
				button_image_url: "../images/upload_select.gif",	// Relative to the Flash file
				button_width: "71",
				button_height: "24",
				button_placeholder_id: "spanButtonPlaceHolder",
				//button_text: '<span class="theFont">选择..</span>',
				//button_text_style: ".theFont { font-size: 14; }",
				button_text_left_padding: 12,
				button_text_top_padding: 0,
				button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
				button_cursor: SWFUpload.CURSOR.HAND,
				
				// The event handler functions are defined in handlers.js
				file_dialog_start_handler : fileDialogStart,
				file_queued_handler : fileQueued,
				file_queue_error_handler : fileQueueError,
				file_dialog_complete_handler : fileDialogComplete,
				upload_start_handler : uploadStart,
				upload_progress_handler : uploadProgress,
				upload_error_handler : uploadError,
				upload_success_handler : uploadSuccess,
				upload_complete_handler : uploadComplete
			};

			swfu = new SWFUpload(settings);

			if(top.CompressWidth)
				$("#CompressWidth").val(top.CompressWidth);
			if(top.CompressHeight)
				$("#CompressHeight").val(top.CompressHeight);
	    };

function startSWFU(){
	var ReWrite;
	var browser;
	var option;

	if(jQuery.browser.msie){
		browser="msie";
	option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"<%=Type%>","fieldname":"<%=fieldname%>"};
	}else{
		browser="mozilla";
		option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"<%=Type%>","fieldname":"<%=fieldname%>","Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>"};
	}
	<%if(Type.equals("Flash") || Type.equals("Video")){%>
		var Width=jQuery("#Width").val();
		var Height=jQuery("#Height").val();
		jQuery.extend(option,{"Width":Width,"Height":Height});  
	<%} else if(Type.equals("Image")){%>
	var Watermark="";
	var IsCompress = "";
	var UseCompress = "";
	if(jQuery("#Watermark").is(':checked')){
			Watermark="Yes";
	}
	if(jQuery("#IsCompress").is(':checked')){
			IsCompress="1";
	}
	if(jQuery("#UseCompress").is(':checked')){
			UseCompress="1";
	}
	jQuery.extend(option,{"Watermark":Watermark,"IsCompress":IsCompress,"CompressHeight":$("#CompressHeight").val(),"CompressWidth":$("#CompressWidth").val(),"UseCompress":UseCompress});
	<%}%>
	
	swfu.setPostParams(option);
	swfu.startUpload();
}
	</script>
</head>
<body>
<form action="insertfile_submit.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check();">
<div class="iframe_form">
	<div class="form_top">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="form_main">
    	<div class="form_main_m"  style="height:130px;">
<table  border="0" width="460">
  <%if(Type.equals("Flash") || Type.equals("Video")){%>
    <tr>
    <td align="right" valign="middle">尺寸：</td>
    <td valign="middle">宽度<input name="Width" type="text" class="textfield" id="Width">
    高度<input name="Height" type="text" class="textfield" id="Height"></td>
  </tr>
<%}%>
<%if(Type.equals("Image")){%>
    <tr>
    <td colspan="2">
	<!--<input type=checkbox name="Watermark" value="Yes" id="Watermark">加上水印-->
	<input type=checkbox name="IsCompress" value="1" id="IsCompress" checked><label for="IsCompress">压缩图片</label>&nbsp;&nbsp;
	<label for="CompressWidth">宽度：</label><input type="text" value="" name="CompressWidth" size=5 id="CompressWidth">
	<label for="CompressHeight">高度：</label><input type="text" value="" name="CompressHeight" id="CompressHeight" size=5> <input type="checkbox" name="UseCompress" value="1" id="UseCompress"><label for="UseCompress">使用压缩后图片</label>
	</td>
  </tr>
<%}%>
   <tr>
    <td align="right" valign="middle" width="80">请选择文件：</td>
    <td valign="middle" width="380"><span id="spanButtonPlaceHolder"></span></td>
  </tr>
  <tr>
    <td align="right" valign="middle"></td>
    <td valign="middle">
    	<div class="upload_flash" id="fsUploadProgress">
        	
        </div>
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
<div class="form_button">
	<input name="startButton" type="button" class="button" value="确定" id="startButton"  onclick="startSWFU();" disabled="disabled"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="cancelQueue(swfu);top.TideDialogClose('');"/>
</div>
</form>
</body>
</html>