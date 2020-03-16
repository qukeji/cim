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
     * 接口配置页  2019-11-05  王力
     */
    int type = getIntParameter(request, "type");
    TableUtil tu = new TableUtil();
    if (type != 0) {
        int id = getIntParameter(request, "id");
        String WebDocument = getParameter(request, "WebDocument");
        String WebDocumentPv = getParameter(request, "WebDocumentPv");
        String AppDocument = getParameter(request, "AppDocument");
        String AppDocumentPv = getParameter(request, "AppDocumentPv");
        String WeixinDocument = getParameter(request, "WeixinDocument");
        String WeixinDocumentPv = getParameter(request, "WeixinDocumentPv");
        String SubjectUse = getParameter(request, "SubjectUse");
        String VideoUpload = getParameter(request, "VideoUpload");
        String sql = "";
        if(id==0){//新增
            sql = "insert into channel_connector_setting (Title,WebDocument,WebDocumentPv,AppDocument,AppDocumentPv,WeixinDocument,WeixinDocumentPv," +
                    "SubjectUse,VideoUpload) values ('接口配置','"+ WebDocument+"','"+WebDocumentPv+"','"+AppDocument+"','"+AppDocumentPv+"','"+WeixinDocument+"','"+
                    WeixinDocumentPv+"','"+SubjectUse+"','"+VideoUpload +"')";
            tu.executeUpdate(sql);
        }else{//修改
            sql = "update channel_connector_setting set WebDocument='"+WebDocument+"',WebDocumentPv='"+WebDocumentPv+"',AppDocument='"+AppDocument+"',AppDocumentPv='"+AppDocumentPv
                    +"',WeixinDocument='"+WeixinDocument+"',WeixinDocumentPv='"+WeixinDocumentPv+"',SubjectUse='"+SubjectUse+"',VideoUpload='"+VideoUpload+"' where id="+id;
            tu.executeUpdate(sql);
        }
        return;
    }
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
            <span class="breadcrumb-item active">工作绩效管理系统 / 接口设置</span>
        </nav>
    </div>
</div>
<%
    String sql = "select * from channel_connector_setting";
    ResultSet rs = tu.executeQuery(sql);
    int id = 0;
    String webDocument ="";
    String WebDocumentPv ="";
    String AppDocument ="";
    String AppDocumentPv ="";
    String WeixinDocument ="";
    String WeixinDocumentPv ="";
    String SubjectUse ="";
    String VideoUpload ="";
    if (rs.next()) {
        id = rs.getInt("id");
        webDocument = rs.getString("WebDocument");
        WebDocumentPv = rs.getString("WebDocumentPv");
        AppDocument = rs.getString("AppDocument");
        AppDocumentPv = rs.getString("AppDocumentPv");
        WeixinDocument = rs.getString("WeixinDocument");
        WeixinDocumentPv = rs.getString("WeixinDocumentPv");
        SubjectUse = rs.getString("SubjectUse");
        VideoUpload = rs.getString("VideoUpload");
    }
    tu.closeRs(rs);
%>
<form action="interface_content.jsp" id="form" method="post">
    <div style="padding:20px;">
        <div class="bg-white" style="padding: 15px;">
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">网站发稿量：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="WebDocument" size="80" value="<%=webDocument%>">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">网站稿件PV：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="WebDocumentPv" size="80" value="<%=WebDocumentPv%>">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">客户端发稿量：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="AppDocument" size="80" value="<%=AppDocument%>">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">客户端稿件PV：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="AppDocumentPv" size="80" value="<%=AppDocumentPv%>">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">微信发稿量：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="WeixinDocument" size="80" value="<%=WeixinDocument%>">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">微信稿件PV：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="WeixinDocumentPv" size="80" value="<%=WeixinDocumentPv%>">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">选题采用量：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="SubjectUse" size="80" value="<%=SubjectUse%>">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <div class="row flex-row align-items-center mg-b-15 mg-l-10">
                <label class="wd-120">视频上传量：</label>
                <label class="wd-content-lable d-flex wd-sm-table">
                    <input class="form-control" placeholder="" type="text" name="VideoUpload" size="80" value="<%=VideoUpload%>">
                </label>
                <label><span class="mg-l-10"></span></label>
            </div>
            <label class="d-flex align-items-center tx-gray-800 tx-12 mg-l-20">
                <i class="icon ion-information-circled tx-16 tx-gray-900 mg-r-5"></i>
                此处填写不同指标数据入库接口地址，<a>接口示例。</a>数据从保存后开始入库，采用拉取方式，每天00:00拉取前一天数据；
            </label>
        </div>
        <div class="br-pagebody mg-r-20 mg-t-20" url="" id="">
            <div class="br-content-box pd-20">
                <div class="row flex-row align-items-center mg-b-15 justify-content-center" id="tr_Title">
                    <input name="type" value="1" type="hidden">
                    <button type="button" class="btn btn-primary tx-size-xs pd-x-30" onclick="save()">保存
                    </button>
                </div>
            </div>
        </div>
    </div>
</form>
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
    var id = <%=id%>;
    function save() {
        $.ajax({
            url: 'interface_content.jsp?id='+id,
            type: 'POST',
            data: $('#form').serialize(),
            success: function (res) {
                if(id == 0){
                    TideAlert("提示","新增成功!");
                }else{
                    TideAlert("提示","修改成功!");
                }
                window.location.reload();
            }
        })
    }

</script>
</body>

</html>
