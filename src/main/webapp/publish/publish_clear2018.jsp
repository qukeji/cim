<%@ page import="tidemedia.cms.system.*,
                java.sql.*,
				java.net.URL,				
				tidemedia.cms.base.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*"%>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!

%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int SiteId = getIntParameter(request,"SiteId");
int Scheme = getIntParameter(request,"Scheme");
String S_Title=Util.getParameter(request,"S_Title");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
String queryString = getParameter(request,"queryString");
String	Submit	= getParameter(request,"Submit");
if(!Submit.equals("")){
	if(RedisUtil.getInstance().isRedis()){//开启了Redis
		RedisUtil.getInstance().DelAllTemplateFile(SiteId,Scheme);//从发布队列中删除
	}
	String Sql = "delete from publish_item where Status!=1";
	if(SiteId>0){
	Sql+=" and site="+SiteId;
	}
	if(Scheme>0){
	Sql+=" and PublishScheme="+Scheme;
	}
	TableUtil tu = new TableUtil();
	int res = tu.executeUpdate(Sql);

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
 <form name="form" method="post" action="publish_clear2018.jsp" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">你确定要清空所有待发布任务?</label>							            
	   		  	</div>	
                 <div class="row">                              				
		  	  		  <label class="left-fn-title" >清空以后无法恢复!</label>							            
	   		  	</div>								
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		        <input type="hidden" name="S_Title" value="<%=S_Title%>">  
		        <input type="hidden" name="Scheme" value="<%=Scheme%>">  
		       <input type="hidden" name="currPage" value="<%=currPage%>">    
		      <input type="hidden" name="rowsPerPage" value="<%=rowsPerPage%>">     
		      <input type="hidden" name="SiteId" value="<%=SiteId%>">   		  
              <input type="hidden" name="Submit" value="Submit">    		    
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->
    
  </body>
</html>
