<%@ page import="tidemedia.cms.system.*,
                java.sql.*,
				java.net.URL,
				tidemedia.cms.spider.*,
				tidemedia.cms.base.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String action =	getParameter(request,"action");
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
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS</title>

    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <!--<link href="../../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">-->
    <!--<link href="../../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">-->
    
    <!--<link href="../lib/highlightjs/github.css" rel="stylesheet">-->
    
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script type="text/javascript">


</script>  
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	.modal-body-btn .config-box .row .left-fn-title{
  		min-width: 70px;
  	}
  </style>  
  </head>
  <body class="">
    <div class="bg-white modal-box">
 <form name="form" method="post" action="list_del2018.jsp" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">		
	        <div class="config-box mg-t-15">
			<%if(action.equals("fileNull")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请选择文件!</label>							            
	   		  	</div>	                							       
	         <%}%>  
            <%if(action.equals("fileMore")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请选择一个文件!</label>							            
	   		  	</div>	                								       
	         <%}%>  
			 <%if(action.equals("numberNull")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请输入数字!</label>							            
	   		  	</div>	                							       
	         <%}%>  
			 <%if(action.equals("publishFileNull")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请选择要发布的文件!</label>							            
	   		  	</div>	                							       
	         <%}%>  
              <%if(action.equals("delNull")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请选择要删除的文件!</label>							            
	   		  	</div>
               <%}%> 
			    <%if(action.equals("previewFileNull")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请选择要预览的文件!</label>							            
	   		  	</div>
               <%}%> 
			    <%if(action.equals("previewFileMore")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请选择一个要预览的文件!</label>							            
	   		  	</div>
               <%}%> 
              <%if(action.equals("downfileNull")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请选择要下载的文件!</label>							            
	   		  	</div>
               <%}%> 	
               <%if(action.equals("downfileMore")){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">请选择一个要下载的文件!</label>							            
	   		  	</div>
               <%}%> 				   
	        </div>
	           			 
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >		    		      
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-primary tx-size-xs" data-dismiss="modal">确定</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->
    
  </body>
</html>
