<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

String	ChannelID		=	Util.getParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");
String ChannelName	=	Util.getParameter(request,"ChannelName");

String Name = getParameter(request,"Name");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

		int UserId = userinfo_session.getId();
		UserInfo userinfo = new UserInfo(UserId);
		//String Websiteid = userinfo.getSite();

	if(!Name.equals(""))
	{
		String	FolderName		= getParameter(request,"FolderName");
		String	SerialNo		= getParameter(request,"SerialNo");
		String	Href			= getParameter(request,"Href");
		int		Parent			= getIntParameter(request,"Parent");
		int		IsDisplay		= getIntParameter(request,"IsDisplay");
		int		ChannelType		= 3;
		int		TemplateInherit	= getIntParameter(request,"TemplateInherit");
		int     IsReviewDisplay = getIntParameter(request,"IsReviewDisplay");

		Channel channel = new Channel();
	    Channel parentChannel=CmsCache.getChannel(Parent);
	    channel.setSiteID(parentChannel.getSiteID());
		channel.setName(Name);
		channel.setParent(Parent);
		channel.setFolderName(FolderName);
		channel.setSerialNo(SerialNo);
		channel.setIsDisplay(IsDisplay);
		channel.setType(ChannelType);
		channel.setHref(Href);
		channel.setTemplateInherit(TemplateInherit);
		//channel.setCanComment(IsReviewDisplay);
		
		//channel.Add(Websiteid);
		channel.Add();
		int id = channel.getSiteBySerialNo(SerialNo);
		//session.removeAttribute("channel_tree_string");
		
		int		ParentName	= getIntParameter(request,"ParentName");
		String	Template	= getParameter(request,"Template");
		String	TargetName	= getParameter(request,"TargetName");
		String	Charset		= getParameter(request,"Charset");

		App p = new App(id);
		
		p.setName(Name);
		p.setParent(ParentName);
		p.setType(3);
		p.setTemplate(Template);
		p.setTargetName(TargetName);
		p.setCharset(Charset);

		p.Add(id);
		//leener edit 2007-04-03
		
			p.GenerateFormFile(userinfo_session);
		
		//end;
		if(ContinueAdd==0)
			{out.println("<script>top.TideDialogClose({refresh:'left'});</script>");return;}
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript">
function init()
{
		document.form.Name.focus();
}

function selectTemplate(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(650);
	dialog.setHeight(470);
	dialog.setSuffix('_2');
	dialog.setUrl("channel/selecttemplate.jsp");
	dialog.setTitle("页面框架模板");
	dialog.setScroll('auto');
	dialog.show();
}

function setReturnValue(o){
	if(o.TemplateID!=null){
		document.form.TemplateID.value =o.TemplateID;
		var scr = document.createElement('script')
		scr.src = '../channel/template_add_js.jsp?id=' + o.TemplateID;
		document.getElementById('ajax_script').appendChild(scr);
	}
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
	if(isEmpty(document.form.SerialNo,"请输入标识名."))
		return false;

	//var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"; 

	//if (document.form.ChannelType[1].checked){
	//if(isEmpty(document.form.FolderName,"请输入目录名."))
		//return false;
	//for(var i=0;i<document.form.SerialNo.value.length;i++)
	//{
		//var exist = false;
		//for(var j=0;j<smallch.length;j++)
		//{
			//if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
			//{
				//exist = true;
			//}
		//}

		//if(!exist)
		//{
			//alert("具有独立表单的频道的标识名必须由英文字母或下划线组成.");
			//document.form.SerialNo.focus();
			//return false;
		//}

	//}
	//}

	//document.form.Button2.disabled  = true;

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

function initOther()
{
	if(document.form.SerialNo.value!="" && document.form.FolderName.value=="")
	{
		document.form.FolderName.value = document.form.SerialNo.value;
	}
}
</script>
</head>
<body  onload="init();">
<form name="form" action="app_add.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
<tr>
    <td align="right" valign="middle">上级频道：</td>
    <td valign="middle"><label id="ParentName"><%=ChannelName%></label></td>
  </tr>
    <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type=text name="Name"  class="textfield"></td>
  </tr>
 <tr>
    <td align="right" valign="middle">标识名：</td>
    <td valign="middle"><input type=text name="SerialNo" class="textfield" onBlur="initOther()"></td>
  </tr>
    <tr>
    <td align="right" valign="middle">目录名：</td>
    <td valign="middle"><input type=text name="FolderName"  class="textfield"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">页面框架模板：</td>
    <td valign="middle"><input type=text name="Template" size="32" class="textfield">
	<input name="" type="button" class="tidecms_btn3" value="..." onclick="selectTemplate();"/>
	<input type="hidden" name="TemplateID" value=""></td>
  </tr>
    <tr>
    <td align="right" valign="middle">对应页面文件名：</td>
    <td valign="middle"> <input type=text name="TargetName"  class="textfield"></td>
  </tr>
  <tr>
    <td align="right" valign="middle">文件编码：</td>
    <td valign="middle"><select name="Charset">
				<option value="">系统默认编码</option>
				<option value="gb2312">简体中文(GB2312)</option>
				<option value="utf-8">Unicode(UTF-8)</option>
				</select></td>
  </tr>
    <tr>
    <td align="right" valign="middle">继续新建：</td>
    <td valign="middle"><input type=checkbox id="s1" name="ContinueAdd" value="1" class="textfield" <%=ContinueAdd==1?"checked":""%>></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input type="hidden" name="Parent" value="<%=ChannelID%>">
	<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	<input name="submitButton" type="submit" class="tidecms_btn2" value="确定"  id="submitButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>