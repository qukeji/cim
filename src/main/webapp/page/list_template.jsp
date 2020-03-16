<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,java.util.*,tidemedia.cms.publish.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
int		pageID		= getIntParameter(request,"pageID");
int		moduleID	= getIntParameter(request,"moduleID");

ChannelTemplate ct = new ChannelTemplate();
PageModule pm = new PageModule();

if(moduleID>0) 
{
	pm = new PageModule(moduleID);
	ct = new ChannelTemplate(pm.getTemplate());   
}

Channel channel = CmsCache.getChannel(ct.getChannelID());
int ChannelID = channel.getId();

if(!new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageModuleEdit))
{
	response.sendRedirect("../noperm.jsp");return;
}

ArrayList cts = channel.getChannelTemplates(1);
if(cts!=null && cts.size()>0)
{
	ct = (ChannelTemplate)cts.get(0);
}
else
	ct = new ChannelTemplate();

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	TargetName		= getParameter(request,"TargetName");
	String	Charset			= getParameter(request,"Charset");
	int		TemplateID		= getIntParameter(request,"TemplateID");
	int		rowsPerPage		= getIntParameter(request,"rowsPerPage");

	if(ChannelID>0)
	{
		System.out.println("submit cid:"+ChannelID);
		
		if(TemplateID==0)//删除模板配置
		{
			ct.Delete(ct.getId());
		}
		else
		{
			ct.setChannelID(ChannelID);

			ct.setTemplateType(1);
			ct.setTargetName(TargetName);
			ct.setCharset(Charset);
			ct.setRowsPerPage(rowsPerPage);
			ct.setTemplateID(TemplateID);

			if(ct.getId()==0)
			{
				//新增模板
				ct.Add();
			}
			else
			{
				ct.Update();
			}

			Publish publish = new Publish();
			publish.setPublishType(Publish.ONLYTHISTemplate_PUBLISH);
			publish.setChannelID(ct.getChannelID());
			publish.setTemplateID(ct.getTemplateID());
			publish.GenerateFile();
		}
	}
	else
		System.out.println("pagemodule_add_1.jsp channelid = 0");

	out.println("<script>top.TideDialogClose({refresh:'main'});</script>");return;
}

String channelName = "";

if(ct.getChannelID()>0)
	channelName = CmsCache.getChannel(ct.getChannelID()).getName();

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>
var PageID=<%=pageID%>;var ModuleID=<%=moduleID%>;
function init()
{
	top.TideDialogSetTitle("配置列表模板");
	//top.TideDialogResize(500,400);
}

function check()
{
	if(isEmpty(document.form.ChannelName,"请选择频道."))
		return false;
	if(isEmpty(document.form.Template,"请选择模板."))
		return false;

	return true;
}

function selectTemplate(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(680);
	dialog.setHeight(450);
	dialog.setSuffix('_2');
	dialog.setLayer(2);
	dialog.setUrl("../template/template.jsp");
	dialog.setTitle("选择模板");
	dialog.setScroll('auto');
	dialog.show();
}

function setReturnValue(o){
	if(o.TemplateID!=null){
		document.form.TemplateID.value =o.TemplateID;
		var scr = document.createElement('script')
		scr.src = '../template/template_add_js.jsp?id=' + o.TemplateID;
		document.getElementById('ajax_script').appendChild(scr);
	}

	if(o.ChannelID!=null){
		//alert(o.ChannelID);
		document.form.ChannelID.value =o.ChannelID;
		var scr = document.createElement('script')
		scr.src = '../channel/channel_add_js.jsp?id=' + o.ChannelID;
		document.getElementById('ajax_script').appendChild(scr);
	}
}

function Delete()
{
	if(confirm('你确认要删除吗?')) 
	{
		document.form.Template.value = "";
		document.form.TemplateID.value = "";
		document.form.submit();
	}
}


function ViewTemplate()
{
		TemplateID = document.form.TemplateID.value;

		if(TemplateID=="") return;

		var foldername = "";
		var filename = "";
	  	var width  = Math.floor( screen.width  * .8 );
  		var height = Math.floor( screen.height * .8 );
  		var leftm  = Math.floor( screen.width  * .1)+30;
 		var topm   = Math.floor( screen.height * .05)+30;
 		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm+ ",top=" + topm + ", width="+width+", height="+height;

  		var url="../template/template_edit.jsp?TemplateID="+TemplateID;
		window.open(url,"",Feature);
}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onload="init();" scroll="no">
<form name="form" action="list_template.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
        <tr> 
          <td align="right">频道：</td>
          <td class="lin28">
          <%=channel.getName()%>&nbsp;
          </td>
        </tr>
        <tr> 
          <td align="right">模板：</td>
          <td class="lin28">
          <input type=text name="Template" size="20" class="textfield" value="<%=ct.getTemplateFile().getFileName()%>"> <input type="button" value="..." onclick="selectTemplate();" class="tidecms_btn2">&nbsp;<input type="button" value="查看" onClick="ViewTemplate();" class="tidecms_btn2"><input type="hidden" name="TemplateID" value="<%=ct.getTemplateID()%>">
          </td>
        </tr>
        <tr valign="top"> 
          <td align="right">对应程序文件名：</td>
          <td class="lin28">
          <input type=text name="TargetName" size="20" class="textfield" value="<%=ct.getTargetName()%>">&nbsp;<input type="button" value="预览" onClick="window.open('<%=channel.getSite().getUrl()+ct.getFullTargetName()%>');" class="tidecms_btn2">
		  <br>为空表示由系统自动分配文件名
          </td>
        </tr>
		<tr>
		<td align="right" valign="middle">每页纪录数：</td>
		<td valign="middle"><input type=text name="rowsPerPage" size="10" class="textfield" value="20"></td>
		</tr>
        <tr> 
          <td align="right">文件编码：</td>
          <td class="lin28">
				<select name="Charset">
				<option value="">系统默认编码</option>
				<option value="gb2312">简体中文(GB2312)</option>
				<option value="utf-8">Unicode(UTF-8)</option>
				</select>
          </td>
        </tr>
        <tr>
          <td align="right">&nbsp;</td>
          <td class="lin28">&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>

</table><div id="ajax_script" style="display:none;"></div>

</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<%if(moduleID>0){%><input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/> <input name="delButton" type="button" class="tidecms_btn2" value="删除配置" onClick="Delete()"/><%}else{%><input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/><%}%>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
	  <input type="hidden" name="pageID" value="<%=pageID%>">
	  <input type="hidden" name="moduleID" value="<%=moduleID%>">
	  <input type="hidden" name="Submit" value="Submit">
</div>
</form>
</body>
</html>
