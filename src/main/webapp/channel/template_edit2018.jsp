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
	int		allowPreview			= getIntParameter(request,"allowPreview");

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
		ct.setAllowPreview(allowPreview);

		ct.Update();
        CmsCache.delChannel(ChannelID);
	}

	out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
	return;
}
%>
<!DOCTYPE HTML>
<html>

<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
	<title>TideCMS</title>
	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<style>
		html,
		body {
			width: 100%;
			height: 100%;
		}
	</style>
</head>

<body>
<div class="bg-white modal-box">
	<form name="form" action="template_edit2018.jsp" method="post" onSubmit="return check();">

		<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
			<div class="config-box">
				<ul>
					<li class="block">
						<div class="row">
							<label class="left-fn-title">频道：</label>
							<label class="wd-230">
								<span><%=CmsCache.getChannel(ChannelID).getName()%></span>
							</label>
						</div>
						<div class="row">
							<label class="left-fn-title">模板：</label>
							<label class="wd-230">
								<input class="form-control" placeholder="" size="20" type="text" name="Template" value="<%=ct.getTemplateFile().getFileName()%>">
							</label>
							<input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="..." onclick="selectTemplate();">
							<input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="查看" onClick="ViewTemplate();">
							<input type="hidden" name="TemplateID" value="<%=ct.getTemplateID()%>">
						</div>
						<div class="row">
							<label class="left-fn-title">标识：</label>
							<label class="wd-230">
								<input class="form-control" placeholder="" type="text" name="Label" size="32" value="<%=ct.getLabel()%>">
							</label>
						</div>
						<div class="row">
							<label class="left-fn-title">模板类型：</label>
							<select class="form-control wd-230 ht-40 select2" name="TemplateType" onChange="change();">
								<%if(ct.getTemplateType()==1){%><option value="1">索引页面模板</option><%}%>
								<%if(ct.getTemplateType()==2){%><option value="2">内容页面模板</option><%}%>
								<%if(ct.getTemplateType()==3){%><option value="3">附加页面模板</option><%}%>
								<%if(ct.getTemplateType()==5){%><option value="5">应用页面模板</option><%}%>
								<%if(ct.getTemplateType()==6){%><option value="6">注册页面模板</option><%}%>
							</select>
						</div>
						<div class="row">
							<label class="left-fn-title">对应程序文件名：</label>
							<label class="wd-230">
								<input class="form-control" placeholder="" type="text" name="TargetName" size="32" value="<%=ct.getTargetName()%>">
							</label>
						</div>
						<div class="row">
							<label class="left-fn-title">文件编码：</label>
							<select class="form-control wd-230 ht-40 select2" name="Charset">
								<option value="">系统默认编码</option>
								<option value="gb2312">简体中文(GB2312)</option>
								<option value="utf-8">Unicode(UTF-8)</option>
							</select>
						</div>

						<%if(ct.getTemplateType()==2){%>
						<div class="row">
							<label class="left-fn-title">子目录命名规则：</label>
							<select class="form-control wd-230 ht-40 select2" name="SubFolderType" onChange="changeFolderType();">
								<option value="0">系统默认</option>
								<option value="1">按年份命名，每年一个目录</option>
								<option value="2">按年月命名，每月一个目录</option>
								<option value="3">按年月日命名，每日一个目录</option>
								<option value="4">按每天一个目录(如/2018-08-08/)</option>
								<option value="6">按每天一个目录(如/20180808/)</option>
								<option value="5">按文档指定目录</option>
							</select>
							<label class="wd-230" id="FolderTypeDesc">没有子目录</label>
						</div>
						<div class="row">
							<label class="left-fn-title">文件名规则：</label>
							<select class="form-control wd-230 ht-40 select2" name="FileNameType" onChange="changeFileNameType();">
								<option value="0">系统默认</option>
								<option value="1">以标题做文件名</option>
								<option value="2">时间戳加随机数</option>
								<option value="3">按文档指定文件名</option>
								<option value="4">定制规则</option>
							</select>
						</div>
						<div class="row" id="filename-type" style="display: none">
							<label class="left-fn-title"> </label>
							<label class="wd-230">
								<input class="form-control" placeholder="" type="text"  id="FileNameField" name="FileNameField"  value="<%=ct.getFileNameField()%>">
							</label>
						</div>
						<div class="row">
							<label class="left-fn-title">条件：</label>
							<label class="wd-230">
								<input class="form-control" placeholder="" type="text" name="WhereSql" value="<%=Util.HTMLEncode(ct.getWhereSql())%>">
							</label>
						</div>
						<%}%>

						<%if(ct.getTemplateType()==3){%>
						<div class="row">
							<label class="left-fn-title">指定行数：</label>
							<label class=""><input class="form-control wd-60" placeholder="" type="text" name="Rows" size="10" value="<%=ct.getRows()%>"></label>
							<label class="mg-l-10">对列表模板有效</label>
						</div>
						<div class="row">
							<label class="left-fn-title">限制标题：</label>
							<label class=""><input class="form-control wd-60" placeholder="" type="text" name="TitleWord" size="6" value="<%=ct.getTitleWord()>0?ct.getTitleWord():""%>"></label>
							<label class="mg-l-10">字</label>
						</div>
						<div class="row">
							<label class="left-fn-title">链接：</label>
							<label class="wd-230">
								<input class="form-control" placeholder="" type="text" name="Href" size="32" value="<%=ct.getHref()%>">
							</label>
						</div>
						<%}%>

						<%if(ct.getTemplateType()==1){%>
						<div class="row">
							<label class="left-fn-title">条件：</label>
							<label class="wd-230">
								<input class="form-control" placeholder="" type="text" name="WhereSql" value="<%=ct.getWhereSql()%>">
							</label>
						</div>
						<div class="row">
							<label class="left-fn-title">包含子频道：</label>
							<label class="ckbox wd-30-force">
								<input class="textfield" placeholder="" type="checkbox"  name="IncludeChildChannel" value="1" <%=ct.getIncludeChildChannel()==1?"checked":""%>><span></span>
							</label>
						</div>
						<div class="row">
							<label class="left-fn-title">每页纪录数：</label>
							<label class="wd-230">
								<input class="form-control" placeholder="" type="text" name="rowsPerPage" size="10" value="<%=ct.getRowsPerPage()%>">
							</label>
						</div>
						<div class="row">
							<label class="left-fn-title">文件生成频率：</label>
							<label class="wd-230">
								<input class="form-control" placeholder="" type="text" name="PublishInterval" size="5" value="<%=ct.getPublishInterval()%>">
							</label>
							<span class="mg-l-10">分钟</span>
						</div>
						<%}%>

						<%if(ct.getTemplateType()==1 || ct.getTemplateType()==2){%>
    						<div class="row">
    							<label class="left-fn-title">继承上级模板：</label>
    							<label class="ckbox wd-30-force">
    								<input class="textfield" placeholder="" type="checkbox" value="1" name="IsInherit" onClick="inherit(this);" <%=ct.getIsInherit()==1?"checked":""%>><span></span>
    							</label>
    						</div>
    						<%if(ct.getTemplateType()==2){%>
    						    <div class="row">
    								<label class="left-fn-title">允许预览：</label>
    								<label class="ckbox">
    								<input class="textfield" placeholder="" type="checkbox" name="allowPreview" value="1" <%=ct.getAllowPreview()==1?"checked":""%>><span></span>
    								</label>
							    </div>
    						<%}%>
						<%}%>
					</li>
				</ul>
			</div>
		</div>
		<!--modal-body-->

		<div class="btn-box">
			<div class="modal-footer">
				<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
				<input type="hidden" name="id" value="<%=id%>">
				<input type="hidden" name="Submit" value="Submit">
				<button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
				<button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消</button>
				<input type="hidden" name="Submit" value="Submit">
			</div>
		</div>
		<div id="ajax_script" style="display:none;"></div>
	</form>
</div>
<!-- modal-box -->
</body>
                
                
<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>

<script language=javascript>
	//自定义js
	function init() {
		document.form.Template.focus();
	}

	function check() {
		<%if(ct.getTemplateType()==1 || ct.getTemplateType()==2){%>
		if (document.form.IsInherit.checked)
			return true;
		<%}%>
		<%if(ct.getTemplateID()>0){%>
		if (isEmpty(document.form.Template, "请输入模板."))
			return false;
		<%}%>
		if (isEmpty(document.form.TemplateType, "请选择模板类型."))
			return false;
		<%if(ct.getTemplateID()>0){%>
		if (isEmpty(document.form.TargetName, "请输入对应程序文件名称."))
			return false;
		<%}%>
		//document.form.Button2.disabled  = true;

		return true;
	}

	function isEmpty(field, msg) {
		if (field.value == "") {
			alert(msg);
			field.focus();
			return true;
		}
		return false;
	}

	function selectTemplate() {
		var dialog = new top.TideDialog();
		dialog.setWidth(1000);
		dialog.setHeight(620);
		dialog.setSuffix('_2');
		dialog.setUrl("../channel/selecttemplate2018.jsp");
		dialog.setTitle("选择模板");
		//dialog.setScroll('auto');
		dialog.show();
	}

	function setReturnValue(o) {
		if (o.TemplateID != null) {
			document.form.TemplateID.value = o.TemplateID;
			var scr = document.createElement('script')
			scr.src = '../channel/template_add_js.jsp?id=' + o.TemplateID;
			document.getElementById('ajax_script').appendChild(scr);
		}
	}

	function change() {
		if (document.form.TemplateType.value == "1") {
			tr01.style.display = "";
		} else
			tr01.style.display = "none";
	}

	function changeFolderType() {
		if (document.form.SubFolderType == null)
			return;

		var t = "";
		if (document.form.SubFolderType.value == "0") {
			t = "没有子目录";
		} else if (document.form.SubFolderType.value == "1") {
			t = "如：/2018/";
		} else if (document.form.SubFolderType.value == "2") {
			t = "如：/2018/08/";
		} else if (document.form.SubFolderType.value == "3") {
			t = "如：/2018/08/08/";
		} else if (document.form.SubFolderType.value == "4") {
			t = "如：/2018-08-08/";
		} else if (document.form.SubFolderType.value == "5") {
			t = "目录由文档中的Path字段指定.";
		} else if (document.form.SubFolderType.value == "6") {
			t = "如：/20180808/";
		}

		$("#FolderTypeDesc").html(t);
	}

	function changeFileNameType() {
		if (document.form.FileNameType == null)
			return;

		var t = "";
		if (document.form.FileNameType.value == "3") {
			$("#filename-type").show();
		} else
			$("#filename-type").hide();
	}

	function inherit(obj) { //alert(obj.checked);
		if (obj.checked) {
			document.form.Template.disabled = true;
			document.form.TargetName.disabled = true;
		} else {
			document.form.Template.disabled = false;
			document.form.TargetName.disabled = false;
		}
	}

	function ViewTemplate() {
		TemplateID = document.form.TemplateID.value;

		if (TemplateID == "") return;

		var foldername = "";
		var filename = "";
		var width = Math.floor(screen.width * .8);
		var height = Math.floor(screen.height * .8);
		var leftm = Math.floor(screen.width * .1) + 30;
		var topm = Math.floor(screen.height * .05) + 30;
		var Feature = "toolbar=0,location=0,maximize=1,directories=0,status=1,menubar=0,scrollbars=0, resizable=1,left=" + leftm + ",top=" + topm + ", width=" + width + ", height=" + height;

		var url = "../template/template_edit2018.jsp?TemplateID=" + TemplateID;
		window.open(url, "", Feature);
	}
</script>

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
