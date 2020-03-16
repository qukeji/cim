<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*"%>
<%@ page import="java.beans.Encoder" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
String fieldname = Util.getParameter(request,"fieldname");
int video_type = CmsCache.getParameter("sys_editor_video_type").getIntValue();
int userid = userinfo_session.getId();
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
String inner_url = "",outer_url="";
if(photo_config != null)
{
	int sys_channelid_image = photo_config.getInt("channelid");
	Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
	inner_url = img_site.getUrl();
	outer_url = img_site.getExternalUrl();
}
String video_url ="/vms/video/tcenter_video_upload.jsp?flag=1&userid="+userid+"&fieldname="+fieldname;
	video_url = URLEncoder.encode(video_url,"utf-8");
%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

	<link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <!--<link rel="stylesheet" type="text/css" href="video.css" />-->
	<!-- webuploader -->
	<link rel="stylesheet" type="text/css" href="../ueditor/third-party/webuploader/webuploader.css">
	
	<script src="../lib/2018/jquery/jquery.js"></script>
    <!-- <script type="text/javascript" src="../internal.js"></script> -->
	
	<style>
	  	html,body{width: 100%;height: 100%;}
		.modal-body {top: 45px;bottom: 70px;}
		.config-box{overflow-y: auto;}
		.wd-content-lable{width: 400px;}
		.wd-content-lable-half{width: 120px;}
	</style>
	<script>
		function changeFrameH(_this,index){
			var _index = index ? 5 : 0 ;
			if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
				_this.style.height = _this.contentWindow.document.body.scrollHeight - _index +"px";				
			}else{	
				_this.style.height = _this.contentWindow.document.documentElement.scrollHeight - _index +"px";				
			}
		}
	</script>
	
</head>
<body>
<div class="bg-white modal-box">
      <div class="ht-45 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
        <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab" data-index="0" id="localUpload">本地上传</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab" data-index="1">音视频库</a></li>
        </ul>
      </div>
	    <div class="modal-body pd-0">
	        <div class="config-box ht-100p ">
				<ul class="">
					<li>
						<iframe id="frmMain2" src="/vms/index_tcenter.jsp?url=<%=video_url%>" name="frmMain2" frameborder="0" width="100%" height="479" scrolling="auto" allowtransparency="true"></iframe>
					</li>
					<li>
						<iframe id="frmMain3" src="../ueditor/dialogs/video/video_list.jsp?fieldname=<%=fieldname%>" name="frmMain3" frameborder="0" width="100%" height="479" scrolling="auto" allowtransparency="true"  ></iframe>
					</li>
				</ul>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" >
      	<div class="modal-footer" >
		      <button type="button" id="startButton" class="btn btn-primary tx-size-xs" onclick="confirm ()">确认</button>
		      <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		    </div> 
      </div>
</div>


<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>

<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../common/2018/bracket.js"></script>  
<!-- webuploader -->
<script type="text/javascript" src="../ueditor/third-party/webuploader/webuploader.min.js"></script>

<!-- video -->
<!-- <script type="text/javascript" src="video.js"></script> -->
<!--<script src="../../../common/document.js"></script>-->
<script src="../common/2018/common2018.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>

<script>
var dialog	= window.parent;
var ueditor = dialog.getUE();

//确认事件
function confirm(){
	var html="";
    var img = "<img class=\"tide_video_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
	var _index = $(".nav-link.active").attr("data-index") ;   //_index 为0，1，2  对应三个frmMain1,frmMain2,frmMain3
	if(_index==1){
		$(window.document).find("#frmMain3").contents().find("#right").get(0).contentWindow.getVideoUrl();
		top.TideDialogClose();
    }else if(_index==0){
    	window.frames["frmMain2"].document.getElementById("uploadButton").click();
    	//$("#frmMain2").contentWindow.document.getElementById("uploadButton").click();
    }
	
		//top.TideDialogClose();
	
	//$(parent1).find('.edui-dialog-closebutton div[title="关闭对话框"]').trigger('click')
	//return true ;
}



var video_type = <%=video_type%>;
var inner_url = "<%=inner_url%>";
var outer_url = "<%=outer_url%>";

function previewFile(){
	var name = document.getElementById("photoUrl").value;
	//图片库采用本地预览
	var reg = new RegExp(outer_url,"g");
	if(name=="") return;

	if(name.indexOf("http://")!=-1)  window.open(name.replace(reg,inner_url));
	else	window.open("/" + name);
}

function setPath(path){
	$("#photoUrl").val(path);
}
var channelid = 0;
function selectImage(fieldname){
	var	dialog = new TideDialog();
		dialog.setWidth(730);
		dialog.setHeight(450);
		//dialog.setLayer(2);
		dialog.setZindex(9999);
		dialog.setUrl("../../../ueditor/dialogs/video/insertfile_video.jsp?ChannelID="+channelid+"&Type=Image&fieldname="+fieldname);
		dialog.setTitle("上传图片");
		dialog.show();
}

var parentcID = window.parent.ChannelID ;
//$("#localvideo")[0].src = "ueditor_video.jsp?ChannelID="+parentcID
	//调整iframe高度
	function adjusHeight(i){
		if(i==3){   //调整音视频库里面的iframe高度
			document.getElementById("frmMain3").contentWindow.setTimeoutIfa();
		}
//		if(i==1){
//			return false;
//		}
//		if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
//			document.getElementById("frmMain"+i).style.height = document.getElementById("frmMain"+i).contentWindow.document.body.scrollHeight +5 +"px";				
//		}else{	
//			document.getElementById("frmMain"+i).style.height = document.getElementById("frmMain"+i).contentWindow.document.documentElement.scrollHeight +5 +"px";				
//		}
	}
	;$(function(){
		
		//切换iframe显示
		$("#form_nav a.nav-link").click(function(){
			var _index = parseInt( $(this).attr("data-index") );
			console.log(_index)
			//重新调整高度
			$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
			adjusHeight(_index+1);
		})
		$("#localUpload").click();
	});

</script>
</body>
</html>
