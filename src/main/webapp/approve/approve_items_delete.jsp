<%@ page import="tidemedia.cms.system.*,
                java.sql.*,
				java.net.URL,
				java.util.ArrayList,
				tidemedia.cms.base.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"ItemID");
int parent = getIntParameter(request,"parent");
int suffix = getIntParameter(request,"suffix");

boolean flag = false ;
String sql = "select * from approve_actions where ApproveId="+id;
TableUtil tu = new TableUtil();
ResultSet rs = tu.executeQuery(sql);
if(rs.next()){
	flag = true ;
}
tu.closeRs(rs);

if(flag){
}

String	Submit	= getParameter(request,"Submit");
if(!Submit.equals("")){
	new ApproveItems().Delete(id);

	if(suffix==1){//频道页面展示
		out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	}else{
		out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true,id:"+parent+"}});</script>");
	}
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
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
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
	<form name="form" method="post" action="approve_items_delete.jsp" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">你确定要删除此审核环节?</label>							            
	   		  	</div>	
                <div class="row">                              				
		  	  		  <label class="left-fn-title" >删除以后无法恢复!</label>							            
	   		  	</div>								
	        </div>
	    </div><!-- modal-body -->
		<div class="btn-box">
      		<div class="modal-footer" >
		      <input type="hidden" name="ItemID" value="<%=id%>">   
			  <input type="hidden" name="parent" value="<%=parent%>">
			  <input type="hidden" name="suffix" value="<%=suffix%>">
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
