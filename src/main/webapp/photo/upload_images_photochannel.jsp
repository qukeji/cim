<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Type			= getParameter(request,"Type");
String fieldname			= getParameter(request,"fieldname");
int ChannelID		= getIntParameter(request,"ChannelID");
int parentGlobalID	= getIntParameter(request,"globalid");
int fieldgroup		= getIntParameter(request,"fieldgroup");

String file_types = "*.*";
String file_types_description = "所有文件";
file_types = "*.gif;*.jpg;*.png;*.jpeg";
file_types_description = "图片文件";
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">  
<link rel="stylesheet" href="../style/2018/common.css">

<style>
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
html,body{width: 100%;height: 100%;}
.modal-body .config-box .row{margin-bottom: 20px;height: 40px;}
.modal-body-btn .config-box .row .left-fn-title{min-width: 80px;text-align: left;}
.modal-body .config-box label.ckbox{width: 90px;cursor: pointer;margin-right: 40px;}
.table thead th{vertical-align: middle;}
.table th{padding: 0.3rem 0.75rem ;}
.table td{padding: 0.4rem 0.75rem ;}
label {margin-right: 10px;}
</style>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/webuploader.js"></script>

</head>
<body>

<div class="bg-white modal-box">

<div class="modal-body modal-body-btn pd-20 overflow-y-auto">

<form action="upload_images_submit_photochannel.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check();">
	<div class="config-box">
<%if(Type.equals("Image")){%>
   	<!-- <tr>
    <td colspan="2">
	<input type=checkbox name="Watermark" value="Yes" id="Watermark">
        <label for="Watermark">加上水印</label>
	    <select id="mask_location">
		<option value="rightbottom">右下方</option>
		<option value="righttop">右上方</option>
		<option value="middle">居中</option>
		<option value="leftbottom">左下方</option>
		<option value="lefttop">左上方</option>
		</select>
	
	<input type=checkbox name="IsCompress" value="1" id="IsCompress" checked> <label for="IsCompress">压缩图片</label>
	<label for="CompressWidth">宽度：</label><input type="text" value="" name="CompressWidth" size=5 id="CompressWidth">
	<label for="CompressHeight">高度：</label><input type="text" value="" name="CompressHeight" id="CompressHeight" size=5> <input type="checkbox" name="UseCompress" value="1" id="UseCompress"><label for="UseCompress">使用压缩后图片</label>
	</td>
  </tr>-->
<%}%>
		<div class="row">
			<div class="btn-group hidden-xs-down file_upload_choose" id="uploader">         
				<label id="picker">选择文件</label>                             			                  		              	                  
			</div>
			<label class="ckbox mg-b-0-force mg-l-20">
				<input type="checkbox" name="Watermark" id="Watermark" value="Yes"><span for="Watermark">加上水印</span>
			</label>
			<label>
				<select id="mask_location" class="form-control wd-82 ht-40 select2">
					<option value="rightbottom">右下方</option>
					<option value="righttop">右上方</option>
					<option value="middle">居中</option>
					<option value="leftbottom">左下方</option>
					<option value="lefttop">左上方</option>
				</select>
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

<div class="btn-box">
 	<div class="modal-footer" >		     
		<button name="startButton" type="button" class="btn btn-primary tx-size-xs"  id="startButton">确定</button>
	    <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
	</div> 
</div>

</div>

<script>
	var returnData = "";
	//h5上传
	jQuery(function() {
		var $ = jQuery,
			$list = $('#thelist'),//上传文件列表
			$btn = $('#startButton'),//开始上传
			state = 'pending',
			uploader;
		//初始化
		uploader = WebUploader.create({
			
			swf: '../common/Uploader.swf',// swf文件路径
			
			server: '../photo/upload_images_submit_photochannel.jsp',// 文件接收服务端。
			
			pick: '#picker',// 选择文件的按钮。可选。内部根据当前运行是创建，可能是input元素，也可能是flash.

			compress: false,//不启用压缩

			resize: false,//尺寸不改变

			threads: 1,//最大上传并发数

			// 只允许选择图片文件。
			accept: {
				title: 'Images',
				extensions: 'gif,jpg,jpeg,png',
				mimeTypes: 'image/gif,image/jpg,image/jpeg,image/png'
			}
		});
		// 当有文件添加进来的时候
		uploader.on( 'fileQueued', function( file ) {
			$list.append( '<tr id="' + file.id + '">' +
				'<td>' + file.name + '<\/td>' +
				'<td id= "'+file.id+"_schedule"+'"><\/td>' +
				'<td>' + Math.floor((file.size)/1024) + 'KB<\/td>' +
				'<td id="'+file.id+"_del"+'" class="tx-center"><\/td>' +
			'<\/tr>' );

			var $btns = $("#"+file.id+"_del").html('<a class="file_del">' +
				'<i class="fa fa-times tx-danger tx-18" aria-hidden="true"></i></a>');
			//删除文件		
			$btns.on( 'click', function() {
				uploader.removeFile( file,true );
				$("#"+file.id+"").remove();
			});
		});
		//创建上传事件
		$btn.on( 'click', function() {
			if (state === 'uploading' ) {
				uploader.stop();
			} else {
				var browser;
				var option;
				var Watermark="";
				var IsCompress = "";
				var UseCompress = "";
				var mask_location="";
				if(jQuery("#Watermark").is(':checked')){
						Watermark="Yes";
						mask_location=$("#mask_location").val();
				}
				if(jQuery("#IsCompress").is(':checked')){
						IsCompress="1";
				}
				 
				if(jQuery("#UseCompress").is(':checked')){
						UseCompress="1";
				}
				if(jQuery.support){
					browser="msie";
					option={"browser":browser,"ChannelID":"<%=ChannelID%>","parentGlobalID":"<%=parentGlobalID%>","Type":"<%=Type%>","fieldname":"<%=fieldname%>","Watermark":Watermark,"IsCompress":IsCompress,"UseCompress":UseCompress,"mask_location":mask_location};
				}else{
					browser="mozilla";
					option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"<%=Type%>","fieldname":"<%=fieldname%>","Watermark":Watermark,"Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>","IsCompress":IsCompress,"UseCompress":UseCompress,"mask_location":mask_location};
				}
				jQuery.extend(option,{"fieldgroup":"<%=fieldgroup%>","parentGlobalID":"<%=parentGlobalID%>"});
				uploader.options.formData= option;
				uploader.upload();		
			}
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
			returnData = response._raw;
		});
		//上传出错
		uploader.on( 'uploadError', function( file ) {
			$( '#'+file.id ).find('p.state').text('上传出错');
		});
		//上传结束
		uploader.on( 'uploadFinished', function() {
			state = 'done';
			eval(returnData);
		});
	});
</script>
</body>
</html>