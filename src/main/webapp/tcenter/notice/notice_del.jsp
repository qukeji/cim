<%@ page import="tidemedia.cms.system.*,
				org.json.*,
                java.sql.*,
				java.net.URL,
				java.util.ArrayList,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

String	Submit	= getParameter(request,"Submit");
if(!Submit.equals("")){
	
	Notice notice = new Notice(id);
	notice.setUserId(userinfo_session.getId());
	notice.Delete(id);

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
<meta name="author" content="ThemePixels">
<title>TideCMS</title>
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
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
	<form name="form" method="post" action="notice_del.jsp" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">你确定要删除此通知?</label>							            
	   		  	</div>	
                <div class="row">                              				
		  	  		  <label class="left-fn-title" >删除以后无法恢复!</label>							            
	   		  	</div>								
	        </div>
	    </div><!-- modal-body -->
		<div class="btn-box">
      		<div class="modal-footer" >
		      <input type="hidden" name="id" value="<%=id%>">   
              <input type="hidden" name="Submit" value="Submit">    		    
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
			</div> 
       </div>
	   <div id="ajax_script" style="display:none;"></div> 
	</form>	     
    </div><!-- br-mainpanel -->
</body>
</html>
