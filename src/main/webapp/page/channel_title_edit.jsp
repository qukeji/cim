<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

int		pageID		= getIntParameter(request,"pageID");
int		moduleID	= getIntParameter(request,"moduleID");

PageModule pm = new PageModule(moduleID);
ChannelTemplate ct = new ChannelTemplate(pm.getTemplate());

Channel channel = CmsCache.getChannel(ct.getChannelID());
Channel channel2 = CmsCache.getChannel(pageID).getParentChannel();

//System.setProperty("file.encoding","gb2312");
String Name = getParameter(request,"Name");
if(ct.getChannelID()>0 && channel.getChannelCode().startsWith(channel2.getChannelCode()) && !Name.equals(""))
{
	channel.setName(Name);

	channel.Update();

			Publish publish = new Publish();
			publish.setPublishType(Publish.ONLYTHISTemplate_PUBLISH);
			publish.setChannelID(ct.getChannelID());
			publish.setTemplateID(pm.getTemplate());
			publish.GenerateFile();

	out.println("<script>top.TideDialogClose({suffix:'_3'});top.TideDialogClose({refresh:'main'});</script>");return;
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
<script language="javascript">
function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;

	return true;
}
</script>
</head>

<body>
<form name="form" action="channel_title_edit.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle">标题：</td>
    <td valign="middle"><input type="text" name="Name" id="Name" class="textfield" value="<%=channel.getName()%>"/></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input name="submitButton" type="submit" class="tidecms_btn2" value="确定" id="submitButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose({suffix:'_3'});"/>
	  <input type="hidden" name="pageID" value="<%=pageID%>">
	  <input type="hidden" name="moduleID" value="<%=moduleID%>">
	  <input type="hidden" name="Submit" value="Submit">
</div>

</form>
</body>
</html>