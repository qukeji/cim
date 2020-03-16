<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
PhotoScheme p = new PhotoScheme(id);
String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	int		Width					= getIntParameter(request,"Width");
	int		Height					= getIntParameter(request,"Height");
	String	Name					= getParameter(request,"Name");
	
	PhotoScheme ps = new PhotoScheme();

	ps.setName(Name);
	ps.setHeight(Height);
	ps.setWidth(Width); 
    ps.setId(id);
    
	ps.Update();

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
<script type="text/javascript">

</script>
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  </style>  
  </head>
  <body class="" onload="init();" >
    <div class="bg-white modal-box">
 <form  name="form" action="photo_scheme_edit2018.jsp" method="POST" >     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	       		 				 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">名称：</label>
		              <label class="wd-230">
		                <input name="Name" size="32"  class="form-control" placeholder="" type="text" value="<%=p.getName()%>">
		              </label>									            
	   		  	</div>
				
                 <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">宽：</label>
		              <label class="wd-230">
		                <input name="Width" size="32" class="form-control" placeholder="" type="text" value="<%=p.getWidth()%>" >
		              </label>									            
	   		  	</div>
                <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">高：</label>
		              <label class="wd-230">
		                <input name="Height" size="32" class="form-control" placeholder="" type="text" value="<%=p.getHeight()%>">
		              </label>									            
	   		  	</div>				
                 				
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		      <input type="hidden" name="Submit" value="Submit">
              <input type="hidden" name="id" value="<%=id%>">
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
