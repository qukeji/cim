<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		ChannelID		= getIntParameter(request,"ChannelID");
int		Type			= getIntParameter(request,"Type");

String	Submit	= getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	fieldGroupName	= getParameter(request,"FieldGroupName");
	String	extra			= getParameter(request,"Extra");
	String	url				= getParameter(request,"Url");
	int		LinkChannel		= getIntParameter(request,"LinkChannel");
	int groupType = getIntParameter(request,"groupType");
	if(groupType==1){
		Type = 3 ;
	}else if(groupType==2){
		Type = 4 ;
	}else if(groupType==3){
		Type = 5 ;
	}

	if(Type==3)
	{
		FieldGroup fieldGroup = new FieldGroup();

		fieldGroup.setChannel(ChannelID);
		fieldGroup.setName(fieldGroupName);
		fieldGroup.setExtra(extra);
		fieldGroup.setUrl("../content/content_gather.jsp?LinkChannelID="+LinkChannel);
		fieldGroup.setLinkChannel(LinkChannel);
		fieldGroup.setType(Type);

		fieldGroup.Add();
		out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");
		return;
	}

	if(Type==4)
	{
		if(fieldGroupName.equals("")){
			fieldGroupName = "图片";
		}

		//图片集组
		FieldGroup fieldGroup = new FieldGroup();

		fieldGroup.setChannel(ChannelID);
		fieldGroup.setName(fieldGroupName);
		fieldGroup.setExtra(extra);
		fieldGroup.setUrl("../photo/document_photo_list.jsp");
		fieldGroup.setType(Type);

		fieldGroup.Add();
		out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");
		return;
	}

	if(Type==5)
	{
		if(fieldGroupName.equals("")){
			fieldGroupName = "视频";
		}
		//视频管理
		FieldGroup fieldGroup = new FieldGroup();

		fieldGroup.setChannel(ChannelID);
		fieldGroup.setName(fieldGroupName);
		fieldGroup.setExtra(extra);
		fieldGroup.setUrl("../video/document_video_list.jsp");
		fieldGroup.setType(Type);

		fieldGroup.Add();
		out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");
		return;
	}

	if(Type==6)
	{
		//关联组（Parent字段）
		FieldGroup fieldGroup = new FieldGroup();

		fieldGroup.setChannel(ChannelID);
		fieldGroup.setName(fieldGroupName);
		fieldGroup.setExtra(extra);
		fieldGroup.setUrl("../content/content_relation2.jsp?LinkChannelID="+LinkChannel);
		fieldGroup.setLinkChannel(LinkChannel);
		fieldGroup.setType(Type);

		fieldGroup.Add();
		out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");
		return;
	}

	if(ChannelID>0 && !fieldGroupName.equals(""))
	{
		FieldGroup fieldGroup = new FieldGroup();

		fieldGroup.setChannel(ChannelID);
		fieldGroup.setName(fieldGroupName);
		fieldGroup.setExtra(extra);
		fieldGroup.setUrl(url);
		fieldGroup.setLinkChannel(LinkChannel);
		fieldGroup.setType(Type);

		fieldGroup.Add();
		out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");
		return;
	}
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
    <title>TideCMS 7 列表</title>
    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">   
    
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">

	<script src="../lib/2018/jquery/jquery.js"></script>

<script type="text/javascript">

$(document).ready(function() {
	$("input[name='groupType']").bind("click",function(){ 

		var groupType = $("input[name='groupType']:checked").val();
		if(groupType==0){
			$("#groupType1").css("display","");
			$("#groupType2").css("display","none");
		}else if(groupType==1){
			$("#groupType1").css("display","none");
			$("#groupType2").css("display","");
		}else if(groupType==2||groupType==3){
			$("#groupType1").css("display","none");
			$("#groupType2").css("display","none");
		}
	}); 
});

function check()
{
	var groupType = $("input[name='groupType']:checked").val();
	if(groupType!=2&&groupType!=3&&isEmpty(document.form.FieldGroupName,"请输入字段名称.")){
		return false;
	}
		
  document.getElementById("submitButton").disabled=true;
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


function init()
{

}

function relatedDoc()
{
   document.getElementById("FieldGroupName").value = "相关文章";
  // document.getElementById("form1").style.display = "";
   //document.getElementById("ExtraDesc").innerHTML = "频道范围：";
}

function relatedVideo()
{
   document.getElementById("FieldGroupName").value = "相关视频";
   //document.getElementById("form1").style.display = "";
  // document.getElementById("ExtraDesc").innerHTML = "频道范围：";
}
</script>   
  
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	.modal-body-btn .config-box .row .left-fn-title{
  		min-width: 100px;
  	}
  </style>
 </head>
  <body class="" onload="init();">
    <div class="bg-white modal-box">
     <form name="form" method="post" action="fieldgroup_add2018.jsp" onsubmit="return check();"> 
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">	
						<div class="row">                  		  	  	
	   		  	  <label class="left-fn-title">类型：</label>
			        <label class="rdiobox">
								<input type="radio" name="groupType" value="0" checked><span class="d-inline-block">普通</span>
			        </label>
				      <label class="rdiobox">
			          <input type="radio" name="groupType" value="1"><span class="d-inline-block">集合</span>
			        </label>
							<label class="rdiobox">
								<input type="radio" name="groupType" value="2"><span class="d-inline-block">图片</span>
							</label>
							<label class="rdiobox">
								<input type="radio" name="groupType" value="3"><span class="d-inline-block">视频</span>
							</label>
	       		</div>
						
						
	   		  	<div class="row">                   		  	  	
		  	  		<label class="left-fn-title">组名：</label>
		            <label class="wd-230">
		              <input class="form-control" placeholder="" type="text" id="FieldGroupName" name="FieldGroupName">
		            </label>									            
	   		  	  </div>

	   		  	  <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">备注：</label>
		            <label class="wd-300">
		              <input class="form-control" placeholder="" type="text" id="Extra" name="Extra">
		            </label>									            
	   		  	  </div>	  
<%if(Type==0){%>
				  <div class="row" id="groupType1">                   		  	  	
		  	  		  <label class="left-fn-title" >对应程序：</label>
		              <label class="wd-300">
		                <input class="form-control" placeholder="" type="text">
		              </label>									            
	   		  	  </div>
				  <div class="row" id="groupType2" style="display:none">                   		  	  	
						<label class="left-fn-title">对应频道编号：</label>
						<label class="wd-300">
							<input class="form-control" placeholder="" size="40" type="text" id="LinkChannel" name="LinkChannel">
						</label>									            
				  </div>
<%}%>  				
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		      <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	          <input type="hidden" name="Submit" value="Submit">
	          <input type="hidden" name="Type" value="<%=Type%>">
		      <button type="submit" class="btn btn-primary tx-size-xs" name="submitButton" id="submitButton">确认</button>
		      <button type="button" onclick="top.TideDialogClose({suffix:'_2'});"   name="btnCancel1" id="btnCancel1"  class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		    </div> 
      </div>
	    
<div id="ajax_script" style="display:none;"></div>
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->
  </body>
</html>
