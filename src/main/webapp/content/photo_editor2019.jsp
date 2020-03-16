<%@ page import="tidemedia.cms.system.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>


<!DOCTYPE html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>添加字段</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

    <script src="../lib/2018/select2/js/select2.min.js"></script>
    
    <script src="../common/2018/bracket.js"></script>
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	.modal-body .config-box .row{
  		margin-bottom: 10px;
  	}
  	.modal-body .config-box label.ckbox{
  		width: auto;
  		margin-right: 10px;
  	}
  	.modal-body .config-box label.ckbox input{
  		
  		margin-right: 2px;
  	}
  </style>
  <script >
  function init(){
		var ChannelID = GetQueryString("ChannelID");
		var img = GetQueryString("img");
		var fieldname = GetQueryString("fieldname");
		document.getElementById("imgeditor").src="../photo/image_editor2019.jsp?ChannelID="+ChannelID+"&img="+img+"&fieldname="+fieldname;
	}
		 
	//获取参数
	function GetQueryString(name)
	{
	     var reg = new RegExp("(^|&)"+ name +"=([^&]*)(&|$)");
	     var r = window.location.search.substr(1).match(reg);
	     if(r!=null)return  unescape(r[2]); return null;
	}
	function dothis(){
	    var fieldname = GetQueryString("fieldname");
        var childWindow = $("#imgeditor")[0].contentWindow;  
        childWindow.save(); 
        var url = childWindow.document.getElementById("image_src").value;
        //2.拿到父框口对象
        var w=window.parent;
        //3.拿到父窗口中的文本框对象
        w.document.getElementById(fieldname).value=url;
        //4.将内容赋值给父窗口中的文本框对象的value属性
        
        top.TideDialogClose({suffix:'_1'});
        
	}
   function cancel(){
        top.TideDialogClose({suffix:'_1'});
        
	}

</script>
  </head>
  <body  onload="init();">
<div class="wrapper">
	<iframe  marginheight="0" frameborder="no"  id="imgeditor" name="imgeditor" marginwidth="0" scrolling="auto" height="500" width="850" ></iframe>
</div>
 <div class="btn-box" >
      	<div class="modal-footer" >
		      <button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onclick="dothis();">确认</button>
		      <button name="btnCancel1" type="button"  id="btnCancel1" class="btn btn-secondary tx-size-xs" data-dismiss="modal" onclick="cancel();">取消</button>
		    </div> 
      </div>
    
    
    <script>

    </script>
  </body>
</html>
