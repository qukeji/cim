<%@ page
import="tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.util.*,tidemedia.cms.user.*,java.util.*,java.sql.*,java.text.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//禁止添加方案
//boolean flag1 = userinfo_session.isAdministrator();
if(! userinfo_session.isAdministrator())
{response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");

if(Submit.equals("Submit"))
{

//	String			=	getParameter(request,"");
	String	title		=	getParameter(request,"title");
	String	jobtime		=	getParameter(request,"jobtime");
	String	program		=	getParameter(request,"program");
	String	remark		=   getParameter(request,"remark");
	String	selFunction	=   getParameter(request,"selFunction");//selFunction的值为可能为1,2,3
	//int	status	=	getIntParameter(request,"status");
	int     type		=   0;
	type = Integer.parseInt(selFunction);
	System.out.println(type+":type");
	QuartzJob quartzUtil = new QuartzJob();

//	u.set();
	quartzUtil.setTitle(title);
	quartzUtil.setJobtime(jobtime);
	quartzUtil.setProgram(program);
	quartzUtil.setRemark(remark);
	//quartzUtil.setStatus(status);
	quartzUtil.setType(type);
	quartzUtil.Add();

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");return;
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/form-common.css" rel="stylesheet" />
<link href="../style/dialog.css" type="text/css" rel="stylesheet" />
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
	if(!flag)
	{
		var value = $("#selFunction").val();
		var text = $("#selFunction").find("option:selected").text();
		alert("调度名称、调度程序或调度时间机制不能为空");
	}else{
		var flag4 = false;
		if($("#selFunction").val()!=0)
			$("#jobform").submit();
		else
			alert("请选择调度的类型");
		
		
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

function isEmpty(flag,msg)
{	
	if(!flag)
	{
		alert(msg);
		//field.focus();
		return true;
	}
	return false;
}
function init()
{

}
function changeName(){
	var value = $("#selFunction").val();
	if(value==0){
		var info = "调度程序：";
		$("#quartzFunction").html(info);
	}
	if(value==1){
		var info = "调度脚本路径：";
		$("#quartzFunction").html(info);
	}
	if(value==2){
		var info = "调度程序路径：";
		$("#quartzFunction").html(info);
	}
	if(value==3){
		var info = "javabean路径：";
		$("#quartzFunction").html(info);
	}
}
</script>
<style> 
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
</style>
</head>

<body  onload="init();">
<form name="form" method="post" action="job_add.jsp"  id="jobform">
<!-- start-->
<div class="edit-main">
	<div class="edit-nav">
    	
        <div class="clear"></div>
    </div>
    <div class="edit-con">
    	<div class="top">
        	<div class="left"></div>
            <div class="right"></div>
        </div>
		<div class="center_main">

<div class="center" id="form1">
<table width="100%" border="0" align="center">

  <tr>
    <td width="100">调度名称：</td>
    <td><input name="title" id="title" type="text" class="textfield"></td>
  </tr>
  <tr>
    <td width="100">调度类型：</td>
    <td>
		<select class="textfield" id="selFunction" onchange="changeName()" name="selFunction">
			<option name="function" value="0">--类型--</option>
			<option name="function" value="1">服务器脚本</option>
			<option name="function" value="2">程序文件</option>
			<option name="function" value="3">javabean</option>
		</select>
	</td>
  </tr>
  <tr>
    <td id="quartzFunction">调度程序：</td>
    <td><input name="program" id="program" type="text" class="textfield"  width="200" style="width:250px"></td>
  </tr>

  <tr>
    <td>调度时间机制：</td>
    <td><input name="jobtime" id="jobtime" type="text" class="textfield" value=""></td>
  </tr>
  <tr>
    <td>备注：</td>
    <td><textarea name="remark" id="remark" type="textarea" class="textfield" value="" rows="6" cols="38"></textarea></td>
  </tr>
</table>
</div>     

        </div>
        <div class="bot">
        	<div class="left"></div>
            <div class="right"></div>
        </div>
    </div>
</div>
<!-- end-->
<div class="form_button">
	<input type="hidden" name="CopyMode"  id="CopyMode" value="1">
	<input type="hidden" name="Submit" value="Submit">
	<input type="hidden" name="SiteId" value="">
	<input name="startButton" type="button" class="button" value="确定" id="startButton" onclick="check()"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>