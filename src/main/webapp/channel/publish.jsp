<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

String Submit = getParameter(request,"Submit");
int		ChannelID			= getIntParameter(request,"ChannelID");
Channel channel = new Channel(ChannelID);
if(!Submit.equals(""))
{
	int		IncludeSubChannel	= getIntParameter(request,"IncludeSubChannel");
	int		PublishAllItems		= getIntParameter(request,"PublishAllItems");

	PublishManager publishmanager = PublishManager.getInstance();
	publishmanager.ChannelPublish(ChannelID,IncludeSubChannel,userinfo_session.getId(),PublishAllItems);
/*
	Publish publish = new Publish(ChannelID,userinfo_session.getId());
	publish.setIncludeSubChannel(IncludeSubChannel);
	publish.Start();
*/
//	response.sendRedirect("../close_pop.jsp");
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">
function init()
{
}

function check()
{
	document.form.submitButton.disabled  = true;

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

function selectTemplate(){
  	 	var Feature = "dialogWidth:34em; dialogHeight:27em;center:yes;status:no;help:no";
		var FileName = window.showModalDialog("../modal_dialog.jsp?target=channel/selecttemplate.jsp",null,Feature);
		if (FileName!=null) {
		  document.form.Template.value=FileName;
		  var filename = FileName.substring(0,FileName.lastIndexOf("."))+".jsp";
		  document.form.TargetName.value = filename.substring(filename.lastIndexOf("/")+1);
		  }
}

function change()
{
	if(document.form.TemplateType.value=="1")
	{
		tr01.style.display = "";
	}
	else
		tr01.style.display = "none";
}
</script>
</head>
<body>
<form name="form" action="publish.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
<%if(Submit.equals("")){%>
<tr>
    <td valign="middle">频道：</td>
    <td valign="middle"><label id="ChannelName"><%=channel.getName()%></label></td>
  </tr>
    <tr>
    <td  valign="middle">你要发布本频道吗？</td>
    <td valign="middle"></td>
  </tr>
   <tr>
    <td  valign="middle">包含所有子频道：</td>
    <td valign="middle"><input type="checkbox" id="s1" name="IncludeSubChannel" value="1" class="textfield"></td>
  </tr>
   <tr>
    <td  valign="middle">发布所有文档：</td>
    <td valign="middle"><input type="checkbox" id="s2" name="PublishAllItems" value="1" class="textfield"></td>
  </tr>
    <script>
		jQuery(document).ready(function(){
			jQuery("#submitButton").show();
		});
  </script>
<%}else{%>
   <tr>
    <td  valign="middle">系统开始在后台处理发布任务.</td>
    <td valign="middle"></td>
  </tr>
    <tr>
    <td  valign="middle">
	估计会需要一段时间.</td>
    <td valign="middle"></td>
  </tr>
    <tr>
    <td valign="middle">你可以先关闭此窗口.</td>
    <td valign="middle"></td>
  </tr>
<%}%>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	<input type="hidden" name="Submit" value="Submit">
	<input name="submitButton" type="submit" class="tidecms_btn2" value="确定" id="submitButton" style="display:none;"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="关闭"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>
