<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 java.util.*,
                 java.sql.*" %>
<%@ page import="tidemedia.cms.web.Web" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp" %>
<%
    /**
     * 通知配置页  2019-11-06  王力
     */

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>TideCMS 列表</title>
    <link href="../lib/2018/jquery-toggles/toggles-full.css" rel="stylesheet">
    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="../lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <link href="../style/contextMenu.css" type="text/css" rel="stylesheet"/>
    <style>
        .collapsed-menu .br-mainpanel-file {
            margin-left: 0;
            margin-top: 0;
        }

        table {
            table-layout: fixed;
            word-break: break-all;
            word-wrap: break-word
        }

        table. table.table-fixed th, table.table-fixed td {
            border: 1px solid #dee2e6;
            border-collapse: collapse !important;
        }

        .list-pic-box .list-img-contanier img {
            width: auto;
            max-height: 100%;
            max-width: 100%;
        }
        .collapsed-menu .br-mainpanel-file {
            margin: 0px;
        }
    </style>
    <style>
        .collapsed-menu .br-mainpanel-file{margin:0px;margin-bottom: 30px;}
        #nav-header{line-height: 60px;margin-left: 20px;color: #a4aab0;font-style: normal;}
        #nav-header a{color: #a4aab0;}
        .wd-content-lable.wd-sm-table{width: 400px;}
        .app-img-box{max-width: 800px;}
        .app-img-box img{max-width: 100%}
        .row{margin-left:0;margin-right: 0 }
        .wd-content-ckx label{margin-bottom: 0}
        .start_type_item{display:none;}
        .start_type_item.show{display:flex;}
        #start_label .rdiobox{cursor:pointer;}
        @media (max-width: 1200px) {
            .wd-content-lable.wd-sm-table{width: 300px;}
        }
        @media (max-width: 992px) {
            .collapsed-menu .br-mainpanel-file {margin-left: 0;}
        }
        .bs-tooltip-bottom .tooltip-inner {padding: 8px 15px;font-size: 13px;border-radius: 3px;color: #ffffff;background-color: #f8f9fa;opacity: 1;}
        .tooltip.bs-tooltip-bottom .arrow::before,
        .tooltip.bs-tooltip-auto[x-placement^="bottom"] .arrow::before {border-bottom-color: #f8f9fa;	}
        .sp-replacer{
            width:20px;
            height:20px;
            position: absolute;
            top:10px;
            right:15px;
            background: url(../images/apppack/color_icon.png) no-repeat 0 0;
            border:none;
        }
        .position-re {
            position: relative;
        }
        .sp-preview {
            width: 0;
        }
        ul,li{list-style: none;}
        .pics-ul{max-height: 400px;margin-bottom: 5px;max-width:320px}
        .slide-pics img{width: 100%;}
        .pics-ul li{display: none;}
        .pics-ul li{display: none;}
        .pic-btn{background-color: #ccc;border-color: #ccc;}
        .pics-ul li:first-of-type{display: block;}
        .pics-btn .btn{padding: 0.3rem 0.75rem;}
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
    <script>
        var listType = 1;
    </script>
</head>
<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">工作绩效管理系统 / 通知设置</span>
        </nav>
    </div>
</div>
<%
%>
<form action="interface_content.jsp" id="form" method="post">
    <div style="padding:20px;">
        <div class="bg-white" style="padding: 15px;">
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">邮件通知：</label>
                <div class="toggle-wrapper">
                    <input id="email" type="hidden" value="0">
                    <div class="toggle toggle-light success" data-toggle-on="true" field="email"
                         style="height: 25px; width: 60px;">
                        <div class="toggle-slide">
                            <div class="toggle-inner" style="width: 95px; margin-left: 0px;">
                                <div class="toggle-on active" style="height: 25px; width: 47.5px; text-indent: -8.33333px; line-height: 25px;">ON</div>
                                <div class="toggle-blob" style="height: 25px; width: 25px; margin-left: -12.5px;"></div>
                                <div class="toggle-off" style="height: 25px; width: 47.5px; margin-left: -12.5px; text-indent: 8.33333px; line-height: 25px;">OFF</div>
                            </div>
                        </div>
                    </div>
                </div>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">邮件地址：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="WebDocumentPv" size="80" value="">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <label class="d-flex align-items-center tx-gray-800 tx-12 mg-l-120">
                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                多个邮件地址使用英文逗号分隔，数据生成后自动发送统计数据文件。
            </label>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">短信通知：</label>
                <div class="toggle-wrapper">
                    <input id="node" type="hidden" value="0">
                    <div class="toggle toggle-light success" data-toggle-on="true" field="note"
                         style="height: 25px; width: 60px;">
                        <div class="toggle-slide">
                            <div class="toggle-inner" style="width: 95px; margin-left: 0px;">
                                <div class="toggle-on active" style="height: 25px; width: 47.5px; text-indent: -8.33333px; line-height: 25px;">ON</div>
                                <div class="toggle-blob" style="height: 25px; width: 25px; margin-left: -12.5px;"></div>
                                <div class="toggle-off" style="height: 25px; width: 47.5px; margin-left: -12.5px; text-indent: 8.33333px; line-height: 25px;">OFF</div>
                            </div>
                        </div>
                    </div>
                </div>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">手机号：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="WebDocumentPv" size="80" value="">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <label class="d-flex align-items-center tx-gray-800 tx-12 mg-l-120">
                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                多个手机号使用英文逗号分隔，数据生成后自动发送通知短信。
            </label>
        </div>
        <div class="mg-r-20 mg-t-20" url="" id="">
            <div class="br-content-box">
                <div class="row flex-row align-items-center mg-b-15 justify-content-center" id="tr_Title">
                    <input name="type" value="1" type="hidden">
                    <button type="button" class="btn btn-primary tx-size-xs pd-x-30" onclick="save()">保存
                    </button>
                </div>
            </div>
        </div>
    </div>
</form>
<script src="../lib/2018/jquery-toggles/toggles.min.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>
<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script>

    function save() {
        $.ajax({
            url: 'interface_content.jsp?id=' + id,
            type: 'POST',
            data: $('#form').serialize(),
            success: function (res) {
                if (id == 0) {
                    TideAlert("提示", "新增成功!");
                } else {
                    TideAlert("提示", "修改成功!");
                }
                window.location.reload();
            }
        })
    }

</script>
</body>

</html>
