<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
int		ChannelID		= getIntParameter(request,"ChannelID");

ChannelTemplate ct = new ChannelTemplate(id);

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	TargetName				= getParameter(request,"TargetName");
	String	Charset					= getParameter(request,"Charset");
	String	WhereSql				= getParameter(request,"WhereSql");
	String	Label					= getParameter(request,"Label");
	String	Href					= getParameter(request,"Href");
	String	FileNameField			= getParameter(request,"FileNameField");

	int		rowsPerPage				= getIntParameter(request,"rowsPerPage");
	int		SubFolderType			= getIntParameter(request,"SubFolderType");
	int		FileNameType			= getIntParameter(request,"FileNameType");
	//int		Category			= getIntParameter(request,"Category");
	int		Rows					= getIntParameter(request,"Rows");
	int		TitleWord				= getIntParameter(request,"TitleWord");

	int		IsInherit				= getIntParameter(request,"IsInherit");
	int		IncludeChildChannel		= getIntParameter(request,"IncludeChildChannel");
	int		TemplateID				= getIntParameter(request,"TemplateID");
	int		PublishInterval			= getIntParameter(request,"PublishInterval");

	if(IsInherit==1)
	{
		ct.InheritTemplate();
	}
	else
	{
		ct.setRowsPerPage(rowsPerPage);
		ct.setTargetName(TargetName);
		ct.setCharset(Charset);
		ct.setWhereSql(WhereSql);
		ct.setSubFolderType(SubFolderType);
		ct.setFileNameType(FileNameType);
		ct.setFileNameField(FileNameField);
		ct.setChannelID(ChannelID);
		ct.setRows(Rows);
		ct.setTitleWord(TitleWord);
		ct.setIsInherit(0);
		ct.setLabel(Label);
		ct.setLinkTemplate(0);
		ct.setHref(Href);
		ct.setIncludeChildChannel(IncludeChildChannel);
		ct.setTemplateID(TemplateID);
		ct.setPublishInterval(PublishInterval);

		ct.Update();
	}

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
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
<style>.form_main_m select{width:222px;}</style>
<script language=javascript>
function init()
{
	document.form.Template.focus();
}

function check()
{
<%if(ct.getTemplateType()==1 || ct.getTemplateType()==2){%>
	if(document.form.IsInherit.checked)
		return true;
<%}%>
	<%if(ct.getTemplateID()>0){%>
	if(isEmpty(document.form.Template,"请输入模板."))
		return false;
	<%}%>
	if(isEmpty(document.form.TemplateType,"请选择模板类型."))
		return false;
	<%if(ct.getTemplateID()>0){%>
	if(isEmpty(document.form.TargetName,"请输入对应程序文件名称."))
		return false;
	<%}%>
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

function selectTemplate(){
	var	dialog = new top.TideDialog();
	dialog.setWidth(700);
	dialog.setHeight(470);
	dialog.setSuffix('_2');
	dialog.setUrl("channel/selecttemplate.jsp");
	dialog.setTitle("选择模板");
	//dialog.setScroll('auto');
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

function change()
{
		if(document.form.TemplateType.value=="1")
		{
			tr01.style.display = "";
		}
		else
			tr01.style.display = "none";
}

function changeFolderType()
{
	if(document.form.SubFolderType==null)
		return;

	var t = "";
	if(document.form.SubFolderType.value=="0")
	{
		t = "没有子目录";
	}
	else if(document.form.SubFolderType.value=="1")
	{
		t = "如：/2018/";
	}
	else if(document.form.SubFolderType.value=="2")
	{
		t = "如：/2018/08/";
	}
	else if(document.form.SubFolderType.value=="3")
	{
		t = "如：/2018/08/08/";
	}
	else if(document.form.SubFolderType.value=="4")
	{
		t = "如：/2018-08-08/";
	}
	else if(document.form.SubFolderType.value=="5")
	{
		t = "目录由文档中的Path字段指定.";
	}
	else if(document.form.SubFolderType.value=="6")
	{
		t = "如：/20180808/";
	}

	$("#FolderTypeDesc").html(t);
}

function changeFileNameType()
{
	if(document.form.FileNameType==null)
		return;

	var t = "";
	if(document.form.FileNameType.value=="3")
	{
		$("#FileNameField").show();
	}
	else
		$("#FileNameField").hide();
}

function inherit(obj)
{//alert(obj.checked);
	if(obj.checked)
	{
		document.form.Template.disabled = true;
		document.form.TargetName.disabled = true;
	}
	else
	{
		document.form.Template.disabled = false;
		document.form.TargetName.disabled = false;
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
<body>
<form name="form" action="template_edit.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
  <tr>
    <td align="right" valign="middle">频道：</td>
    <td valign="middle"><%=CmsCache.getChannel(ChannelID).getName()%></td>
  </tr>
    <tr>
    <td align="right" valign="middle">模板：</td>
    <td valign="middle"><input type=text name="Template" size="20" class="textfield" value="<%=ct.getTemplateFile().getFileName()%>"> <input type="button" value="..." onclick="selectTemplate();" class="tidecms_btn3"> <input type="button" value="查看" onClick="ViewTemplate();" class="tidecms_btn3"><input type="hidden" name="TemplateID" value="<%=ct.getTemplateID()%>">
	</td>
  </tr>

   <tr>
    <td align="right" valign="middle">标识：</td>
    <td valign="middle"> <input type=text name="Label" size="32" class="textfield" value="<%=ct.getLabel()%>"></td>
  </tr>

      <tr>
    <td align="right" valign="middle">模板类型：</td>
    <td valign="middle"><select name="TemplateType" onChange="change();">
			<%if(ct.getTemplateType()==1){%><option value="1">索引页面模板</option><%}%>
			<%if(ct.getTemplateType()==2){%><option value="2">内容页面模板</option><%}%>
			<%if(ct.getTemplateType()==3){%><option value="3">附加页面模板</option><%}%>
			<%if(ct.getTemplateType()==5){%><option value="5">应用页面模板</option><%}%>
			<%if(ct.getTemplateType()==6){%><option value="6">注册页面模板</option><%}%></td>
  </tr>

      <tr>
    <td align="right" valign="middle">对应程序文件名：</td>
    <td valign="middle"><input type=text name="TargetName" size="32" class="textfield" value="<%=ct.getTargetName()%>"></td>
  </tr>

      <tr>
    <td align="right" valign="middle">文件编码：</td>
    <td valign="middle"><select name="Charset">
				<option value="">系统默认编码</option>
				<option value="gb2312">简体中文(GB2312)</option>
				<option value="utf-8">Unicode(UTF-8)</option>
				</select></td>
  </tr>
<%if(ct.getTemplateType()==2){%>
<tr>
    <td align="right" valign="middle">子目录命名规则：</td>
    <td valign="middle">	<select name="SubFolderType" onChange="changeFolderType();">
				<option value="0">系统默认</option>
				<option value="1">按年份命名，每年一个目录</option>
				<option value="2">按年月命名，每月一个目录</option>
				<option value="3">按年月日命名，每日一个目录</option>
				<option value="4">按每天一个目录(如/2018-08-08/)</option>
				<option value="6">按每天一个目录(如/20180808/)</option>
				<option value="5">按文档指定目录</option>
				</select>
				<br><br><Label id="FolderTypeDesc">没有子目录</Label></td>
  </tr>
<tr>
    <td align="right" valign="middle">文件名规则：</td>
    <td valign="middle"><select name="FileNameType" onChange="changeFileNameType();">
				<option value="0">系统默认</option>
				<option value="1">以标题做文件名</option>
				<option value="2">时间戳加随机数</option>
				<option value="3">按文档字段指定文件名</option>
				<option value="4">定制规则</option>
				</select>
				<br><br><input id="FileNameField" style="display:none" type=text name="FileNameField" class="textfield" value="<%=ct.getFileNameField()%>"></td>
  </tr>
<tr>
    <td align="right" valign="middle">条件：</td>
    <td valign="middle"><input type=text name="WhereSql" class="textfield" value="<%=Util.HTMLEncode(ct.getWhereSql())%>"></td>
 </tr>
<%}%>
<%if(ct.getTemplateType()==3){
%>
   <tr>
    <td align="right" valign="middle">指定行数：</td>
    <td valign="middle"><input type=text name="Rows" size="10" class="textfield" value="<%=ct.getRows()%>"> 对列表模板有效</td>
  </tr>
  <tr>
    <td align="right" valign="middle">限制标题：</td>
    <td valign="middle">最多<input type=text name="TitleWord" size="6" class="textfield" value="<%=ct.getTitleWord()>0?ct.getTitleWord():""%>">字</td>
  </tr>
  <tr>
    <td align="right" valign="middle">链接：</td>
    <td valign="middle"><input type=text name="Href" size="32" class="textfield" value="<%=ct.getHref()%>"></td>
  </tr>
<%}%>
<%if(ct.getTemplateType()==1){%>
<tr>
    <td align="right" valign="middle">条件：</td>
    <td valign="middle"><input type=text name="WhereSql" class="textfield" value="<%=ct.getWhereSql()%>"></td>
 </tr>
    <tr>
    <td align="right" valign="middle">包含子频道：</td>
    <td valign="middle"><input name="IncludeChildChannel" type="checkbox" value="1" <%=ct.getIncludeChildChannel()==1?"checked":""%>></td>
  </tr>
  
  <tr>
    <td align="right" valign="middle">每页纪录数：</td>
    <td valign="middle"><input type=text name="rowsPerPage" size="10" class="textfield" value="<%=ct.getRowsPerPage()%>"></td>
  </tr>

  <tr>
    <td align="right" valign="middle">文件生成频率：</td>
    <td valign="middle"><input type=text name="PublishInterval" size="5" class="textfield" value="<%=ct.getPublishInterval()%>"> 分钟</td>
  </tr>
<%}%>
<%if(ct.getTemplateType()==1 || ct.getTemplateType()==2){%>
    <tr>
    <td align="right" valign="middle">继承上级模板：</td>
    <td valign="middle"><input name="IsInherit" type="checkbox" value="1" onClick="inherit(this);" <%=ct.getIsInherit()==1?"checked":""%>></td>
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
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
<input type="hidden" name="id" value="<%=id%>">
<input type="hidden" name="Submit" value="Submit">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
<script language=javascript>
<%if(!ct.getCharset().equals("")){%>
document.form.Charset.value = "<%=ct.getCharset()%>";
<%}%>
<%if(ct.getTemplateType()==2){%>
document.form.SubFolderType.value = "<%=ct.getSubFolderType()%>";
document.form.FileNameType.value = "<%=ct.getFileNameType()%>";
<%}%>
changeFolderType();
changeFileNameType();
</script>
</html>
