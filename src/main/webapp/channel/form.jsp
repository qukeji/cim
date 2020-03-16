<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="../common/pop_window.css" />
<script language=javascript>
function init()
{
	var Obj = top.Obj;
	if(Obj)
	{
		formview.location = "form_view.jsp?ChannelID=" + Obj.ChannelID;
	}
	if(Obj.Type!=3)
	{
		document.getElementById("copyForm").style.display="";
	}
	if(Obj.Type!=4)
	{
		document.getElementById("copyForm").style.display="";
	}
}

function check()
{
	if(isEmpty(document.form.Template,"请输入模板."))
		return false;
	if(isEmpty(document.form.TargetName,"请输入对应程序文件名称."))
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

function addField()
{
	var Obj = top.Obj;

	var myObject = new Object();
    myObject.title = "添加字段";
	if(Obj)
	{
		myObject.ChannelID = Obj.ChannelID;
	}

 	var Feature = "dialogWidth:32em; dialogHeight:35em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=channel/field_add.jsp",myObject,Feature);

	if(retu!=null)
	{
		formview.form.submit();
	}
}

function copyForm()
{
	var Obj = top.Obj;

	var myObject = new Object();
    myObject.title = "将表单应用到所有子频道";
	if(Obj)
	{
		myObject.ChannelID = Obj.ChannelID;
	}

 	var Feature = "dialogWidth:30em; dialogHeight:15em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=channel/form_copy.jsp",myObject,Feature);

	if(retu!=null)
	{
		formview.form.submit();
	}
}
</script>
</head>
<body onload="init();">
<table height="100%" valign="top" width="100%" cellpadding="0" cellspacing="0" border="0">
  <tr>
    <td height="68"> &nbsp;&nbsp; 
      <input type="button" value="插入字段" name="B3" onclick="addField();">
<input type="button" value="关闭返回" onclick="self.close();">
<input id="copyForm" style="display:none" type="button" value="将表单应用于所有子频道" onclick="copyForm();">
<br><br>
&nbsp; 表单预览：<br>  
</td>
<tr>
<td>
<iframe id="formview" src="about:blank" width="100%" height="100%"></iframe>
</td>
</table>
</body>
</html>
