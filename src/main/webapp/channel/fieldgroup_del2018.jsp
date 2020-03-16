<%@ page import="tidemedia.cms.system.*,
				java.util.ArrayList"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int	Groupid = getIntParameter(request,"Groupid");
 FieldGroup fieldGroup = new FieldGroup(Groupid);
String	Submit	= getParameter(request,"Submit");
if(!Submit.equals("")){	 
	fieldGroup.Delete();
    out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");
    return;
}
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
	 <form name="form" method="post" action="fieldgroup_del2018.jsp">
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">
	   		  	<div class="row">                              				
		  	  		  <label class="left-fn-title" >你确定要删除分组<font color="red"><%=fieldGroup.getName()%>吗?</font></label>							            
	   		  	</div>
                  <div class="row">                              				
		  	  		  <label class="left-fn-title" >删除以后无法恢复!</label>							            
	   		  	</div>					
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		      <input type="hidden" name="Groupid" value="<%=Groupid%>">     
              <input type="hidden" name="Submit" value="Submit">    		    
		      <button type="submit" class="btn btn-primary tx-size-xs" >确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose({suffix:'_2'});" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->
    
  </body>
</html>
