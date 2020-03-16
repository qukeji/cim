/**
 * @license Copyright (c) 2003-2015, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.dialog.add( 'image', function( editor ) {
	var lang = editor.lang.about;
	var imagePath = "";
        var ckgEditorVer = editor.config.ckgEditorVer;
	return {
		title: CKEDITOR.env.ie ? lang.dlgTitle : lang.title,
		minWidth: 650,
		minHeight: 500,
		onOk: function() {
			alert("ok");
			var browser;
			var option = new Object();

			if(jQuery.browser.msie)
			{
				browser="msie";
				option={"browser":browser,"ChannelID":"<%=ChannelID%>"};
			}
			else
			{
				browser="mozilla";
				option={"browser":browser,"ChannelID":"<%=ChannelID%>","Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>"};
			}

			option.Client = "editor";
			option.txtWidth = $("#txtWidth").val();
			option.txtHeight = $("#txtHeight").val();
			option.txtBorder = $("#txtBorder").val();
			option.txtHSpace = $("#txtHSpace").val();
			option.txtVSpace = $("#txtVSpace").val();
			option.txtLnkUrl = $("#txtLnkUrl").val();
			option.cmbLnkTarget = $("#cmbLnkTarget").val();
			option.cmbAlign = $("#cmbAlign").val();
			if($("#Thumbnail").attr("checked"))
				option.Thumbnail = $("#Thumbnail").val();
			if($("#keepbig").attr("checked"))
				option.keepbig = $("#keepbig").val();
			if($("#Watermark").attr("checked"))
			{
				option.Watermark = $("#Watermark").val();
				option.mask_location = $("#mask_location").val();
			}
			if($("#sharpen").attr("checked"))
				option.sharpen = $("#sharpen").val();
			alert(option.Client+","+option.browser);
			alert(swfu);
			swfu.setPostParams(option);
			swfu.startUpload();
			return false;
		},
		onShow: function() {
			var settings = {
				flash_url : "../swfupload/swfupload.swf",
				upload_url: "../content/insertimage_editor_submit.jsp",	// Relative to the SWF file
				post_params: {},
				file_size_limit : "0",
				file_types : "*.jpg;*.png;*.gif;*.bmp",
				file_types_description : "All Files",
				file_upload_limit : 0,
				file_queue_limit :0,
				custom_settings : 
				{
					progressTarget : "fsUploadProgress",
					cancelButtonId : "btnCancel1",
					startButton:"startButton",
					percentage:"percentage",
					oneormore:"1", //o单选 1 多选
					action:"document_upload",
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
		},
		contents: [
            {
			id: 'tab1',
			label: '',
			title: '',
			expand: true,
			padding: 0,
			elements: [
				{
					type: 'html',
					html: '<style>body{background:none;padding:0;}</style><link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />' +
'						<div id="divUploadPhoto">' +
'<form action="" enctype="multipart/form-data" method="post"  name="image_form">' +
'	<div id="divInfo">' +
 '   <div class="content_2012">' +
 '           <div class="line" style="overflow:hidden;">' +
 '                   <div class="fck_f_l w170 lh28"><span class="file_upload_dir">图片上传：</span><div class="file_upload_choose"><span id="spanButtonPlaceHolder">选择</span></div></div>' +
'                    <div class="fck_f_l w170"><span fcklang="DlgImgWidth" class="fck_f_l_box lh28">宽度：</span> <input type="text" style="width:64px" id="txtWidth" name="txtWidth" onkeyup="OnSizeChanged(\'Width\',this.value);" class="fck_f_l_input"/> </div>' +
'                    <div class="fck_f_l w170"><span fcklang="DlgImgHeight" class="fck_f_l_box lh28">高度：</span>' +
'						<input type="text" style="width:64px" id="txtHeight" name="txtHeight" onkeyup="OnSizeChanged(\'Height\',this.value);" class="fck_f_l_input"/>' + 
'					<div id="btnLockSizes" class="BtnLocked" onmouseover="this.className = (bLockRatio ? \'BtnLocked\' : \'BtnUnlocked\' ) + \' BtnOver\';" onmouseout="this.className = (bLockRatio ? \'BtnLocked\' : \'BtnUnlocked\' );" title="Lock Sizes" onclick="SwitchLock(this);"></div></div>' +
 '                   <div class="fck_f_l w100 lh28"><input type=checkbox id="Thumbnail" name="Thumbnail" value="yes"><label for="Thumbnail">使用缩略图</label></div>' +
 '                   <div class="fck_f_l w80 lh28"><input type=checkbox id="keepbig" name="keepbig" value="yes"><label for="keepbig">保留原图</label></div>' +
 '           </div>' +
 '           <div class="line" style="overflow:hidden;">' +
'                <div class="fck_f_l w170"><span fcklang="DlgImgBorder">边框大小：</span> <input type="text" style="width:64px" value="" id="txtBorder" name="txtBorder" onkeyup="UpdatePreview();" /></div>' +
'                <div class="fck_f_l w170"><span fcklang="DlgImgHSpace" class="fck_f_l_box lh28">水平间距：</span> <input type="text" style="width:64px" id="txtHSpace" name="txtHSpace" onkeyup="UpdatePreview();" class="fck_f_l_input" /></div>' +
'                <div class="fck_f_l w170"><span fcklang="DlgImgVSpace" class="fck_f_l_box lh28">垂直间距：</span> <input type="text" style="width:64px" id="txtVSpace" name="txtVSpace" onkeyup="UpdatePreview();" class="fck_f_l_input" /></div>' +
'                <div class="fck_f_l w170 lh28"><input type=checkbox  id="sharpen" name="sharpen" value="yes"><label for="sharpen">锐化</label></div>' +
'            </div>' +
'            <div class="line" style="overflow:hidden;">' +
'                <div class="fck_f_l w170 lh28">' +
'                    <span fcklang="DlgImgAlign" class="fck_f_l_box">对齐方式：</span> ' +
'                    <select id="cmbAlign" name="cmbAlign" onchange="UpdatePreview();" style="margin:0;">' +
'                        <option value="" selected="selected">无</option>' +
'                        <option fcklang="DlgImgAlignLeft" value="left">左对齐</option>' +
'                        <option fcklang="DlgImgAlignAbsBottom" value="absBottom">绝对底边</option>' +
'                        <option fcklang="DlgImgAlignAbsMiddle" value="absMiddle">绝对居中</option>' +
'                        <option fcklang="DlgImgAlignBaseline" value="baseline">基线</option>' +
'                        <option fcklang="DlgImgAlignBottom" value="bottom">底边</option>' +
'                        <option fcklang="DlgImgAlignMiddle" value="middle">居中</option>' +
'                        <option fcklang="DlgImgAlignRight" value="right">右对齐</option>' +
'                        <option fcklang="DlgImgAlignTextTop" value="textTop">文本上方</option>' +
'                        <option fcklang="DlgImgAlignTop" value="top">顶端</option>' +
'                    </select>' +
'                </div>' +
'                <div class="fck_f_l w170 lh28">' +
'                    <span fcklang="DlgImgAlign" class="fck_f_l_box">加水印：</span>' +
'                    <select id="mask_location" style="margin:0;">' +
'                        <option value="none">无</option>' +
'                        <option value="rightbottom">右下方</option>' +
'                        <option value="righttop">右上方</option>' +
'                        <option value="middle">居中</option>' +
'                        <option value="leftbottom">左下方</option>' +
'                        <option value="lefttop">左上方</option>' +
'                    </select>' +
'               </div>' +
'            </div>' +
'    </div>' +
'    <div class="content_2012">' +
 '       <div class="viewpane_tbdoy">' +
'        <table width="100%" border="0" id="fsUploadProgress" class="view_table">' +
'        <thead>' +
'                <tr id="oTable_th">' +
'                            <th class="v3" width="200">名称</th>' +
'                            <th class="v8" >进度</th>' +
'                            <th class="v8" width="60">大小</th>' +
'                            <th class="v9" width="40" align="center" valign="middle">操作</th>' +
'                </tr>' +
'        </thead>' +
'        </table>   ' +
'    </div>  ' +
'    </div>' +
    
 '   </div>' +

'	<div id="divLink" style="display: none">' +
'		<table cellspacing="1" cellpadding="1" border="0" width="100%">' +
'			<tr>' +
'				<td>' +
'					<div>' +
'						<span fcklang="DlgLnkURL">URL</span><br />' +
'						<input id="txtLnkUrl" name="txtLnkUrl" style="width: 100%" type="text" onblur="UpdatePreview();" />' +
'					</div>' +
'					<div id="divLnkBrowseServer" align="right">' +
'						<input type="button" value="Browse Server" fcklang="DlgBtnBrowseServer" onclick="LnkBrowseServer();" />' +
'					</div>' +
'					<div>' +
'						<span fcklang="DlgLnkTarget">Target</span><br />' +
'						<select id="cmbLnkTarget" name="cmbLnkTarget">' +
'							<option value="" fcklang="DlgGenNotSet" selected="selected"><not set></option>' +
'							<option value="_blank" fcklang="DlgLnkTargetBlank">New Window (_blank)</option>' +
'							<option value="_top" fcklang="DlgLnkTargetTop">Topmost Window (_top)</option>' +
'							<option value="_self" fcklang="DlgLnkTargetSelf">Same Window (_self)</option>' +
'							<option value="_parent" fcklang="DlgLnkTargetParent">Parent Window (_parent)</option>' +
'						</select>' +
'					</div>' +
'				</td>' +
'			</tr>' +
'		</table>' +
'	</div>' +
'	<div id="divAdvanced" style="display: none">' +
'		<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">' +
'			<tr>' +
'				<td valign="top" width="50%">' +
'					<span fcklang="DlgGenId">Id</span><br />' +
'					<input id="txtAttId" style="width: 100%" type="text" />' +
'				</td>' +
'				<td width="1">' +
'					 </td>' +
'				<td valign="top">' +
'					<table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">' +
'						<tr>' +
'							<td width="60%">' +
'								<span fcklang="DlgGenLangDir">Language Direction</span><br />' +
'								<select id="cmbAttLangDir" style="width: 100%">' +
'									<option value="" fcklang="DlgGenNotSet" selected="selected"><not set></option>' +
'									<option value="ltr" fcklang="DlgGenLangDirLtr">Left to Right (LTR)</option>' +
'									<option value="rtl" fcklang="DlgGenLangDirRtl">Right to Left (RTL)</option>' +
'								</select>' +
'							</td>' +
'							<td width="1%">' +
'								 </td>' +
'							<td nowrap="nowrap">' +
'								<span fcklang="DlgGenLangCode">Language Code</span><br />' +
'								<input id="txtAttLangCode" style="width: 100%" type="text" />?' +
'							</td>' +
'						</tr>' +
'					</table>' +
'				</td>' +
'			</tr>' +
'			<tr>' +
'				<td colspan="3">' +
'					 </td>' +
'			</tr>' +
'			<tr>' +
'				<td colspan="3">' +
'					<span fcklang="DlgGenLongDescr">Long Description URL</span><br />' +
'					<input id="txtLongDesc" style="width: 100%" type="text" />' +
'				</td>' +
'			</tr>' +
'			<tr>' +
'				<td colspan="3">' +
'					?</td>' +
'			</tr>' +
'			<tr>' +
'				<td valign="top">' +
'					<span fcklang="DlgGenClass">Stylesheet Classes</span><br />' +
'					<input id="txtAttClasses" style="width: 100%" type="text" />' +
'				</td>' +
'				<td>' +
'				</td>' +
'				<td valign="top">' +
'					?<span fcklang="DlgGenTitle">Advisory Title</span><br />' +
'					<input id="txtAttTitle" style="width: 100%" type="text" />' +
'				</td>' +
'			</tr>' +
'		</table>' +
'		<span fcklang="DlgGenStyle">Style</span><br />' +
'		<input id="txtAttStyle" style="width: 100%" type="text" />' +
'	</div>' +
'</div>' +

'<div id="divInternetPhoto" style="display: none">' +
'        <div class="content_2012">' +
'                <table class="fck_images">' +
'                        <tr>	  ' +
'                                <td align="left"><div class="line">网络地址：</div></td>' +
'                                <td>' +
'                                        <div class="line"><input type=text id="txtUrl2" name="txtUrl2" size="80" onkeyup="UpdatePreview_();" class="textfield" > <input type=checkbox id="Localization" name="Localization" value="yes"><label for="Localization">是否本地化</label></div><input id="ChannelID" name="ChannelID" type="hidden" value="0"><input name="Client" type="hidden" value="editor"><input id="txtUrl" name="txtUrl" type="hidden" >' +
'                                </td>' +
'                        </tr>' +
'                        <tr> <td align="left"><div class="line">描述：</div></td><td><div class="line"><input id="txtAlt" name="txtAlt" size="80" type="text" /></div></td></tr>' +
'                </table>' +
'        </div>' +
'        <div class="line" style="text-align:center;">' +
'        	<input class="tidecms_btn3" value="添加网络图片" style="width:72px" onclick="addNewPhoto();"/>' +
'        	<input class="tidecms_btn3" value="移除网络图片" style="width:72px" onclick="removePhoto();"/>' +
'        </div>' +
'</form>' +
'</div>' +

'<div id="divSelectPhoto" style="display: none">' +
'	<table cellpadding="0" cellspacing="0" width="100%" height="100%">' +
'		<tr>' +
'			<td width="100%">' +
'				<table cellpadding="1" cellspacing="1" align="center" border="0" width="100%" height="100%">' +
'				<tbody >' +
'				<tr><td><iframe  marginheight="0" frameborder="no"  id="photo" name="photo" marginwidth="0" scrolling="auto" height="420" width="750" src="about:blank"></iframe></td><td></td></tr>' +
'				</tbody>' +
'				</table>' +
'			</td>' +
'		</tr>' +
'	</table>' +
'</div>'
				}
			]
		} ],
		buttons: [ CKEDITOR.dialog.cancelButton,CKEDITOR.dialog.okButton]
	};
} );

function uploadSuccess2(file, serverData) 
{
	returnData = returnData + serverData;
}

function uploadComplete2(file) 
{
	if(returnData.indexOf("error:")!=-1)
	{
		alert($.trim(returnData.replace("error:","")));
		window.location.reload();
	}
	else
	{
		if (this.getStats().files_queued == 0) 
		{
			var oEditor		= dialog.InnerDialogLoaded() ;
			var FCK			= oEditor.FCK ;//alert(FCK);
			FCK.InsertHtml(returnData);
			dialog.CloseDialog() ;
		}
		else
		{
			swfu.startUpload();
		}
	}

}