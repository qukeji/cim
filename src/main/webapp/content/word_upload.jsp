<%@ page import="tidemedia.cms.util.*,tidemedia.cms.system.*,org.json.JSONArray,org.json.JSONObject"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
*		修改人		修改时间		备注
*		张赫东		2013/8/22		word导入功能
**/

int ChannelID = Util.getIntParameter(request,"ChannelID");
String FolderName =Util.getParameter(request,"FolderName");
int SiteId = Util.getIntParameter(request,"SiteId");
String file_types = "*.doc;*.docx";
String file_types_description = "Word文件";
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
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../swfupload/swfupload.js"></script>
<script type="text/javascript" src="../swfupload/fileprogress_2010.js"></script>
<script type="text/javascript" src="../swfupload/handlers.js"></script>
	<script type="text/javascript">
		var swfu;
		var returnData = "";

	window.onload = function() {
			var settings = {
				flash_url : "<%=request.getContextPath()%>/swfupload/swfupload.swf",
				upload_url: "<%=request.getContextPath()%>/content/word_upload_submit.jsp",	// Relative to the SWF file
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
				top.TideDialogClose({refresh:'right'});
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
	/*if(jQuery("#ReWrite").is(':checked')){
			ReWrite="Yes";
	}else{
			ReWrite="";
	}*/
	var str="";
	$("input[name='videotype']").each(function(){
		if($(this).attr("checked")){
			  str+=$(this).val()+",";
		}
	 });
	 //alert("<%=ChannelID%>");
	if(jQuery.browser.msie){
		browser="msie";
		
	option={"browser":browser,"FolderName":"<%=FolderName%>","videotype":str,"videotype2":"","ChannelID":"<%=ChannelID%>","globalid":"","transcode_need":"0","SiteId":"<%=SiteId%>","ReWrite":""};
	}else{
		browser="mozilla";
		option={"browser":browser,"FolderName":"<%=FolderName%>","videotype":str,"videotype2":"","transcode_need":"0","ChannelID":"<%=ChannelID%>","globalid":"","SiteId":"<%=SiteId%>","ReWrite":"","Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>"};
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
    <td align="left" valign="middle"><span class="file_upload_dir">文件上传：</span>
	<!--<span class="file_upload_over">
	<input type="checkbox" name="ReWrite" id="ReWrite" value="Yes">
	<label for="ReWrite">重名覆盖</label>
	</span>-->
	<div class="file_upload_choose">
	<span class="file_upload_choose_txt"> </span>
	<span id="spanButtonPlaceHolder"></span></div>
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
   <tr>
	<td valign="middle" width="380"></td>
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

	<input name="startButton" type="button" class="tidecms_btn2" value="确定" id="startButton"  onclick="startSWFU();"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="cancelQueue(swfu);top.TideDialogClose('');"/>
</div>
</form>
</body>
</html>