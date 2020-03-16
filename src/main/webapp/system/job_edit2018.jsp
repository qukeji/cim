<%@ page import="java.sql.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%//禁止编辑发布方案
if(! userinfo_session.isAdministrator())
{response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
int type = getIntParameter(request,"type");
int actionUser = userinfo_session.getId();
QuartzJob quartz = new QuartzJob(id);

//PublishScheme publishscheme = new PublishScheme(id);
String Submit = getParameter(request,"Submit");
if(Submit.equals("Submit"))
{
	QuartzJob quartzUtil = new QuartzJob();

	String	title= getParameter(request,"title");
	String	program= getParameter(request,"program");
	String	jobtime		=	getParameter(request,"jobtime");
	String	remark      =   getParameter(request,"remark");
	
	quartzUtil.setTitle(title);
	quartzUtil.setProgram(program);
	quartzUtil.setJobtime(jobtime);
	quartzUtil.setRemark(remark);
	quartzUtil.setActionUser(actionUser);
	quartzUtil.Update(id,type);
  //CmsCache.getSite(publishscheme.getSite()).clearPublishSchemes();
	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
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
    <title>调度管理</title>

    <!-- vendor css -->
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">   
    <!-- Bracket CSS -->
    <link rel="stylesheet" href="../style/2018/bracket.css">    
    <link rel="stylesheet" href="../style/2018/common.css">	
<script type="text/javascript">
function check()
{
	var flag1 = false;
	if($("#title").val()!="")
		flag1 = true;
	var flag2 = false;
	if($("#jobtime").val()!="")
		flag2 = true;
	var flag3 = false;
	if($("#program").val()!="")
		flag3 = true;
	

	var flag = flag1&&flag2&&flag3;
	if(!flag){
		alert("调度名称、调度程序或调度时间机制不能为空");
	}else{
		$("#jobform").submit();
		/*var jobname  = $("#jobname").val();
		var path= "/cms_btv/system/job_action.jsp?Action=Check&jobname="+jobname;
		$.ajax({
			 type: "GET",
			 url: path,
			 success: function(data){
				 //0为有同名
				 if(data==0){
					alert("任务名称已存在,请更改");
				 }
				 else{
					 $("#jobform").submit();
				 }
				 //document.location.href=document.location.href;
			 }	
		}); */ 
	}
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

</script>
  <style>
  	html,body{
  		width: 100%;
  		height: 100%;
  	}
  </style>  
  </head>
  <body class="" onload="" >
    <div class="bg-white modal-box">
 <form  name="form" action="job_edit2018.jsp" method="POST"  id="jobform">     
	    <div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	        <div class="config-box">	
               <ul>
	       	  	<!--基本信息-->
	       		  <li class="block">	       		 				 
	   		  	<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">调度名称：</label>
					  <%if(type==0){%>
		              <label class="wd-230">
		                <input name="title" id="title" class="form-control" placeholder="" type="text" value="<%=quartz.getTitle()%>" >
		              </label>
                     <%}else{%>	                        
		                <input name="title" id="title" class="form-control" placeholder="" type="hidden" value="<%=quartz.getTitle()%>" >
		             <label class="mg-l-5"><%=quartz.getTitle()%></label>	
                     <%}%>					 
	   		  	</div>
                 <div class="row">    
                    			 
		  	  		  <label class="left-fn-title">调度程序：</label>
					  <%if(type==0){%>	
		              <label class="wd-230">
		                <input name="program" id="program" class="form-control" placeholder="" type="text" value="<%=quartz.getProgram()%>">
		              </label>	
                    <%}else{%>
                      	<input type="hidden" name="program" id="program" value="<%=quartz.getProgram()%>">				
	   		  	        <label class="mg-l-5"><%=quartz.getProgram()%></label>	
					 <%}%>
				</div>	
                 <div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">调度时间机制：</label>
		              <label class="wd-230">
		                <input name="jobtime" id="jobtime" class="form-control" placeholder="" type="text" value="<%=quartz.getJobtime()%>">
		              </label>									            
	   		  	</div>	
				<div class="row">                   		  	  	
		  	  		  <label class="left-fn-title">备注：</label>
		              <label class="wd-150">
		               <textarea name="remark" id="remark" type="textarea" value="" rows="6" cols="38"  class="form-control wd-300" placeholder=""><%=quartz.getRemark()%></textarea>
		              </label>									            
	   		  	</div>	
                 				
               </li>      	    
	       	  </ul>             	
	        </div>	                   
	    </div><!-- modal-body -->
      <div class="btn-box">
      	<div class="modal-footer" >
		     <input type="hidden" name="CopyMode"  id="CopyMode" value="1">
	         <input type="hidden" name="Submit" value="Submit">
	        <input type="hidden" name="id" value="<%=id%>">
		      <button name="startButton" type="button" class="btn btn-primary tx-size-xs" id="startButton" onclick="check()">确定</button>
		      <button name="btnCancel1" type="button" onclick="top.TideDialogClose('');" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
		 </div> 
      </div>
	   <div id="ajax_script" style="display:none;"></div> 
</form>	     
    </div><!-- br-mainpanel -->
    <!-- ########## END: MAIN PANEL ########## -->   
  </body>
               <script src="../common/2018/common2018.js"></script>
	           <script src="../lib/2018/jquery/jquery.js"></script>
	            <script src="../lib/2018/popper.js/popper.js"></script>
                <script src="../lib/2018/bootstrap/bootstrap.js"></script>
                <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
                <script src="../lib/2018/moment/moment.js"></script>
                <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
                <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
                <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
                <script src="../lib/2018/select2/js/select2.min.js"></script>
                <script src="../common/2018/bracket.js"></script>
</html>
