<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id =Util.getIntParameter(request,"id");
TemplateFile tf =new TemplateFile(id);
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
<script  type="text/javascript">
function check()
{
	if(isEmpty(document.form.Name,"请输入文件名."))
		return false;

	return true;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
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
 <form >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	       		 				 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">文件名：</label>
		              <label class="wd-230">
		                 <span><%=tf.getFileName()%></span>
		              </label>									            
	   		  	</div>
				
                 <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">名称：</label>
		              <label class="wd-230">
		                <span><%=tf.getName()%></span>
		              </label>									            
	   		  	</div>
				<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">模板描述：</label>
		              <label class="wd-230">
		                <span><%=tidemedia.cms.util.Util.convertNewlines(tf.getDescription())%></span>
		              </label>									            
	   		  	</div>
				<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">预览图片：</label>
		              <label class="wd-230">
		                <span></span>
		              </label>									            
	   		  	</div>
                <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">使用的频道：</label>
		              <label class="wd-230">
		                <span><%=tf.listChannelUse()%></span>
		              </label>								            
	   		  	</div>				
                 				
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >		    		     
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-primary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
  </body>
                  <script src="../lib/2018/jquery/jquery.js"></script>
                  <script src="../common/2018/common2018.js"></script>
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
