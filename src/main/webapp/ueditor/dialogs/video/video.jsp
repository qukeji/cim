<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
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
	String video_url ="/vms/video/tcenter_video_upload.jsp?userid="+userid+"&video_type="+video_type;
	video_url = URLEncoder.encode(video_url,"utf-8");
%>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
    
	<link href="../../../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../../../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">

	<link href="../../../lib/2018/highlightjs/github.css" rel="stylesheet">
    <link rel="stylesheet" href="../../../style/2018/bracket.css">
    <link rel="stylesheet" href="../../../style/2018/common.css">
    <!--<link rel="stylesheet" type="text/css" href="video.css" />-->
	<!-- webuploader -->
	<link rel="stylesheet" type="text/css" href="../../third-party/webuploader/webuploader.css">
	
	<script src="../../../lib/2018/jquery/jquery.js"></script>
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
          <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#" role="tab" data-index="0">插入地址</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab" data-index="1">本地上传</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab" data-index="2">音视频库</a></li>
        </ul>
      </div>
	    <div class="modal-body pd-0">
	        <div class="config-box ht-100p ">
				<ul class="">
					<li class="block">
						<div id="video" class="pd-20">
							<div class="row flex-row align-items-center mg-y-10" id="">
								<label class="left-fn-title wd-100" id="">音视频地址：</label>
								<label class="wd-content-lable d-flex " id="">
									<input type="text" class="textfield form-control" size="80" name="DocFrom" id="videoUrl" value=""> 
								</label>
							</div>
							<div class="row mg-t--10" id="">
								<label class="left-fn-title wd-100"> </label>
								<label class="d-flex align-items-center tx-gray-800 tx-12">
									<i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>请填写完整音视频地址，视频格式：mp4   视频编码：h264；音频格式：mp3
								</label>
							</div>
							<div class="row flex-row align-items-center mg-y-10" id="">
								<label class="left-fn-title wd-100" id="">封面图：</label>
								<label class="wd-content-lable d-flex " id="">
									<input type="text" name="Photo" id="photoUrl" value="" class=" form-control" title="" size="80" data-original-title="">
								</label>
								<label><input type="button" value="上传" onclick="selectImage('Photo')" class="btn btn-primary tx-size-xs mg-l-10"></label>
								<label><input type="button" value="预览" onclick="previewFile('Photo')" class="btn btn-primary tx-size-xs mg-l-10"></label>
							</div>
							
							<div class="row flex-row align-items-center mg-y-10" id="">
								<label class="left-fn-title wd-100" id="">画面尺寸：</label>
								<label class="wd-content-lable-half d-flex mg-r-20 " id="">
									<input type="text" class="form-control" size="80" name="" id="videoWidth" placeholder="宽" value=""> 
								</label>
								
								<label class="wd-content-lable-half d-flex mg-r-20" id="">
									<input type="text" class="form-control" size="80" name="" id="videoHeight" placeholder="高" value=""> 
								</label>
							</div>
						</div>
						
					</li>
					<li>
						<iframe id="frmMain2" src="/vms/index_tcenter.jsp?url=/vms/video/tcenter_video_upload.jsp?url=<%=video_url%>" name="frmMain2" frameborder="0" width="100%" height="479" scrolling="auto" allowtransparency="true"></iframe>
					</li>
					<li>
						<iframe id="frmMain3" src="video_list.jsp" name="frmMain3" frameborder="0" width="100%" height="479" scrolling="auto" allowtransparency="true"  ></iframe>
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


<script src="../../../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../../../lib/2018/popper.js/popper.js"></script>
<script src="../../../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../../../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../../../lib/2018/moment/moment.js"></script>

<script src="../../../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../../../lib/2018/peity/jquery.peity.js"></script>
<script src="../../../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../../../common/2018/bracket.js"></script>  
<!-- webuploader -->
<script type="text/javascript" src="../../third-party/webuploader/webuploader.min.js"></script>

<!-- video -->
<!-- <script type="text/javascript" src="video.js"></script> -->
<!--<script src="../../../common/document.js"></script>-->
<script src="../../../common/2018/common2018.js"></script>
<script type="text/javascript" src="../../../common/2018/TideDialog2018.js"></script>

<script>
var dialog	= window.parent;
var ueditor = dialog.getUE();

//确认事件
function confirm(){
	var html="";
    var img = "<img class=\"tide_video_fake\" src=\"../editor/images/spacer.gif\" _fckfakelement=\"true\" _fckrealelement=\"1\">";
	var _index = $(".nav-link.active").attr("data-index") ;   //_index 为0，1，2  对应三个frmMain1,frmMain2,frmMain3
	if(_index==0){
		var isCode = false ;
		var codeValue=  document.getElementById("videoUrl").value;
		if(!codeValue){
			top.TideDialogClose();
		   return false 
		}
		var videoUrlValue = document.getElementById("videoUrl").value;
		var photoUrlValue = document.getElementById("photoUrl").value;
		var videoWidthValue = document.getElementById("videoWidth").value;
		var videoHeightValue = document.getElementById("videoHeight").value;
		videoWidthValue==""?videoWidthValue="100%":videoWidthValue=videoWidthValue+"px";
		videoHeightValue==""?videoHeightValue="100%":videoHeightValue=videoHeightValue+"px";

		html+= '<div style="width:100%; height:auto;margin:15px auto;" align="center">';
		if(video_type==1){
			html+= '<div id="tide_video"><span hidden="hidden">video</span>';
			html+= '<video src="'+videoUrlValue+'" controls="controls" poster="'+photoUrlValue+'" width="'+videoWidthValue+'" height="'+videoHeightValue+'"></video>';
			html+= '</div>';
		}else{
			html+= '<span id="tide_video">';
			html+= '<script>tide_player.showPlayer({video:"'+videoUrlValue+'",width:"'+videoWidthValue+'",height:"'+videoHeightValue+'",cover:"'+photoUrlValue+'"});<\/script>';
			html+= '</span>';
			html+='<img class="tide_video_fake" src="../editor/images/spacer.gif"  _fckfakelement="true" _fckrealelement="1">';
		}
		html+="</div>"
			if(html!=""&&html!== undefined)
			{
				ueditor.focus();
				ueditor.execCommand('inserthtml',html);
				top.TideDialogClose();
				//editor.setContent(html,true); 	
			}
    }else if(_index==2){
		$(window.document).find("#frmMain3").contents().find("#right").get(0).contentWindow.getCheckRadio();
		top.TideDialogClose();
    }else if(_index==1){
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
	var	dialog = new top.TideDialog();
		dialog.setWidth(730);
		dialog.setHeight(450);
		//dialog.setLayer(2);
		dialog.setZindex(9999);
		dialog.setUrl("../ueditor/dialogs/video/insertfile_video.jsp?ChannelID="+channelid+"&Type=Image&fieldname="+fieldname);
		dialog.setTitle("上传图片");
		dialog.show();
}

function setReturnValue(o) {
    if (o.photoUrl != null) {
        $("#photoUrl").val(o.photoUrl);
    }
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
	 
	});

</script>
</body>
</html>
