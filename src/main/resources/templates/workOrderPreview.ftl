
<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Meta -->
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico"/>
    <title>工单详情</title>
    <link href="${request.contextPath}/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="${request.contextPath}/style/2018/bracket.css">
    <link rel="stylesheet" href="${request.contextPath}/style/2018/common.css">
    <link href="${request.contextPath}/style/contextMenu.css" type="text/css" rel="stylesheet" />
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
    <script src="${request.contextPath}/lib/2018/jquery/jquery.js"></script>
    <script>

        function updateState(state){
            var url= "${request.contextPath}/workorder/upadteState?id=${id}&operation_status="+state;
            $.ajax({
                type: "GET",
                url: url,
                success: function(msg){
                    if(msg.trim()!=""){
                        alert(msg.trim());
                    }else{
                        document.location.reload();
                    }
                }
            });
        }
        function reply(){
            var url= "${request.contextPath}/operate/job/job_back.jsp?ItemID=${id}";
            var	dialog = new top.TideDialog();
            dialog.setWidth(540);
            dialog.setHeight(280);
            dialog.setUrl(url);
            dialog.setTitle("回复");
            dialog.show();
        }
    </script>
</head>
<style>
    html, body {
        width: 100%;
        height: 100%;
    }

    .wd-content-lable {
        flex: 1;
    }

    div.wd-content-div {
        display: block;
        width: 100%;
        flex: 1;
    }

    div.wd-content-div p {
        line-height: 1.5;
    }

    div.wd-content-div img {
        max-width: 100%;;
        margin: 5px 0;
    }

    div.wd-content-img {
        max-width: 300px;
        display: block;
    }

    div.wd-content-img img {
        max-width: 100%;
    }

    .table-responsive th, .table-responsive td {
        text-align: center;
    }

    @media (max-width: 575px) {
        .wd-content-lable {
            flex: auto;
        }

        div.wd-content-div {
            display: block;
            width: 100%;
            flex: auto;
        }
    }
</style>


<body class="collapsed-menu email" id="withSecondNav">
<script type="text/javascript">document.body.disabled = true;</script>
<div class="br-logo"><img src="../images/2018/system-logo.png"></div>
<div class="br-sideleft overflow-y-auto">
    <label class="sidebar-label pd-x-15 mg-t-20"></label>
    <div class="br-sideleft-menu">
        <a href="javascript:showTab('1')" class='br-menu-link active' id="form1_td" data-toggle="tooltip" data-placement="right" title="内容编辑">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-edit tx-22"></i>
                <span class="menu-item-label">内容编辑</span>
            </div><!-- menu-item -->
        </a><!-- br-menu-link -->
    </div><!-- br-sideleft-menu -->
</div><!-- br-sideleft -->
<!-- br-header -->
<div class="br-header">
    <div class="br-header-left">
        <div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
        <div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
        <div id="nav-header" class="hidden-md-down flex-row align-items-center">
        </div>
    </div><!-- br-header-left -->
    <div class="br-header-right">
        <#if operationStatus == 2>
            <div class="btn-box" >
                <button type="button"  class="btn btn-secondary tx-size-xs mg-r-10" onclick="self.close();window.opener.document.location.reload();">关闭</button>
            </div>
        <#else>
            <div class="btn-box" >
                <#if  company != 0 || myCreate>
                    <button type="button" class="btn btn-primary tx-size-xs mg-r-5"  onclick="updateState(2);">结束</button>
                </#if>
                <#if (replyList?size)==0 &&company==0>
                    <button type="button" class="btn btn-primary tx-size-xs mg-r-5"  onclick="reply();">回复</button>
                </#if>
                <button type="button"  class="btn btn-secondary tx-size-xs mg-r-10" onclick="self.close();window.opener.document.location.reload();">关闭</button>
            </div>
        </#if>
    </div><!-- br-header-right -->
</div>
<!-- br-header -->
<div class="br-mainpanel br-mainpanel-file overflow-hidden" url="" id="form1">
    <div class="row row-sm mg-t-0">
        <div class="col-sm-8 pd-r-0-force colapprove">
            <div class="br-pagebody bg-white mg-l-20 mg-r-20 ">
                <div class="br-content-box pd-20">
                    <div class="center">
                        <div class="article-title mg-l-15 mg-b-15 pd-r-30">
                            <div class="row flex-row align-items-center mg-b-15" id="">
                                <label class="left-fn-title wd-120" id=''>工单名称：</label>
                                <label class="wd-content-lable d-flex " id="">
                                    ${Title}
                                </label>
                            </div>
                            <div class="row flex-row align-items-center mg-b-15" id="">
                                <label class="left-fn-title wd-120" id=''>提交工单者：</label>
                                <label class="wd-content-lable d-flex " id="">
                                    ${UserName}
                                </label>
                            </div>
                            <div class="row flex-row align-items-center mg-b-15" id="">
                                <label class="left-fn-title wd-120" id=''>状态：</label>
                                <label class="wd-content-lable d-flex " id="">
                                    ${operation_status}
                                </label>
                            </div>
                            <div class="row flex-row align-items-center mg-b-15" id="">
                                <label class="left-fn-title wd-120" id=''>工单描述：</label>
                                <label class="wd-content-lable d-flex " id="">
                                    ${Summary}
                                </label>
                            </div>
                            <div class="row flex-row align-items-center mg-b-15" id="">
                                <label class="left-fn-title wd-120" id=''>提交时间：</label>
                                <label class="wd-content-lable d-flex " id="">
                                    ${PublishDate}
                                </label>
                            </div>

                        </div><!-- br-mainpanel -->
                    </div><!-- br-pagebody -->
                </div><!-- colapprove -->
            </div>
        </div>
        <!-- 操作栏 -->
        <div class="col-sm-4 pd-x-0-force">
            <div class="br-pagebody mg-l-0 mg-r-30 pd-x-0-force">
                <div class="bg-white">
                    <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
                        <h6 class="card-title tx-uppercase tx-12 mg-b-0">处理结果</h6>
                    </div>
                </div>

                <div class="approve_body">
                    <div class="card-body bg-white">
                        <#--<div class="mg-y-8 pd-l-20 tx-14">
                            <i class="fa fa-ellipsis-v"></i>
                        </div>-->
                        <div class="mg-y-5 sh-item d-flex justify-content-between align-items-center">
                            <p class="mg-b-0 tx-inverse tx-lato">
                                <span class="mg-r-7">
                                    提交：
                                </span>
                                <span class="mg-r-7">
                                    ${UserName}
                                </span>
                            </p>
                            <p class="mg-b-0 tx-sm">
                                ${PublishDate}
                            </p>
                        </div>
                        <div class="widget rounded_rect hcenter vmiddle"
                             style="left: 930px; top: 509px; z-index: 67; background-color: rgb(222, 226, 230); font-size: 14px; padding: 10px; border-width: 1px; border-style: solid; text-align: left; line-height: 20px; font-weight: normal; font-style: normal; opacity: 1;">
                             <span style="color: black;line-height: 2rem;margin-left: 10px;">
                                ${Summary}
                            </span>
                        </div>
                        <#list replyList as key>
                            <div class="mg-y-8 pd-l-20 tx-14"><i class="fa fa-ellipsis-v"></i> </div>
                            <div class="mg-y-5 sh-item d-flex justify-content-between align-items-center">
                                <p class="mg-b-0 tx-inverse tx-lato">
                                <span class="mg-r-7">
                                    平台管理员：
                                </span>
                                    <span class="mg-r-7 tx-success">
                                    ${key.fromUser}
                                </span>

                                </p>
                                <p class="mg-b-0 tx-sm">
                                    ${key.replyDate}
                                </p>
                            </div>
                            <div class="widget rounded_rect hcenter vmiddle" style="left: 930px; top: 509px; z-index: 67; background-color: rgb(222, 226, 230); font-size: 14px; padding: 10px; border-width: 1px; border-style: solid; text-align: left; line-height: 20px; font-weight: normal; font-style: normal; opacity: 1;"><span class="--mb--rich-text" style="font-family:SourceHanSansSC; font-weight:400; font-size:14px; color:rgb(16, 16, 16); font-style:normal; letter-spacing:0px; line-height:20px; text-decoration:none;">${key.replySummary}</span></div>
                        </#list>
                    </div>
                </div>
            </div>
        </div>
        <!-- 操作栏 -->
    </div>
</div>
<!-- ########## END: MAIN PANEL ########## -->

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/highlightjs/highlight.pack.js"></script>

<script src="../common/2018/bracket.js"></script>
<script>
    $(function() {
        'use strict';

        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

        $('.br-mailbox-list,.br-subleft').perfectScrollbar();

        $('#showMailBoxLeft').on('click', function(e) {
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
            shadowColor: "#ffffff",
            textColor: "000000",
            trigger: "hover"
        });

        //自定义部分
        var height = document.documentElement.clientHeight - 300;
        $('#summernote').summernote({
            height: height,
            lang: "zh-CN",
            focus: true,
            tooltip: false,
            callback: {

            }
        })
    });

    //refresh为true，刷新url
    function showTab(n,refresh)
    {
        if(document.body.disabled) return;

        for(i=1;i<=2;i++)
        {
            $("#form"+i).hide();
            $("#form"+i+"_td").removeClass('active');
        }
        $("#form"+n+"_td").addClass('active');
        $("#form"+n).show();
        var url = $("#form"+n).attr("url")+"";//alert(url);
        url = url.replace("itemid=0","itemid="+$("#ItemID").val());
        url = url.replace("globalid=0","globalid="+$("#GlobalID").val());
        if(url!="")
        {
            if($("#iframe"+n).attr("src")=="../null.jsp" || refresh) $("#iframe"+n).attr("src",url);//document.getElementById("iframe"+n).src = url;
        }
        if($("#iframe"+n).length>0){
            $("#form"+n).find(".br-content-box").css("background-color","#e9ecef")
            if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){
                $("#iframe"+n).get(0).style.height = $("#iframe"+n).get(0).contentWindow.document.body.scrollHeight+40+"px";
            }else{
                $("#iframe"+n).get(0).style.height = $("#iframe"+n).get(0).contentWindow.document.documentElement.scrollHeight+40+"px";
            }
        }

    }
</script>
</body>
</html>
