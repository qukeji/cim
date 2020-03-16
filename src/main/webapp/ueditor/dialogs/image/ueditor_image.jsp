 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				tidemedia.cms.util.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
/**
* 1,胡翔 2019/8/6 修改  删除type参数
*/
int ChannelID = getIntParameter(request,"ChannelID");
Channel channel = CmsCache.getChannel(ChannelID);

//回调图片频道
String serialNo = "photo_back";
Channel channel2 = CmsCache.getChannel(serialNo);
int channelId = channel2.getId();
String sys_config_photo = CmsCache.getParameterValue("sys_config_photo");

JSONObject jo = new JSONObject(sys_config_photo);
int photo_channelid = jo.getInt("channelid");

//图片及图片库配置
Channel channel3 = null;
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
int sys_channelid_image = photo_config.getInt("channelid");
channel3 = CmsCache.getChannel(sys_channelid_image);
Site site = channel3.getSite();//
String Path = channel3.getRealImageFolder();//图片库地址
String SiteUrl = site.getExternalUrl();//图片库预览地址
String SiteFolder = site.getSiteFolder();//图片库目录
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>本地图片上传 - TideCMS</title>

<link href="../../../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../../../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../../../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../../../style/2018/bracket.css">  
<link rel="stylesheet" href="../../../style/2018/common.css">

<style>
	html,body{width: 100%;background: #fff;}
	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
	.modal-body .config-box .row{margin-bottom: 20px;height: 40px;}
	.modal-body-btn .config-box .row .left-fn-title{min-width: 80px;text-align: left;}
	.modal-body .config-box label.ckbox{width: 90px;cursor: pointer;margin-right: 0px;}
	.table thead th{vertical-align: middle;}
	.table th{padding: 0.3rem 0.75rem ;}
	.table td{padding: 0.4rem 0.75rem ;}
	label {margin-right: 10px;}
	label.ckbox.mg-b-0-force.mg-l-20 {width: 100px;}
	.modal-body .config-box{bottom: 0px;padding-bottom:20px ;}
	.modal-body-btn{bottom: 0px;}
</style>

<script src="../../../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../../../common/webuploader.js"></script>

<script language=javascript>
	
	var dialog	= window.parent.parent;
	var ueditor = dialog.getUE();
	var returnData = "";

	var state = 'pending',
		uploader ;

	var oImage =ueditor.selection.getRange().getClosedNode();//是否选中图片

	if ( oImage && oImage.tagName != 'IMG' && !( oImage.tagName == 'INPUT' && oImage.type == 'image' ) )
		oImage = null ;

	var oImageOriginal ;

	function setDefaults()
	{
		oSample = document.getElementById("SampleTD") ;
		oEditor.FCKLanguageManager.TranslatePage(document) ;
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
				startUpload();
			}
		}

	}

	function uploadSuccess2(file, serverData) 
	{
		returnData = returnData + serverData;
	}
	//初始化
	window.onload = function() 
	{
		LoadSelection();//显示图片属性
	};

	function toEnd()
	{
		var evt = getEvent();
		var e = getEventSrcElement(evt);
		if(document.all)
		{
			var r =e.createTextRange();
			r.moveStart("character",e.value.length);
			r.collapse(true);
			r.select();
		}
	}

	function UpdatePreview_()
	{
		if(!document.getElementById("divUploadPhoto").style.display!="none")
			document.image_form.txtUrl.value = GetE('txtUrl2').value;
		UpdatePreview();
	}

	function UpdatePreview1()
	{
		if(document.getElementById("divUploadPhoto").style.display!="none")
			document.image_form.txtUrl.value = GetE('txtUrl1').value;
		else
			document.image_form.txtUrl.value = GetE('txtUrl2').value;

		eImgHidden.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").sizingMethod = 'image';
		eImgHidden.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = GetE('txtUrl').value;
		var jWidth = eImgHidden.offsetWidth;
		var jHeight = eImgHidden.offsetHeight;

		var style = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+GetE('txtUrl').value+"');";
		eImgPreview.src = "";
		eImgPreview.style.filter = style;
		eImgPreview.style.width = jWidth;
		eImgPreview.style.height = jHeight;
		GetE('txtWidth').value = jWidth;
		GetE('txtHeight').value = jHeight;
		
		UpdateOriginal();
		oImageOriginal.width = jWidth;
		oImageOriginal.height = jHeight;

		eImgPreviewLink.style.display = '' ;
	}

	function UpdateType()
	{
		if(document.getElementById("divUploadPhoto").style.display!="none")
		{	
			GetE('txtUrl2').disabled=true;
		}
		else//网络
		{	
			GetE('txtUrl2').disabled=false;
			GetE('txtWidth').value = "";
			GetE('txtHeight').value = "";
		}
		
		UpdatePreview_();
	}

	function Ok(){

		var html;
		
		//是否为编辑图片
		if(!oImage){

			if(document.getElementById("divUploadPhoto").style.display!="none"){   
				startUpload();
				return true;
			}else{  
				//alert("mmm");
			}

		}else{

			if(uploader.getFiles().length>0){
				startUpload();
				return true;
			}else{
				UpdateImage( oImage ) ;//编辑图片
			}
		}
		return true;
	}

	function LoadSelection()
	{
		if ( ! oImage ) return ;

		var sUrl = oImage.getAttribute( '_fcksavedurl' ) ;
		if ( sUrl == null )
			sUrl = GetAttribute( oImage, 'src', '' ) ;

		GetE('txtUrl').value    = sUrl ;
		GetE('txtAlt').value    = GetAttribute( oImage, 'alt', '' ) ;

		var iWidth, iHeight ;

		var regexSize = /^\s*(\d+)px\s*$/i ;

		if ( oImage.style.width )
		{
			var aMatchW  = oImage.style.width.match( regexSize ) ;
			if ( aMatchW )
			{
				iWidth = aMatchW[1] ;
				oImage.style.width = '' ;
				SetAttribute( oImage, 'width' , iWidth ) ;
			}
		}

		if ( oImage.style.height )
		{
			var aMatchH  = oImage.style.height.match( regexSize ) ;
			if ( aMatchH )
			{
				iHeight = aMatchH[1] ;
				oImage.style.height = '' ;
				SetAttribute( oImage, 'height', iHeight ) ;
			}
		}

		GetE('txtWidth').value	= iWidth ? iWidth : GetAttribute( oImage, "width", '' ) ;
		GetE('txtHeight').value	= iHeight ? iHeight : GetAttribute( oImage, "height", '' ) ;

		GetE('txtAttId').value			= oImage.id ;
		GetE('cmbAttLangDir').value		= oImage.dir ;
		GetE('txtAttLangCode').value	= oImage.lang ;
		GetE('txtAttTitle').value		= oImage.title ;
		GetE('txtLongDesc').value		= oImage.longDesc ;

		GetE('txtAttClasses').value = oImage.getAttribute('class',2) || '' ;
		GetE('txtAttStyle').value = oImage.getAttribute('style',2) ;

		UpdatePreview() ;
	}

	var eImgPreview ;
	var eImgPreviewLink ;
	var eImgHidden;

	function SetPreviewElements( imageElement, linkElement,imgHiddenElement )
	{
		eImgPreview = imageElement ;
		eImgPreviewLink = linkElement ;
		eImgHidden = imgHiddenElement;

		UpdatePreview() ;
		UpdateOriginal() ;

		bPreviewInitialized = true ;
	}

	function UpdatePreview()
	{
		if ( !eImgPreview || !eImgPreviewLink )
			return ;

		if ( GetE('txtUrl').value.length == 0 )
			eImgPreviewLink.style.display = 'none' ;
		else
		{
			UpdateImage( eImgPreview, true ) ;

			if ( GetE('txtLnkUrl').value.Trim().length > 0 )
				eImgPreviewLink.href = 'javascript:void(null);' ;
			else
				SetAttribute( eImgPreviewLink, 'href', '' ) ;

			eImgPreviewLink.style.display = '' ;
		}
	}

	function UpdateOriginal( resetSize )
	{
		if ( !eImgPreview )
			return ;

		if ( GetE('txtUrl').value.length == 0 )
		{
			oImageOriginal = null ;
			return ;
		}

		oImageOriginal = document.createElement( 'IMG' ) ;	// new Image() ;

		if ( resetSize )
		{
			oImageOriginal.onload = function()
			{
				this.onload = null ;
				ResetSizes() ;
			}
		}

		oImageOriginal.src = eImgPreview.src ;
	}

	function UpdateImage( e, skipId )
	{
		e.src = GetE('txtUrl').value ;
		SetAttribute( e, "_fcksavedurl", GetE('txtUrl').value ) ;
		SetAttribute( e, "alt"   , GetE('txtAlt').value ) ;
		SetAttribute( e, "width" , GetE('txtWidth').value ) ;
		SetAttribute( e, "height", GetE('txtHeight').value ) ;

		if ( ! skipId )
			SetAttribute( e, 'id', GetE('txtAttId').value ) ;

		SetAttribute( e, 'dir'		, GetE('cmbAttLangDir').value ) ;
		SetAttribute( e, 'lang'		, GetE('txtAttLangCode').value ) ;
		SetAttribute( e, 'title'	, GetE('txtAttTitle').value ) ;
		SetAttribute( e, 'longDesc'	, GetE('txtLongDesc').value ) ;

		SetAttribute( e, 'class'	, GetE('txtAttClasses').value ) ;
		SetAttribute( e, 'style', GetE('txtAttStyle').value ) ;
	}

	function OnSizeChanged( dimension, value )
	{
		if ( oImageOriginal && bLockRatio )
		{
			var e = dimension == 'Width' ? GetE('txtHeight') : GetE('txtWidth') ;

			if ( value.length == 0 || isNaN( value ) )
			{
				e.value = '' ;
				return ;
			}

			if ( dimension == 'Width' )
				value = value == 0 ? 0 : Math.round( oImageOriginal.height * ( value  / oImageOriginal.width ) ) ;
			else
				value = value == 0 ? 0 : Math.round( oImageOriginal.width  * ( value / oImageOriginal.height ) ) ;

			if ( !isNaN( value ) )
				e.value = value ;
		}

		UpdatePreview() ;
	}

	var bLockRatio = true ;

	function SwitchLock( lockButton )
	{
		bLockRatio = !bLockRatio ;
		lockButton.className = bLockRatio ? 'BtnLocked' : 'BtnUnlocked' ;
		lockButton.title = bLockRatio ? 'Lock sizes' : 'Unlock sizes' ;

		if ( bLockRatio )
		{
			if ( GetE('txtWidth').value.length > 0 )
				OnSizeChanged( 'Width', GetE('txtWidth').value ) ;
			else
				OnSizeChanged( 'Height', GetE('txtHeight').value ) ;
		}
	}


	function addNewPhoto()
	{
		var content = $("table[class='fck_images'] tr") ;
		//txtUrl2
		 var len = (content.length/2)+1;
		 $(content[0]).find("input").attr("id","textUrl2_"+len).attr("name","textUrl2_"+len);
		 $(content[1]).find("input").attr("id","txtAlt_"+len).attr("name","txtAlt_"+len);
		
		$("table[class='fck_images']").append(content[0].outerHTML+content[1].outerHTML);
	}

	function removePhoto()
	{
		var content = $("table[class='fck_images'] tr") ;
		var len = content.length;
		if(len>2)
		{
			$("table[class='fck_images'] tr:gt("+(len-3)+")").each(function(){
				$(this).remove();
			});
		}
		else
			alert("至少保留一个网络图片！");
	}
	function GetE( elementId )
	{
		return document.getElementById( elementId )  ;
	}
	function SetAttribute( element, attName, attValue )
	{
		if ( attValue == null || attValue.length == 0 )
			element.removeAttribute( attName, 0 ) ;			// 0 : Case Insensitive
		else
			element.setAttribute( attName, attValue, 0 ) ;	// 0 : Case Insensitive
	}

	function GetAttribute( element, attName, valueIfNull )
	{
		var oAtt = element.attributes[attName] ;

		if ( oAtt == null || !oAtt.specified )
			return valueIfNull ? valueIfNull : '' ;

		var oValue = element.getAttribute( attName, 2 ) ;

		if ( oValue == null )
			oValue = oAtt.nodeValue ;

		return ( oValue == null ? valueIfNull : oValue ) ;
	}

	function checkIsWatermark(){
	    if($("#Watermark").prop("checked")){
			$("#f_1").show();
			$("#f_2").show();
			$("#f_3").show();
		}else{
			$("#f_1").hide();
			$("#f_2").hide();
			$("#f_3").hide();
		}
	}
	</script>
   
</head>
<body>
<div class="bg-white modal-box">
	<div class="modal-body modal-body-btn pd-20 ">

<div id="divUploadPhoto">
<form action="" enctype="multipart/form-data" method="post"  name="image_form">
	<div class="config-box">
		<div class="row">
			<div class="btn-group hidden-xs-down file_upload_choose" id="uploader">         
				<label id="picker">图片上传</label>                             			                  		              	                  
			</div>
			
		</div>
		<div class="row">
			<label class="ckbox mg-b-0-force">
				<input type="checkbox" name="Watermark" id="Watermark" value="Yes" onclick="checkIsWatermark();"><span for="Watermark">水印</span>
			</label>
			<!-- <label class="mg-r-40"></label> -->
			<label id="f_2" style="display:none">
				<select id="mask_location" class="form-control wd-120 ht-40 select2">
					<option value="rightbottom">右下方</option>
					<option value="righttop">右上方</option>
					<option value="middle">居中</option>
					<option value="leftbottom">左下方</option>
					<option value="lefttop">左上方</option>
				</select>
			</label>
			<label id="f_1" style="display:none">
				<select id="mask_scheme" name = "mask_scheme" class="form-control wd-82 ht-40 select2">
					<%
						List<Watermark> watermarks= new  Watermark().listAllWaterMark(userinfo_session.getCompany());
						for(int i=0;i<watermarks.size();i++)
						{
							Watermark watermark = watermarks.get(i);
							int  waterid = watermark.getId();
							%>
					<option value="<%=waterid%>" id="<%=watermark.getWaterMark()%>"><%=watermark.getName()%></option>
					<%} %>
				</select>
			</label>
			<label id="f_3" style="display:none">
				<input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="预览水印" onclick="preview_watermark();">
			</label>
		</div>
		<div class="row">
			<label class="ckbox mg-b-0-force">
				<input type="checkbox" name="Thumbnail" id="Thumbnail" value="yes"><span for="Thumbnail">压缩图片</span>
			</label>
			<label fcklang="DlgImgWidth" class="mg-r-0">宽度：</label>
			<label><input type="text" name="txtWidth" size=5 id="txtWidth" onkeyup="OnSizeChanged('Width',this.value);" class="form-control"></label>
			<label class="mg-r-0">高度：</label>
			<label><input type="text" name="txtHeight" id="txtHeight" size=5 class="form-control" onkeyup="OnSizeChanged('Height',this.value);"></label>
			<label>
				<div id="btnLockSizes" class="BtnLocked" onmouseover="this.className = (bLockRatio ? 'BtnLocked' : 'BtnUnlocked' ) + ' BtnOver';" onmouseout="this.className = (bLockRatio ? 'BtnLocked' : 'BtnUnlocked' );" title="Lock Sizes" onclick="SwitchLock(this);"></div>
			</label>			
		</div>
		
		<div class="bd rounded table-responsive">
			<table class="table table-bordered mg-b-0">
				<thead>
					<tr>
						<th class="wd-220">名称</th>
						<th class="text-center">进度</th>
						<th class="wd-100-force">大小</th>
						<th class="wd-50 text-center"><a class="tx-18" href="javascript:;"><i class="fa fa-angle-double-right" aria-hidden="true"></i></a></th>
					</tr>
				</thead>
				<tbody id="thelist">
				</tbody>
			</table>
		</div>
	</div>
</form>
</div>

	</div>
</div>

<script>	
     //使用缩略图必填宽高
	 /*$("#Thumbnail").click(function(){
		 if($(this).prop("checked")){
			var dialog = new top.TideDialog();	   
				dialog.setWidth(350);
				dialog.setHeight(300);		
				dialog.setTitle("提示");
				dialog.setMsg("勾选压缩图片时，宽高至少填写一项。");
				dialog.ShowMsg();
		 }
	 });*/
	//h5上传
	jQuery(function() {
		var $ = jQuery,
			$list = $('#thelist');//上传文件列表
			
		//初始化
		uploader = WebUploader.create({
			
			swf: '../../../common/Uploader.swf',// swf文件路径
			
			server: '../../../content/insertimage_editor_submit.jsp',// 文件接收服务端。
			
			pick: '#picker',// 选择文件的按钮。可选。

			compress: false,//不启用压缩

			resize: false,//尺寸不改变

			threads: 1,//最大上传并发数

			// 只允许选择图片文件。
			accept: {
				title: 'Images',
				extensions: 'gif,jpg,jpeg,png,webp',
				mimeTypes: 'image/gif,image/jpg,image/jpeg,image/png,image/webp'
			}
		});
		// 当有文件添加进来的时候
		uploader.on( 'fileQueued', function( file ) {
			$list.append( '<tr id="' + file.id + '">' +
				'<td>' + file.name + '<\/td>' +
				'<td id= "'+file.id+"_schedule"+'"><\/td>' +
				'<td>' + Math.floor((file.size)/1024) + 'KB<\/td>' +
				'<td id="'+file.id+"_del"+'"><\/td>' +
			'<\/tr>' );

			var $btns = $("#"+file.id+"_del").html('<a class="file_del">' +
				'<img src="../image/images/inner_menu_del.gif"></a>');
			//删除文件		
			$btns.on( 'click', function() {
				uploader.removeFile( file,true );
				$("#"+file.id+"").remove();
			});
		});		
		 // 文件上传过程中创建进度条实时显示。
		uploader.on( 'uploadProgress', function( file, percentage ) {

			var $li = $( '#'+file.id+"_schedule" ),
				$percent = $li.find('.progress .progress-bar');

			// 避免重复创建
			if (!$percent.length) {
				$percent = $('<div class="progress progress-striped active upload_jdt">' +
								'<div class="progress-bar upload_jdt_box" role="progressbar" style="width: 0%">' +
								'</div>' +
							'</div>').appendTo( $li ).find('.progress-bar');
			}
			$li.find('p.state').text('上传中');

			$percent.css( 'width', percentage * 100 + '%' );
			$percent.html(parseInt(percentage * 100)+'%');
			
		});
		//上传成功
		uploader.on( 'uploadSuccess', function( file , response) {
			//$( '#'+file.id ).find('p.state').text('已上传');
			$( '#'+file.id ).addClass('upload-state-done');
			uploadSuccess2(file,response._raw);
		});
		//上传出错
		uploader.on( 'uploadError', function( file ) {
			$( '#'+file.id ).find('div.error').text('上传出错');
		});
		//上传结束
		uploader.on( 'uploadFinished', function() {
			state = 'done';
			if(returnData!=""&&returnData!== undefined)
			{
                ueditor.focus();
				ueditor.execCommand('inserthtml',surroundP(returnData));
				//window.parent.parent.setContent(returnData,true); 	
				top.TideDialogClose();
			}
		});
		
	});
	//创建上传事件
	function startUpload(){
		if ( state === 'uploading' ) {
			uploader.stop();
		} else {
			var browser;
			var option = new Object();

			if(jQuery.support)
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
//			option.txtBorder = $("#txtBorder").val();
//			option.txtHSpace = $("#txtHSpace").val();
//			option.txtVSpace = $("#txtVSpace").val();
			option.txtLnkUrl = $("#txtLnkUrl").val();
			option.cmbLnkTarget = $("#cmbLnkTarget").val();
//			option.cmbAlign = $("#cmbAlign").val();
			if($('#Thumbnail').is(':checked')){
				if(option.txtWidth || option.txtHeight ){
					option.Thumbnail = $("#Thumbnail").val();
				}else{
					var dialog = new top.TideDialog();	   
						dialog.setWidth(330);
						dialog.setHeight(220);
						dialog.setZindex(9999);	
						dialog.setTitle("提示");
						dialog.setMsg('勾选“压缩图片”请填写宽高');
						dialog.ShowMsg();
					return false ;
				}				
			}
			
		
			if($("#keepbig").is(':checked'))
				option.keepbig = $("#keepbig").val();

			if(jQuery("#Watermark").is(':checked'))
					{
						option.Watermark="yes";
						option.mask_location = $("#mask_location").val();
						option.mask_scheme = $("#mask_scheme option:selected").val();
					}

//			if($("#sharpen").is(':checked'))
//				option.sharpen = $("#sharpen").val();

			uploader.options.formData= option;
			uploader.upload();		
		}
	}
	   
	 function surroundP(value){
	     var obj = $(value);
	     var objHtml = '';
	     for(var i=0;i<obj.length;i++){
	        var ht = obj.eq(i).prop("outerHTML");
	        if(ht!=undefined){
	            var p = document.createElement('p');
	            p.style = "text-align:center";
	            $(p).append(ht);
	            objHtml+=$(p).prop("outerHTML");
	        }
	     }
	     return objHtml;
	 }
	 function preview_watermark() {
		var watermark = $('#mask_scheme option:selected').prop("id");
		var SiteUrl = '<%=SiteUrl%>';
        var SiteFolder = '<%=SiteFolder%>';
        window.open(watermark.replace(SiteFolder,SiteUrl));
	}
</script>
<script src="../../../lib/2018/select2/js/select2.min.js"></script>
<script type="text/javascript">
	$(function(){
		if($().select2) {
		    $('.select2').select2({
		      minimumResultsForSearch: Infinity
		 });
		}
	})
</script>
</body>
</html>
