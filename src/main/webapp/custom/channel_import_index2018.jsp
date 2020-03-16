<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.*,
				tidemedia.cms.base.*,
				java.sql.*,
				java.util.concurrent.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
     /**
	  * 用途 ：频道导入
	  * 
	  */
%>
<!DOCTYPE html>
<html >
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
    <!-- Meta -->
  <!--  <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">  -->
   <!-- <meta name="author" content="ThemePixels"> -->
     <!-- <link rel="Shortcut Icon" href="../favicon.ico">  -->
    <title>TideCMS</title>

    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">   
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">	
<script type="text/javascript">
function ok(){

	var file=$("#file").val();
	var channelId = $("#channelId").val();

	if (file!=""&&channelId!=""){

		$.ajax({
			url: "../custom/channel_import_xml.jsp?file="+file+"&channelId="+channelId,
			type:"get",
			async:false,
		    success:function(data){
				alert(data.trim());
			}
		});

		top.TideDialogClose('');
	}else{
		alert("参数不能为空");
	}
}
function uploadFile()
{
	var	dialog = new top.TideDialog();
		dialog.setWidth(600);
		dialog.setHeight(400);
		dialog.setUrl("../custom/channel_import_upload.jsp?FolderName=/jushi/temp&SiteId=21");
		dialog.setTitle("上传文件");
		dialog.show();
}


</script>
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  </style>  
  </head>
  <body class="" >
    <div class="bg-white modal-box">
<form name="form" action="" method="post" >
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">		 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">导入文件：</label>
		              <label class="wd-180">
		                <input name="file" id="file" class="form-control" placeholder="" type="text">
		              </label>		
                        <input class="btn btn-primary tx-size-xs mg-l-10" id="picker" href="javascript:;" name="" type="button" value="选择" onclick="uploadFile()">					  
	   		  	</div>
	   		  	
                 <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">目标频道编号：</label>
		              <label class="wd-180">
		                <input name="channelId" id="channelId" class="form-control" placeholder="" type="text" >
		              </label>									            
	   		  	</div>							
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		     <input type="hidden" name="Submit" value="Submit">
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton" onclick="ok();">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
  </body>
               <script type="text/javascript" src="../common/common.js"></script>
	           <script src="../lib/2018/jquery/jquery.js"></script>
	            <script src="../lib/2018/popper.js/popper.js"></script>
                <script src="../lib/2018/bootstrap/bootstrap.js"></script>
                <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
                <script src="../lib/2018/moment/moment.js"></script>
                <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
                <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
                <script src="../lib/2018/peity/jquery.peity.js"></script>
                <script src="../lib/2018/select2/js/select2.min.js"></script>
                <script src="../common/2018/bracket.js"></script>

</html>

