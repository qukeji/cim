<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				java.sql.*,
				java.util.ArrayList"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		groupID		= getIntParameter(request,"GroupID");
FieldGroup fieldGroup = new FieldGroup(groupID);

String	Submit	= getParameter(request,"Submit");

if(!Submit.equals(""))
{
			
	String	fieldGroupName	= getParameter(request,"FieldGroupName");
	String	extra			= getParameter(request,"Extra");
	String	url				= getParameter(request,"Url");
	String  icon            = getParameter(request,"Icon");
	fieldGroup.setName(fieldGroupName);
	fieldGroup.setExtra(extra);
	fieldGroup.setUrl(url);
	fieldGroup.setIcon(icon);
	fieldGroup.Update();
			
	out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");

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
   
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	 <script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript">

function init()
{

}

function check()
{
	if(isEmpty(document.form.FieldGroupName,"请输入字段名称."))
		return false;

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
function selectIcon(){	
	
	var title='选择图标'
	url="../channel/icon_list2018.html";
	var	dialog = new top.TideDialog();
		dialog.setWidth(800);
		dialog.setHeight(600);
		dialog.setUrl(url);
		dialog.setTitle(title);
		dialog.show();
}
	/*function setReturnValue(o) {
		if (o.TemplateID != null) {
			document.form.icon_list2018.value = o.icon_list2018;
			var scr = document.createElement('script')
			scr.src =o.icon_list2018;
			document.getElementById('icon_list2018').appendChild(scr);
		}
	}*/
	function setReturnValue(o) {
		if (o.icon != null) {
			$('#icon_list2018').html(o.icon);
			$('#Icon').attr("value",o.icon);
		}
	}
</script>  
  <style>
  	html,body{
  		width: javascript:preview();100%;
  		height: 100%;
  	}
  	.modal-body-btn .config-box .row .left-fn-title{
  		min-width: 70px;
  	}
  </style>  
  </head>
  <body class="" onload="init();" >
    <div class="bg-white modal-box">
 <form name="form" method="post" action="fieldgroup_edit2018.jsp" onsubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box mg-t-15">	       	  
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">组名：</label>
		              <label class="wd-230">
		                <input id="FieldGroupName" name="FieldGroupName" class="form-control" placeholder="" type="text" value="<%=fieldGroup.getName()%>">
		              </label>									            
	   		  	  </div>
	   		  	<div class="row">
                    <label class="left-fn-title">图标：</label>
					<input name="Icon" id="Icon" type="hidden" value='<%=fieldGroup.getIcon()%>'>
                    <label class="mg-t-5-force" id="icon_list2018">
                    	<!--这里放图标--><%=fieldGroup.getIcon()%>
			            
					</label>
					<input class="btn btn-primary btn-sm mg-l-10" href="javascript:;" name="" type="button" value="选择" onclick="selectIcon();">
                </div>	
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">备注：</label>
		              <label class="wd-300">
		                <input id="Extra" name="Extra" class="form-control" placeholder="" type="text" value="<%=fieldGroup.getExtra()%>">
		              </label>									            
	   		  	</div>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">对应程序：</label>
		              <label class="wd-300">
		                <input id="Url" name="Url" class="form-control" placeholder="" type="text" value="<%=fieldGroup.getUrl()%>" size="40">
		              </label>									            
	   		  	</div>	       		  	  	
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
			  <input type="hidden" name="GroupID" value="<%=groupID%>">
              <input type="hidden" name="Submit" value="Submit">
		      <button name="submitButton" type="submit" class="btn btn-primary tx-size-xs" id="submitButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose({suffix:'_2'});" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
		 </div> 
      </div>	     
<div id="ajax_script" style="display:none;"></div> 
</form>	   
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->
   
  </body>
</html>
