<%@ page import="tidemedia.cms.util.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms7.css" rel="stylesheet" />
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
	<script type="text/javascript">
		var swfu;
		var returnData = "";

	window.onload = function() {
			var settings = {
				flash_url : "<%=request.getContextPath()%>/swfupload/swfupload.swf",
				upload_url: "<%=request.getContextPath()%>/channel/icon_upload_submit.jsp",	// Relative to the SWF file
				post_params: {},
				file_size_limit : "0",
				file_types : "*.jpg;*.png;*.gif;",
				file_types_description : "图片文件（图标）",
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
				button_image_url: "../images/upload_select2.gif",	// Relative to the Flash file
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
				upload_success_handler : uploadSuccess2,
				upload_complete_handler : uploadComplete2
			};

			swfu = new SWFUpload(settings);
	    };

function uploadComplete2(file) {
	try {

		if (this.getStats().files_queued == 0) {
			if(this.customSettings.action=="explorer_right_refresh"){

				if(returnData!="")
				{
					alert(returnData);
				}
				top.TideDialogClose({refresh:'frame=window.frames["popiframe_2"];frame.location=frame.location;'});
				return ;
			}
			document.getElementById(this.customSettings.startButton).disabled = true;
		}
		else
		{
			swfu.startUpload();
		}
	} catch (ex) {
		this.debug(ex);
	}
}

function uploadSuccess2(file, serverData) 
{
	var d = $.trim(serverData);
	if(d!="")
		returnData = returnData + d + "\r\n";
}

function cancelFile(id)
{
	swfu.cancelUpload(id);
}

function startSWFU(){
	var ReWrite;
	var browser;
	var option;
	if(jQuery("#ReWrite").is(':checked')){
			ReWrite="Yes";
	}else{
			ReWrite="";
	}
	if(jQuery.browser.msie){
		browser="msie";
	option={"browser":browser,"FolderName":"","SiteId":"","ReWrite":ReWrite};
	}else{
		browser="mozilla";
		option={"browser":browser,"FolderName":"","SiteId":"","ReWrite":ReWrite,"Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>"};
	}
	
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
    <td align="left" valign="middle"><span class="file_upload_over"></span><div class="file_upload_choose"><span class="file_upload_choose_txt"> </span><span id="spanButtonPlaceHolder"></span></div>
	</td>
  </tr>
  <tr>
    <td valign="middle" width="600">
	<div class="viewpane_tbdoy">
		<table width="100%" border="0" id="fsUploadProgress" class="view_table">
		<thead>
				<tr id="oTable_th">
							<th class="v3" width="200">名称</th>
							<th class="v8" >进度</th>
							<th class="v8" width="60">大小</th>
							<th class="v9" width="20" align="center" valign="middle">>></th>
				</tr>
		</thead>
		</table>   
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
	<input name="startButton" type="button" class="button" value="确定" id="startButton"  onclick="startSWFU();"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="cancelQueue(swfu);top.TideDialogClose('');"/>
</div>
</form>
</body>
</html>