<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 tidemedia.cms.user.*,
                 java.util.*,
                 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    //2019/07/12 by chensiding  注释二维码
%>
<%
    String CalculateType = getParameter(request, "CalculateType");
    if (CalculateType != "") {
        System.out.println("calcu=" + CalculateType);
    }

    String uri = request.getRequestURI();
    long begin_time = System.currentTimeMillis();
    int ChannelID = getIntParameter(request, "ChannelID");
    int ItemID = getIntParameter(request, "ItemID");
    int RecommendItemID = getIntParameter(request, "RecommendItemID");
    int RecommendChannelID = getIntParameter(request, "RecommendChannelID");
    String RecommendTarget = getParameter(request, "RecommendTarget");
    int RecommendOutItemID = getIntParameter(request, "ROutItemID");
    int RecommendOutChannelID = getIntParameter(request, "ROutChannelID");
    /*云资源采用*/
    int CloudItemID = getIntParameter(request, "CloudItemID");
    int CloudChannelID = getIntParameter(request, "CloudChannelID");
    String ROutTarget = getParameter(request, "ROutTarget");
    int parentGlobalID = getIntParameter(request, "pid");

    int ContinueNewDocument = getIntParameter(request, "ContinueNewDocument");
    int NoCloseWindow = getIntParameter(request, "NoCloseWindow");
    String From = getParameter(request, "From");
    int IsDialog = getIntParameter(request, "IsDialog");//如果是弹出窗口，值设为1
    int Parent = getIntParameter(request, "Parent");//如果设置了Parent,就设置Parent字段的值

    String transfer_article = getParameter(request, "transfer_article");//一键转载url

    int GlobalID = 0;
    String QRcode = "";
    String title = "";
    ChannelPrivilege cp = new ChannelPrivilege();
    if (!cp.hasRight(userinfo_session, ChannelID, 2)) {
        response.sendRedirect("../close_pop.jsp");
        return;
    }


    Document item = null;
    Channel channel = CmsCache.getChannel(ChannelID);
    if (channel.getDocumentProgram().length() > 0 && uri.endsWith("/content/document.jsp"))
        response.sendRedirect(channel.getDocumentProgram() + "?ChannelID=" + ChannelID + "&ItemID=" + ItemID + "&ROutTarget=" + ROutTarget + "&ROutChannelID=" + RecommendOutChannelID + "&ROutItemID=" + RecommendOutItemID + "&RecommendItemID=" + RecommendItemID + "&RecommendChannelID=" + RecommendChannelID + "&RecommendTarget=" + RecommendTarget + "&CloudItemID=" + CloudItemID + "&CloudChannelID=" + CloudChannelID);

    if (channel.isVideoChannel()) {
        response.sendRedirect("../video/document.jsp?ItemID=" + ItemID + "&ChannelID=" + ChannelID);
        return;
    }

    if (ItemID > 0) {
        item = CmsCache.getDocument(ItemID, ChannelID);

        //解决同步问题，2012.09.19
        if (item.getChannel().getId() != ChannelID) {
            ChannelID = item.getChannel().getId();
            item = CmsCache.getDocument(ItemID, ChannelID);
            channel = CmsCache.getChannel(ChannelID);
        }
    }

    if (item != null) {
        GlobalID = item.getGlobalID();
        QRcode = "";
        title = item.getTitle();
    }
    String calculateType = "";
    String usersByJixiaoId = "";
    if (item != null) {
        calculateType = item.getValue("CalculateType");
        int id = item.getId();
        usersByJixiaoId = new JiXiaoUtil().getUsersByJixiaoId(id);
    }


    ArrayList fieldGroupArray = channel.getFieldGroupInfo();
    String SiteAddress = channel.getSite().getUrl();

    String check2 = "";

    boolean editCategory = false;

    if (channel.isTableChannel() && channel.getType2() == 8) editCategory = true;

    String userGroup = "";

    try {
        userGroup = new UserGroup(userinfo_session.getGroup()).getName();
    } catch (Exception e) {
    }

    TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
    String inner_url = "", outer_url = "";
    if (photo_config != null) {
        int sys_channelid_image = photo_config.getInt("channelid");
        Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
        inner_url = img_site.getUrl();
        outer_url = img_site.getExternalUrl();
    }

    int ApproveScheme = channel.getApproveScheme();//是否配置了审核方案
    int Version = channel.getVersion();//是否开启了版本功能


    ApproveAction approve = new ApproveAction(GlobalID, 0);//最近一次审核操作
    int id_aa = approve.getId();//审核操作id
    int approveId = approve.getApproveId();//审核环节id
    int action = approve.getAction();//是否通过
    int end = approve.getEndApprove();//是否终审

    int data_approve = 0;//是否显示右侧审核栏
    int data_yl = 0;//是否为审核预览

    if (id_aa != 0) {//说明已提交审核
        data_approve = 1;//是否显示右侧审核栏
        data_yl = 0;//是否为审核预览
    }

    boolean isChannelRecommend = false; //显示一稿多发内容的开关,默认关闭
    ChannelRecommend cr = new ChannelRecommend();
    List<ChannelRecommend> crlist = cr.getChannelRecommendListByChannelId(ChannelID, 1);//获取推荐列表  1为推荐
    if (crlist.size() > 0) {
        isChannelRecommend = true;
    }
    TideJson json = CmsCache.getParameter("jixiao_view_userid").getJson();
    String userids = json.getString("user_id");
    String[] uids = userids.split(",");
    String userList = "";
    for (int i = 0; i < uids.length; i++) {
        int uid = Integer.parseInt(uids[i]);
        UserInfo userInfo = new UserInfo(uid);
        String name = userInfo.getName();
        userList += name + ",";
    }
    userList = userList.substring(0, userList.length() - 1);
    //System.out.println(item.getValue("Title"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico"/>
    <title><%=item != null ? "编辑文档 " + item.getTitle() : "新建文档"%> <%=channel.getParentChannelPath()%> TideCMS</title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/summernote/summernote-bs4.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">

    <link rel="stylesheet" href="../style/2018/common.css">
    <link rel="stylesheet" type="text/css" href="../style/jquery.tagit.css"/>
    <link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css"/>
    <link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui-timepicker-addon.css"/>
    <link rel="stylesheet" href="../style/2018/bracket.css">

    <style>
        .collapsed-menu .br-mainpanel-file {
            margin-left: 60px;
            margin-bottom: 30px;
        }

        #nav-header {
            line-height: 60px;
            margin-left: 20px;
            color: #a4aab0;
            font-style: normal;
        }

        #nav-header a {
            color: #a4aab0;
        }

        .table-bordered {
            border: 1px solid #dee2e6;
            text-align: center;
        }

        #tabTable td {
            padding: 0.3rem !important;
            cursor: pointer;
        }

        .selTab {
            border: 1px solid #17A2B8 !important;
            background-color: #17A2B8;
            color: #fff;
        }

        .edui-default .edui-editor-breadcrumb {
            line-height: 30px;
        }

        .btn-box a {
            color: #fff
        }

        .ui-widget-content {
            border: 1px solid rgba(0, 0, 0, 0.15);
        }

        .bs-tooltip-bottom .tooltip-inner {
            padding: 8px 15px;
            font-size: 13px;
            border-radius: 3px;
            color: #ffffff;
            background-color: #f8f9fa;
            opacity: 1;
        }

        .tooltip.bs-tooltip-bottom .arrow::before,
        .tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {
            border-bottom-color: #f8f9fa;
        }

        /*.edui-editor {z-index: 0 !important;}*/
        /*tooltip相关样式*/
        .bs-tooltip-right .tooltip-inner {
            padding: 8px 15px;
            font-size: 13px;
            border-radius: 3px;
            color: #ffffff;
            background-color: #00b297;
            opacity: 1;
        }

        .tooltip.bs-tooltip-right .arrow::before,
        .tooltip.bs-tooltip-auto[x-placement^="right"] .arrow::before {
            border-right-color: #00b297;
        }
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../common/2018/common2018.js"></script>
    <script src="../common/document.js"></script>
    <script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
    <script src="../common/tag-it.js"></script>
    <!--百度编辑器-->
    <script type="text/JavaScript" charset="utf-8" src="../ueditor/ueditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="../ueditor/ueditor.all.js"></script>
    <script type="text/javascript" charset="utf-8" src="../ueditor/lang/zh-cn/zh-cn.js"></script>
    <!--<script type="text/javascript" charset="utf-8" src="../ueditor/toupiaoDialog.js"></script>-->
    <script type="text/javascript" charset="utf-8" src="../ueditor/photosDialog.js"></script>
    <script type="text/javascript" charset="utf-8" src="../ueditor/imgeditorDialog.js"></script>
    <script type="text/javascript" charset="utf-8" src="../ueditor/imagesDialog.js"></script>
    <script>

        $(function () {
            $.ajax({
                url: 'get_perm_people.jsp',
                type: 'get',
                success: function (data) {
                    $("#jixiao_permission").val(data);
                }
            })
            var calculateType = '<%=calculateType%>';
            var calculateTypes = calculateType.split(",");
            var i = 0;
            $(".ckbox.mg-r-15 input").each(function () {
                if (typeof (calculateTypes[i]) != "undefined") {

                    var calculateTypeInt = calculateTypes[i];
                    console.log(calculateTypeInt);
                    $(this).attr("doc-data", calculateTypeInt);
                } else {
                    $(this).attr("doc-data", '');
                }
                i++;
            })

            $("#Caption_enable").hide();
            $("#tr_jixiao_permission").hide();
            $("#Caption_jixiao_permission").hide();

            $("#Caption_AssessCycle .d-flex").removeClass("align-items-center");
            var docData = $("#CalculateType").attr("value");
            var calculateTypes = docData.split(",");
            updateHint(calculateTypes);

            $('input:checkbox[name="AssessIndicator"]').click(function () {
                var array = $("#CalculateType").val().split(',');
                if ($(this).prop("checked") == false) {
                    var a = $(this).val() - 1;
                    array[a] = "0";
                    $("#CalculateType").attr("value", array.toString());
                }
                updateHint(array);
            });

        })

        var webName = "${pageContext.request.contextPath}";

        var Pages = 1;
        var curPage = 1;
        var Contents = new Array();
        Contents[Contents.length] = "";
        var userId = <%=userinfo_session.getId()%>;
        var userName = "<%=userinfo_session.getName()%>";
        var userGroupName = "<%=userGroup%>";
        var userGroupId = <%=userinfo_session.getGroup()%>;
        var channelid = <%=ChannelID%>;
        var groupnum = <%=QRcode.equals("")?fieldGroupArray.size():fieldGroupArray.size()+1%>;
        var begin_time =<%=begin_time/1000%>;
        var SiteAddress = "<%=SiteAddress%>";
        var GlobalID = <%=GlobalID%>;
        var inner_url = "<%=inner_url%>";
        var outer_url = "<%=outer_url%>";
        var is_auto_save = false;//自动保存
        var timer = null;//定时器
        var ChannelID = "<%=ChannelID%>";


        var NoCloseWindow = <%=NoCloseWindow%>;//是否关闭页面
        var unload = true;//关闭页面是否提示
        window.onresize = function () {
            if (document.getElementsByClassName("content-edit-frame")[0]) {
                if (navigator.userAgent.indexOf("MSIE") > 0 || navigator.userAgent.indexOf("rv:11") > 0 || navigator.userAgent.indexOf("Firefox") > 0) {
                    var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.body.scrollHeight;
                } else {
                    var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.documentElement.scrollHeight;
                }
                document.getElementsByClassName("content-edit-frame")[0].style.height = _height
            }
        }
        //更新计算方式的提示内容
        function updateHint(calculateTypes) {
            var html = '<label class="left-fn-title wd-150"> </label><label class="d-flex align-items-center tx-gray-800 tx-12"><i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>';
            var a = 0;
            if (calculateTypes[0] != 0) {
                html += '网站发稿量(' + calculateTypes[0] + '=1)';
                a++;
            }
            if (calculateTypes[1] != 0) {
                if(a==0){
                    html += '网站稿件PV(' + calculateTypes[1] + '=1)';
                }else{
                    html += '+网站稿件PV(' + calculateTypes[1] + '=1)';
                }
                a++;
            }
            if (calculateTypes[2] != 0) {
                if(a==0){
                    html += '客户端发稿量(' + calculateTypes[2] + '=1)';
                }else{
                    html += '+客户端发稿量(' + calculateTypes[2] + '=1)';
                }
                a++;
            }
            if (calculateTypes[3] != 0) {
                if(a==0){
                    html += '客户端稿件PV(' + calculateTypes[3] + '=1)';
                }else{
                    html += '+客户端稿件PV(' + calculateTypes[3] + '=1)';
                }
                a++;
            }
            if (calculateTypes[4] != 0) {
                if(a==0){
                    html += '微信发稿量(' + calculateTypes[4] + '=1)';
                }else{
                    html += '+微信发稿量(' + calculateTypes[4] + '=1)';
                }
                a++;
            }
            if (calculateTypes[5] != 0) {
                if(a==0){
                    html += '微信稿件PV(' + calculateTypes[5] + '=1)';
                }else{
                    html += '+微信稿件PV(' + calculateTypes[5] + '=1)';
                }
                a++;
            }
            if (calculateTypes[6] != 0) {
                if(a==0){
                    html += '选题采用量(' + calculateTypes[6] + '=1)';
                }else{
                    html += '+选题采用量(' + calculateTypes[6] + '=1)';
                }
                a++;
            }
            if (calculateTypes[7] != 0) {
                if(a==0){
                    html += '视频上传量(' + calculateTypes[7] + '=1)';
                }else{
                    html += '+视频上传量(' + calculateTypes[7] + '=1)';
                }
                a++;
            }

            if(a!=0){
                html+=' = 总分值';
            }
            html += '</label>';
            $("#Caption_CalculateType").html('');
            $("#Caption_CalculateType").append(html);
        }
        
        //调整iframe的高度
        function changeFrameHeight(_this) {
            if (navigator.userAgent.indexOf("MSIE") > 0 || navigator.userAgent.indexOf("rv:11") > 0 || navigator.userAgent.indexOf("Firefox") > 0) {
                _this.style.height = _this.contentWindow.document.body.scrollHeight + 5;
            } else {
                _this.style.height = _this.contentWindow.document.documentElement.scrollHeight + 5;
            }
        }

        function save_() {
            var users = $("#approve").attr("user");
            var user = <%=userinfo_session.getId()%>+"";
            var arr = new Array();
            arr = users.split(',');

            var result = $.inArray(user, arr);
            if (result == -1) {
                tips("当前用户没有权限");
            } else {
                Save();
            }
        }

        //提示信息
        function tips(obj) {
            var dialog = new top.TideDialog();
            dialog.setWidth(320);
            dialog.setHeight(280);
            dialog.setTitle("提示");
            dialog.setMsg(obj);
            dialog.ShowMsg();
        }


        //选择用户
        function showUser() {
            var users = $("#users_id").val();
            var dialog = new top.TideDialog();
            dialog.setWidth(800);
            dialog.setHeight(500);
            dialog.setUrl("../jixiao/user_index.jsp?users="+users);
            dialog.setTitle("选择用户");
            dialog.show();
        }

        //设置计算方式
        function calc() {
            var arrayObj = new Array();
            var arrayObj1 = new Array();
            $('input:checkbox[name="AssessIndicator"]:checked').each(function () {
                var id = $(this).val() - 1;
                var AssessIndicator = $("#AssessIndicator_" + id).next().html();
                arrayObj.push(AssessIndicator);
            });
            var docData = $("#CalculateType").attr("value");
            var dialog = new top.TideDialog();
            dialog.setWidth(600);
            dialog.setHeight(500);
            dialog.setUrl("../jixiao/calc.jsp?AssessIndicator=" + arrayObj + "&docData=" + docData);
            dialog.setTitle("选择用户");
            dialog.show();
        }


    </script>

    <script>


        $(function () {
            var html = '<input type="hidden" id="users_id" name="users_id">';
            $("#participant").append(html);
            $("#users_id").val('<%=usersByJixiaoId%>');
        })

        function Save_approve() {
            document.form.Approve.value = 1;
            Save();
        }



        function Save() {

            var CalculateType = $("#CalculateType").val();
            if (CalculateType == "0,0,0,0,0,0,0,0") {
                TideAlert("提示","计算方式不能为空!");
                return;
            }else{
                var CalculateTypes = CalculateType.split(",");
                var i = 0;
                var b = false;
                $("input[name='AssessIndicator']").each(function() {
                    if($(this).is(":checked")){
                        if(CalculateTypes[i]=="0"){
                            b = true;
                            var assessIndicatorName = $(this).next().html();
                            TideAlert("提示","请设置"+assessIndicatorName+"的分值!");
                        }
                    }
                    i++;
                });
                if(b){
                    return;
                }
            }

            if (check()) {
                //有内容拦的情况下，保存前先处理内容栏
                if (document.getElementById("tabTableRow"))
                    Save_Content();
                document.getElementById("Image1Href").href = "javascript:void(0);";
                <%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
                document.getElementById("Image2Href").href = "javascript:void(0);";
                <%}%>

                if (is_auto_save) {
                    document.getElementById("Image1Href").href = "javascript:void(0);";
                    <%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
                    document.getElementById("Image2Href").href = "javascript:void(0);";
                    <%}%>
                }


                var _form_data = $("#form").serialize();
                if (form_data == _form_data && is_auto_save)// 自动保存 数据没有变化时不进行数据提交
                {
                    // $("#display_auto_save").removeClass("auto_save_hide").addClass("auto_save").text("数据没有变化"+getNowFormatDate());
                    return;
                }
                //如果有数据变化 把新的表单值赋值给form_data
                form_data = _form_data;
                //编辑互斥
                isSaved();
                $("#display_auto_save").removeClass("auto_save_hide").addClass("auto_save").text("正在保存" + getNowFormatDate());

                if (<%=isChannelRecommend%>) {  //一稿多发
                    var framsId = $("iframe[name='oneDocManySend']").attr('id');
                    var RecommendChannelIDs = $('#' + framsId)[0].contentWindow.getAllCheck();//选中要一稿多发的channelIdList(a,b,c)
                    document.form.RecommendChannelIDs.value = RecommendChannelIDs;
                    var WeixinIds = $('#' + framsId)[0].contentWindow.getWxCheck();// 选中的微信公众号id
                    document.form.WeixinIds.value = WeixinIds;
                }
                $.ajax({
                    type: "POST",
                    url: "jixiao_document_submit.jsp",//../content/document_submit.jsp
                    data: $('#form').serialize(),
                    dataType: 'json',
                    success: function (result) {
                        if (!is_auto_save) {//非自动保存
                            if (result.message == "") {
                                unload = false;
                                <%if(IsDialog==0){%>
                                if (window.opener != null) {
                                    window.opener.document.location.reload();
                                }
                                window.close();
                                <%}%>

                                <%if(IsDialog==1){%>
                                top.TideDialogClose({refresh: 'right'});
                                <%}%>
                            } else {
                                if (result.message == "auto save") {
                                } else {
                                    ddalert(result.message, "(function dd(){getDialog().Close({suffix:'html'});})()");
                                    //alert(result.message);
                                }
                                document.getElementById("Image1Href").href = "javascript:Save();";
                                <%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
                                document.getElementById("Image2Href").href = "javascript:Save_Publish();";
                                <%}%>
                            }
                        } else {
                            //自动保存刷新页面
                            //window.location.href="document.jsp?NoCloseWindow=1&ItemID=" + result.id+ "&ChannelID="+result.channelid
                            document.form.NoCloseWindow.value = '1';
                            document.form.Action.value = 'Update';
                            document.form.ItemID.value = result.id;

                            document.getElementById("Image1Href").href = "javascript:Save();";
                            <%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
                            document.getElementById("Image2Href").href = "javascript:Save_Publish();";
                            <%}%>


                        }
                        $("#display_auto_save").addClass("auto_save").text("保存完成" + getNowFormatDate());
                        // $("#display_auto_save").removeClass("auto_save").addClass("auto_save_hide");
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        alert("保存没有成功，请重新尝试。");
                        document.getElementById("Image1Href").href = "javascript:Save();";
                        <%if(cp.hasRight(userinfo_session,ChannelID,3)){%>
                        document.getElementById("Image2Href").href = "javascript:Save_Publish();";
                        <%}%>
                    }
                });
            }
        }


        function init() {

            $('#SetPublishDate').datetimepicker({
                timeText: '时间',
                hourText: '小时',
                minuteText: '分钟',
                secondText: '秒',
                currentText: '现在',
                closeText: '完成',
                showSecond: true, //显示秒
                dateFormat: "yy-mm-dd",
                timeFormat: 'HH:mm:ss',//格式化时间
                monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
                dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
                dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
                dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']
            });
            $('#Revoketime').datetimepicker({
                timeText: '时间',
                hourText: '小时',
                minuteText: '分钟',
                secondText: '秒',
                currentText: '现在',
                closeText: '完成',
                showSecond: true, //显示秒
                dateFormat: "yy-mm-dd",
                timeFormat: 'HH:mm:ss',//格式化时间
                monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
                dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
                dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
                dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']
            });

            $(".date").datetimepicker({
                timeText: '时间',
                hourText: '小时',
                minuteText: '分钟',
                secondText: '秒',
                currentText: '现在',
                closeText: '完成',
                showSecond: true, //显示秒
                dateFormat: "yy-mm-dd",
                timeFormat: 'HH:mm:ss',//格式化时间
                monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
                dayNames: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
                dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
                dayNamesMin: ['日', '一', '二', '三', '四', '五', '六']
            });

            var sampleTags = [];
            $("#Keyword").tagit({availableTags: sampleTags});
            $("#Tag").tagit({availableTags: sampleTags});
            <%
                if(item!=null)
                {
                    out.println("document.form.Action.value = 'Update';");
                }
                else
                {
                    if(RecommendItemID>0 && RecommendChannelID>0)
                    {
                        out.println("recommendItemJS("+RecommendItemID+","+RecommendChannelID+","+ChannelID+",\""+RecommendTarget+"\");");
                    }

                    if(RecommendOutItemID>0&&RecommendOutChannelID>0)
                    {
                        out.println("recommendOutItemJS("+RecommendOutItemID+","+RecommendOutChannelID+","+ChannelID+",\""+ROutTarget+"\");");
                    }

                    if(CloudChannelID>0 && CloudItemID>0)
                    {
                        out.println("cloudItemJS("+CloudItemID+","+CloudChannelID+");");
                    }

                    if(transfer_article.length()>0)
                    {
                        out.println("transferArticleJS(\""+transfer_article+"\");");
                    }
                }
            %>
            checkTitle();
            document.body.disabled = false;
            auto_save();
        }

        //获取当前时间
        function getNowFormatDate() {
            var date = new Date();
            var seperator1 = "-";
            var seperator2 = ":";
            var year = date.getFullYear();
            var month = date.getMonth() + 1;
            var strDate = date.getDate();
            if (month >= 1 && month <= 9) {
                month = "0" + month;
            }
            if (strDate >= 0 && strDate <= 9) {
                strDate = "0" + strDate;
            }
            var currentdate = year + seperator1 + month + seperator1 + strDate
                + " " + date.getHours() + seperator2 + date.getMinutes()
                + seperator2 + date.getSeconds();
            return currentdate;
        }

        //自动保存
        function auto_save() {
            if ($("#auto_save").attr("checked"))//勾选了才自动保存
            {
                is_auto_save = true;
                document.form.NoCloseWindow.value = '1';
                timer = window.setInterval("Save()", "30000");
            }
            //自动保存
            $("#auto_save").change(
                function () {
                    if (this.checked) {//选中 自动保存
                        is_auto_save = true;
                        document.form.NoCloseWindow.value = '1';
                        timer = window.setInterval("Save()", "30000");
                    } else {//取消自动保存
                        is_auto_save = false;
                        document.form.NoCloseWindow.value = '0';
                        window.clearInterval(timer);
                    }
                }
            );

        }

        function initContent1() {
            <%if(item!=null){%>
            if (document.getElementById("tabTableRow"))
                try {
                    {<%//System.out.println(item.getContent());%>
                        <%if(item.getTotalPage()>1){for(int i=2;i<=item.getTotalPage();i++){item.setCurrentPage(i);%>
                        AddPageInit();//alert(content);
                        content = '<%=Util.JSQuote(item.getContent())%>';//alert(content);
                        <%if(!SiteAddress.equals("")){%>content = content.replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/');
                        <%}%>
                        //SetContent(<%=i%>,content);
                        var num = <%=i%>;
                        if (num <= Contents.length)
                            Contents[num - 1] = content;
                        else
                            Contents[Contents.length] = content;
                        <%}}%>
                    }
                } catch (er) {
                    window.setTimeout("initContent1()", 5);
                }
            document.form.Action.value = "Update";//alert(Contents["t2"]);
            <%}%>
        }

        function initContent() {
            window.setTimeout("initContent1()", 1);
        }

        var curField = 0;

        function previewFile(fieldname) {
            var name = document.getElementById(fieldname).value;
            //图片库采用本地预览
            var reg = new RegExp(outer_url, "g");
            if (name == "") return;

            if (name.indexOf("http://") != -1 || name.indexOf("https://") != -1) window.open(name.replace(reg, inner_url));
            else window.open("<%=SiteAddress%>/" + name);
        }

        function selectByKeyword() {
            var ByKeyword = document.getElementById("ByKeyword");
            var ByTitle = document.getElementById("ByTitle");
            document.getElementById("related_doc_list").src = "related_doc_list.jsp?GlobalID=<%=GlobalID%>&ChannelID=<%=ChannelID%>&ByKeyword=" + ByKeyword.checked + "&ByTitle=" + ByTitle.checked + "&keyword=" + encodeURIComponent(document.form.ByKeywordText.value);
        }


    </script>
</head>

<body class="collapsed-menu email" id="withSecondNav">
<label class="wd-content-lable d-flex " id="username"><input type="text" class="textfield form-control" size="10" name="reporter" id="reporter" value=""> </label>
<script type="text/javascript">document.body.disabled = true;</script>
<form name="form" action="../content/document_submit.jsp" method="post" id="form">
    <div class="br-logo"><img src="../images/2018/system-logo.png"></div>
    <div class="br-sideleft overflow-y-auto">
        <label class="sidebar-label pd-x-15 mg-t-20"></label>
        <%
            for (int i = 0; i < fieldGroupArray.size(); i++) {
                FieldGroup fieldGroup = (FieldGroup) fieldGroupArray.get(i);
        %>
        <div class="br-sideleft-menu">
            <a href="javascript:showTab('<%=i+1%>')" <%=(i == 0 ? "class='br-menu-link active'" : "class='br-menu-link'")%>
               id="form<%=i+1%>_td" groupid="<%=fieldGroup.getId()%>" data-toggle="tooltip" data-placement="right"
               title="<%=fieldGroup.getName()%>">
                <div class="br-menu-item">
                    <%
                        if (!fieldGroup.getIcon().equals("")) {
                            out.print(fieldGroup.getIcon());
                        } else {
                    %>
                    <i class="menu-item-icon fa fa-edit tx-22"></i>
                    <%}%>
                    <span class="menu-item-label"><%=fieldGroup.getName()%></span>
                </div><!-- menu-item -->
            </a><!-- br-menu-link -->
        </div><!-- br-sideleft-menu -->
        <%
            }
            if (!QRcode.equals("")) {
        %>
        <div class="br-sideleft-menu">
            <a href="javascript:showTab('<%= fieldGroupArray.size()+1%>')" class="br-menu-link"
               id="form<%= fieldGroupArray.size()+1%>_td" data-toggle="tooltip" data-placement="right" title="二维码">
                <div class="br-menu-item">
                    <i class="menu-item-icon fa fa-edit tx-22"></i>
                    <span class="menu-item-label">二维码</span>
                </div><!-- menu-item -->
            </a><!-- br-menu-link -->
        </div><!-- br-sideleft-menu -->
        <%}%>

        <%
            int vercount = (!QRcode.equals("")) ? fieldGroupArray.size() + 1 : fieldGroupArray.size();
            if (Version == 1) {
                vercount = vercount + 1;
        %>
        <div class="br-sideleft-menu">
            <a href="javascript:showTab('<%=vercount%>')" class="br-menu-link" id="form<%=vercount%>_td"
               data-toggle="tooltip" data-placement="right" title="历史版本">
                <div class="br-menu-item">
                    <i class="menu-item-icon fa fa-history tx-22"></i>
                    <span class="menu-item-label">历史版本</span>
                </div><!-- menu-item -->
            </a><!-- br-menu-link -->
        </div><!-- br-sideleft-menu -->
        <%
            }
            if (isChannelRecommend) {
                vercount = vercount + 1;
        %>
        <div class="br-sideleft-menu">
            <a href="javascript:showTab('<%=vercount%>')" class="br-menu-link" id="form<%=vercount%>_td"
               data-toggle="tooltip" data-placement="right" title="一稿多发">
                <div class="br-menu-item">
                    <i class="menu-item-icon fa fa-random tx-22"></i>
                    <span class="menu-item-label">一稿多发</span>
                </div><!-- menu-item -->
            </a><!-- br-menu-link -->
        </div><!-- br-sideleft-menu -->
        <%
            }
        %>
    </div><!-- br-sideleft -->
    <div class="br-header">
        <div class="br-header-left">
            <div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a>
            </div>
            <div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i
                    class="icon ion-navicon-round"></i></a></div>
            <div id="nav-header" class="hidden-md-down flex-row align-items-center">
                <%=channel.getParentChannelPath().replaceAll(">", " / ")%>
            </div>
        </div><!-- br-header-left -->
        <div class="br-header-right">
            <div class="btn-box">
                <%if (ApproveScheme == 0 || (action == 1 || id_aa == 0) || ItemID == 0) {%>
                <a class="btn btn-primary tx-size-xs mg-r-5" href="javascript:Save();" id="Image1Href">保存</a>
                <%if (ApproveScheme != 0) {%>
                <a class="btn btn-secondary tx-size-xs mg-r-5" id="Image2Href"
                   href="javascript:Save_approve();">提交审核</a>
                <%
                } else {
                    if (cp.hasRight(userinfo_session, ChannelID, 3)) {
                %>
                <a class="btn btn-secondary tx-size-xs mg-r-5" id="Image2Href"
                   href="javascript:Save_Publish();">保存并发布</a>
                <%
                        }
                    }
                } else {
                %>
                <a class="btn btn-primary tx-size-xs mg-r-5" href="javascript:save_();"
                   id="imageHrefJurisdiction">保存</a>
                <%if (channel.getChannelTemplates(2).size() != 0) {%>
                <a class="btn btn-secondary tx-size-xs mg-r-5" href="javascript:Preview2()">本地预览</a>
                <%}%>

                <%if (end != 1) {%>
                <a class="btn btn-secondary tx-size-xs mg-r-5" href="javascript:SaveApprove(1);" id="Image1Href">驳回</a>
                <a class="btn btn-secondary tx-size-xs mg-r-5" href="javascript:SaveApprove(0);" id="Image2Href">通过</a>
                <%}%>
                <%}%>
                <a class="btn btn-secondary tx-size-xs mg-r-10" href="javascript:self.close();">关闭</a>
            </div>
        </div><!-- br-header-right -->
    </div><!-- br-header -->
    <!--	<div class="br-pagebody bg-white mg-l-20 mg-r-20">
            <div class="br-content-box pd-20">  -->
    <%
        int j = 0;
        do {
            String padding = "";
            FieldGroup fieldGroup = null;//字段分组
            int fieldGroupID = 0;
            if (fieldGroupArray.size() > 0) {
                fieldGroup = (FieldGroup) fieldGroupArray.get(j);
                fieldGroupID = fieldGroup.getId();
            }

            String url = "";
            if (fieldGroupArray.size() > 0 && fieldGroup.getUrl().length() > 0) {
                url = fieldGroup.getUrl();
                url = url.replace("$globalid", GlobalID + "");
                url = url.replace("$itemid", ItemID + "");
                url = url.replace("$channelid", ChannelID + "");
                boolean b = url.contains("?");
                String c = "";
                if (!url.contains("itemid="))
                    c += "&itemid=" + ItemID;
                if (!url.contains("globalid="))
                    c += "&globalid=" + GlobalID;
                c += "&channelid=" + ChannelID + "&fieldgroup=" + (j + 1);
                url += ((b) ? "" : "?") + c;
            }
            if (fieldGroupID > 0 && !fieldGroup.getUrl().equals("")) {
                padding = "clear-padding";
            } else {
                padding = "";
            }
    %>
    <div class="br-mainpanel br-mainpanel-file overflow-hidden" url="<%=url%>"
         id="form<%=j+1 %>" <%if(j!=0)out.print("style=\"display:none;\"");%> <%if(j==0)out.print("data-approve=\""+data_approve+"\" data-yl=\""+data_yl+"\"");%>>
            <%
	//out.println("<div class=\"center\" url=\""+url+"\" id=\"form"+(j+1)+"\" "+(j!=0?"style=\"display:none;\"":"")+">");
    out.println("<div class=\"br-pagebody bg-white mg-l-20 mg-r-20 "+padding+"\" url=\""+url+"\" ><div class=\"br-content-box pd-20\"><div class=\"center\" >");
	if(fieldGroupID>0 && !fieldGroup.getUrl().equals(""))
	{
		out.println("<iframe id=\"iframe"+(j+1)+"\" frameborder=\"0\" style=\"width:100%;height:100%\" marginheight=\"0\" marginwidth=\"0\" scrolling=\"auto\" src=\""+url+"\" <!--onload=\"changeFrameHeight(this)\"--> ></iframe>");
	}
	else
	{
		Field field_title = channel.getFieldByFieldName("Title");
%>
        <div class="article-title mg-l-15 mg-b-15 pd-r-30">
            <%if (j == 0) {%>
            <div class="row flex-row align-items-center mg-b-15" id="tr_<%=field_title.getName()%>">
                <label class="left-fn-title wd-150 " id="tr_Title"><%=field_title.getDescription()%>：</label>
                <label class="wd-content-lable d-flex" id="field_Title">
                    <input class="form-control" placeholder="" type="text" id="Title" name="Title" size="80"
                           <%if(field_title.getName() == "CalculateType"){%>style="display:none"<%}%>
                           value="<%=item!=null?Util.HTMLEncode(item.getValue("Title")):""%>" onkeyup="checkTitle();">
                </label>
                <label><span id="TitleCount" class="mg-l-10"></span></label>
                <%
                    if (field_title.getJS().length() > 0) {
                        out.println("<script>" + field_title.getJS() + "</script>");
                    }
                %>
                <%if (editCategory) {%>
                <label class="left-fn-title wd-60 ">分类：</label>
                <select class="form-control wd-230 ht-40 select2" name="ChannelID" id="ChannelID">
                    <%
                        ArrayList categorys = channel.listAllSubChannels(Channel.Category_Type);
                        if (categorys != null && categorys.size() > 0) {
                            for (int i = 0; i < categorys.size(); i++) {
                                Channel subcategory = (Channel) categorys.get(i);
                    %>
                    <option value="<%=subcategory.getId()%>" <%=(item != null && subcategory.getId() == item.getCategoryID()) ? "selected" : ""%>><%=subcategory.getName()%>
                    </option>
                    <%
                            }
                        }
                    %>
                </select>
                <%}%>
            </div>
            <%if (!field_title.getCaption().equals("")) {%>
            <div class="row mg-t--10">
                <label class="left-fn-title wd-150"> </label>
                <label class="d-flex align-items-center tx-gray-800 tx-12"><i
                        class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                </i><%=field_title.getCaption()%>
                </label>
            </div>
            <%}%>
            <%}%>

            <%
                ArrayList arraylist = channel.getFieldsByGroup(fieldGroupID, j);
                int jj = 0;
                for (int i = 0; i < arraylist.size(); i++) {
                    Field field = (Field) arraylist.get(i);
                    if (channel.isShowField(field.getName()) && field.getIsHide() == 0) {
                        if (field.getDisableBlank() == 1) {
                            check2 += "	if(isEmpty(document.form." + field.getName() + ",'请输入" + field.getDescription() + ".'))";
                            check2 += "	return false;";
                        }
            %>
            <%if (field.getName().equalsIgnoreCase("Content")) {%>
            <%} else if (field.getFieldType().equals("label")) {%>

            <div class="row flex-row align-items-center mg-b-15" id="tr_<%=field.getName()%>">
                <%if (!field.getFieldType().equals("label")) {%>
                <label class="left-fn-title wd-150 "><%=field.getDescription()%>：</label>
                <%}%>
                <label class="wd-content-lable d-flex"><%=field.getOther()%>
                </label>
            </div>
            <%if (!field.getCaption().equals("")) {%>
            <div class="row mg-t--10">
                <label class="left-fn-title wd-150"> </label>
                <label class="d-flex align-items-center tx-gray-800 tx-12"><i
                        class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                </i><%=field.getCaption()%>
                </label>
            </div>
            <%}%>
            <%} else {%>
            <%if (field.getName().equals("PublishDate")) {%>
            <div class="row flex-row align-items-center mg-b-15" id="tr_<%=field.getName()%>">
                <label class="left-fn-title wd-150 "><%=field.getDescription()%>：</label>
                <label class=""><%=field.getDisplayHtml_(item != null ? item.getPublishDate() : Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"))%>  <%=channel.getFieldByFieldName("Weight").getDisplayHtml_(item != null ? item.getWeight() + "" : "")%>
                </label>
            </div>
            <%if (!field.getCaption().equals("")) {%>
            <div class="row mg-t--10">
                <label class="left-fn-title wd-150"> </label>
                <label class="d-flex align-items-center tx-gray-800 tx-12"><i
                        class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                </i><%=field.getCaption()%>
                </label>
            </div>
            <%}%>
            <%} else if (field.getName().equals("Keyword2")) {%>
            <div class="row flex-row align-items-center mg-b-15" id="tr_<%=field.getName()%>" style="display: none">
                <label class="left-fn-title wd-150 "><%=field.getDescription()%>：</label>
                <label class="wd-content-lable d-flex">
                    <%=field.getDisplayHtml_(item != null ? item.getValue(field.getName()) : "")%>
                    <input name="kewwordselect" type="button" class="btn btn-primary tx-size-xs mg-r-5" value="按关键词选择"
                           onclick="selectByKeyword2()">
                </label>
            </div>
            <%if (!field.getCaption().equals("")) {%>
            <div class="row mg-t--10">
                <label class="left-fn-title wd-150"> </label>
                <label class="d-flex align-items-center tx-gray-800 tx-12"><i
                        class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5">
                </i><%=field.getCaption()%>
                </label>
            </div>
            <%}%>
            <div class="row flex-row align-items-center mg-b-15">
                <label class="left-fn-title wd-150 ">相关视频：</label>
                <label class="wd-content-lable d-flex">
                    <iframe id="related_video_list" frameborder="0" height="400" width="650" marginheight="0"
                            marginwidth="0" scrolling="auto"
                            src="../video/related_video_list.jsp?id=<%=ItemID%>&ChannelID=<%=ChannelID%>"></iframe>
                </label>
            </div>
            <%
                } else {
                    out.println(field.getDisplayHtml2018(item));
                }
            %>
            <%}%>
            <%
                    }
                }
            %>
        </div>
            <%}
	out.println("</div></div></div></div>");j++;
}while(j < fieldGroupArray.size());%>

            <%if(!QRcode.equals("")){%>
        <div class="br-mainpanel br-mainpanel-file overflow-hidden" <%if(j!=0){%>style="display:none;"<%}%>
             id="form<%=fieldGroupArray.size()+1%>">
            <div class="br-pagebody bg-white mg-l-20 mg-r-20">
                <div class="br-content-box pd-20">
                    <!--标签组-->
                    <div class="center" url="">
                        <div class="article-title mg-l-15 mg-b-15 pd-r-30">
                            <div class="row flex-row align-items-center">
                                <label class="left-fn-title wd-150 ">二维码分享功能：</label>
                                <label class="wd-content-lable d-flex">
                                    <div><img src="<%=QRcode%>"></div>
                                    <div>二维码标签分享功能</div>
                                    <div>左侧的二维码是本内容是由移动终端分享地址生成。<br>通过手机、PAD客户端或微信“扫一扫”功能拍摄扫描二维码实现移动设备的内容浏览，并可以通过分享工具分享给移动设备用户。<br>也可以将本二维码发布到网页中，实现基于网页的二维码拍摄分享功能。
                                    </div>
                                </label>
                            </div>
                        </div>
                        <div class="article-title mg-l-15 mg-b-15 pd-r-30">
                            <div class="row flex-row align-items-center">
                                <label class="left-fn-title wd-150 ">二维码图片地址：</label>
                                <label class="wd-content-lable d-flex"><%=QRcode%>
                                </label>
                            </div>
                        </div>
                    </div>
                    <%}%>
                    <%
                        int vercount1 = (!QRcode.equals("")) ? fieldGroupArray.size() + 1 : fieldGroupArray.size();
                        if (Version == 1) {
                            vercount1 = vercount1 + 1;
                    %>
                    <div class="br-mainpanel br-mainpanel-file overflow-hidden" <%if(j!=0){%>style="display:none;"<%}%>
                         url="" id="form<%=vercount1%>">
                        <iframe id="iframe<%=vercount1%>" class="content-edit-frame"
                                style="width:100%;min-height:960px;height:100%;" frameborder="0" marginheight="0"
                                marginwidth="0" scrolling="auto"
                                src="content_historical_version.jsp?GlobalID=<%=GlobalID%>"></iframe>
                    </div>
                    <%
                        }
                        if (isChannelRecommend) {
                            vercount1 = vercount1 + 1;
                    %>
                    <div class="br-mainpanel br-mainpanel-file overflow-hidden" <%if(j!=0){%>style="display:none;"<%}%>
                         url="" id="form<%=vercount1%>">
                        <iframe id="iframe<%=vercount1%>" name="oneDocManySend" class="content-edit-frame"
                                style="width:100%;min-height:600px;" frameborder="0" marginheight="0" marginwidth="0"
                                scrolling="auto"
                                src="../recommend/content_multiple.jsp?GlobalID=<%=GlobalID%>&ChannelID=<%=ChannelID%>&ItemID=<%=ItemID%>"
                                onload="changeFrameHeight(this)"></iframe>
                    </div>
                    <%
                        }
                    %>

                    <div class="program-time pd-x-20 pd-sm-x-30 pd-t-0 mg-b-20 wd-300" style="margin-left:30px">
                        <span style="color: transparent;" class="ht-40 d-block" onclick="this.style.color='#333'"
                              onmouseout="this.style.color='transparent'">执行时间：<%=(System.currentTimeMillis() - begin_time)%>毫秒</span>
                    </div>
                </div>

            </div>

        </div>

        <input type="hidden" name="From" value="<%=From%>">
        <input type="hidden" name="Action" value="Add">
        <input type="hidden" name="Content" value="">
        <input type="hidden" id="ItemID" name="ItemID" value="<%=ItemID%>">
            <%if(!editCategory){%><input type="hidden" name="ChannelID" value="<%=ChannelID%>"><%}%>
        <input type="hidden" name="Status" value="0">
        <input type="hidden" name="Approve" value="0">
        <input type="hidden" id="GlobalID" name="GlobalID" value="<%=GlobalID%>">
        <input type="hidden" name="ParentGlobalID" value="<%=parentGlobalID%>">
        <input type="hidden" name="RelatedItemsList" value="">
        <input type="hidden" name="Page" value="1">
        <input type="hidden" id="RecommendGlobalID" name="RecommendGlobalID" value="0">
        <input type="hidden" name="RecommendChannelID" value="0">
        <input type="hidden" name="RecommendItemID" value="0">
        <input type="hidden" name="NoCloseWindow" id="NoCloseWindow" value="0">
        <input type="hidden" name="ContinueNewDocument" value="<%=ContinueNewDocument%>">
        <input type="hidden" id="RecommendType" name="RecommendType" value="0">
        <input type="hidden" id="RecommendChannelIDs" name="RecommendChannelIDs" value="">
        <input type="hidden" id="WeixinIds" name="WeixinIds" value="">
        <input type="hidden" id="CompanyId" name="CompanyId" value="<%=userinfo_session.getCompany()%>">
        <div id="ajax_script" style="display:none;"></div>
</form>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
<%
    if (channel.getDocumentJS().length() > 0) {
        out.println("<script>");
        out.println(channel.getDocumentJS());
        out.println("</script>");
    }
%>
<script type="text/javascript">
    var form_data = $("#form").serialize();//获取表单数据
    <%if(Parent>0){
    out.println("setValue('Parent',"+Parent+");");
    }%>
</script>

<!--兼容性提示弹窗-->
<div class="editorTipsModal modal" id="editorTipsModal">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close">×</button>
                <h4 class="modal-title" id="myModalLabel">系统提示</h4>
            </div>
            <div class="modal-body">
                <p>系统检测到您正在使用低版本浏览器，为保证您的正常使用，请升级浏览器到最新版本。</p>
                <p>推荐使用浏览器：谷歌浏览器，其他浏览器及版本：360浏览器最新版、IE9及以上版本。</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default btn-close" data-dismiss="modal">关闭</button>
            </div>
        </div>
    </div>
</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../lib/2018/medium-editor/medium-editor.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script type="text/javascript" src="../common/jquery-ui-timepicker-addon.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>
    var groupnum =<%=vercount%>;
    $(function () {
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function (e) {
            e.preventDefault();
            if ($('body').hasClass('show-mb-left')) {
                $('body').removeClass('show-mb-left');
                $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
            } else {
                $('body').addClass('show-mb-left');
                $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
            }
        });

        $('.br-sideleft [data-toggle="tooltip"]').tooltip({
            shadowColor: "#ffffff",
            textColor: "000000",
            trigger: "hover"
        });
    });

</script>

<script>
    //h5编辑器相关
    var everLoadH5 = false;
    $("#tr_changeEditor input[name='editortype']").click(function () {
        var val = $(this).val();
        if (val == 0) {
            $("#tr_h5Editor").hide();
            $("#tr_Content").show();
            setContent(h5_getContent());
            h5_setContent("");
        } else {
            if (!everLoadH5) {
                var _html = '<iframe id="h5editor1_Frame" src="../h5/index.html?webname=${pageContext.request.contextPath}" width="100%" height="800" frameborder="0" scrolling="no" onload="inserBdContent()" ></iframe>';
                $("#tr_Content").hide();
                $("#tr_h5Editor").html(_html).show();
                everLoadH5 = true;
            } else {
                $("#tr_h5Editor").show();
                $("#tr_Content").hide();
                h5_setContent(getContent());
                setContent("");
            }
//			var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor
//			h5ue.ready(function() {
//			   h5_insertContent(getContent());
//			});
        }
    })
    var Parameter = "&ChannelID=" + ChannelID;

    //本地预览
    function Preview2() {
        window.open("../content/document_preview.jsp?ItemID=<%=ItemID%>" + Parameter);
    }

    //审核预览
    function approve_preview(versionid) {
        window.open("../content/preview_version.jsp?vid=" + versionid + "&ItemID=" + <%=ItemID%> +Parameter);
    }

    function returnVersion(id) {
        $.ajax({
            url: "version_data.jsp?id=" + id,
            dataType: "json",
            success: function (data) {
                $("#Title").val(data.Title);
                var currcontent = (data.Content).replace(/src=\"\//g, 'src=\"<%=SiteAddress%>\/');
                setContent(currcontent, "");
                $("#Summary").val(data.Summary);
                tipVersion(data.Title);
            }
        });
    }

    function tipVersion(title) {
        window.alert(title + "版本内容已恢复，请返回内容编辑");
    }

    function inserBdContent() {
        var _interval = setInterval(function () {
            try {
                var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor;
                if (h5ue) {
                    h5ue.ready(function () {
                        h5_setContent(getContent());
                        setContent("");
                    });
                    clearInterval(_interval)
                } else {
                    return;
                }
            } catch (err) {
            }
        }, 50)
    }

    //获得h5编辑器内容
    function h5_getContent() {
        var content = document.getElementById("h5editor1_Frame").contentWindow.getUecontent();
        return content;
    }

    //h5编辑器写入内容
    function h5_setContent(insertContent, b) {
        document.getElementById("h5editor1_Frame").contentWindow.setCurrentContent(insertContent, true);
    }

    //h5编辑器插入内容
    function h5_insertContent(insertContent, b) {
        document.getElementById("h5editor1_Frame").contentWindow.setInsertContent(insertContent, true);
    }

    $(function () {


        //判断是否为ie8及以下浏览器
        var DEFAULT_VERSION = 8.0;
        var _ua = navigator.userAgent.toLowerCase();
        var _isIE = _ua.indexOf("msie") > -1;
        var browserVersion;
        if (_isIE) {
            browserVersion = _ua.match(/msie ([\d.]+)/)[1];
        }
        if (browserVersion <= DEFAULT_VERSION) {
            $('#editorTipsModal').show().css("opacity", 1)
        }
        ;
        $(".editorTipsModal .btn-close,.editorTipsModal button.close").click(function () {
            $('#editorTipsModal').hide().css("opacity", 0)
        })
    });
</script>
</body>
</html>

