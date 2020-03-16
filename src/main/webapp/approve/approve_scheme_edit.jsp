<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
ApproveScheme as = new ApproveScheme(id);
boolean flag =(1==as.getEditable());
String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Title	= getParameter(request,"Title");
	//Integer editable = getIntParameter(request,"switch");
	as.setTitle(Title);
	as.setUserId(userinfo_session.getId());
	//as.setEditable(editable);
	as.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
%>
<!DOCTYPE html>
<html >
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">   
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">	
<link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
</style>  

<script type="text/javascript">

//	$(document).ready(function() {
//		document.form.Title.focus();
//	});

	function check()
	{
		if(isEmpty(document.form.Title,"请输入名称."))
			return false;

		//document.form.Button2.disabled  = true;

		return true;
	}
</script>
  
</head>

<body class="" >
    <div class="bg-white modal-box">
	  <form name="form" action="approve_scheme_edit.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	  <!--基本信息-->
	       		  <li class="block">
				 
					<div class="row">                   		  	  	
						<label class="left-fn-title">方案名称：</label>
						<label class="wd-300">
							<input name="Title" size="32" class="form-control" placeholder="" type="text" value="<%=as.getTitle()%>">
						</label>									            
					</div>
				  </li>      	    
	       	  </ul>             	
	        </div>	                   
		</div><!-- modal-body -->
		<div class="btn-box">
      		<div class="modal-footer" >
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		      <input type="hidden" name="Submit" value="Submit">
			  <input type="hidden" name="id" value="<%=id%>">
			</div> 
		</div>
		<div id="ajax_script" style="display:none;"></div> 
	  </form>	     
	</div><!-- br-mainpanel -->
</body>

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>        
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>

</html>
