<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		ChannelID			= getIntParameter(request,"ChannelID");
Channel channel = new Channel(ChannelID);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	ChannelTemplate ct = new ChannelTemplate();
	ct.setChannelID(ChannelID);
	ct.InheritTemplate();
	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>TideCMS</title>
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">
<script src="../lib/2018/jquery/jquery.js"></script>

<script type="text/javascript">
function check(){
	document.form.submitButton.disabled  = true;
	return true;
}
</script>
<style>
  	html,body{width: 100%;height: 100%;}
  	.modal-body-btn .config-box .row .left-fn-title{min-width: 70px;}
  	.inherit-tips{margin-left: 37px;}
</style>  
</head>
<body scroll="no" >
	<form name="form" class="ht-100p" action="template_inherit.jsp" method="post" onSubmit="return check();">
    <div class="bg-white modal-box" >
      <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
				<div class="config-box">					
					<div class="row">                   		  	  	
   		  	  		  <label class="left-fn-title">频道：</label>
		                <label  class="wd-100 mg-l-20" id="ChannelName">
		                	<%=channel.getName()%>
		                </label>								            
       		  	    </div>
       		  	    <p class="mg-t-20 inherit-tips">你要从上级频道继承模板吗？</p>					
				</div>
			</div>	  
		  <div class="btn-box">
			<div class="modal-footer" >
				  <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
				  <input type="hidden" name="Submit" value="Submit">
				  <button name="Submit" type="submit" value="确定" id="submitButton" class="btn btn-primary tx-size-xs" >确定</button>
				  <button name="Submit2" type="button" id="btnCancel1"  onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
			 </div> 
		  </div>	   
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>

</html>