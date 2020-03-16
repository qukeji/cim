<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

String	ChannelID	=	Util.getParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");
String ChannelName	=	Util.getParameter(request,"ChannelName");

String Name = getParameter(request,"Name");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

if(!Name.equals(""))
{
	String	FolderName		= getParameter(request,"FolderName");
	String	ImageFolderName	= getParameter(request,"ImageFolderName");
	String	SerialNo		= getParameter(request,"SerialNo");
	String	Href			= getParameter(request,"Href");
	String	Attribute1		= getParameter(request,"Attribute1");
	String	Attribute2		= getParameter(request,"Attribute2");
	int		Parent			= getIntParameter(request,"Parent");
	int		IsDisplay		= getIntParameter(request,"IsDisplay");
	int		ChannelType		= getIntParameter(request,"ChannelType");
	int		TemplateInherit	= getIntParameter(request,"TemplateInherit");
	int		LinkChannelID	= getIntParameter(request,"LinkChannelID");

	Channel channel = new Channel();
	
	channel.setName(Name);
	channel.setParent(Parent);
	channel.setFolderName(FolderName);
	channel.setImageFolderName(ImageFolderName);
	channel.setSerialNo(SerialNo);
	channel.setIsDisplay(IsDisplay);
	channel.setType(Channel.MirrorChannel_Type);
	channel.setHref(Href);
	channel.setAttribute1(Attribute1);
	channel.setAttribute2(Attribute2);
	channel.setTemplateInherit(TemplateInherit);
	channel.setLinkChannelID(LinkChannelID);

	channel.setActionUser(userinfo_session.getId());
	channel.Add();

	session.removeAttribute("channel_tree_string");

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
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">
var TideDialog;
function init()
{
		document.form.Name.focus();
		var	scr = document.createElement('script')
		scr.src = 'getserialno.jsp?Parent=<%=ChannelID%>&random=' + Math.random();
		document.getElementById('ParentName').appendChild(scr);
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
	if(isEmpty(document.form.SerialNo,"请输入标识名."))
		return false;

	var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"; 

	//if (document.form.ChannelType[1].checked){
	if(isEmpty(document.form.FolderName,"请输入目录名."))
		return false;
	for(var i=0;i<document.form.SerialNo.value.length;i++)
	{
		var exist = false;
		for(var j=0;j<smallch.length;j++)
		{
			if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
			{
				exist = true;
			}
		}

		if(!exist)
		{
			alert("具有独立表单的频道的标识名必须由英文字母或下划线组成.");
			document.form.SerialNo.focus();
			return false;
		}

	}
	//}

	document.form.Button2.disabled  = true;

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

function selectChannel()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(450);
	dialog.setSuffix('_2');
	dialog.setUrl("channel/select_channel_category_tree.jsp");
	dialog.setTitle("选择频道");
	//dialog.setScroll('auto');
	dialog.show();
}

function setReturnValue(o){
		document.form.LinkChannelName.value = o.Name;
		document.form.LinkChannelID.value = o.ChannelID;
}

function initOther()
{
	if(document.form.SerialNo.value!="")
	{
		if(document.form.FolderName.value=="") 
		{
			var index = document.form.SerialNo.value.lastIndexOf("_");
			var folder = "";
			if(index!=-1)
				folder = document.form.SerialNo.value.substring(index+1);
			else
				folder = document.form.SerialNo.value;
			document.form.FolderName.value = folder;
			document.form.ImageFolderName.value = folder + "/images";
		}

		var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789";

		for(var i=0;i<document.form.SerialNo.value.length;i++)
		{
			var exist = false;
			for(var j=0;j<smallch.length;j++)
			{
				if(document.form.SerialNo.value.charAt(i)==smallch.charAt(j))
				{
					exist = true;
				}
			}

			if(!exist)
			{
				alert("具有独立表单的频道的标识名必须由英文字母或下划线组成.");
				document.form.SerialNo.focus();
				return false;
			}
		}
		scr = document.createElement('script')
		scr.src = 'checkserialno.jsp?SerialNo=' + document.form.SerialNo.value + '&random=' + Math.random();
		document.getElementById('ParentName').appendChild(scr);
	}
}
</script>
</head>
<body  onload="init();">
<form name="form" action="mirror_channel_add.jsp" method="post" onSubmit="return check();">
<div class="form_top">
<div class="left"></div>
<div class="right"></div>
</div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
<tr>
    <td align="right" valign="middle">上级频道：</td>
    <td valign="middle"><label id="ParentName"><%=ChannelName%></label></td>
  </tr>
  <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type="text" name="Name" id="Name" class="textfield"/></td>
  </tr>
     <tr>
    <td align="right" valign="middle">镜像到的频道：</td>
    <td valign="middle"><input type=text name="LinkChannelName" class="textfield" value=""><input type="hidden" name="LinkChannelID" value="0"> <input type="button" value="..." onclick="selectChannel();" class="tidecms_btn3"> 
	<!-- <input name="" type="button" class="submit tidecms_btn3" value="..." onclick="selectChannel();"/>--></td>
  </tr>

     <tr>
    <td align="right" valign="middle">模板方式：</td>
    <td valign="middle"><input name="TemplateInherit" id="s003" type="radio" value="1" class="textfield" checked>
          <label for="s003">继承上级模板</label>
          <input type="radio" id="s004" name="TemplateInherit" value="0" class="textfield">
          <label for="s004">独立模板</label></td>
  </tr>

      <tr>
    <td align="right" valign="middle">标识名：</td>
    <td valign="middle"><input type=text name="SerialNo" class="textfield" onBlur="initOther()" value=""></td>
  </tr>
      <tr>
    <td align="right" valign="middle">目录名：</td>
    <td valign="middle"><input type=text name="FolderName" class="textfield"></td>
  </tr>
      <tr>
    <td align="right" valign="middle">图片上传目录：</td>
    <td valign="middle"><input type=text name="ImageFolderName" class="textfield"></td>
  </tr>
      <tr>
    <td align="right" valign="middle">链接：</td>
    <td valign="middle"><input type=text name="Href" class="textfield"></td>
  </tr>
      <tr>
    <td align="right" valign="middle">标题字数：</td>
    <td valign="middle"><input type=text name="Attribute1"  class="textfield"></td>
  </tr>
      <tr>
    <td align="right" valign="middle">推荐栏目：</td>
    <td valign="middle"><textarea name="Attribute2" cols=32 rows=4 class="textfield"></textarea></td>
  </tr>
       <tr>
    <td align="right" valign="middle">是否在导航中出现：</td>
    <td valign="middle"><input type=checkbox name="IsDisplay" value="1" class="textfield" checked></td>
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
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>