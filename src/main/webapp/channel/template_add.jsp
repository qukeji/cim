<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/**
	 *	修改人		日期		备注
	 *	
	 *	王海龙		20131130	添加 子目录命名规则 “按文档指定目录”
	 * 王海龙      20160708   ViewTemplate方法中的notepad.jsp改成template_edit.jsp
	 */
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		TemplateType	= getIntParameter(request,"TemplateType");
int		ChannelID		= getIntParameter(request,"ChannelID");

String Submit = getParameter(request,"Submit");
if(!Submit.equals(""))
{
	String	TargetName				= getParameter(request,"TargetName");
	String	Charset					= getParameter(request,"Charset");
	String	WhereSql				= getParameter(request,"WhereSql");
	String	Label					= getParameter(request,"Label");
	String	Href					= getParameter(request,"Href");

	int		rowsPerPage				= getIntParameter(request,"rowsPerPage");
	int		SubFolderType			= getIntParameter(request,"SubFolderType");
	int		FileNameType			= getIntParameter(request,"FileNameType");
	//int		Category			= getIntParameter(request,"Category");
	int		Rows					= getIntParameter(request,"Rows");
	int		TitleWord				= getIntParameter(request,"TitleWord");
	int		IncludeChildChannel		= getIntParameter(request,"IncludeChildChannel");
	int		TemplateID				= getIntParameter(request,"TemplateID");
	
	
	ChannelTemplate ct = new ChannelTemplate();

	ct.setTemplateType(TemplateType);
	ct.setRowsPerPage(rowsPerPage);
	ct.setTargetName(TargetName);
	ct.setCharset(Charset);
	ct.setWhereSql(WhereSql);
	ct.setSubFolderType(SubFolderType);
	ct.setFileNameType(FileNameType);
	ct.setChannelID(ChannelID);
	ct.setLabel(Label);
	ct.setHref(Href);
	ct.setRows(Rows);
	ct.setTitleWord(TitleWord);
	ct.setIncludeChildChannel(IncludeChildChannel);
	ct.setTemplateID(TemplateID);
	

	ct.Add();

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
	if(isEmpty(document.form.Template,"请输入模板."))
		return false;
	if(isEmpty(document.form.TemplateType,"请选择模板类型."))
		return false;
	if(isEmpty(document.form.TargetName,"请输入对应程序文件名称."))
		return false;

	//document.form.Button2.disabled  = true;

	return true;
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
	$("#tr01").hide();$("#tr02").hide();$("#tr03").hide();

	var type = document.form.TemplateType.value;//alert(type);
	if(type=="1")
	{
		$("#tr01").show();//tr01.style.display = "";
	}
	else if(type=="2")
	{
		$("#tr02").show();//tr02.style.display = "";
	}
	else if(type=="3")
	{
		$("#tr03").show();//tr03.style.display = "";
	}

}

function changeFolderType()
{
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
<form name="form" action="template_add.jsp" method="post" onSubmit="return check();">
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
    <td valign="middle"><input type=text name="Template" size="32" class="textfield"> 
	<input name="" type="button" class="tidecms_btn3" value="..." onclick="selectTemplate();"/>&nbsp;<input name="" type="button" class="tidecms_btn3" value="查看" onClick="ViewTemplate();"/>
		  <input type="hidden" name="TemplateID" value=""></td>
  </tr>

   <tr>
    <td align="right" valign="middle">标识：</td>
    <td valign="middle"><input type=text name="Label" size="32" class="textfield"></td>
  </tr>

      <tr>
    <td align="right" valign="middle">模板类型：</td>
    <td valign="middle"><select name="TemplateType" onChange="change();">			
			<%if(TemplateType==1){%><option value="1">索引页面模板</option><%}%>
			<%if(TemplateType==2){%><option value="2">内容页面模板</option><%}%>			
			<%if(TemplateType==3){%><option value="1">索引页面模板</option><option value="2">内容页面模板</option><option value="3" selected>附加页面模板</option><%}%>
			<%if(TemplateType==5){%><option value="5">应用页面模板</option><%}%>
			<%if(TemplateType==6){%><option value="6">注册页面模板</option><%}%>
			</select></td>
  </tr>

      <tr>
    <td align="right" valign="middle">对应程序文件名：</td>
    <td valign="middle"><input type=text name="TargetName" size="32" class="textfield"></td>
  </tr>

      <tr>
    <td align="right" valign="middle">文件编码：</td>
    <td valign="middle"><select name="Charset">
				<option value="">系统默认编码</option>
				<option value="gb2312">简体中文(GB2312)</option>
				<option value="utf-8">Unicode(UTF-8)</option>
				</select></td>
  </tr>
<%if(TemplateType==2){%>
<tbody id="tr02">
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
    <td valign="middle"><select name="FileNameType">
				<option value="0">系统默认</option>
				<option value="1">以标题做文件名</option>
				<option value="2">时间戳加随机数</option>
				<option value="3">按文档指定文件名</option>
				<option value="4">定制规则</option>
				</select></td>
  </tr>
</tbody>
<%}%>

<%if(TemplateType==3){
%>
<tbody id="tr01" style="display:none; ">
   <tr>
    <td align="right" valign="middle">包含子频道：</td>
    <td valign="middle"><input name="IncludeChildChannel" type="checkbox" value="1"></td>
  </tr>
   <tr>
    <td align="right" valign="middle">每页纪录数：</td>
    <td valign="middle"><input type=text name="rowsPerPage" size="10" class="textfield" value=""></td>
  </tr>
</tbody>
<tbody id="tr02" style="display:none; ">
   <tr>
    <td align="right" valign="middle">子目录命名规则：</td>
    <td valign="middle"><select name="SubFolderType" onChange="changeFolderType();">
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
    <td valign="middle"><select name="FileNameType">
				<option value="0">系统默认</option>
				<option value="1">以标题做文件名</option>
				<option value="2">时间戳加随机数</option>
				<option value="3">按文档指定文件名</option>
				<option value="4">定制规则</option>
				</select></td>
  </tr>
   <tr>
    <td align="right" valign="middle">条件：</td>
    <td valign="middle"><input type=text name="WhereSql" class="textfield"></td>
  </tr>
</tbody>

<tbody id="tr03">
   <tr>
    <td align="right" valign="middle">指定行数：</td>
    <td valign="middle"><input type=text name="Rows" size="10" class="textfield" value="8"> 对列表模板有效</td>
  </tr>
  <tr>
    <td align="right" valign="middle">限制标题：</td>
    <td valign="middle">最多<input type=text name="TitleWord" size="6" class="textfield" value="">字 对列表模板有效</td>
  </tr>
  <tr>
    <td align="right" valign="middle">链接：</td>
    <td valign="middle"><input type=text name="Href" size="32" class="textfield" value=""></td>
  </tr>
</tbody>
<%}%>

<%if(TemplateType==1){%>
   <tr>
    <td align="right" valign="middle">条件：</td>
    <td valign="middle"><input type=text name="WhereSql" class="textfield"></td>
  </tr>
    <tr>
    <td align="right" valign="middle">包含子频道：</td>
    <td valign="middle"><input name="IncludeChildChannel" type="checkbox" value="1"></td>
  </tr>
       <tr>
    <td align="right" valign="middle">每页纪录数：</td>
    <td valign="middle"><input type=text name="rowsPerPage" size="10" class="textfield" value="20"></td>
  </tr>
<%}%>

<%if(TemplateType==6){%>
        <tr> 
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
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
<input type="hidden" name="Submit" value="Submit">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>