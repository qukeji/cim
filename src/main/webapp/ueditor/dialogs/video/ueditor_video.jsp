<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
int ChannelID		= getIntParameter(request,"ChannelID");

int video_type = CmsCache.getParameter("sys_editor_video_type").getIntValue();
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
	html,body{width: 100%;height: 100%;}
	.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
	.modal-body .config-box .row{margin-bottom: 10px;}
	.modal-body-btn .config-box .row .left-fn-title{min-width: 80px;text-align: left;}
	.modal-body .config-box label.ckbox{width: 90px;cursor: pointer;margin-right: 40px;}
	.table thead th{vertical-align: middle;}
	.table th{padding: 0.3rem 0.75rem ;}
	.table td{padding: 0.4rem 0.75rem ;}
	label {margin-right: 10px;}
	label.ckbox.mg-b-0-force.mg-l-20 {width: 100px;}
</style>

<script src="../../../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../../../common/webuploader.js"></script>

</head>

<body>
<div class="bg-white modal-box">
	<div class="modal-body modal-body-btn pd-20 overflow-y-auto">

	<div id="divUploadPhoto">
		<form action="" enctype="multipart/form-data" method="post"  name="image_form">
			<div class="config-box">
				<div class="row">
					<div class="btn-group hidden-xs-down file_upload_choose" id="uploader">         
						<label id="picker">视频上传</label>                             			                  		              	                  
					</div>
				</div>
				<div class="row">
					<label class="tx-danger" fcklang="DlgImgAlign">提示：</label>
					<label>
						只允许上传MP4或者mp3格式，本地上传未做转码，可能导致手机端兼容问题无法播放，请确保上传的视频格式正确。
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

	<div id="divSelectPhoto" style="display: none">
		<table cellpadding="0" cellspacing="0" width="100%" height="100%">
			<tr>
				<td width="100%">
					<table cellpadding="1" cellspacing="1" align="center" border="0" width="100%" height="100%">
					<tbody >
					<tr><td><iframe  marginheight="0" frameborder="no"  id="photo" name="photo" marginwidth="0" scrolling="auto" height="400" width="100%" src=""></iframe></td><td></td></tr>
					</tbody>
					</table>
				</td>
			</tr>
		</table>
	</div>

	</div>
</div>


<script>

	var dialog	= window.parent.parent;
	var ueditor = dialog.getUE();
	var returnData = "";
	
	var state = 'pending',
		uploader ;	
	function Ok(){
		if(uploader.getFiles().length>0){
			startUpload();
			return false;
		}
		return false;
	}
	
	function uploadSuccess2(file, serverData) {
		returnData = returnData + serverData;
	}
	
	function getUrl(name) {
			 var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
		 var r = window.location.search.substr(1).match(reg);
		 if(r!=null)return  unescape(r[2]); return null;
	};

	// 图片上传
	jQuery(function() {
		var $ = jQuery,
			$list = $('#thelist');//上传文件列表

		//初始化
		uploader = WebUploader.create({

			swf: '../../../common/Uploader.swf',// swf文件路径

			runtimeOrder: 'html5', //指定上传方式

			server: '../../../content/insertfile_submit.jsp',// 文件接收服务端

			pick: '#picker',// 选择文件的按钮。可选。

			compress: false,//不启用压缩

			resize: false,//尺寸不改变

			threads: 1,//最大上传并发数

			fileNumLimit : 1 , //最大上传文件数

			// 只允许选择视频文件。
			accept: {
				title: 'Video',
				extensions: 'mp3,mp4',
				mimeTypes: 'video/*,audio/*'
			}

		});

		//上传中的错误提示
		uploader.on("error", function (type) {
            if (type == "Q_TYPE_DENIED") {
                alert("请上传正确的格式！");
            } else if (type == "Q_EXCEED_SIZE_LIMIT") {
                alert("文件大小超过限制！");  
            }else if (type == "Q_EXCEED_NUM_LIMIT") {
                alert("文件数量超过限制！只能同时上传一个！");  
            }else {
                alert("上传出错！请检查后重新上传！错误代码"+type);
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
			$( '#'+file.id ).find('p.state').text('已上传');
			uploadSuccess2(file,response._raw);
		});
		//上传出错
		uploader.on( 'uploadError', function( file ) {
			$( '#'+file.id ).find('p.state').text('上传出错');
		});
		//上传结束
		uploader.on( 'uploadFinished', function() {
			state = 'done';
			if(returnData!=""&&returnData!== undefined)
			{
                ueditor.focus();
				ueditor.execCommand('inserthtml',surroundVideo(returnData));
				$(dialog.document).find('.edui-dialog-closebutton div[title="关闭对话框"]').trigger('click');
			}
		});
	});

	//创建上传事件
	function startUpload(){
		if (state === 'uploading' ) {
			uploader.stop();
		} else {
			var browser;
			var option = new Object();

			if(jQuery.support){
				browser="msie";
				option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"UeditorVideo","fieldname":"content","Client":"DirectUpload"};
			}else{
				browser="mozilla";
				option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"UeditorVideo","fieldname":"content","Client":"DirectUpload","Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>"};
			}

			uploader.options.formData= option;
			uploader.upload();		
		}
	}

	function surroundVideo(value){
	    var str = value.trim();
	    var objHtml = "" ;
	    if(str){
			var video_type = <%=video_type%>;

			objHtml+= '<div style="width:100%; height:auto;margin:15px auto;" align="center">';
			if(video_type==1){
				objHtml+= '<div id="tide_video"><span hidden="hidden">video</span>';
				objHtml+= '<video src="'+str+'" controls="controls" poster="../editor/images/spacer.gif" width="100%" height="100%"></video>';
				objHtml+= '</span>';
			}else{
				objHtml+= '<span id="tide_video">';
				objHtml+= '<script>tide_player.showPlayer({video:"'+str+'"});<\/script>';
				objHtml+= '</span>';
				objHtml+='<img class="tide_video_fake" src="../editor/images/spacer.gif"  _fckfakelement="true" _fckrealelement="1">';
			}
			objHtml+="</div>"
	    }
	    return objHtml;
	 }
</script>

</body>
</html>
