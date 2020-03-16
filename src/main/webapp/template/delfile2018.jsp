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

String		fileNames = getParameter(request,"fileNames");
int 	 fileLength			=Util.getIntParameter(request,"fileLength");
String		ItemID	=	getParameter(request,"ItemID");
String		GroupID =   getParameter(request,"GroupID");
String		Submit =   getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String[] ids = Util.StringToArray(ItemID, ",");
	int a = ids.length;
	int b = 0;
	for (int i = 0; i < ids.length; i++) 
	{
		int id_ = Util.parseInt(ids[i]);
		TemplateFile ct = new TemplateFile(id_);

		//System.out.println(id_+","+ct.getId()+","+ct.getName()+","+ct.getUsedNumber());
		if(ct.getUsedNumber()==0)
		{
			String success= "{\"status\":1,\"message\":2}";
			ct.setActionUser(userinfo_session.getId());
			ct.Delete(id_);
			out.println(success);
		}
		else
			b++;	
	}

	if(b>0) 
	{
		String afterMassage="要删除"+a+"个模板，其中"+b+"个模板在使用中，无法删除.";
		out.println("<script>top.TideDialogClose({recall:true,returnValue:{refresh:true,field:"+afterMassage+"}});</script>");
		//out.println(JsonUtil.fail("要删除"+a+"个模板，其中"+b+"个模板在使用中，无法删除.")); suffix:'_2'
		return;
	}
	
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
 <form name="form" method="post" action="delfile2018.jsp" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">
			<%if(!fileNames.equals("")){%>
	   		  	<div class="modal-body pd-25" id="alert_boy" style="position:static;top:0;bottom:0;height:100%">                   		  	  	
		  	  		  <p class="mg-b-5">你确定要删除<%=fileNames%>吗?</p>							            
	   		  	</div>	             							
	       
	        <%}%>      
            <%if(fileLength>5){%>
	   		  	<div class="modal-body pd-25" id="alert_boy" style="position:static;top:0;bottom:0;height:100%">                   		  	  	
		  	  		  <p class="mg-b-5">你确定要删除这<%=fileLength%>项吗?</p>							            
	   		  	</div>	             								       
	        <%}%> 
           </div>			
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		       <input type="hidden" name="fileLength" value="<%=fileLength%>"> 
		       <input type="hidden" name="fileNames" value="<%=fileNames%>"> 
		       <input type="hidden" name="ItemID" value="<%=ItemID%>"> 
		      <input type="hidden" name="GroupID" value="<%=GroupID%>">     
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
