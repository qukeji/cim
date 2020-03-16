<%@ page contentType="text/html;charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/form-iframe.css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../swfupload/swfupload.js"></script>
<script type="text/javascript" src="../swfupload/fileprogress.js"></script>
<script type="text/javascript" src="../swfupload/handlers.js"></script>
	<script type="text/javascript">
		var swfu;
	window.onload = function() {
			var settings = {
				flash_url : "<%=request.getContextPath()%>/swfupload/swfupload.swf",
				upload_url: "<%=request.getContextPath()%>/util/video_upload_submit.jsp",	// Relative to the SWF file
				post_params: {},
				file_size_limit : "0",
				file_types : "*.*",
				file_types_description : "All Files",
				file_upload_limit : 0,
				file_queue_limit :0,
				custom_settings : {
					progressTarget : "fsUploadProgress",
					cancelButtonId : "btnCancel1",
					startButton:"startButton",
					percentage:"percentage",
					oneormore:"1", //o单选 1 多选
					action:"explorer_right_refresh",
					fileinput:"fileinput"
				},
				debug: false,

				// Button settings
				button_image_url: "../images/upload_select.gif",	// Relative to the Flash file
				button_width: "71",
				button_height: "24",
				button_placeholder_id: "spanButtonPlaceHolder",

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
	    };

function startSWFU(){
	var ReWrite;
	var browser;
	var option;
	if(jQuery("#ReWrite").is(':checked')){
			ReWrite="Yes";
	}else{
			ReWrite="";
	}

	option={"ReWrite":ReWrite};
	swfu.setPostParams(option);
	swfu.startUpload();
}
	</script>
</head>
<body>
<form action="file_upload_submit.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check();">
<div class="iframe_form">
	<div class="form_top">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="form_main">
    	<div class="form_main_m"  style="height:290px;">
<table  border="0">
    <tr>
    <td align="right" valign="middle">重名覆盖：</td>
    <td valign="middle"><input type="checkbox" name="ReWrite" id="ReWrite" value="Yes"></td>
  </tr>
   <tr>
    <td align="right" valign="middle">请选择文件：</td>
    <td valign="middle"><span id="spanButtonPlaceHolder"></span></td>
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