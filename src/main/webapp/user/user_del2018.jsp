<%@ page import="tidemedia.cms.system.*,
                java.sql.*,
				java.util.ArrayList,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int	id = getIntParameter(request,"id");

String name = getParameter(request,"name");
String	Submit	= getParameter(request,"Submit");
String errorMsg="";
if(!Submit.equals("")){
   UserInfo userinfo = new UserInfo(id);

   if(userinfo.getRole()==1)
	{
		if(!(new UserPerm().canManageAdminUser(userinfo_session)))
		{response.sendRedirect("../noperm.jsp");
	   errorMsg="操作失败.";
	   return;}
	}
	//userinfo.setMessageType();
	userinfo.setActionUser(userinfo_session.getId());
	userinfo.Delete(id);
    out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
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
 <form name="form" method="post" action="user_del2018.jsp" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
		   
	        <div class="config-box mg-t-15">
			<%if(errorMsg.equals("")){ %>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">你确定要删除<%=name%>用户?</label>							            
	   		  	</div>	
                 <div class="row">                              				
		  	  		  <label class="left-fn-title" >删除以后无法恢复!</label>							            
	   		  	</div>	
            <% } %>
            <%if(!errorMsg.equals("")){ %>	
			      <div class="row">                              				
		  	  		  <label class="left-fn-title" >操作失败!</label>							            
	   		  	</div>	
            <% } %>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
        	  <input type="hidden" name="id" value="<%=id%>">			  
              <input type="hidden" name="Submit" value="Submit">
          <%if(errorMsg.equals("")){ %>			  
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		   <% } %>
		   <%if(!errorMsg.equals("")){ %>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">关闭</button>
		    <% } %>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->
    
  </body>
</html>
