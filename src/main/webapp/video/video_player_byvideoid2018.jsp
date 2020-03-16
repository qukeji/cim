<%@ page import="tidemedia.cms.system.Channel,
				tidemedia.cms.system.CmsCache"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
/*
 *  修改人		修改时间		备注
 *  王海龙		20130711		添加了复制视频html代码 使用ZeroClipboard.js处理跨浏览器复制功能 增加了copy() initCopy方法 删除了copyToClipboard()方法
 *  王海龙		20140225		视频预览 可以选择不同码率预览
 */
  int id = getIntParameter(request,"id");
  int channelid = getIntParameter(request,"channelid");
  Channel channel = CmsCache.getChannel(channelid);
  String externalurl= channel.getSite().getExternalUrl();
  String baseurl = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/"; 

%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
    <title>聚视后台</title>

    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">    
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">   
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">  
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/ZeroClipboard.js"></script>
    <script type="text/javascript" src="../common/2018/tidePlayer.js"></script>
    <script type="text/javascript" charset="utf-8">     
function copy(id)
{ 
	var clip = new ZeroClipboard($("#"+id), {
		  moviePath: "../common/ZeroClipboard.swf"
		});
		
		clip.addEventListener( "complete", function(){      
			alert("复制成功！");       
		}); 	 
}  

function initCopy()
{
	$.ajax({
		url:"list_transcode_videos.jsp",
		data:"id=<%=id%>&channelid=<%=channelid%>",
		type:"post",
		dataType:"json",
		success:function(data) 
		{
			var html ='<label class="ht-40">码率选择:</label> <select name="video_select" id="video_select" class="form-control wd-120 ht-40 select2"  onchange="change(this);" data-placeholder="标清">';
			var content = "";
			    
			$.each(data,function(index,obj){
                //alert("obj.flv==="+obj.flv);				
				var flv = obj.flv;	
				html +='<option value="'+obj.title+'" flv="'+flv+'" >'+obj.title+'</option>';				
				if(index==0)//默认显示第一个			
					changeContent(flv);
				 
			});
			html +="</select>";
            $(".v_pre_select").html(html);
		}
	
	});	 
	
       	top.$("#TideDialogClose").click(function(){
		top.$(".v_pre_select").remove("");//先移除码率选择下拉框
	});
	copy("html_code_button");
	copy("player_code_button");
	copy("player_code_url_button");		

}

//下拉框change事件
function change(data)
{
	var flv = $(data).children('option:selected').attr("flv");
	//var vtype =$(data).children('option:selected').attr("vtype");
	changeContent(flv);
}

//弹出窗内容切换
function changeContent(flv)
{
	var htmlCode = "<script src=\"http://cdn.staticfile.org/hls.js/0.10.1/hls.light.min.js\"><\/script><script src=\"<%=baseurl%>\/common\/2018\/tidePlayer.js\"><\/script><script>tidePlayer({video:\""+flv+"\"});<\/script>";
           
   // $("#player_code").val(inputs);
	$("#html_code").val(htmlCode);
	$("#player_code_url").val(flv);
	$(".con_video_content").html('<script>tidePlayer({video:"'+flv+'",width:640,height:480,divid:"con_video_content"});<\/script>');

}

</script>
  </head>
  <style> 	
  	html,body{height: 100%;}
  	#video-preview .video-preview-about{}
  	#video-preview label{margin-bottom: 0;}
  	#video-preview .ht-30{line-height: 30px;}
  	#player_code{height: 90px;}
    #player_code_url{height: 120px;}
    #html_code{height: 210px;}
  	.btn-sm{padding: 0.25rem 0.8rem;}
  	.wd-120{width: 120px;}
	#TIDE_PLAYER_1{height: 480px !important;}
    #TIDE_PLAYER_1 video{width:640px;height: 480px;}
  </style>
  <body class="" onload="initCopy();" id="video-preview"> 
    <div class="bg-white modal-box">
      
	    <div class="pd-20 overflow-y-auto">
	       <div class="d-flex justify-content-between">
	       	<div class="video-preview-box con_video_content" id="con_video_content">
	       		<script>
                    //tidePlayer({video:"",width:640,height:480,divid:"con_video_content"})           
                </script>	       		
	       	</div>
	       	<div class="video-preview-about wd-250">
	       		<div class="row mg-l-0 mg-r-0 alig-items-center v_pre_select">                   		  	  	
	  	  		              		  	  		 						            
   		  	  </div>
   		  	  
   		  	  <div class=" mg-l-0 mg-r-0 mg-t-10">
   		  	  	<div class="d-flex alig-items-center justify-content-between wd-100p mg-b-10">
   		  	  		<span class="ht-30"> 视频路径: </span>
   		  	  		<a href="javascript:;" id = "player_code_url_button"  class="btn btn-info btn-sm">复制</a> 
   		  	  	</div>
   		  	  	<textarea id="player_code_url" class="wd-100p"> </textarea>
   		  	  </div>
   		  	  <div class=" mg-l-0 mg-r-0 mg-t-10">
   		  	  	<div class="d-flex alig-items-center justify-content-between wd-100p mg-b-10">
   		  	  		<span class="ht-30"> html代码: </span>
   		  	  		<a href="javascript:;"  class="btn btn-info btn-sm">复制</a> 
   		  	  	</div>
   		  	  	<textarea id="html_code" id="html_code_button" class="wd-100p"> </textarea>
   		  	  </div>
	       	</div>
	       </div>
	    </div><!-- modal-body -->
      
	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

    
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    
	  <script src="../lib/2018/highlightjs/highlight.pack.js"></script>
    
    <script src="../lib/2018/select2/js/select2.min.js"></script>
    <script src="../common/2018/bracket.js"></script>  
    
    <script>
      $(function(){
      	
      });
    </script>
  </body>
</html>
