<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");
String	ChannelID		=	Util.getParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");
String ChannelName	=	Util.getParameter(request,"ChannelName");

String Name = getParameter(request,"Name");
int ContinueAdd = getIntParameter(request,"ContinueAdd");

if(!Name.equals(""))
{
	int		SuperChannel	= getIntParameter(request,"SuperChannel");
	String	Template		= getParameter(request,"Template");
	String	TargetName		= getParameter(request,"TargetName");
	String	Charset			= getParameter(request,"Charset");
	int		TemplateID				= getIntParameter(request,"TemplateID");

	Page p = new Page();
	
	p.setName(Name);
	p.setParent(SuperChannel);
	p.setType(2);
	p.setTemplate(Template);
	p.setTargetName(TargetName);
	p.setCharset(Charset);
	p.setTemplateID(TemplateID);
	p.setActionUser(userinfo_session.getId());

	p.Add();

	//session.removeAttribute("channel_tree_string");

	if(p.TargetFileExist())
	{
		response.sendRedirect("page_targetfile.jsp?PageID=" + p.getId());
		return;
	}
	else
		p.GenerateTargetFile();

	if(ContinueAdd==0)
		{out.println("<script>top.TideDialogClose({recall:true,returnValue:{close:1}});</script>");return;}
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript">
function init()
{
		document.form.Name.focus();
}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
	if(isEmpty(document.form.Template,"请输入页面框架模板."))
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

function selectTemplate(){
	/*
	var	dialog = new top.TideDialog();
	dialog.setWidth(650);
	dialog.setHeight(470);
	dialog.setSuffix('_2');
	dialog.setUrl("page/select_page_template.jsp");
	dialog.setTitle("页面框架模板");
	dialog.setScroll('auto');
	dialog.show();
	*/
	tidecms.dialog("page/select_page_template.jsp",800,450,"选择页面框架模板");
}

function setReturnValue(o){
	if(o.TemplateID!=null){
		document.form.TemplateID.value =o.TemplateID;
		var scr = document.createElement('script')
		scr.src = '../channel/template_add_js.jsp?id=' + o.TemplateID;
		document.getElementById('ajax_script').appendChild(scr);
	}
}
</script>
</head>
<body  onload="init();">
<form name="form" action="page_add.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
<tr>
    <td align="right" valign="middle">上级频道：</td>
    <td valign="middle"><label id="SuperChannelName"<%=ChannelName%></label></td>
  </tr>
    <tr>
    <td align="right" valign="middle">名称：</td>
    <td valign="middle"><input type=text name="Name" class="textfield"></td>
  </tr>
    <tr>
    <td align="right" valign="middle">页面框架模板：</td>
    <td valign="middle"><input type=text name="Template" size="32" class="textfield">
	<input name="" type="button" class="submit tidecms_btn3" value="选择模板" onclick="selectTemplate();"/>
	<input type="hidden" name="TemplateID" value=""></td>
  </tr>
   <tr>
    <td align="right" valign="middle">对应页面文件名：</td>
    <td valign="middle"><input type=text name="TargetName"  class="textfield"></td>
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
    <td valign="middle"><input type="checkbox" id="s1" name="ContinueAdd" value="1" class="textfield" <%=ContinueAdd==1?"checked":""%>></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input type="hidden" name="SuperChannel" value="<%=ChannelID%>">
	<input type="hidden" name="ChannelID" value="<%=ChannelID%>">

	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>