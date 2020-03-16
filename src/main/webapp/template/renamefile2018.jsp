<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int 	ItemID			=Util.getIntParameter(request,"ItemID");
int 	GroupID			=Util.getIntParameter(request,"GroupID");
TemplateFile tf = new TemplateFile(ItemID);
TemplateGroup	group=new TemplateGroup(GroupID);

String	FileName		= getParameter(request,"FileName");
String NewFileName = getParameter(request,"NewFileName");
if(!NewFileName.equals(""))
{
	tf.setFileName(NewFileName);
	tf.Update();
	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
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
	if(isEmpty(document.form.NewFileName,"请输入文件名."))
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
 <form  name="form" action="renamefile2018.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	       		 				 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">上级目录：</label>
		              <label class="wd-230">
		                 <span><%=group.getName()%></span>
		              </label>									            
	   		  	</div>
				
                 <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">原文件名：</label>
		              <label class="wd-230">
		                <span><%=tf.getFileName()%></span>
		              </label>									            
	   		  	</div>
                <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">新文件名：</label>
		              <label class="wd-230">
		                <input name="NewFileName" size="32" class="form-control" placeholder="" type="text" value="<%=tf.getFileName()%>">
		              </label>									            
	   		  	</div>				
                 				
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		      <input type="hidden" name="ItemID" value="<%=ItemID%>">
	          <input type="hidden" name="GroupID" value="<%=GroupID%>">
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton" >确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
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
