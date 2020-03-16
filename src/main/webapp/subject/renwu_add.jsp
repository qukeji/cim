<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    int SubjectId = getIntParameter(request,"SubjectId");
    int		ChannelID				= getIntParameter(request,"ChannelID");
    Document doc=CmsCache.getDocument(SubjectId);
    int		ItemID				= getIntParameter(request,"ItemID");
    doc = CmsCache.getDocument(ItemID, ChannelID);
    System.out.println("doc=="+doc);
    String SubjectName=doc.getTitle();

    Channel channel=CmsCache.getChannel(ChannelID);

    boolean canApprove = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanApprove);
    boolean canDelete = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanDelete);
    boolean canAdd = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CanAdd);
    boolean createCategory = channel.hasRight(userinfo_session,ChannelPrivilegeItem.CreateCategory);
    int canExcel=channel.getIsExportExcel();//是否导出Excel
    int canWord=channel.getIsImportWord();//是否导出world
    String SiteAddress = channel.getSite().getUrl();
    Channel task_doc = ChannelUtil.getApplicationChannel("task_doc");//选题
    int channelId_xuanti = task_doc.getId();


//获取频道路径
    String parentChannelPath = channel.getParentChannelPath().replaceAll(">"," / ");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico"/>
    <title><%=parentChannelPath%></title>
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/summernote/summernote-bs4.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">

    <link rel="stylesheet" href="../style/2018/common.css">
    <link rel="stylesheet"  type="text/css" href="../style/jquery.tagit.css" />
    <link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">

    <link rel="stylesheet" type="text/css" href="../style/timepicker/jquery-ui.css" />
    <link rel="stylesheet"  type="text/css" href="../style/timepicker/jquery-ui-timepicker-addon.css" />
    <link rel="stylesheet" href="../style/2018/bracket.css">

    <style>
        .collapsed-menu .br-mainpanel-file{margin-left: 60px;margin-bottom: 30px;}
        #nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
        #nav-header a{color: #a4aab0;}
        .table-bordered {border: 1px solid #dee2e6;text-align: center;}
        #tabTable td{padding: 0.3rem !important;cursor: pointer;}
        .selTab{border: 1px solid #17A2B8 !important;background-color: #17A2B8;color: #fff;}
        .edui-default .edui-editor-breadcrumb{line-height: 30px;}
        .btn-box a{color:#fff }
        .ui-widget-content{border: 1px solid rgba(0, 0, 0, 0.15) ;}
        .bs-tooltip-bottom .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #f8f9fa;opacity: 1;}
        .tooltip.bs-tooltip-bottom .arrow::before,
        .tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #f8f9fa;	}
        /*.edui-editor {z-index: 0 !important;}*/
        /*tooltip相关样式*/
        .bs-tooltip-right .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #00b297;opacity: 1;}
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
        var SubjectId = "<%=SubjectId%>";
        $(function(){
            $("#field_users").after("\r\n<label><input type=\"button\" value=\"选择\" onclick=\"getusers('<%=SubjectId%>')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>");

            $("#field_bespeak_name").after("\r\n<label><input type=\"button\" value=\"选择\" onclick=\"getcars('<%=SubjectId%>')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>");

            $("#field_device_name").after("\r\n<label><input type=\"button\" value=\"选择\" onclick=\"getdevices()\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>");

            $("#field_SubjectName").after("\r\n<label><input type=\"button\" value=\"选择\" onclick=\"getcars('<%=SubjectId%>')\" class=\"btn btn-primary tx-size-xs mg-l-10\"></label>");

        });
    </script>
    <script>
        var Pages=1;
        var curPage = 1;
        var Contents = new Array();
        Contents[Contents.length] = "";
        var userId = <%=userinfo_session.getId()%>;
        var userName = "<%=userinfo_session.getName()%>";
        var SubjectName=<%=SubjectName%>;

        var is_auto_save = false;//自动保存
        var timer = null;//定时器
        var ChannelID = "<%=ChannelID%>";


        var NoCloseWindow = 0;//是否关闭页面
        var unload = true ;//关闭页面是否提示
        window.onresize = function(){
            if(document.getElementsByClassName("content-edit-frame")[0]){
                if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
                    var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.body.scrollHeight ;
                }else{
                    var _height = document.getElementsByClassName("content-edit-frame")[0].contentWindow.document.documentElement.scrollHeight ;
                }
                document.getElementsByClassName("content-edit-frame")[0].style.height = _height
            }
        }
        //调整iframe的高度
        function changeFrameHeight(_this){
            if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
                _this.style.height = _this.contentWindow.document.body.scrollHeight +5;
            }else{
                _this.style.height = _this.contentWindow.document.documentElement.scrollHeight +5;
            }
        }
        function SaveApprove(action){
            var user = $("#approve").attr("user");
            var approveId = $("#approve").attr("approveId");
            var endApprove = $("#approve").attr("end");
            var actionMessage = $("#approve").val();
            if(action==1&&actionMessage==""){
                alert("请输入驳回理由");
                return false ;
            }
            var title = $("#Title").val();
            var enTitle= encodeURI(title);
            var url= "../approve/approve_sumbit.jsp?globalid="+GlobalID+"&title="+enTitle+"&action="+action+"&user="+user+"&approveId="+approveId+"&endApprove="+endApprove+"&actionMessage="+actionMessage;
            $.ajax({
                type: "GET",
                url: url,
                success: function(msg){
                    if(msg.trim()!=""){
                        alert(msg.trim());
                    }else{
                        if(action==0){
                            Save();
                        }else{
                            document.location.reload();
                        }
                    }
                }
            });
        }
    </script>

    <script>

        function Save_approve()
        {
            document.form.Status.value = 1;
            Save();
        }
           function closewindow()
        {
           var message="是否确认关闭";
          	 if(confirm(message)){
          	       window.close();
          	 }
          
        }
        function Save()
        {
            var form_data = $("#form").serialize();//获取表单数据
          
            var content1_ =$("input[name='StartDate']").val();
            var content2_ =$("input[name='EndDate']").val();
            var title =$("#Title").val();
            if(content1_>content2_){
                alert("开始时间不能大于结束时间");
                return;
            }
             if(!title){
                alert("请填写任务名称");
                return;
            }

            $.ajax({
                type: "POST",
                url:"renwu_submit.jsp",
                data:$('#form').serialize(),
                dataType:'json',
                success: function(result)
                {
                    unload = false ;
                    if(window.opener!=null)
                    {
                        window.opener.document.location.reload();
                    }
                    window.close();

                    //alert(result.message);

                    $("#display_auto_save") .addClass("auto_save").text("保存完成"+getNowFormatDate());
                    // $("#display_auto_save").removeClass("auto_save").addClass("auto_save_hide");
                },
                error: function (result)
                {
                    alert("保存失败，请检查选项是否为空");
                    document.getElementById("Image1Href").href = "javascript:Save();";

                    document.getElementById("Image2Href").href = "javascript:Save_Publish();";

                }
            });


        }




        function init()
        {

            $(".date").datetimepicker({
                timeText: '时间',
                hourText: '小时',
                minuteText: '分钟',
                secondText: '秒',
                currentText: '现在',
                closeText: '完成',
                showSecond: true, //显示秒
                dateFormat:"yy-mm-dd",
                timeFormat: 'HH:mm:ss',//格式化时间
                monthNames: ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
                dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
                dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
                dayNamesMin: ['日','一','二','三','四','五','六']
            });

            var sampleTags = [];
            $("#Keyword").tagit({availableTags: sampleTags    });
            $("#Tag").tagit({availableTags: sampleTags    });

            checkTitle();
            document.body.disabled  = false;
            auto_save();
        }

        //获取当前时间
        function getNowFormatDate()
        {
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
        function auto_save()
        {
            if($("#auto_save").attr("checked"))//勾选了才自动保存
            {
                is_auto_save = true;
                document.form.NoCloseWindow.value = '1';
                timer = window.setInterval("Save()","30000");
            }
            //自动保存
            $("#auto_save").change(
                function()
                {
                    if(this.checked)
                    {//选中 自动保存
                        is_auto_save = true;
                        document.form.NoCloseWindow.value = '1';
                        timer = window.setInterval("Save()","30000");
                    }
                    else
                    {//取消自动保存
                        is_auto_save = false;
                        document.form.NoCloseWindow.value = '0';
                        window.clearInterval(timer);
                    }
                }
            );

        }

        function initContent1()
        {
            <%if(doc.getId()!=0){%>
            if(document.getElementById("tabTableRow"))
                try{
                    {

                    }
                }catch(er){	window.setTimeout("initContent1()",5);}
            document.form.Action.value = "Update";//alert(Contents["t2"]);
            <%}%>
        }

        function initContent()
        {
            window.setTimeout("initContent1()",1);
        }

        var curField = 0;

        function previewFile(fieldname)
        {
            var name = document.getElementById(fieldname).value;
            //图片库采用本地预览
            var reg = new RegExp(outer_url,"g");
            if(name=="") return;

            if(name.indexOf("http://")!=-1 || name.indexOf("https://")!=-1)  window.open(name.replace(reg,inner_url));
            else	window.open("/" + name);
        }

        function selectByKeyword()
        {
            var ByKeyword = document.getElementById("ByKeyword");
            var ByTitle = document.getElementById("ByTitle");
            document.getElementById("related_doc_list").src = "related_doc_list.jsp?GlobalID=1456229&ChannelID=16681&ByKeyword="+ByKeyword.checked + "&ByTitle="+ByTitle.checked + "&keyword=" + encodeURIComponent(document.form.ByKeywordText.value);
        }


    </script>
</head>

<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled  = true;</script>
<form name="form" action="../content/document_submit.jsp" method="post" id = "form">
    <div class="br-logo"><img src="../images/2018/system-logo.png"></div>
    <div class="br-sideleft overflow-y-auto">
        <label class="sidebar-label pd-x-15 mg-t-20"></label>

        <div class="br-sideleft-menu">
            <a href="javascript:showTab('1')" class='br-menu-link active' id="form1_td" groupid="8572" data-toggle="tooltip" data-placement="right" title="新建任务">
                <div class="br-menu-item">
                    <i class="menu-item-icon fa fa-edit tx-22"></i>
                    <span class="menu-item-label">新建任务</span>
                </div><!-- menu-item -->
            </a><!-- br-menu-link -->
        </div><!-- br-sideleft-menu -->


    </div><!-- br-sideleft -->
    <div class="br-header">
        <div class="br-header-left">
            <div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
            <div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
            <div id="nav-header" class="hidden-md-down flex-row align-items-center">
                新建任务
            </div>
        </div><!-- br-header-left -->
        <div class="br-header-right">
            <div class="btn-box" >

                <a class="btn btn-primary tx-size-xs mg-r-5" href="javascript:Save();" id="Image1Href">保存</a>

                <a class="btn btn-secondary tx-size-xs mg-r-5" id="Image2Href" href="javascript:Save_Publish();">保存并发布</a>

                <a class="btn btn-secondary tx-size-xs mg-r-10" href="javascript:closewindow();">关闭</a>
            </div>
        </div><!-- br-header-right -->
    </div><!-- br-header -->
    <!--	<div class="br-pagebody bg-white mg-l-20 mg-r-20">
            <div class="br-content-box pd-20">  -->
    <%
        String Title="";
        String StartDate="";
        String EndDate="";
        String users="";
        String users_id="";
        String Summary="";
        String table=channel.getTableName();
        String subjectname="";
        if(ItemID!=0){
            String sql="select * from "+table+" where Active=1 and id="+ItemID;
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            if (rs.next()){
                Title=convertNull(rs.getString("Title"));
                users=convertNull(rs.getString("users"));
                users_id=convertNull(rs.getString("UserID"));
                StartDate	= convertNull(rs.getString("StartDate"));
                StartDate=Util.FormatDate("yyyy-MM-dd HH:mm",StartDate);
                EndDate	= convertNull(rs.getString("EndDate"));
                EndDate=Util.FormatDate("yyyy-MM-dd HH:mm",EndDate);
                subjectname =convertNull(rs.getString("SubjectName"));
                Summary =convertNull(rs.getString("Summary"));
            }
        }
    %>
    <div class="br-mainpanel br-mainpanel-file overflow-hidden" id="form1"  data-approve="0" data-yl="0">
        <div class="br-pagebody bg-white mg-l-20 mg-r-20 " url="" ><div class="br-content-box pd-20"><div class="center" >

            <div class="article-title mg-l-15 mg-b-15 pd-r-30" >
                <div class="row flex-row align-items-center mg-b-15" id="tr_Title">
                    <label class="left-fn-title wd-150 " id="tr_Title">任务名称：</label>
                    <label class="wd-content-lable d-flex" id="field_Title">
                        <input class="form-control" placeholder="" type="text" id="Title" name="Title" size="80" value="<%=Title%>" onkeyup="checkTitle();">
                    </label>
                    <label><span id="TitleCount" class="mg-l-10"></span></label>
                </div>
                <div class="row flex-row align-items-center mg-b-15">
                    <label class="left-fn-title wd-150" id='desc_TaskType'>任务类型：</label>
                    <select class="form-control wd-700 ht-40 select2" data-placeholder="" name="TaskType">
                        <option value="1" >采稿</option>
                        <option value="2" >写稿</option>
                        <option value="3" >发布</option>
                        <option value="4" >后期制作</option>
                    </select>
                </div>

                <div class="row flex-row align-items-center mg-b-15" id="tr_StartDate">
                    <label class="left-fn-title wd-150" id='desc_StartDate'>任务开始时间：</label><label class="wd-content-lable d-flex " id="field_StartDate"><input type='text' name='StartDate' id='StartDate' value='<%=StartDate%>' class='textfield date form-control' size='24'>
                </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15" id="tr_EndDate">
                    <label class="left-fn-title wd-150" id='desc_EndDate'>任务结束时间：</label><label class="wd-content-lable d-flex " id="field_EndDate"><input type='text' name='EndDate' id='EndDate' value='<%=EndDate%>' class='textfield date form-control' size='24'>
                </label>
                </div>
                <%if (SubjectId==0){%>
                <div class="row flex-row align-items-center mg-b-15" id="tr_users">
                    <label class="left-fn-title wd-150" id='desc_SubjectName'>添加选题：</label>
                    <label class="wd-content-lable d-flex " id="field_SubjectName">
                        <input type="text" class="textfield form-control" size="80" name="SubjectName" id="SubjectName" value="<%=subjectname%>">
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15" id="tr_SubjectId" hidden="hidden">
                    <label class="left-fn-title wd-150" id='desc_SubjectId'>选题id：</label>
                    <label class="wd-content-lable d-flex " id="field_SubjectId">
                        <input type="text" class="textfield form-control" size="80" name="SubjectId" id="SubjectId" value="<%=SubjectId%>">
                    </label>
                </div>
                <%}%>

                <div class="row flex-row align-items-center mg-b-15" id="tr_users">
                    <label class="left-fn-title wd-150" id='desc_users'>任务执行人：</label>
                    <label class="wd-content-lable d-flex " id="field_users">
                        <input type="text" class="textfield form-control" size="80" name="users" id="users" value="<%=users%>">
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15" id="tr_users_id">
                    <label class="left-fn-title wd-150" id='desc_users_id'>任务执行人id：</label>
                    <label class="wd-content-lable d-flex " id="field_users_id">
                        <input type="text" class="textfield form-control" size="80" name="users_id" id="users_id" value="<%=users_id%>">
                    </label>
                </div>
                <div class="row flex-row align-items-center mg-b-15" id="tr_Summary">
                    <label class="left-fn-title wd-150" id='desc_Summary'>任务描述：</label>
                    <label class="wd-content-lable d-flex " id="field_Summary">
                        <textarea cols="81" class="textfield form-control" rows=5 name="Summary" onDblClick="showEditor('Summary')" id="Summary"><%=Summary%></textarea>
                    </label>
                </div>
                  <div class="row flex-row align-items-center mg-b-15" id="tr_SubjectuUserId" hidden="hidden">
                    <label class="left-fn-title wd-150" id='desc_SubjectuUserId'>任务执行人id：</label>
                    <label class="wd-content-lable d-flex " id="field_SubjectuUserId">
                        <input type="text" class="textfield form-control" size="80" name="SubjectuUserId" id="SubjectuUserId" value="">
                    </label>
                </div>
               
            </div>
        </div>
        </div></div></div>
    <input type="hidden" name="From" value="">
    <input type="hidden" name="Action" value="Add">
    <input type="hidden" name="Content" value="">
    <input type="hidden" id="ItemID" name="ItemID" value="<%=ItemID%>">
    <input type="hidden" id="Status" name="Status" value="">
    <input type="hidden" name="ChannelID" value="<%=ChannelID%>">
    <input type="hidden" name="SubjectId" value="<%=SubjectId%>">
    <input type="hidden" name="SubjectName" value="<%=SubjectName%>">
    <input type="hidden" name="SubjectuUserId" value="">


</form>
<!--17ms-->

<script type="text/javascript">
    var form_data = $("#form").serialize();//获取表单数据

</script>

<!--兼容性提示弹窗-->
<div class="editorTipsModal modal" id="editorTipsModal" >
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
    var channelId_xuanti=<%=channelId_xuanti%>;
    var groupnum=4;
    $(function(){
        'use strict';

        //show only the icons and hide left menu label by default
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e){
            e.preventDefault();
            if($('body').hasClass('show-mb-left')) {
                $('body').removeClass('show-mb-left');
                $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
            } else {
                $('body').addClass('show-mb-left');
                $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
            }
        });

        $('.br-sideleft [data-toggle="tooltip"]').tooltip({
            shadowColor:"#ffffff",
            textColor:"000000",
            trigger:"hover"
        });
    });

</script>

<script>
    //h5编辑器相关
    var everLoadH5 = false ;
    $("#tr_changeEditor input[name='editortype']").click(function(){
        var val = $(this).val();
        if(val==0){
            $("#tr_h5Editor").hide();
            $("#tr_Content").show();
            setContent(h5_getContent());
            h5_setContent("");
        }else{
            if(!everLoadH5){
                var _html = '<iframe id="h5editor1_Frame" src="../h5/index.html?webname=/tcenter" width="100%" height="800" frameborder="0" scrolling="no" onload="inserBdContent()" ></iframe>' ;
                $("#tr_Content").hide();
                $("#tr_h5Editor").html(_html).show();
                everLoadH5 = true ;
            }else{
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
    //审核预览
    function approve_preview(versionid)
    {
        window.open("../content/preview_version.jsp?vid="+versionid+"&ItemID=" + 402 + Parameter);
    }
    function returnVersion(id){
        $.ajax({
            url:"version_data.jsp?id="+id,
            dataType:"json",
            success:function(data){
                $("#Title").val(data.Title);
                var currcontent = (data.Content).replace(/src=\"\//g, 'src=\"\/' ) ;
                setContent(currcontent,"");
                $("#Summary").val(data.Summary);
                tipVersion(data.Title);
            }
        });
    }
    function tipVersion(title){
        window.alert(title+"版本内容已恢复，请返回内容编辑");
    }
    function inserBdContent(){
        var _interval = setInterval(function(){
            try
            {
                var h5ue = document.getElementById("h5editor1_Frame").contentWindow.WXBEditor ;
                if(h5ue){
                    h5ue.ready(function() {
                        h5_setContent(getContent());
                        setContent("");
                    });
                    clearInterval(_interval)
                }else{
                    return ;
                }
            }
            catch(err)
            {
            }
        },50)
    }
    //获得h5编辑器内容
    function h5_getContent(){
        var content = document.getElementById("h5editor1_Frame").contentWindow.getUecontent();
        return content;
    }
    //h5编辑器写入内容
    function h5_setContent(insertContent,b){
        document.getElementById("h5editor1_Frame").contentWindow.setCurrentContent(insertContent,true);
    }
    //h5编辑器插入内容
    function h5_insertContent(insertContent,b){
        document.getElementById("h5editor1_Frame").contentWindow.setInsertContent(insertContent,true);
    }
    $(function() {
        //判断是否为ie8及以下浏览器
        var DEFAULT_VERSION = 8.0;
        var _ua = navigator.userAgent.toLowerCase();
        var _isIE = _ua.indexOf("msie")>-1;
        var browserVersion;
        if(_isIE){
            browserVersion =  _ua.match(/msie ([\d.]+)/)[1];
        }
        if(browserVersion <= DEFAULT_VERSION ){
            $('#editorTipsModal').show().css("opacity",1)
        };
        $(".editorTipsModal .btn-close,.editorTipsModal button.close").click(function(){
            $('#editorTipsModal').hide().css("opacity",0)
        })
    });

    /*
    //改变栏目
    function changeCategory(){
    //获取被选中的option标签value值
    var select = document.getElementById('Category').value;

    $.ajax({
        type: "GET",
        url: "../content/document_copy.jsp",
        data: {ItemID:ItemID,SourceChannel:ChannelID,DestChannel:select,Type:1},
        success: function(msg){
            //return;
            location.reload();
        }
    });
    }
    */

    function getusers(id){
        var content_ =$("input[name='users_id']").val();
        var content_1 =$("input[name='SubjectName']").val();
        var content_2 =$("input[name='SubjectId']").val();
        var userid =$("input[name='SubjectuUserId']").val();
        if (id==0){
            id=content_2;
        }
        var	dialog = new top.TideDialog();
        dialog.setWidth(900);
        dialog.setHeight(650);
        dialog.setUrl("renwu_userselect.jsp?SubjectId="+id+"&userid="+userid);
        dialog.setTitle('参与人选择');
        dialog.show();
    }

    function getcars(id){
        var	dialog = new top.TideDialog();
        var url = "documentHref_index.jsp?ChannelID=<%=channelId_xuanti%>&fieldName=juxian_liveid";

        dialog.setWidth(900);
        dialog.setHeight(650);
        dialog.setUrl(url);
        dialog.setTitle('选择选题');
        dialog.show();
    }

    function getdevices(){
        var content3_ =$("input[name='device']").val();
        var	dialog = new top.TideDialog();
        dialog.setWidth(900);
        dialog.setHeight(650);
        dialog.setUrl("task_deviceselect.jsp?id=16534&fieldName=device&content="+content3_);
        dialog.setTitle('预约设备');
        dialog.show();
    }


    $(function(){
//显示参与人

        var devices =$("input[name='device']").val();
        var bespeaks =$("input[name='bespeak']").val();
        $.ajax({
            type : "GET",
            url : "task_getnamedesc.jsp",
            dataType:"json",
            //jsonpCallback:"callback",
            data:{
                ChannelID:16534,
                itemid:devices
            },
            success: function (res) {
                console.log(res);
                if(res.code==200){
                    //var data2 = res.data;
                    //console.log(data2.name);
                    $("#device_name").attr("value",res.name);
                }
            }
        });
        $.ajax({
            type : "GET",
            url : "http://123.56.71.230:889/cms/task/task_getnamedesc.jsp",
            dataType:"json",
            //jsonpCallback:"callback",
            data:{
                ChannelID:16532,
                itemid:bespeaks
            },
            success: function (res) {
                console.log(res);
                if(res.code==200){
                    //var data2 = res.data;
                    //console.log(data2.name);
                    $("#bespeak_name").attr("value",res.name);
                }
            }
        });


    })

</script>
</body>
</html>

