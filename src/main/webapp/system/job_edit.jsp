<%@ page import="java.sql.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%//禁止编辑发布方案
if(! userinfo_session.isAdministrator())
{response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
int type = getIntParameter(request,"type");

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
	quartzUtil.Update(id,type);
  //CmsCache.getSite(publishscheme.getSite()).clearPublishSchemes();
	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
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
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
</style>
</head>

<body  onload="">
<form name="form" method="post" action="job_edit.jsp" id="jobform">
<!-- start-->
<div class="edit_main dialog_editChannel">
	<div class="edit_nav">
    	
        <div class="clear"></div>
    </div>
    <div class="edit_con">
    	 
		<div class="center_main">
<div  class="center">
<table width="100%" border="0" align="center">

  <tr>
    <td width="100">调度名称：</td>
	<%if(type==0){%>
		 <td><input name="title" id="title" type="text" class="textfield" value="<%=quartz.getTitle()%>"></td>
	<%}else{%>
		 <input type="hidden" name="title" id="title" value="<%=quartz.getTitle()%>">
		 <td><%=quartz.getTitle()%></td>
	<%}%>
  </tr>
  <tr>
    <td>调度程序：</td>
	<%if(type==0){%>
    <td><input name="program" id="program" type="text" class="textfield" value="<%=quartz.getProgram()%>" style="width:250px" ></td>
	<%}else{%>
	<input type="hidden" name="program" id="program" value="<%=quartz.getProgram()%>">
	<td><%=quartz.getProgram()%></td>
	<%}%>
  </tr>
  <tr>
    <td>调度时间机制：</td>
    <td><input name="jobtime" id="jobtime" type="text" class="textfield" value="<%=quartz.getJobtime()%>"></td>
  </tr>
  <tr>
    <td>备注：</td>
    <td><textarea name="remark" id="remark" type="textarea" class="textfield"  value="" rows="6" cols="38"><%=quartz.getRemark()%></textarea></td>
  </tr>
  <!--<tr>
    <td>
	是否开启调度：
	</td>
	<td>
	<input type="radio" id="s001" name="status" value="0" <%=quartz.getStatus()==0? "checked=\"checked\"":""%>>
	<label for="s001">是</label>
	<input type="radio" id="s002" name="status" value="1" <%=quartz.getStatus()==1? "checked=\"checked\"":""%>>
	<label for="s002">否</label></td>
  </tr>-->
</table>
</div>      

        </div>
         
    </div>
</div>
<!-- end-->
<div class="form_button">
	<input type="hidden" name="CopyMode"  id="CopyMode" value="1">
	<input type="hidden" name="Submit" value="Submit">
	<input type="hidden" name="id" value="<%=id%>">
	<input name="startButton" type="button" class="tidecms_btn2" value="确定"  id="startButton" onclick="check()"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>