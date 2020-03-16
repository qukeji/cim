<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

/**
*        时间          修改人            详情
*     2015-12-09     曲科籍       修改拼到时显示数据源参数，当前显示的规则是：DataSource此参数不为空或者null *时候显示，目前调用SetDataSource()时候无法修改属性，
*
*
*
**/


//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

int ChannelID = getIntParameter(request,"ChannelID");

Channel channel = new Channel(ChannelID);
String IconFolder = request.getContextPath() + "/images/channel_icon/";
//System.setProperty("file.encoding","gb2312");
String Name = getParameter(request,"Name");
if(!Name.equals(""))
{
	String	FolderName				= getParameter(request,"FolderName");
	String	ImageFolderName			= getParameter(request,"ImageFolderName");
	String	SerialNo				= getParameter(request,"SerialNo");
	String	Href					= getParameter(request,"Href");
	String	Attribute1				= getParameter(request,"Attribute1");
	String	Attribute2				= getParameter(request,"Attribute2");
	String	RecommendOut			= getParameter(request,"RecommendOut");
	String	RecommendOutRelation	= getParameter(request,"RecommendOutRelation");
	String  Extra1					= getParameter(request,"Extra1");
	String	ListJS					= getParameter(request,"ListJS");
	String	ListSearchField			= getParameter(request,"ListSearchField");
	String	ListShowField			= getParameter(request,"ListShowField");
	String  DocumentJS				= getParameter(request,"DocumentJS");
	String	ListProgram				= getParameter(request,"ListProgram");
	String	DocumentProgram			= getParameter(request,"DocumentProgram");
	String  Extra2					= getParameter(request,"Extra2");
	String	Icon					= getParameter(request,"Icon");
	String  DataSource              = getParameter(request,"DataSource");

	int		IsDisplay				= getIntParameter(request,"IsDisplay");
	int		TemplateInherit			= getIntParameter(request,"TemplateInherit");
	int		IsWeight				= getIntParameter(request,"IsWeight");
	int		IsComment				= getIntParameter(request,"IsComment");
	int		IsClick					= getIntParameter(request,"IsClick");
	int		IsShowDraftNumber		= getIntParameter(request,"IsShowDraftNumber");
	int		ImageFolderType			= getIntParameter(request,"ImageFolderType");
	int	    ViewType				= getIntParameter(request,"ViewType");
	int		IsListAll			    = getIntParameter(request,"IsListAll");
	int		IsTop					= getIntParameter(request,"IsTop");
	int		IsPublishFile			= getIntParameter(request,"IsPublishFile");
	int		IsImportWord			= getIntParameter(request,"IsImportWord");
	int		IsExportExcel			= getIntParameter(request,"IsExportExcel");
	int     Version                 = getIntParameter(request,"Version");

	int	Attribute1_Type				= getIntParameter(request,"Attribute1_Type");
	int	Attribute2_Type				= getIntParameter(request,"Attribute2_Type");
	int	RecommendOut_Type			= getIntParameter(request,"RecommendOut_Type");
	int	RecommendOutRelation_Type	= getIntParameter(request,"RecommendOutRelation_Type");
	int	ListProgram_Type			= getIntParameter(request,"ListProgram_Type");
	int	DocumentProgram_Type		= getIntParameter(request,"DocumentProgram_Type");
	int	ListJS_Type					= getIntParameter(request,"ListJS_Type");
	int	DocumentJS_Type				= getIntParameter(request,"DocumentJS_Type");


	if(Attribute1_Type==0) Attribute1 = "***";
	if(Attribute2_Type==0) Attribute2 = "***";
	if(RecommendOut_Type==0) RecommendOut = "***";
	if(RecommendOutRelation_Type==0) RecommendOutRelation = "***";
	if(ListProgram_Type==0) ListProgram = "***";
	if(DocumentProgram_Type==0) DocumentProgram = "***";
	if(ListJS_Type==0) ListJS = "***";
	if(DocumentJS_Type==0) DocumentJS = "***";

	channel.setName(Name);
	if(!channel.isRootChannel())
	{
		if(!channel.getFolderName().equals(FolderName))
		{
			//如果改变了频道的目录名，则更新full path
			channel.setFolderName(FolderName);
			channel.UpdateFullPath();
		}		
	}
	channel.setImageFolderName(ImageFolderName);
	channel.setImageFolderType(ImageFolderType);
	if(!channel.isRootChannel())
		channel.setSerialNo(SerialNo);
	channel.setIsDisplay(IsDisplay);
	channel.setIsWeight(IsWeight);
	channel.setIsComment(IsComment);
	channel.setIsClick(IsClick);
	channel.setIsShowDraftNumber(IsShowDraftNumber);
	channel.setHref(Href);
	channel.setAttribute1(Attribute1);
	channel.setAttribute2(Attribute2);
	channel.setRecommendOut(RecommendOut);
	channel.setRecommendOutRelation(RecommendOutRelation);
	channel.setExtra1(Extra1);
	channel.setExtra2(Extra2);
	channel.setListJS(ListJS);
	channel.setListSearchField(ListSearchField);
	channel.setListShowField(ListShowField);
	channel.setDocumentJS(DocumentJS);
	channel.setListProgram(ListProgram);
	channel.setDocumentProgram(DocumentProgram);
	channel.setIcon(Icon);
	channel.setViewType(ViewType);
	channel.setIsListAll(IsListAll);
	channel.setIsTop(IsTop);
	channel.setIsPublishFile(IsPublishFile);
	channel.setIsImportWord(IsImportWord);
	channel.setIsExportExcel(IsExportExcel);
	channel.setDataSource(DataSource);
//	channel.setRootPath(application.getRealPath(RootPath));

	channel.setActionUser(userinfo_session.getId());
	channel.setTemplateInherit(TemplateInherit);
	channel.setVersion(Version);
	channel.Update();

	session.removeAttribute("channel_tree_string");

	String o = "{action:1,id:\""+channel.getId()+"\",name:\""+channel.getName()+"\",icon:\""+Icon+"\"}";
	out.println("<script>top.TideDialogClose({refresh:'left.action("+o+");'});</script>");return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">

$(function () {
	$(".FieldValueType").each(function(){
		//追加按钮
		var field = $(this).attr("value2");
		var img1 = "13.png";
		if($(this).val()==1)
		{
			img1 = "14.png";
		}
		else
		{
			//继承
			$("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');;
		}

		var html = "<a href=\"javascript:cT('"+field+"')\"><img id=\""+field+"_img1\" src=\"../images/icon/"+img1+"\" title=\"继承上级\" /></a>";
		html += " <a href=\"javascript:applySubChannel('"+field+"')\"><img src=\"../images/icon/43.png\" title=\"应用到子频道\" /></a>";
		//alert($(this));
		$(this).after(html);
	});
});

function cT(field)
{
	if($("#"+field+"_Type").val()==0)
	{
		//继承
		$("#"+field+"_Type").val("1");
		$("#"+field+"_img1").attr("src","../images/icon/14.png");
		$("#"+field).attr("class","textfield").removeAttr('disabled');

	}
	else
	{
		$("#"+field+"_Type").val("0");
		$("#"+field+"_img1").attr("src","../images/icon/13.png");
		$("#"+field).attr("class","textinput_disabled").attr('disabled','disabled');
	}
	//alert($("#"+field+"_img1").attr("src"));
}

function init()
{

}

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
<%if(channel.getType()==0 && !channel.isRootChannel()){%>
	if(isEmpty(document.form.FolderName,"请输入目录名."))
		return false;
	if(isEmpty(document.form.SerialNo,"请输入标识名."))
		return false;
<%}%>
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
<%if(channel.getType()==0 ){%>
	if(document.form.SerialNo.value!="" && document.form.FolderName.value=="")
		document.form.FolderName.value = document.form.SerialNo.value;
<%}%>
}

function showRecommend()
{
	var o = document.getElementById("RecommendArea");
	if(o)
	{
		if(o.style.display =="")
			o.style.display = "none";
		else
			o.style.display = "";
	}
}

function showTab(form,form_td)
{
	var num = 5;
	for(i=1;i<=num;i++)
	{
		jQuery("#form"+i).hide();
		jQuery("#form"+i+"_td").removeClass("cur");
	}
	
	jQuery("#"+form).show();
	jQuery("#"+form_td).addClass("cur");
}

function autoChange(id)
{
	var o = document.getElementById(id);
	if(o)
	{
		if(o.rows==4)
		{o.rows=20;}
		else
		{o.rows=4;}
	}
}

function openIconList()
{
	var	dialog = new top.TideDialog();
	dialog.setWidth(600);
	dialog.setHeight(450);
	dialog.setSuffix('_2');
	dialog.setUrl("channel/icon_list.jsp");
	dialog.setTitle("选择图标");
	dialog.setScroll('auto');
	dialog.show();
}

function setReturnValue(o){
	//alert(o.icon);return;
	if(o.icon!=null){
		$("#iconimg").attr("src","<%=IconFolder%>"+o.icon).show();
		$("#Icon").val(o.icon);
	}
}

function applySubChannel(field)
{
	var v = $("#"+field).val();
	if(confirm('当前频道及其所有子频道的对应属性都会被覆盖，请确认要复制该属性到子频道吗？属性内容是：'+v)) 
	{
		var url="channel_attribute_copy.jsp";
		$.ajax({
			type: "POST",
			url: url,
			data: {id:$("#ChannelID").val(),field:field,value:v},
			success: function(msg){alert("应用成功.");}});
	}
}

</script>
<style> 
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
</style>
</head>

<body>
<form name="form" action="channel_edit.jsp" method="post" onSubmit="return check();">
<!-- start-->
<div class="edit_main edit_main dialog_editChannel">
	<div class="edit_nav">
    	<ul>
        	<li><a href="javascript:showTab('form1','form1_td');" class="cur" id="form1_td"><span>基本信息</span></a></li>
            <li><a href="javascript:showTab('form2','form2_td');" id="form2_td"><span>扩展信息</span></a></li>
            <li><a href="javascript:showTab('form3','form3_td');" id="form3_td"><span>推荐设置</span></a></li>
            <li><a href="javascript:showTab('form4','form4_td');" id="form4_td"><span>列表设置</span></a></li>
			<li><a href="javascript:showTab('form5','form5_td');" id="form5_td"><span>内容设置</span></a></li>
			<!--<li><a href="javascript:showTab('form6','form6_td');" id="form6_td"><span>通知功能</span></a></li>-->
        </ul>
        <div class="clear"></div>
    </div>
    <div class="edit_con">
    	 
		<div class="center_main">
        <div class="center" id="form1">
<table width="100%" border="0">
  <tr>
    <td>名称：</td>
    <td><input type="text" name="Name" class="textfield"  value="<%=channel.getName()%>"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>模板方式：</td>
    <td><input name="TemplateInherit" id="s003" type="radio" value="1" <%=channel.getTemplateInherit()==1?"checked":""%>><label for="s003">继承上级模板</label></td>
    <td><input type="radio" id="s004" name="TemplateInherit" value="0" <%=channel.getTemplateInherit()==0?"checked":""%>><label for="s004">独立模板</label></td>
  </tr>
  <tr>
    <td>标识名：</td>
    <td><%if(channel.isRootChannel()){%><%=channel.getSerialNo()%><%}else{%><input type="text" name="SerialNo" class="textfield" onBlur="initOther()" value="<%=channel.getSerialNo()%>"><%}%></td>
    <td>&nbsp;</td>
  </tr>
  <%if(channel.getDataSource()!=null&&!channel.getDataSource().equals("")){%>  
  <tr>
    <td>数据源：</td>
    <td><input type=text value ="<%=channel.getDataSource()%>" name="DataSource"  class="textfield"></td>
    <td>&nbsp;</td>
  </tr>
<%}%>
  <tr>
    <td>目录名：</td>
    <td><%if(channel.isRootChannel()){%><%=channel.getFolderName()%><%}else{%><input type="text" name="FolderName"  class="textfield" value="<%=channel.getFolderName()%>"><%}%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>图片上传目录：</td>
    <td><input type="text" name="ImageFolderName" class="textfield" value="<%=channel.getImageFolderName()%>"></td>
    <td>*为空使用站点默认图片目录</td>
  </tr>
  <tr> 
    <td>图片目录规则</td>
    <td>
		<select name="ImageFolderType">
		<option value="0" <%=channel.getImageFolderType()==0?"selected":""%>>系统默认</option>
		<option value="1" <%=channel.getImageFolderType()==1?"selected":""%>>按年份命名，每年一个目录</option>
		<option value="2" <%=channel.getImageFolderType()==2?"selected":""%>>按年月命名，每月一个目录</option>
		<option value="3" <%=channel.getImageFolderType()==3?"selected":""%>>按年月日命名，每日一个目录</option>
		<option value="4" <%=channel.getImageFolderType()==4?"selected":""%>>按每天一个目录</option>
		</select>
	</td>
  </tr>
  <tr>
    <td>链接：</td>
    <td><%if(channel.isRootChannel()){%><%=channel.getHref()%><%}else{%><input type="text" name="Href" class="textfield" value="<%=channel.getHref()%>"><%}%></td>
    <td>&nbsp;</td>
  </tr>
<%if(channel.isTableChannel() || channel.isRootChannel()){%>
  <tr>
    <td>图标：</td>
    <td><img id="iconimg" src="<%=IconFolder + channel.getIcon()%>" style="vertical-align:middle;display:<%if(channel.getIcon().length()==0){%>none<%}%>">&nbsp;<input name="" type="button" class="tidecms_btn3" value="选择" onClick="openIconList()"/></td>
    <td>&nbsp;</td>
  </tr>
<%}%>
<%if(!channel.isRootChannel()){%>
  <tr>
    <td>是否在导航中出现：</td>
    <td><input type="checkbox" name="IsDisplay" value="1" <%=channel.getIsDisplay()==1?"checked":""%>></td>
    <td>&nbsp;</td>
  </tr>
<%}%>
</table>
        </div>
        
       <div class="center" id="form2" style="display:none;">
<table width="100%" border="0">
  <tr>
    <td width="80">附加属性一：</td>
    <td><textarea name="Extra1" cols="70" rows="4" class="textfield"><%=channel.getExtra1()%></textarea></td>
  </tr>
  <tr>
    <td>附加属性二：</td>
    <td><textarea name="Extra2" cols="70" rows="4" class="textfield"><%=channel.getExtra2()%></textarea></td>
  </tr>
</table>
	</div>
        
         <div class="center" id="form3" style="display:none;">
<table width="100%" border="0" id="table001">
  <tr>
    <td width="120">引用栏目：</td>
    <td width=""><%if(channel.isRootChannel()){%><%=channel.getAttribute1()%><%}else{%><textarea name="Attribute1" id="Attribute1" cols="65" rows="4" class="textfield" onDblClick="autoChange('Attribute1')"><%=channel.getAttribute1()%></textarea><%}%></td>
	<td align="left" width="50">
	<input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"Attribute1")%>" name="Attribute1_Type" id="Attribute1_Type" class="FieldValueType" value2="Attribute1"><!--<a href="javascript:applySubChannel(1)"><img src="../images/icon/43.png" title="应用到子频道" /></a><a href="javascript:applySubChannel(1)"><img src="../images/icon/13.png" title="继承上级" />--></a></td>
  </tr>
  <tr>
    <td>对应关系：</td>
    <td><%if(channel.isRootChannel()){%><%=channel.getAttribute2()%><%}else{%><textarea name="Attribute2" id="Attribute2" cols="65" rows="4" class="textfield" onDblClick="autoChange('Attribute2')"><%=channel.getAttribute2()%></textarea><%}%></td>
	<td align="left">
	<input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"Attribute2")%>" name="Attribute2_Type" id="Attribute2_Type" class="FieldValueType" value2="Attribute2">
	</td>
  </tr>
  <tr>
    <td>推荐栏目：</td>
    <td><textarea name="RecommendOut" id="RecommendOut" cols="65" rows="4" class="textfield" onDblClick="autoChange('RecommendOut')"><%=channel.getRecommendOut()%></textarea></td>
	<td align="left">
	<input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"RecommendOut")%>" name="RecommendOut_Type" id="RecommendOut_Type" class="FieldValueType" value2="RecommendOut">
	</td>
  </tr>
  <tr>
    <td>对应关系：</td>
    <td><textarea name="RecommendOutRelation" id="RecommendOutRelation" cols="65" rows=4 class="textfield" onDblClick="autoChange('RecommendOutRelation')"><%=channel.getRecommendOutRelation()%></textarea></td>
	<td align="left">
	<input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"RecommendOutRelation")%>" name="RecommendOutRelation_Type" id="RecommendOutRelation_Type" class="FieldValueType" value2="RecommendOutRelation">
	</td>
  </tr>
</table>
        </div>
        
        <div class="center" id="form4" style="display:none;">
<table width="100%" border="0" id="table002">
  <tr>
    <td colspan="3">
		<div class="form_view_list"><label>默认视图：</label>
			<input type="radio" name="ViewType" value="0" <%=channel.getViewType()==0?"checked":""%> id="ViewType_0"><label for="ViewType_0">文字</label>
			<input type="radio" name="ViewType" value="1" <%=channel.getViewType()==1?"checked":""%> id="ViewType_1"><label for="ViewType_1">详细</label>
			<input type="radio" name="ViewType" value="2" <%=channel.getViewType()==2?"checked":""%> id="ViewType_2"><label for="ViewType_2">图片</label>
		</div>
	</td>
  </tr>
   <tr>
    <td colspan="3">
    	<ul class="list_show">
        	<li><input type="checkbox" name="IsWeight" value="1" <%=channel.getIsWeight()==1?"checked":""%> id="IsWeight"><label for="IsWeight">是否使用权重</label></li>
            <li><input type="checkbox" name="IsComment" value="1" <%=channel.getIsComment()==1?"checked":""%> id="IsComment"><label for="IsComment">是否显示评论</label></li>
            <li><input type="checkbox" name="IsClick" value="1" <%=channel.getIsClick()==1?"checked":""%> id="IsClick"><label for="IsClick">是否显示点击数</label></li>
            <li><input type="checkbox" name="IsShowDraftNumber" value="1" <%=channel.getIsShowDraftNumber()==1?"checked":""%> id="IsShowDraftNumber"><label for="IsShowDraftNumber">是否显示草稿数</label></li>
            <li><input type="checkbox" name="IsListAll" value="1" <%=channel.getIsListAll()==1?"checked":""%> id="IsListAll"><label for="IsListAll">是否包含子频道</label></li>
            <li><input type="checkbox" name="IsTop" value="1" <%=channel.getIsTop()==1?"checked":""%> id="IsTop"><label for="IsTop">是否允许置顶</label></li>
			<li><input type="checkbox" name="IsPublishFile" value="1" <%=channel.getIsPublishFile()==1?"checked":""%> id="IsPublishFile"><label for="IsPublishFile">文件发布审核</label></li>
			<li><input type="checkbox" name="IsImportWord" value="1" <%=channel.getIsImportWord()==1?"checked":""%> id="IsImportWord"><label for="IsImportWord">导入Word</label></li>
			<li><input type="checkbox" name="IsExportExcel" value="1" <%=channel.getIsExportExcel()==1?"checked":""%> id="IsExportExcel"><label for="IsExportExcel">导出Excel</label></li>
			<li><input type="checkbox" name="Version" value="1" <%=channel.getVersion()==1?"checked":""%> id="Version"><label for="Version">是否开启版本</label></li>

        </ul>
    </td>
  </tr>
 <tr>
    <td colspan="3"><div class="hr_line"></div></td>   
  </tr>
  <tr>
    <td colspan="3">使用定制列表：</td>
  </tr>
    <tr>
    <td>列表页程序：</td>
    <td><input type="text" name="ListProgram" id="ListProgram" class="textfield" size="64" value="<%=channel.getListProgram()%>"/></td>
	<td>
	<input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"ListProgram")%>" name="ListProgram_Type" id="ListProgram_Type" class="FieldValueType" value2="ListProgram">
	</td>
  </tr>
  <tr>
    <td>列表页脚本：</td>
    <td><textarea name="ListJS" id="ListJS" cols="64" rows="4" class="textfield" onDblClick="autoChange('ListJS')"><%=channel.getListJS()%></textarea></td>
	<td>
	<input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"ListJS")%>" name="ListJS_Type" id="ListJS_Type" class="FieldValueType" value2="ListJS">
	</td>
  </tr>
  <tr>
    <td>搜索字段：</td>
    <td><textarea name="ListSearchField" id="ListSearchField" cols="64" rows="4" class="textfield" onDblClick="autoChange('ListSearchField')"><%=channel.getListSearchField()%></textarea></td>
	<td></td>
  </tr>
  <tr>
    <td>列表字段：</td>
    <td><textarea name="ListShowField" id="ListShowField" cols="64" rows="4" class="textfield" onDblClick="autoChange('ListShowField')"><%=channel.getListShowField()%></textarea></td>
	<td></td>
  </tr>
  </table>
        </div>

		<div class="center" id="form5" style="display:none;">
<table width="100%" border="0" id="table002">
<!--
  <tr>
    <td>使用地图位置信息：</td>
    <td><input type="checkbox" name="" value="1"></td>
	<td></td>
  </tr>
    <tr>
    <td>使用相关内容：</td>
    <td><input type="checkbox" name="" value="1"></td>
	<td></td>
  </tr>
 <tr>
 -->
    <td colspan="3"><div class="hr_line"></div></td>
  </tr>
    <tr>
    <td colspan="3">使用定制内容模型：</td>  
  </tr>
 <tr>
    <td>内容页程序：</td>
    <td><input type="text" name="DocumentProgram" id="DocumentProgram" class="textfield" size="64" value="<%=channel.getDocumentProgram()%>"/></td>
	<td>
	<input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"DocumentProgram")%>" name="DocumentProgram_Type" id="DocumentProgram_Type" class="FieldValueType" value2="DocumentProgram">
	</td>
  </tr>
  <tr>
    <td>内容页脚本：</td>
    <td><textarea name="DocumentJS" id="DocumentJS" cols="64" rows="4" class="textfield" onDblClick="autoChange('DocumentJS')"><%=channel.getDocumentJS()%></textarea></td>
	<td>
	<input type="hidden" value="<%=ChannelUtil.getFieldValueType(channel.getId(),"DocumentJS")%>" name="DocumentJS_Type" id="DocumentJS_Type" class="FieldValueType" value2="DocumentJS">
	</td>
  </tr>
 
</table>
        </div>

		<!--<div class="center" id="form6" style="display:none;">
<table width="100%" border="0" id="table002">
  <tr>
    <td>列表页脚本6：<br><a class="applysubchannel" href="javascript:applySubChannel(5)">应用到子频道</a></td>
    <td><textarea name="ListJS" id="ListJS" cols=46 rows=4 class="textfield" onDblClick="autoChange('ListJS')"><%=channel.getListJS()%></textarea></td>
  </tr>
  <tr>
    <td>内容页脚本：<br><a class="applysubchannel" href="javascript:applySubChannel(6)">应用到子频道</a></td>
    <td><textarea name="DocumentJS" id="DocumentJS" cols=46 rows=4 class="textfield" onDblClick="autoChange('DocumentJS')"><%=channel.getDocumentJS()%></textarea></td>
  </tr>
  <tr>
    <td>列表页程序：<br><a class="applysubchannel" href="javascript:applySubChannel(7)">应用到子频道</a></td>
    <td><input type="text" name="ListProgram" class="textfield" size="49" value="<%=channel.getListProgram()%>"/></td>
  </tr>
  <tr>
    <td>内容页程序：<br><a class="applysubchannel" href="javascript:applySubChannel(8)">应用到子频道</a></td>
    <td><input type="text" name="DocumentProgram" class="textfield" size="49" value="<%=channel.getDocumentProgram()%>"/></td>
  </tr>
</table>
        </div>-->

        </div>
    </div>
</div>
<!-- end-->
<div class="form_button">
	<input type="hidden" id="ChannelID" name="ChannelID" value="<%=ChannelID%>">
	<input type="hidden" id="Icon" name="Icon" value="<%=channel.getIcon()%>">
	
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>