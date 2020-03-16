<%@ page import="tidemedia.cms.system.*,
				java.util.*"%>
    <%@ page contentType="text/html;charset=utf-8" %>
        <%@ include file="../config.jsp"%>
            <%
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
    CmsCache.delChannel(ChannelID);
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
                        <form name="form" action="template_add2018.jsp" method="post" onSubmit="return check();">

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
				<input class="form-control" placeholder="" type="text" name="Template">
			  </label>
                                                <input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="..." onclick="selectTemplate();">
                                                <input class="btn btn-primary tx-size-xs mg-l-10" href="javascript:;" name="" type="button" value="查看" onclick="ViewTemplate();">
                                                <input type="hidden" name="TemplateID" value="">
                                            </div>
                                            <div class="row">
                                                <label class="left-fn-title">标识：</label>
                                                <label class="wd-230">
				<input class="form-control" placeholder="" type="text" name="Label">
			  </label>
                                            </div>
                                            <div class="row">
                                                <label class="left-fn-title">模板类型：</label>
                                                <label class="wd-230">
				<select class="form-control wd-230 ht-40 select2" name="TemplateType" onChange="change();">
					<%if(TemplateType==1){%><option value="1">索引页面模板</option><%}%>
					<%if(TemplateType==2){%><option value="2">内容页面模板</option><%}%>
					<%if(TemplateType==3){%><option value="1">索引页面模板</option><option value="2">内容页面模板</option><option value="3" selected>附加页面模板</option><%}%>
					<%if(TemplateType==5){%><option value="5">应用页面模板</option><%}%>
					<%if(TemplateType==6){%><option value="6">注册页面模板</option><%}%>
				</select>
			  </label>
                                            </div>
                                            <div class="row">
                                                <label class="left-fn-title">对应程序文件名：</label>
                                                <label class="wd-230">
				<input class="form-control" placeholder="" type="text" name="TargetName">
			  </label>
                                            </div>
                                            <div class="row">
                                                <label class="left-fn-title">文件编码：</label>
                                                <label class="wd-230">
				<select class="form-control wd-230 ht-40 select2" name="Charset">
					<option value="">系统默认编码</option>
					<option value="gb2312">简体中文(GB2312)</option>
					<option value="utf-8">Unicode(UTF-8)</option>
				</select>
			  </label>
                                            </div>

                                            <%if(TemplateType==2){%>
                                                <div id="tr02">
                                                    <div class="row">
                                                        <label class="left-fn-title">子目录命名规则：</label>
                                                        <label class="wd-230">
				<select class="form-control wd-230 ht-40 select2" name="SubFolderType" onChange="changeFolderType();">
					<option value="0">系统默认</option>
					<option value="1">按年份命名，每年一个目录</option>
					<option value="2">按年月命名，每月一个目录</option>
					<option value="3">按年月日命名，每日一个目录</option>
					<option value="4">按每天一个目录(如/2018-08-08/)</option>
					<option value="6">按每天一个目录(如/20180808/)</option>
					<option value="5">按文档指定目录</option>
				</select>
			  </label>
                                                        <label class="mg-l-10" id="FolderTypeDesc">没有子目录</label>
                                                    </div>
                                                    <div class="row">
                                                        <label class="left-fn-title">文件名规则：</label>
                                                        <label class="wd-230">
				<select class="form-control wd-230 ht-40 select2" name="FileNameType">
					<option value="0">系统默认</option>
					<option value="1">以标题做文件名</option>
					<option value="2">时间戳加随机数</option>
					<option value="3">按文档指定文件名</option>
					<option value="4">定制规则</option>
				</select>
			  </label>
                                                    </div>
                                                </div>
                                                <%}%>

                                                    <%if(TemplateType==3){
%>
                                                        <div id="tr01" style="display:none; ">
                                                            <div class="row">
                                                                <label class="left-fn-title">包含子频道：</label>
                                                                <label class="ckbox">
				<input class="textfield" placeholder="" type="checkbox" name="IncludeChildChannel" value="1"><span></span>
			  </label>
                                                            </div>
                                                            <div class="row">
                                                                <label class="left-fn-title">每页纪录数：</label>
                                                                <label class="wd-230">
				<input class="form-control" placeholder="" type="text" name="rowsPerPage">
			  </label>
                                                            </div>
                                                        </div>
                                                        <div id="tr02" style="display:none; ">
                                                            <div class="row">
                                                                <label class="left-fn-title">子目录命名规则：</label>
                                                                <label class="wd-230">
				<select class="form-control wd-230 ht-40 select2" name="SubFolderType" onChange="changeFolderType();">
					<option value="0">系统默认</option>
					<option value="1">按年份命名，每年一个目录</option>
					<option value="2">按年月命名，每月一个目录</option>
					<option value="3">按年月日命名，每日一个目录</option>
					<option value="4">按每天一个目录(如/2018-08-08/)</option>
					<option value="6">按每天一个目录(如/20180808/)</option>
					<option value="5">按文档指定目录</option>
				</select>
			  </label>
                                                                <label class="wd-230" id="FolderTypeDesc">没有子目录</label>
                                                            </div>
                                                            <div class="row">
                                                                <label class="left-fn-title">文件名规则：</label>
                                                                <label class="wd-230">
				<select class="form-control wd-230 ht-40 select2" name="FileNameType">
					<option value="0">系统默认</option>
					<option value="1">以标题做文件名</option>
					<option value="2">时间戳加随机数</option>
					<option value="3">按文档指定文件名</option>
					<option value="4">定制规则</option>
				</select>
			  </label>
                                                            </div>
                                                            <div class="row">
                                                                <label class="left-fn-title">条件：</label>
                                                                <label class="wd-230">
				<input class="form-control" placeholder="" type="text" name="WhereSql">
			  </label>
                                                            </div>
                                                        </div>
                                                        <div id="tr03">
                                                            <div class="row">
                                                                <label class="left-fn-title">指定行数：</label>
                                                                <label class="wd-230">
				<input class="form-control" placeholder="" type="text" name="Rows" value="8">
			  </label>
                                                                <label class="mg-l-10">对列表模板有效</label>
                                                            </div>
                                                            <div class="row">
                                                                <label class="left-fn-title">限制标题：</label>
                                                                <label class="mg-r-5">最多</label>
                                                                <label class="wd-100">
				<input class="form-control" placeholder="" type="text" name="TitleWord">
			  </label>
                                                                <label class="mg-l-5">字 对列表模板有效</label>
                                                            </div>
                                                            <div class="row">
                                                                <label class="left-fn-title">链接：</label>
                                                                <label class="wd-230">
				<input class="form-control" placeholder="" type="text" name="Href">
			  </label>
                                                            </div>
                                                        </div>
                                                        <%}%>
                                                            <%if(TemplateType==1){%>
                                                                <div class="row">
                                                                    <label class="left-fn-title">条件：</label>
                                                                    <label class="wd-230">
				<input class="form-control" placeholder="" type="text" name="WhereSql">
			  </label>
                                                                </div>
                                                                <div class="row">
                                                                    <label class="left-fn-title">包含子频道：</label>
                                                                    <label class="ckbox">
				<input type="checkbox" name="IncludeChildChannel" value="1" class="textfield"><span></span>
			  </label>
                                                                </div>
                                                                <div class="row">
                                                                    <label class="left-fn-title">每页纪录数：</label>
                                                                    <label class="wd-230">
				<input class="form-control" placeholder="" type="text" name="rowsPerPage" value="20">
			  </label>
                                                                </div>
                                                                <%}%>
                                                                    <%if(TemplateType==6){%>
                                                                        <%}%>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <!--modal-body-->

                            <div class="btn-box" style="position: absolute;bottom: 0;width: 100%;">
                                <div class="modal-footer">
                                    <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
                                    <button name="startButton" type="submit" class="btn btn-primary tx-size-xs" id="startButton">确认</button>
                                    <button name="btnCancel1" type="button" onclick="top.TideDialogClose();" class="btn btn-secondary tx-size-xs" data-dismiss="modal" id="btnCancel1">取消
		</button>
                                    <input type="hidden" name="Submit" value="Submit">
                                </div>
                            </div>
                            <div id="ajax_script" style="display:none;"></div>
                        </form>
                    </div>
                    <!-- modal-box -->
                </body>

                <script src="../common/2018/common2018.js"></script>
                <script src="../lib/2018/jquery/jquery.js"></script>
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
                    function init() {
                        document.form.Template.focus();
                    }

                    function check() {
                        if (isEmpty(document.form.Template, "请输入模板."))
                            return false;
                        if (isEmpty(document.form.TemplateType, "请选择模板类型."))
                            return false;
                        if (isEmpty(document.form.TargetName, "请输入对应程序文件名称."))
                            return false;

                        return true;
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
                        $("#tr01").hide();
                        $("#tr02").hide();
                        $("#tr03").hide();

                        var type = document.form.TemplateType.value; //alert(type);
                        if (type == "1") {
                            $("#tr01").show(); //tr01.style.display = "";
                        } else if (type == "2") {
                            $("#tr02").show(); //tr02.style.display = "";
                        } else if (type == "3") {
                            $("#tr03").show(); //tr03.style.display = "";
                        }

                    }

                    function changeFolderType() {
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

                </html>