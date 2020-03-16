<%@ page import="tidemedia.cms.util.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int ChannelID = Util.getIntParameter(request,"ChannelID");
String FolderName =Util.getParameter(request,"FolderName");
int SiteId = Util.getIntParameter(request,"SiteId");

if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style> 
.file_upload_dir,.file_upload_over,.file_upload_choose,.file_upload_choose_txt{float:left;line-height:28px;}
.file_upload_over{margin:0 15px;*margin:-4px 15px 0;}
.file_upload_over label{vertical-align:middle;cursor:pointer;margin:0 0 0 2px;*margin:0;}
.file_upload_choose .swfupload{margin:-5px 0 0;}

#picker{float:left;margin-right:5px;line-height:26px;padding:0;}
#picker .webuploader-pick {padding:0 10px;display: block;}
.webuploader-element-invisible {position: absolute !important;clip: rect(1px 1px 1px 1px); /* IE6, IE7 */clip: rect(1px,1px,1px,1px);}
.progress-bar{background:url(../images/upload_jdt_box.gif) repeat-x;height:12px;text-align: center;line-height: 12px;}

</style>

<script type="text/javascript" src="../common/jquery.min.js"></script>
<script type="text/javascript" src="../common/webuploader.js"></script>


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
						<td align="left" valign="middle">
							<span class="file_upload_dir">上级目录：<%=FolderName%></span>
							<span class="file_upload_over">
								<input type="checkbox" name="ReWrite" id="ReWrite" value="Yes">
								<label for="ReWrite">重名覆盖</label>
							</span>
							<div class="file_upload_choose">
								<div id="uploader" class="wu-example">
									<div class="btns">
										<div id="picker" class="tidecms_btn2">选择文件</div>
									</div>
								</div>
							</div>
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
									<tbody id="thelist">

									</tbody>
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
		<input name="startButton" type="button" class="tidecms_btn2" value="确定" id="startButton"/>
		<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
	</div>
</form>
<script>
var returnData = "";//接口返回
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
        
        server: '../explorer/file_upload_submit.jsp',// 文件接收服务端。
        
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
    });
	//上传出错
    uploader.on( 'uploadError', function( file ) {
        $( '#'+file.id ).find('p.state').text('上传出错');
    });
	//上传结束
	uploader.on( 'uploadFinished', function() {
		state = 'done';
		returnData = iGetInnerText(returnData);
		if(returnData!=""){//上传成功，接口返回空，否则弹出失败信息
			alert(returnData);
		}
        top.TideDialogClose({refresh:'right',close: true}); 
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