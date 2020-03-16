<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
String Type			= getParameter(request,"Type");
String fieldname	= getParameter(request,"fieldname");
int ChannelID		= getIntParameter(request,"ChannelID");
int photoType		= getIntParameter(request,"photoType");

String CompressWidth = "";
String CompressHeight = "";
String UseCompressCheck = "";
String PhotoScheme = "<option value='0'>尺寸方案</option>";

String file_types = "*.*";
String file_types_description = "所有文件";
if(Type.equalsIgnoreCase("Image"))
{
	file_types = "*.gif;*.jpg;*.png;*.jpeg";
	file_types_description = "图片文件";

	Field field = new Field(fieldname,ChannelID);
	System.out.println("field:"+field.getName()+","+fieldname+","+ChannelID);
	String Other = field.getOther();
	if(Other!=null && Other.length()>0)
	{
		TideJson json = Util.getMyJson(Other);
		CompressWidth = json.getString("width");
		CompressHeight = json.getString("height");

		if(CompressWidth.length()>0 || CompressHeight.length()>0)
			UseCompressCheck = "checked";
	}

	TableUtil tu = new TableUtil();
	String sql = "select * from photo_scheme";
	ResultSet rs = tu.executeQuery(sql);
	while(rs.next())
	{
		String name = tu.convertNull(rs.getString("Name"));
		PhotoScheme += "<option value='' width='"+rs.getInt("Width")+"' height='"+rs.getInt("Height")+"'>"+name+"</option>";
	}
	tu.closeRs(rs);

}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>

<link href="../../../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../../../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../../../lib/2018/select2/css/select2.min.css" rel="stylesheet">
<link rel="stylesheet" href="../../../style/2018/bracket.css">  
<link rel="stylesheet" href="../../../style/2018/common.css">

<style>
.collapsed-menu .br-mainpanel-file{margin-left: 0;margin-top: 0;}
html,body{width: 100%;height: 100%;}
.modal-body .config-box .row{margin-bottom:20px;height: 40px;margin-left:0;}
.modal-body-btn .config-box .row .left-fn-title{min-width:80px;text-align: left;}
.modal-body .config-box label.ckbox{width:80px;cursor:pointer;margin-right:10px;}
.table thead th{vertical-align: middle;}
.table th{padding: 0.3rem 0.75rem ;}
.table td{padding: 0.4rem 0.75rem ;}
</style>

<script src="../../../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../../../common/webuploader.js"></script>

</head>
<body>
<div class="bg-white modal-box"> 

<div class="modal-body modal-body-btn pd-20 overflow-y-auto">

<form action="insertimage_video.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check();">
	<div class="config-box">

		<div class="row">
			<div class="btn-group hidden-xs-down file_upload_choose" id="uploader">         
				<label id="picker">图片上传</label>                             			                  		              	                  
			</div>
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
	    <button name="btnCancel1" type="button" onclick="parent.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
	</div>
</div>

</div>


<script type="text/javascript">
	//h5上传
	
	function previewFile(fieldname)
	{
		var name = document.getElementById(fieldname).value;
		//图片库采用本地预览
		var reg = new RegExp(outer_url,"g");
		if(name=="") return;

		if(name.indexOf("http://")!=-1)  window.open(name.replace(reg,inner_url));
		else	window.open("/" + name);
	}

	var isImage = <%=Type.equalsIgnoreCase("Image")%>;
	var acceptType = {};
	if(isImage){
	   acceptType = {title: 'Images',extensions: 'gif,jpg,jpeg,png',mimeTypes: 'image/gif,image/jpg,image/jpeg,image/png'};
	}

	var returnData = "";//接口返回
	function uploadSuccess2(file, serverData) {
		returnData = returnData + serverData;
	}

	// 图片上传
	jQuery(function() {
		var $ = jQuery,
			$list = $('#thelist'),//上传文件列表
			$btn = $('#startButton'),//开始上传
			state = 'pending',
			uploader;
		//初始化
		uploader = WebUploader.create({

			accept: acceptType ,// 只允许选择图片文件。
			
			swf: '../../../common/Uploader.swf',// swf文件路径
			
			server: '../../../content/insertfile_submit.jsp',// 文件接收服务端。

			pick: '#picker',// 选择文件的按钮。可选。
			
			fileNumLimit: 1,//文件数量

			compress: false,//不启用压缩

			resize: false//尺寸不改变

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
				var option;
				var ReWrite;
				var browser;

				if(jQuery.support){
					browser="msie";
					option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"<%=Type%>","fieldname":"<%=fieldname%>","Client":"DirectUpload"};
				}else{
					browser="mozilla";
					option={"browser":browser,"ChannelID":"<%=ChannelID%>","Type":"<%=Type%>","fieldname":"<%=fieldname%>","Client":"DirectUpload","Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>"};
				}
				<%if(Type.equalsIgnoreCase("Flash") || Type.equalsIgnoreCase("Video")){%>
					var Width=jQuery("#Width").val();
					var Height=jQuery("#Height").val();
					jQuery.extend(option,{"Width":Width,"Height":Height});  
				<%}else if(Type.equalsIgnoreCase("Image")){%>
					var Watermark="";
					var IsCompress = "";
					var mask_location="";
					if(jQuery("#Watermark").is(':checked'))
					{
						Watermark="Yes";
						mask_location = $("#mask_location").val();
					}
					if(jQuery("#IsCompress").is(':checked')){
						IsCompress="1";
					}
					jQuery.extend(option,{"Watermark":Watermark,"IsCompress":IsCompress,"CompressHeight":$("#CompressHeight").val(),"CompressWidth":$("#CompressWidth").val(),"mask_location":mask_location,"photoType":$("#photoType").val()});
				<%}%>
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
			uploadSuccess2(file,response._raw);
		});
		//上传出错
		uploader.on( 'uploadError', function( file ) {
			$( '#'+file.id ).find('p.state').text('上传出错');
		});
		//上传结束
		uploader.on( 'uploadFinished', function() {
			state = 'done';

            //parent.$("#photoUrl").val(returnData.trim());
            top.TideDialogClose({suffix:'_2',recall:true,returnValue:{photoUrl:returnData.trim()}});
		});
	});
</script>

</body>
</html>
