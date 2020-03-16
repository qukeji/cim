<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int	ChannelID		=	getIntParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");

Channel parentChannel = CmsCache.getChannel(ChannelID);
String ChannelName	=	parentChannel.getName();

String Name			=	getParameter(request,"Name");
//if(Name.length()>0)
//{
//String str = new String(request.getParameter("Name").getBytes(),"euc-kr");
//System.out.println("str:"+str);
//System.out.println("Name:"+Name);
//}
int ContinueAdd		=	getIntParameter(request,"ContinueAdd");
int Type2			=	getIntParameter(request,"Type2");//Type2==2 可配置数据源的频道
String Source		=	getParameter(request,"Source");//调用此页面的来源

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
	String  Extra2					= getParameter(request,"Extra2");
	String	ListJS					= getParameter(request,"ListJS");
	String	ListSearchField			= getParameter(request,"ListSearchField");
	String	ListShowField			= getParameter(request,"ListShowField");
	String  DocumentJS				= getParameter(request,"DocumentJS");
	String	ListProgram				= getParameter(request,"ListProgram");
	String	DocumentProgram			= getParameter(request,"DocumentProgram");
	String	DataSource				= getParameter(request,"DataSource");
	int		Parent					= getIntParameter(request,"Parent");
	int		IsDisplay				= getIntParameter(request,"IsDisplay");
	int		ChannelType				= getIntParameter(request,"ChannelType");
	int		TemplateInherit			= getIntParameter(request,"TemplateInherit");
	int		IsWeight				= getIntParameter(request,"IsWeight");
	int		IsComment				= getIntParameter(request,"IsComment");
	int		IsClick					= getIntParameter(request,"IsClick");
	int		IsShowDraftNumber		= getIntParameter(request,"IsShowDraftNumber");
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


	Channel channel = new Channel();
	
	channel.setName(Name);
	channel.setParent(Parent);
	channel.setFolderName(FolderName);
	channel.setImageFolderName(ImageFolderName);
	channel.setSerialNo(SerialNo);
	channel.setIsDisplay(IsDisplay);
	channel.setIsWeight(IsWeight);
	channel.setIsComment(IsComment);
	channel.setIsClick(IsClick);
	channel.setIsShowDraftNumber(IsShowDraftNumber);

	channel.setType(ChannelType);
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
	channel.setTemplateInherit(TemplateInherit);
	channel.setDataSource(DataSource);

	channel.setActionUser(userinfo_session.getId());
	channel.setViewType(ViewType);
	channel.setIsListAll(IsListAll);
	channel.setIsTop(IsTop);
	channel.setIsPublishFile(IsPublishFile);
	channel.setIsImportWord(IsImportWord);
	channel.setIsExportExcel(IsExportExcel);
	channel.setVersion(Version);
	channel.Add();

	session.removeAttribute("channel_tree_string");

	if(Source.equals("Page"))
	{
		out.println("<script language=javascript>");
		out.println("var o = new Object();");
	    out.println("o.Name = '" + channel.getParentChannelPath() + "';");
		out.println("o.ChannelID = " + channel.getId() + ";");
	    out.println("window.returnValue=o;");
	    out.println("window.close();");
		out.println("</script>");
		return;
	}

	if(ContinueAdd==0)
	{
		String o = "{action:2,id:\""+channel.getId()+"\"}";
		out.println("<script>top.TideDialogClose({refresh:'left.action("+o+")',returnValue:{close:2}});</script>");return;
	}
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
<script type="text/javascript">

$(function () {

	document.form.Name.focus();
	var	scr = document.createElement('script')
	scr.src = 'getserialno.jsp?Parent=<%=ChannelID%>&random=' + Math.random();
	document.getElementById('ParentName').appendChild(scr);

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

function check()
{
	if(isEmpty(document.form.Name,"请输入名称."))
		return false;
	if(isEmpty(document.form.SerialNo,"请输入标识名."))
		return false;

	var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789"; 

	if (document.form.ChannelType[1].checked){
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
			alert("具有独立表单的频道的标识名必须由英文字母，数字或下划线组成.");
			document.form.SerialNo.focus();
			return false;
		}

	}
	}

	document.form.startButton.disabled  = true;

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
			//document.form.ImageFolderName.value = folder + "/images";
		}

		var smallch="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_0123456789";

		if (document.form.ChannelType[1].checked){
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
				alert("具有独立表单的频道的标识名必须由英文字母，数字或下划线组成.");
				document.form.SerialNo.focus();
				return false;
			}
		}
		}

		scr = document.createElement('script')
		scr.src = 'checkserialno.jsp?SerialNo=' + document.form.SerialNo.value + '&random=' + Math.random();
		document.getElementById('ParentName').appendChild(scr);
	}
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
</script>
<style> 
.edit-main{margin:0;position:Static;}
.edit-con .bot{position:absolute;bottom:36px;right:0;left:0;}
.edit-con{position:Static;margin:-1px 0 0;}
.edit-con .center_main{position:absolute;top:44px;bottom:50px;right:0;left:0;}
</style>
</head>

<body >
<form name="form" action="channel_add.jsp" method="post" onSubmit="return check();">
<!-- start-->
<div class="edit_main dialog_editChannel">
	<div class="edit_nav">
    	<ul>
		    <li><a href="javascript:showTab('form1','form1_td');" class="cur" id="form1_td"><span>基本信息</span></a></li>
            <li><a href="javascript:showTab('form2','form2_td');" id="form2_td"><span>扩展信息</span></a></li>
            <li><a href="javascript:showTab('form3','form3_td');" id="form3_td"><span>推荐设置</span></a></li>
            <li><a href="javascript:showTab('form4','form4_td');" id="form4_td"><span>列表设置</span></a></li>
			<li><a href="javascript:showTab('form5','form5_td');" id="form5_td"><span>内容设置</span></a></li>
        </ul>
        <div class="clear"></div>
    </div>
    <div class="edit_con">
    	 
		<div class="center_main">
        <div class="center" id="form1">
<table width="100%" border="0">
  <tr>
    <td width="110">上级频道：</td>
	<td  colspan="2"><label id="ParentName"><%=ChannelName%></label></td>
  </tr>
  <tr>
    <td>名称：</td>
    <td><input type=text name="Name" class="textfield"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>表单方式： </td>
    <td><input name="ChannelType" id="s001" type="radio" value="1" checked><label for="s001">继承上级表单</label></td>
    <td><input type="radio" id="s002" name="ChannelType" value="0"><label for="s002">独立表单</label></td>
  </tr>
  <tr>
    <td>模板方式：</td>
    <td><input name="TemplateInherit" id="s003" type="radio" value="1" checked><label for="s003">继承上级模板</label></td>
    <td><input type="radio" id="s004" name="TemplateInherit" value="0"><label for="s004">独立模板</label></td>
  </tr>
  <tr>
    <td>标识名：</td>
    <td><input type=text name="SerialNo"  class="textfield" onBlur="initOther()" value=""></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>目录名：</td>
    <td><input type=text name="FolderName"  class="textfield"></td>
    <td>&nbsp;</td>
  </tr>
<%if(Type2==2){%>  
  <tr>
    <td>数据源：</td>
    <td><input type=text name="DataSource"  class="textfield"></td>
    <td>&nbsp;</td>
  </tr>
<%}%>
  <tr>
    <td>图片上传目录：</td>
    <td><input type=text name="ImageFolderName" class="textfield"></td>
    <td>*为空使用站点默认图片目录</td>
  </tr>
    <tr> 
    <td>图片目录规则</td>
    <td>
		<select name="ImageFolderType">
		<option value="0">系统默认</option>
		<option value="1">按年份命名，每年一个目录</option>
		<option value="2">按年月命名，每月一个目录</option>
		<option value="3">按年月日命名，每日一个目录</option>
		<option value="4">按每天一个目录</option>
		</select>
	</td>
  </tr>
  <tr>
    <td>链接：</td>
    <td><input type="text" name="Href" class="textfield"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>是否在导航中出现：</td>
    <td><input type=checkbox name="IsDisplay" value="1" class="textfield" checked></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>继续新建：</td>
    <td><input type=checkbox id="s1" name="ContinueAdd" value="1" class="textfield" <%=ContinueAdd==1?"checked":""%>></td>
    <td>&nbsp;</td>
  </tr>
</table>
        </div>
        
       <div class="center" id="form2" style="display:none;">
<table width="100%" border="0">
  <tr>
    <td>附加属性一：</td>
    <td><textarea name="Extra1" cols="70" rows="4" class="textfield"></textarea></td>
  </tr>
  <tr>
    <td>附加属性二：</td>
    <td><textarea name="Extra2" cols="70" rows="4" class="textfield"></textarea></td>
  </tr>
</table>
	</div>
        
         <div class="center" id="form3" style="display:none;">
<table width="100%" border="0">
  <tr>
    <td>引用栏目：</td>
    <td><textarea name="Attribute1" id="Attribute1" cols="70" rows="4" class="textfield" onDblClick="autoChange('Attribute1')"></textarea></td>
	<td align="left"><input type="hidden" value="0" name="Attribute1_Type" id="Attribute1_Type" class="FieldValueType" value2="Attribute1"></td>
  </tr>
  <tr>
    <td>对应关系：</td>
    <td><textarea name="Attribute2" id="Attribute2" cols="70" rows="4" class="textfield" onDblClick="autoChange('Attribute2')"></textarea></td>
	<td align="left"><input type="hidden" value="0" name="Attribute2_Type" id="Attribute2_Type" class="FieldValueType" value2="Attribute2"></td>
  </tr>
  <tr>
    <td>推荐栏目：</td>
    <td><textarea name="RecommendOut" id="RecommendOut" cols="70" rows="4" class="textfield" onDblClick="autoChange('RecommendOut')"></textarea></td>
	<td align="left"><input type="hidden" value="0" name="RecommendOut_Type" id="RecommendOut_Type" class="FieldValueType" value2="RecommendOut"></td>
  </tr>
  <tr>
    <td>对应关系：</td>
    <td><textarea name="RecommendOutRelation" id="RecommendOutRelation" cols="70" rows="4" class="textfield" onDblClick="autoChange('RecommendOutRelation')"></textarea></td>
	<td align="left"><input type="hidden" value="0" name="RecommendOutRelation_Type" id="RecommendOutRelation_Type" class="FieldValueType" value2="RecommendOutRelation"></td>
  </tr>
</table>
        </div>
        
        <div class="center" id="form4" style="display:none;">
<table width="100%" border="0">
 <tr>
    <td colspan="3">
		<div class="form_view_list"><label>默认视图：</label>
			<input type="radio" name="ViewType" value="0"  id="ViewType_0"><label for="ViewType_0">文字</label>
			<input type="radio" name="ViewType" value="1"  id="ViewType_1"><label for="ViewType_1">详细</label>
			<input type="radio" name="ViewType" value="2"  id="ViewType_2"><label for="ViewType_2">图片</label>
		</div>
	</td>
  </tr>
   <tr>
    <td colspan="3">
    	<ul class="list_show">
        	<li><input type="checkbox" name="IsWeight" value="1"  id="IsWeight"><label for="IsWeight">使用权重</label></li>
            <li><input type="checkbox" name="IsComment" value="1"  id="IsComment"><label for="IsComment">显示评论</label></li>
            <li><input type="checkbox" name="IsClick" value="1"  id="IsClick"><label for="IsClick">显示点击数</label></li>
            <li><input type="checkbox" name="IsShowDraftNumber" value="1"  id="IsShowDraftNumber"><label for="IsShowDraftNumber">显示草稿数</label></li>
            <li><input type="checkbox" name="IsListAll" value="1"  id="IsListAll"><label for="IsListAll">包含子频道</label></li>
            <li><input type="checkbox" name="IsTop" value="1" id="IsTop"><label for="IsTop">允许置顶</label></li>
			<li><input type="checkbox" name="IsPublishFile" value="1" id="IsPublishFile"><label for="IsPublishFile">文件发布审核</label></li>
			<li><input type="checkbox" name="IsImportWord" value="1" id="IsImportWord"><label for="IsImportWord">导入Word</label></li>
			<li><input type="checkbox" name="IsExportExcel" value="1" id="IsExportExcel"><label for="IsExportExcel">导出Excel</label></li>
			<li><input type="checkbox" name="version" value="1" id="version"><label for="version">开启版本</label></li>
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
    <td><input type="text" name="ListProgram" id="ListProgram" class="textfield" size="64" /></td>
	<td><input type="hidden" value="0" name="ListProgram_Type" id="ListProgram_Type" class="FieldValueType" value2="ListProgram"></td>
  </tr>
  <tr>
    <td>列表页脚本：</td>
    <td><textarea name="ListJS" id="ListJS" cols="64" rows="4" class="textfield" onDblClick="autoChange('ListJS')"></textarea></td>
	<td><input type="hidden" value="0" name="ListJS_Type" id="ListJS_Type" class="FieldValueType" value2="ListJS"></td>
  </tr>
  <tr>
    <td>搜索字段：</td>
    <td><textarea name="ListSearchField" id="ListSearchField" cols="64" rows="4" class="textfield" onDblClick="autoChange('ListSearchField')"></textarea></td>
	<td></td>
  </tr>
  <tr>
    <td>列表字段：</td>
    <td><textarea name="ListShowField" id="ListShowField" cols="64" rows="4" class="textfield" onDblClick="autoChange('ListShowField')"></textarea></td>
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
-->
 <tr>
    <td colspan="3"><div class="hr_line"></div></td>
  </tr>
    <tr>
    <td colspan="3">使用定制内容模型：</td>  
  </tr>
 <tr>
    <td>内容页程序：</td>
    <td><input type="text" name="DocumentProgram" id="DocumentProgram" class="textfield" size="64" value=""/></td>
	<td><input type="hidden" value="0" name="DocumentProgram_Type" id="DocumentProgram_Type" class="FieldValueType" value2="DocumentProgram"></td>
  </tr>
  <tr>
    <td>内容页脚本：</td>
    <td><textarea name="DocumentJS" id="DocumentJS" cols="64" rows="4" class="textfield" onDblClick="autoChange('DocumentJS')"></textarea></td>
	<td><input type="hidden" value="0" name="DocumentJS_Type" id="DocumentJS_Type" class="FieldValueType" value2="DocumentJS"></td>
  </tr>
 
</table>
        </div>
        </div>
        
    </div>
</div>
<!-- end-->
<div class="form_button">
	<input type="hidden" name="Parent" value="<%=ChannelID%>">
	<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
	<input type="hidden" name="Source" id="Source" value="<%=Source%>">
	
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定"  id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消" id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>