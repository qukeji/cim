<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
SpiderField  s = new SpiderField(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	Name		= getParameter(request,"Name");
	String	CodeStart	= getParameter(request,"CodeStart");
	String	CodeEnd		= getParameter(request,"CodeEnd");
	String	CodeReg		= getParameter(request,"CodeReg");
	String	Field		= getParameter(request,"Field");
	
	String rule = getParameter(request,"rule");
	
	s.setName(Name);
	s.setCodeStart(CodeStart);
	s.setCodeEnd(CodeEnd);
	s.setCodeReg(CodeReg);
	s.setField(Field);
	
	s.setRule(rule);

	s.Update();
    out.println("<script>top.TideDialogClose({suffix:'_2',recall:true,returnValue:{refresh:true}});</script>");
	//out.println("<script>top.TideDialogClose({refresh:'var w =window.frames[\"popiframe\"];w.location=w.location;',suffix:'_2'});</script>");
	return;
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
  <!--  <link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" /> 
        <script type="text/javascript" src="../common/jquery.js"></script> -->
<!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
   
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">
	 <script src="../lib/2018/jquery/jquery.js"></script>
<style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  	
</style>
<script type="text/javascript">
function init()
{
	document.form.Code.focus();
}

function check()
{
	if(isEmpty(document.form.Code,"请输入代码."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
}
</script>  
</head>
 
   <body class="" >
    <div class="bg-white modal-box">
      <form name="form" action="spider_field_edit2018.jsp" method="post" onSubmit="return check();">
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">
	       	  <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	 
                      <div class="row">
                        <label class="left-fn-title">编号：</label>
                         <label class="wd-230">
				           <span><%=s.getId()%></span>
			             </label>
                      </div>				  
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">名称：</label>
			              <label class="wd-230">
			                <input name="Name" size="32" class="form-control" placeholder="" type="text" value="<%=s.getName()%>">
			              </label>									            
	       		  	  </div>
					   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">对应字段：</label>
			              <label class="wd-230">
			                <input name="Field" id="Field" class="form-control" placeholder="" type="text" value="<%=s.getField()%>">
			              </label>									            
	       		  	  </div>
					  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">内容对象：</label>
			              <label class="wd-230">
			                <input name="rule" id="rule" class="form-control" placeholder="" type="text" value="<%=s.getRule()%>">			                
						  </label>									            
	       		  	  </div>	
                        <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title"></label>
			               <label class="mg-l-5">使用jquery语法，比如#content，即为提前此节点的内容，填写内容对象后，不需要填写开始和结束代码</label>					               						  								            
	       		  	  </div>						  
	       		  	   <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">开始代码：</label>
			               <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="CodeStart" rows="3" class="form-control" placeholder=""><%=s.getCodeStart()%></textarea>			              
 						  </div>										            
	       		  	  </div>
	       		  	  <div class="row">                   		  	  	
	   		  	  		  <label class="left-fn-title">结束代码：</label>
			             <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="CodeEnd" rows="3" class="form-control" placeholder=""><%=s.getCodeEnd()%></textarea>			              
 						  </div>									            
	       		  	  </div>
	       		  	  
	       		  	  <div class="row">                   		  	  	
	   		  	      <label class="left-fn-title">正则表达式：</label>
			            <div class="pd-l-0 pd-r-0 wd-300">
				              <textarea name="CodeReg"  rows="3" class="form-control" placeholder=""><%=s.getCodeReg()%></textarea>			              
 					   </div>			             
	       		  	  </div>   	  	                              
	       		  </li>       	    
	       	  </ul>
	        </div>
	                   
	    </div><!-- modal-body -->
      <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
      	<div class="modal-footer" >
		      <input type="hidden" name="Submit" value="Submit">
              <input type="hidden" name="id" value="<%=id%>">
		      <button  name="submitButton" type="submit" class="btn btn-primary tx-size-xs" id="submitButton">确认</button>
		      <button  name="btnCancel1" id="btnCancel1" type="button" onclick="top.TideDialogClose({suffix:'_2'});" class="btn btn-secondary tx-size-xs" data-dismiss="modal">取消</button>
        </div> 
      </div>
   </form>     
   </div>	
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
  </body>
</html>
