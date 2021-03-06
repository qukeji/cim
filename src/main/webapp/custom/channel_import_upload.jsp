<%@ page import="tidemedia.cms.util.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int ChannelID = Util.getIntParameter(request,"ChannelID");
String FolderName =Util.getParameter(request,"FolderName");
int SiteId = Util.getIntParameter(request,"SiteId");


%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
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
	.modal-body .config-box .row{margin-bottom: 10px;height: 32px;}
	.modal-body-btn .config-box .row .left-fn-title{min-width: 80px;text-align: left;}
	.modal-body .config-box label.ckbox{width: 90px;cursor: pointer;margin-right: 30px;}
	.table thead th{vertical-align: middle;}
	.table th{padding: 0.3rem 0.75rem ;}
	.table td{padding: 0.4rem 0.75rem ;}
</style>
<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/webuploader.js"></script>

</head>
<body>
<div class="bg-white modal-box">
	<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
		<form action="channel_import_upload_submit.jsp" enctype="multipart/form-data" method="post"  name="form" onSubmit="return check();">
			<div class="config-box">
				<div class="row">                   		  	  	
		  		  	<label class="left-fn-title">上级目录：<span><%=FolderName%></span></label>
					<label class="ckbox mg-b-0-force mg-l-20">
						<input type="checkbox" name="ReWrite" id="ReWrite" value="Yes"><span>重名覆盖</span>
					</label>
					<div class="btn-group hidden-xs-down file_upload_choose" id="uploader">         
		          		<label id="picker">选择文件 </label>                             			                  		              	                  
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
	      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
	    </div> 
	</div>	  
</div>

<script>
var returnData = "";//接口返回
var filePath = "";
// 文件上传
jQuery(function() {
    var $ = jQuery,
        $list = $('#thelist'),//上传文件列表
        $btn = $('#startButton'),//开始上传
        state = 'pending',
        uploader;

	//初始化
    uploader = WebUploader.create({
		
        swf: '../common/Uploader.swf',// swf文件路径
        
        server: '../custom/channel_import_upload_submit.jsp',// 文件接收服务端。
        
        pick: '#picker',// 内部根据当前运行是创建，可能是input元素，也可能是flash.
        
		compress: false,//不启用压缩

        resize: false//尺寸不改变
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
			'<img src="../images/inner_menu_del.gif"></a>');
		//删除文件		
		$btns.on( 'click', function() {
			uploader.removeFile( file,true );
			$("#"+file.id+"").remove();
		});

    });
	//创建上传事件
    $btn.on( 'click', function() {
        if ( state === 'uploading' ) {
            uploader.stop();
        } else {
			var option;
			var ReWrite;
			var browser;
			
			if(jQuery("#ReWrite").is(':checked')){
					ReWrite="Yes";
			}else{
					ReWrite="";
			}
			if(jQuery.support){
				browser="msie";
			option={"browser":browser,"FolderName":"<%=FolderName%>","SiteId":"<%=SiteId%>","ReWrite":ReWrite};
			}else{
				browser="mozilla";
				option={"browser":browser,"FolderName":"<%=FolderName%>","SiteId":"<%=SiteId%>","ReWrite":ReWrite,"Username":"<%=userinfo_session.getUsername()%>","Password":"<%=userinfo_session.getMd5Password()%>"};
			}
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
		filePath = file.name;
    });
	//上传出错
    uploader.on( 'uploadError', function( file ) {
        $( '#'+file.id ).find('p.state').text('上传出错');
    });
	//上传结束
	uploader.on( 'uploadFinished', function(file) {
		state = 'done';
		returnData = iGetInnerText(returnData);
		if(returnData!=""){//上传成功，接口返回空，否则弹出失败信息
			alert(returnData);
		}else{
			$('#file',window.parent.window.frames["popiframe_1"].document).val(filePath)
		}
        top.TideDialogClose('');
    });
});
//获取接口返回值
function uploadSuccess2(file, serverData) 
{
	returnData = returnData + serverData;
}
//取出空格，回车，换行
function iGetInnerText(testStr) {
	var resultStr = testStr.replace(/\ +/g, "");
	resultStr = testStr.replace(/[ ]/g, "");
	resultStr = testStr.replace(/[\r\n]/g, "");
	return resultStr;
}
</script>
</body>
</html>