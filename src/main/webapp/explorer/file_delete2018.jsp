<%@ page import="tidemedia.cms.system.*,
                java.io.File,tidemedia.cms.util.Util,
                java.sql.*,
				java.net.URL,
				java.util.ArrayList,
				tidemedia.cms.base.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String	FolderName		= getParameter(request,"FolderName");
String	FileName		= getParameter(request,"FileName");
int SiteId=Util.getIntParameter(request,"SiteId");

if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

Site site=CmsCache.getSite(SiteId);
String SiteFolder=site.getSiteFolder();
int fileLength=Util.getIntParameter(request,"fileLength");

String		Submit =   getParameter(request,"Submit");
if(!Submit.equals("")&&!FileName.equals(""))
{
	String  Path	= SiteFolder + "/" + FolderName;

		String[] files = Util.StringToArray(FileName,",");
		if(files!=null && files.length>0)
		{
			for(int i=0;i<files.length;i++)
			{
				String RealPath = Path + "/" + files[i];

				String exts = CmsCache.getParameterValue("explorer_edit_file_ext");
				String ext = Util.getFileExt(RealPath);
				if((exts+",").contains(ext+",")) {
					File file = new File(RealPath);
					file.delete();
					new Log().FileLog(LogAction.file_delete, "/" + FolderName + "/" + files[i], userinfo_session.getId(), SiteId);
					//System.out.println(file.getName());
				}
			}
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
 <form name="form" method="post" action="file_delete2018.jsp" >     
	    <div class="modal-body modal-body-btn pd-20 ">
		     <%if(fileLength==1){%>
	   		  	<div class="modal-body pd-25" id="alert_boy" style="position:static;top:0;bottom:0;height:100%">                   		  	  	
		  	  		  <p class="mg-b-5">你确定要删除这一项吗?</p>							            
	   		  	</div>	             								       
	        <%}%> 
			<%if(fileLength<5&&fileLength>1){%>	        	
	   		  	<div class="modal-body pd-25 overflow-y-auto" id="alert_boy" style="position:static;top:0;bottom:0;height:100%">                   		  	  	
		  	  		  <p class="mg-b-5">你确定要删除<%=FileName%>吗?</p>							            
	   		  	</div>	             								       
	        <%}%>      
            <%if(fileLength>=5){%>
	   		  	<div class="modal-body pd-25" id="alert_boy" style="position:static;top:0;bottom:0;height:100%">                   		  	  	
		  	  		  <p class="mg-b-5">你确定要删除这<%=fileLength%>项吗?</p>							            
	   		  	</div>	             								       
	        <%}%> 
           		
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		       <input type="hidden" name="fileLength" value="<%=fileLength%>"> 
		       <input type="hidden" name="FileName" value="<%=FileName%>"> 
		       <input type="hidden" name="FolderName" value="<%=FolderName%>"> 
		      <input type="hidden" name="SiteId" value="<%=SiteId%>">
			     <input type="hidden" name="fileLength" value="<%=fileLength%>">
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
