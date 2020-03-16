<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String Name = getParameter(request,"Name");
String	type		= getParameter(request,"type");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

if(!Name.equals(""))
{
	String	Content	= getParameter(request,"Content");
	int		Status			= getIntParameter(request,"Status");

	MyTask mytask = new MyTask();
	
	mytask.setName(Name);
	mytask.setContent(Content);
	mytask.setStatus(Status);
	mytask.setUser(userinfo_session.getId());
System.out.println(Name);
	mytask.Add();

	if(ContinueAdd==0)
	{
		out.println("<script>top.TideDialogClose({refresh:'"+type+"'});</script>");
		return;
	}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>
function init()
{
	var Obj = top.Obj;
	if(Obj)
	{
	}
}

function check()
{
	if(isEmpty(document.form.Name,"请输入任务名称."))
		return false;

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
</script>
</head>
<body>
<form name="form" action="task_add.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>
<div class="form_main">
<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">任务名称：</td>
    <td valign="middle"><input type="text" name="Name" size="50" class="textfield"></td>
  </tr>

   <tr>
    <td align="right" valign="middle">描述：</td>
    <td valign="middle"><input type="text" name="Content" size="50" class="textfield"></td>
  </tr>

   <tr>
    <td align="right" valign="middle">状态：</td>
    <td valign="middle">
	       <select name="Status">
            <option value="0" selected>未处理</option>
            <option value="1">处理中</option>
            <option value="2">处理完毕</option>
		  </select>
	</td>
  </tr>
  <tr>
    <td align="right" valign="middle"><input type=checkbox id="s1" name="ContinueAdd" value="1" class="textfield" <%=ContinueAdd==1?"checked":""%>></td>
    <td valign="middle"><label for="s1">继续新建</label></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
<input type="hidden" name="type" value="<%=type%>"/>
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="Submit" value="Submit">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>