<%@ page import="tidemedia.cms.system.*,org.json.JSONArray,org.json.JSONObject"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Type			= getParameter(request,"Type");
String fieldname			= getParameter(request,"fieldname");
int ChannelID		= getIntParameter(request,"ChannelID");
int itemid			= getIntParameter(request,"itemid");
int globalid		= getIntParameter(request,"globalid");

String file_types = CmsCache.getParameterValue("sys_upload_videotype");
String file_types_description = "视频文件";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style>
label{margin:0 0 0 2px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../swfupload/swfupload.js"></script>
<script type="text/javascript" src="../swfupload/fileprogress.js"></script>
<script type="text/javascript" src="../swfupload/handlers.js"></script>
	<script type="text/javascript">
		var swfu;
	window.onload = function() {
			var settings = {
				flash_url : "<%=request.getContextPath()%>/swfupload/swfupload.swf",
				upload_url: "<%=request.getContextPath()%>/video/video_upload_submit.jsp",	// Relative to the SWF file
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
function cancelFile(id)
{
	swfu.cancelUpload(id);
}
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
	
	

	var str="";
	//window.console.info($("input[name='videotype']"));
    $("input[name='videotype']").each(function(){
		if($(this).attr("checked")){
              str+=$(this).val()+",";
		}
     });

	 var transcode_need = 0;
	 if($("#transcode_need").is(":checked")) transcode_need = 1;
	 var videotype2 = $("input[name='videotype2']:checked").val();

	jQuery.extend(option,{"itemid":<%=itemid%>,"globalid":<%=globalid%>,"videotype":str,"transcode_need":transcode_need,"videotype2":videotype2,"select_video":$("#videoname").html()});

	window.console.info(option);
	
	//选择编码时的提示信息
	if(transcode_need==0  && str==""){//转码的提示
		alert("请选择一种，或多种转码格式");
		return;
	}
	if(transcode_need==1  && typeof(videotype2)=="undefined"){//不转码的提示
		alert("请选择与本视频相同的码流格式");
		return;
	}

	swfu.setPostParams(option);  
	swfu.startUpload();
}

function selectVideo()
{
	tidecms.dialog("../video/list_choose_video.jsp",600,400,"选择视频",2);
	/*function chooseVideo()
	{
	var dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(400);
	dialog.setUrl("http://123.125.148.3:889/vms/custom/file_list_choose.jsp");
	dialog.setTitle("选择视频");
	dialog.show();
	} */
}

function showMaliuSelect()
{
	if($("#transcode_need").is(":checked"))
	{
		$("#maliu_select2").show();
		$("#maliu_select1").hide();
	}
	else
	{
		$("#maliu_select2").hide();
		$("#maliu_select1").show();
	}
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
    	<div class="form_main_m">
<table  border="0" width="460">
   <tr>
    <td align="right" valign="middle" width="100">本地上传视频：</td>
    <td valign="middle" width="380"><span id="spanButtonPlaceHolder"></span></td>
  </tr>
   <tr>
    <td align="right" valign="middle" width="100">文件服务器：</td>
    <td valign="middle" width="380"> 
	<input name="selectVideoB" type="button" class="tidecms_btn2"style="width:71px" value="选择" onclick="selectVideo();" />&nbsp&nbsp<span id="videoname"><span></td>
  </tr>
  <tr>
    <td align="right" valign="middle"></td>
    <td valign="middle">
    	<div class="upload_flash" id="fsUploadProgress">
        </div>
    </td>
  </tr>
  <tr>
    <td align="right" valign="middle"></td>
    <td valign="middle">
    	<label for="transcode_need">不转码</label><input type="checkbox" value="1" name="transcode_need" id="transcode_need" onClick="showMaliuSelect()">
    </td>
  </tr>
<tbody id="maliu_select1">
   <tr>
    <td align="right" valign="middle" width="80">转码格式：</td>
	<td valign="middle" width="380">
<%
String t = CmsCache.getParameterValue("sys_video");
JSONObject ooo = new JSONObject(t);
JSONArray o = ooo.getJSONArray("birate");
for(int i =0;i<o.length();i++)
{
	JSONObject oo = o.getJSONObject(i);
	if(i>0 && i%3==0) out.println("<br><br>");
%>
<input type="checkbox" value="<%=oo.getString("value")%>" name="videotype" id="videotype_<%=i%>"><label for="videotype_<%=i%>"><%=oo.getString("name")%></label>&nbsp;&nbsp;
<%}%>
  </td></tr>
</tbody>

<tbody id="maliu_select2" style="display:none">
   <tr>
    <td align="right" valign="middle" width="80">转码格式：</td>
	<td valign="middle" width="380">
<%
for(int i =0;i<o.length();i++)
{
	JSONObject oo = o.getJSONObject(i);
	if(i>0 && i%3==0) out.println("<br><br>");
%>
<input type="radio" value="<%=oo.getString("value")%>" name="videotype2" id="videotype2_<%=i%>"><label for="videotype2_<%=i%>"><%=oo.getString("name")%></label>&nbsp;&nbsp;
<%}%>
  </td></tr>
</tbody>

</table>
		</div>
    </div>
    <div class="form_bottom">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
</div>
<div class="form_button">
	<input name="startButton" type="button" class="tidecms_btn3" value="确定" id="startButton"  onclick="startSWFU();" disabled="disabled"/>
	<input name="btnCancel1" type="button" class="tidecms_btn3" value="取消"  id="btnCancel1"  onclick="cancelQueue(swfu);top.TideDialogClose('');"/>
</div>
</form>
</body>
</html>