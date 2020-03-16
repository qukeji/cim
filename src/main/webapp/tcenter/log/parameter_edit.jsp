<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
Parameter  p = new Parameter(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Name					= getParameter(request,"Name");
	String	Content					= getParameter(request,"Content");
	String	Comment					= getParameter(request,"Comment");
	int		IntValue				= getIntParameter(request,"IntValue");
	int		IsJson					= getIntParameter(request,"IsJson");
	int		IsTemplate				= getIntParameter(request,"IsTemplate");
	
	p.setName(Name);
	p.setContent(Content);
	p.setComment(Comment);
	p.setIntValue(IntValue);
	p.setIsTemplate(IsTemplate);
	p.setIsJson(IsJson);

	p.Update();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}

String message = "";
if(p.getContent().startsWith(" ")) message = "<br>提示：输入的内容前面有空格";
if(p.getContent().endsWith(" ")) message = "<br>提示：输入的内容后面有空格";
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
<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">    
<link rel="stylesheet" href="../style/2018/common.css">	
<script type="text/javascript">
function init()
{
	document.form.Code.focus();
}

function check()
{
	//if(isEmpty(document.form.Code,"请输入代码."))
	//	return false;

	//document.form.Button2.disabled  = true;

	return true;
}
</script>
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  </style>  
  </head>
  <body class="" >
    <div class="bg-white modal-box">
 <form  name="form" action="parameter_edit.jsp" method="POST" onSubmit="return check();">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">代码：</label>
			              <label class="wd-300" >
			                <span><%=p.getCode()%></span>
			              </label>									            
	       		  	  </div>
				 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">名称：</label>
		              <label class="wd-300">
		                <input name="Name" size="32" class="form-control" placeholder="" type="text" value="<%=p.getName()%>">
		              </label>									            
	   		  	</div>
				<%if(p.getType2()==0){%>
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">内容：</label>
		              <label class="wd-300">
		                <textarea name="Content" cols=56 rows=4 class="form-control"><%=p.getContent()%></textarea>
		              </label>
                       <font color=red><%=message%></font>					  
	   		  	</div>	
				<%}else if(p.getType2()==1){%>
				    <div class="row">                  		  	  	
	   		  	  		  <label class="left-fn-title"></label>
			              <label class="rdiobox">
			                <input type="radio" name="IntValue" id="s003" value="1" <%=p.getIntValue()==1?"checked":""%>><span class="d-inline-block">true</span>
			              </label>
				          <label class="rdiobox">
			                <input type="radio" id="s004" name="IntValue" value="0" <%=p.getIntValue()==0?"checked":""%>><span class="d-inline-block">false</span>
			              </label>
	       		  	  </div>
				 <%}else if(p.getType2()==2){%>
				 
                 <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">内容:</label>
		              <label class="wd-300">
		                <input name="IntValue" id="IntValue" size="32" class="form-control" placeholder="" type="text" value="<%=p.getIntValue()%>">
		              </label>									            
	   		  	</div>	
				<%}%>
				<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">备注：</label>
		              <label class="wd-300">
		                <textarea name="Comment" cols=56 rows=4 class="form-control"><%=p.getComment()%></textarea>
		              </label>                    				  
	   		  	</div>				
				<div class="row ckbox-row"> 
	       		  	  	 <label class="left-fn-title">&nbsp;</label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsTemplate" id="IsTemplate" value="1"  <%=p.getIsTemplate()==1?"checked":""%> ><span class="d-inline-block">模板</span>
			              </label>
			              <label class="ckbox">
			                <input type="checkbox" name="IsJson" id="IsJson" value="1" <%=p.getIsJson()==1?"checked":""%>><span class="d-inline-block">JSON</span>
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
		      <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
	</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
</body>
</html>