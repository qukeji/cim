<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	int		IsInt					= getIntParameter(request,"IsInt");
	int		IsJson					= getIntParameter(request,"IsJson");
	int		IsTemplate				= getIntParameter(request,"IsTemplate");
	String	Name					= getParameter(request,"Name");
	String	Code					= getParameter(request,"Code");
	String	Content					= getParameter(request,"Content");
	String	Comment					= getParameter(request,"Comment");
	
	Parameter p = new Parameter();

	p.setName(Name);
	p.setCode(Code);
	p.setIsJson(IsJson);
	p.setComment(Comment);
	p.setIsTemplate(IsTemplate);
	if(IsInt==1)
	{
		p.setType2(2);
		p.setIntValue(getIntParameter(request,"Content"));
	}
	else
	{
		p.setContent(Content);	
	}

	p.Add();

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
<title>TideCMS</title>
<!-- Bracket CSS -->
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">	
<style>
html,body{
	width: 100%;
	height: 100%;
}
</style>  

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	document.form.Code.focus();
});

function check()
{
	if(isEmpty(document.form.Code,"请输入代码."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
}
//判断表单值是否为空
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
</script>
  
</head>
<body class="" >
    <div class="bg-white modal-box">

	<form  name="form" action="parameter_add.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">代码：</label>
			              <label class="wd-300" >
			                <input name="Code" size="32" class="form-control" placeholder="" type="text">
			              </label>									            
	       		  	  </div>
				 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">名称：</label>
		              <label class="wd-300">
		                <input name="Name" size="32" class="form-control" placeholder="" type="text">
		              </label>									            
	   		  	</div>
		
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">内容：</label>
		              <label class="wd-300">
		                <textarea name="Content" cols=60 rows=4 class="form-control"></textarea>
		              </label>		  
	   		  	</div>				 
				<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">备注：</label>
		              <label class="wd-300">
		                <textarea name="Comment" cols=60 rows=4 class="form-control"></textarea>
		              </label>                    				  
	   		  	</div>				
				<div class="row ckbox-row"> 
	       		  	  	 <label class="left-fn-title">&nbsp;</label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsTemplate" id="IsTemplate" value="1" ><span class="d-inline-block">模板</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsInt" id="IsInt" value="1"><span class="d-inline-block">数字</span>
			              </label>
                           <label class="ckbox">
			                <input type="checkbox" name="IsJson" id="IsJson" value="1" ><span class="d-inline-block">JSON</span>
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
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
  </body>
</html>