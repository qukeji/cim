<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");
int		ChannelID			= getIntParameter(request,"ChannelID");
Channel channel = new Channel(ChannelID);
if(!Submit.equals(""))
{
	int		IncludeSubChannel	= getIntParameter(request,"IncludeSubChannel");
	int		PublishAllItems		= getIntParameter(request,"PublishAllItems");

	PublishManager publishmanager = PublishManager.getInstance();
	publishmanager.ChannelPublish(ChannelID,IncludeSubChannel,userinfo_session.getId(),PublishAllItems);
/*
	Publish publish = new Publish(ChannelID,userinfo_session.getId());
	publish.setIncludeSubChannel(IncludeSubChannel);
	publish.Start();
*/
//	response.sendRedirect("../close_pop.jsp");
}
%>
<!DOCTYPE html>
<html>
 <head>
 <meta charset="utf-8">
 <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
 <meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="/cms2018/favicon.ico">
    <!-- Meta -->
    <meta name="description" content="Premium Quality and Responsive UI for Dashboard.">
    <meta name="author" content="ThemePixels">
<title>TideCMS</title>
 <!-- <link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" /> -->
<!--  <script type="text/javascript" src="../common/jquery.js"></script> -->
     <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
     <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
     <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
   <script type="text/javascript" src="../common/common.js"></script>  
    <script src="../lib/2018/jquery/jquery.js"></script>
   <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	.modal-body-btn .config-box .row .left-fn-title{
  		text-align: left;
  	}
  </style>

</head>
<body class="" >
 
    <div class="bg-white modal-box">
          <form name="form" action="publish2018.jsp" method="post" onSubmit="return check();">	
		 
		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
                <%if(Submit.equals("")){%>
	        <div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">频道：</label>
			              <label class="wd-230" id="ChannelName">
			                <span><%=channel.getName()%></span>
			              </label>									            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">你要发布本频道吗：</label>
			              <label class="wd-230">
			               
			              </label>									            
	       		  	  </div>
         					  
	       		  	 <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">包含所有子频道：</label>
			              <label class="ckbox">
			                <input type="checkbox" id="s1" name="IncludeSubChannel" value="1" class="textfield"><span></span>
			              </label>								             
	       		  	  </div>
					   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">发布所有文档：</label>
			              <label class="ckbox">
			                <input type="checkbox" id="s2" name="PublishAllItems" value="1" class="textfield"><span></span>
			              </label>								             
	       		  	  </div>
	       		  </li>
       	    
	       	  </ul>
	        </div>
                <script>
		jQuery(document).ready(function(){
			jQuery("#submitButton").show();
		});
                 </script>
<%}else{%>
<div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">
                 <div class="row">                   		  	  	
	   	        <label class="left-fn-title">系统开始在后台处理发布任务.</label>
		        								            
	       	      </div>
                  <div class="row">                   		  	  	
	   		 <label class="left-fn-title">估计会需要一段时间.</label>
									            
	       	   </div>
		   <div class="row">                   		  	  	
	   	         <label class="left-fn-title">你可以先关闭此窗口.</label>									            
	       	      </div>
			 </li>      	    
	       	  </ul>
	        </div>
              <%}%>	 	                   
	    </div>

		<!-- modal-body -->
      <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
      	<div class="modal-footer" >
		      <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	          <input type="hidden" name="Submit" value="Submit">
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs"  id="submitButton" style="display:none;">确认</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">关闭</button>
		    </div> 
      </div>	    
	   </form>   
    </div>
 
<!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## --> 
    <script>
      $(function(){
      	$("#form_nav li").click(function(){
      		var _index = $(this).index();
      		console.log(_index)
      		$(".config-box ul li").removeClass("block").eq(_index).addClass("block");
      	})
       
       //推荐设置锁定图片切换
      $(".lock-unlock").click(function(){    
       	var textBox = $(this).parent(".row").find(".textBox") ;       	
       	if($(this).find("i").hasClass("fa-lock")){      	 
       	 	$(this).find("i").removeClass("fa-lock").addClass("fa-unlock");       	 	
       	 	textBox.removeAttr("disabled","").removeClass("disabled")
       	}else{      	 	
       	 	$(this).find("i").removeClass("fa-unlock").addClass("fa-lock");
       	 	textBox.attr("disabled",true).addClass("disabled")
       	}
      })
		   
      });
    </script>
<script type="text/javascript">
function init()
{
}

function check()
{
	document.form.submitButton.disabled  = true;

	return true;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}

function selectTemplate(){
  	 	var Feature = "dialogWidth:34em; dialogHeight:27em;center:yes;status:no;help:no";
		var FileName = window.showModalDialog("../modal_dialog.jsp?target=channel/selecttemplate.jsp",null,Feature);
		if (FileName!=null) {
		  document.form.Template.value=FileName;
		  var filename = FileName.substring(0,FileName.lastIndexOf("."))+".jsp";
		  document.form.TargetName.value = filename.substring(filename.lastIndexOf("/")+1);
		  }
}

function change()
{
	if(document.form.TemplateType.value=="1")
	{
		tr01.style.display = "";
	}
	else
		tr01.style.display = "none";
}
</script>
  </body>
</html>
