<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
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

if(!new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageModuleEdit))
{
	response.sendRedirect("../noperm.jsp");return;
}

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	TargetName		= getParameter(request,"TargetName");
	String	Charset			= getParameter(request,"Charset");
	int		Rows			= getIntParameter(request,"Rows");
	int		TitleWord		= getIntParameter(request,"TitleWord");

	int		ChannelID		= getIntParameter(request,"ChannelID");
	//System.out.println("ChannelID::"+ChannelID);
	int		TemplateID	= getIntParameter(request,"TemplateID");

	if(ChannelID>0)
	{
		ct.setChannelID(ChannelID);

		ct.setTemplateType(3);
		ct.setTargetName(TargetName);
		ct.setCharset(Charset);
		ct.setRows(Rows);
		ct.setTitleWord(TitleWord);
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

		Page p = new Page(pageID);
		p.updateModule(moduleID,ct.getId());
	}
	else
		System.out.println("pagemodule_add_1.jsp channelid = 0");
/*
System.out.println("id:"+ct.getId()+",templateid:"+TemplateID);
	Page p = new Page(PageID);

	if(ModuleID==0)
	{
		pm = new PageModule();
		pm.setPage(PageID);
		pm.setTemplate(ChannelTemplateID);
		pm.setType(1);
		pm.Add();
	}
	else
	{
		pm = new PageModule(ModuleID);
		pm.setTemplate(ChannelTemplateID);
		//pm.setModuleType(1);
		pm.Update();
	}

	//ct = new ChannelTemplate(TemplateID);

	if(ModuleID==0)
		p.AddModuleCode(pm,Index);
	else
		p.EditModuleCode(pm);
*/

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
	top.TideDialogSetTitle("设置模块");
	top.TideDialogResize(500,400);
}

function check()
{
	if(isEmpty(document.form.ChannelName,"请选择频道."))
		return false;
	if(isEmpty(document.form.Template,"请选择模板."))
		return false;

	return true;
}

function selectChannel(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(400);
	dialog.setHeight(450);
	dialog.setSuffix('_2');
	dialog.setLayer(2);
	dialog.setUrl("select_channel_category.jsp");
	dialog.setTitle("选择频道");
	dialog.setScroll('auto');
	dialog.show();
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

function editChannel(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(300);
	dialog.setHeight(160);
	dialog.setSuffix('_3');
	dialog.setLayer(2);
	dialog.setUrl("../page/channel_title_edit.jsp?pageID=<%=pageID%>&moduleID=<%=moduleID%>");
	dialog.setTitle("修改频道名称");
	dialog.setScroll('auto');
	dialog.show();
}

function deleteModuleContent()
{
	if(confirm('你确认要删除吗?')) 
	{
		this.location = "page_action.jsp?Action=DeleteModuleContent&pageID=<%=pageID%>&moduleID=<%=moduleID%>";
	}
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
		this.location = "pagemodule_delete.jsp?PageID=<%=pageID%>&ModuleID=<%=moduleID%>&Action=Delete";
	}
}

function listTemplate()
{
	this.location = "list_template.jsp?pageID="+PageID+"&moduleID="+ModuleID;
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
<form name="form" action="pagemodule_add_1.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">

<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td class="box-tint"><table width="100%" border="0" cellspacing="0" cellpadding="10">
        <tr> 
          <td align="right">频道：</td>
          <td class="lin28">
          <%if(ct.getChannelID()>0){%><input disabled type=text name="ChannelName" size="20" class="textfield" value="<%=channel.getName()%>" title="<%=channel.getName()%>">&nbsp;<input type="button" value="修改名称" onClick="editChannel();" class="tidecms_btn2">&nbsp;<input type="button" value="配置列表" onClick="listTemplate();" class="tidecms_btn2"><%}else{%><input type=text name="ChannelName" size="20" class="textfield" value=""> <input type="button" value="..." onclick="selectChannel();" class="submit"><%}%>&nbsp;<input type="hidden" name="ChannelID" value="<%=ct.getChannelID()%>">
          </td>
        </tr>
        <tr> 
          <td align="right">模板：</td>
          <td class="lin28">
          <input type=text name="Template" size="32" class="textfield" value="<%=ct.getTemplateFile().getFileName()%>"> 
		  <input name="" type="button" class="tidecms_btn2" value="..." onClick="selectTemplate();"/>
		  &nbsp;
		  <input name="" type="button" class="tidecms_btn2" value="查看" onClick="ViewTemplate();"/>
		  <input type="hidden" name="TemplateID" value="<%=ct.getTemplateID()%>">
          </td>
        </tr>
        <tr valign="top"> 
          <td align="right">对应程序文件名：</td>
          <td class="lin28">
          <input type=text name="TargetName" size="32" class="textfield" value="<%=ct.getTargetName()%>">
		  <br>为空表示由系统自动分配文件名
          </td>
        </tr>
        <tr> 
          <td align="right">指定行数：</td>
          <td class="lin28">
          <input type=text name="Rows" size="32" class="textfield" value="<%=ct.getRows()>0?ct.getRows():"8"%>">
          </td>
        </tr>
        <tr> 
          <td align="right">限制标题：</td>
          <td class="lin28">
          最多<input type=text name="TitleWord" size="6" class="textfield" value="<%=ct.getTitleWord()>0?ct.getTitleWord():""%>">字
          </td>
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
	<%if(moduleID>0){%>
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="删除设置"  onclick="deleteModuleContent();"/>
	<%}else{%>
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<%}%>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
	  <input type="hidden" name="pageID" value="<%=pageID%>">
	  <input type="hidden" name="moduleID" value="<%=moduleID%>">
	  <input type="hidden" name="Submit" value="Submit">
</div>
</form>
</body>
</html>
