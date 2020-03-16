<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config.jsp"%>
<%
//编辑器上传图片、图片字段上传图片
%>
<%
int ChannelID = getIntParameter(request,"ChannelID");

//图片库频道
String sys_config_photo = CmsCache.getParameterValue("sys_config_photo");
JSONObject jo = new JSONObject(sys_config_photo);
int photo_channelid = jo.getInt("channelid");
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
 
    <title>图片上传</title>
    <!-- vendor css -->
    <link href="../../../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../../../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    
    <link href="../../../lib/2018/highlightjs/github.css" rel="stylesheet">
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../../../style/2018/bracket.css">
    <link rel="stylesheet" href="../../../style/2018/common.css">
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
  <style>
  	html,body{width: 100%;height: 100%;}
	.modal-body {top: 45px;bottom: 70px;}
	.config-box{overflow-y: auto;}
  </style>
  <body class="" >
 
    <div class="bg-white modal-box">
      <div class="ht-45 pd-x-20 bg-gray-200 rounded d-flex align-items-center justify-content-center">
        <ul id="form_nav" class="nav nav-outline align-items-center flex-row" role="tablist">
          <li class="nav-item"><a class="nav-link active" data-toggle="tab" href="#" role="tab" data-index="0">本地图片</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab" data-index="1">图片库</a></li>
          <li class="nav-item"><a class="nav-link" data-toggle="tab" href="#" role="tab" data-index="2">回传图片</a></li>
        </ul>
      </div>
	    <div class="modal-body pd-0">
	        <div class="config-box ht-100p ">
				<ul class="ht-100p">
					<li class="block ht-100p">
						<iframe id="frmMain1" src="ueditor_image.jsp?ChannelID=<%=ChannelID%>" name="frmMain1" frameborder="0" width="100%" height="100%" scrolling="auto" allowtransparency="true" onload="changeFrameH(this,1)"></iframe>
					</li>
					<li>
						<iframe id="frmMain2" src="../../../photo/editor_photo_select2019.jsp?flag=1&id=<%=photo_channelid%>" name="frmMain2" frameborder="0" width="100%" height="100%" scrolling="auto" allowtransparency="true" onload="changeFrameH(this)"></iframe>
					</li>
                    <li>
                        <iframe id="frmMain3" src="../../../photo/editor_photo_select2019.jsp?flag=2&id=<%=photo_channelid%>" name="frmMain3" frameborder="0" width="100%" height="100%" scrolling="auto" allowtransparency="true" onload="changeFrameH(this)"></iframe>
                    </li>
				</ul>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" >
      	<div class="modal-footer" >
		      <button type="button" class="btn btn-primary tx-size-xs" onclick="confirm()">确认</button>
		      <button type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		    </div> 
      </div>
	    
	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->

    <script src="../../../lib/2018/jquery/jquery.js"></script>
    <script src="../../../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../../../lib/2018/popper.js/popper.js"></script>
    <script src="../../../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../../../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../../../lib/2018/moment/moment.js"></script>
    
    <script src="../../../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <script src="../../../lib/2018/peity/jquery.peity.js"></script>
    
	<script src="../../../lib/2018/highlightjs/highlight.pack.js"></script>
    
    <script src="../../../lib/2018/select2/js/select2.min.js"></script>
    <script src="../../../common/2018/bracket.js"></script>  
	
    <script>	
		
		var dialog	= window.parent;
		var ueditor = dialog.getUE();
		
		//确认事件
		function confirm(){

			var _index = $(".nav-link.active").attr("data-index") ;   //_index 为0，1，2  对应三个frmMain1,frmMain2,frmMain3
			if(_index==0){

				var frmMain = window.frames["frmMain1"];

				if ( frmMain.Ok && frmMain.Ok() ){
					//top.TideDialogClose();
				}else{
					frmMain.focus();
				}
			
			}else{
				var frmMain = "frmMain"+(parseInt(_index)+1);
				var obj=window.frames[frmMain].getCheckbox();
				var gids=obj.id;
				$.ajax({
					type:"POST", 
					url:"../../../content/insertfile_from_photosource2019.jsp",
					data:"picid="+gids+"&type=1",
					async:false,
					dataType:"html",
					success:function(msg){

						if(msg!=""){
							ueditor.focus();
							ueditor.execCommand('inserthtml',msg);

							top.TideDialogClose();
						}else{
							alert("插入失败！");
						}
										 
					},
					error:function(msg)
					{
					   alert("选择失败");
					}

				});
			}
		}
		
		
		function adjusHeight(i){
			if(i==1){
				return false;
			}
			if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
				document.getElementById("frmMain"+i).style.height = document.getElementById("frmMain"+i).contentWindow.document.body.scrollHeight +15 +"px";				
			}else{	
				document.getElementById("frmMain"+i).style.height = document.getElementById("frmMain"+i).contentWindow.document.documentElement.scrollHeight +15 +"px";				
			}
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
