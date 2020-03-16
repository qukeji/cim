<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 java.util.*,
                 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    /**
     * 用途：文档列表页
     * 1,李永海 20140101 创建
     * 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
     * 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
     */
    String uri = request.getRequestURI();
    int reportid = getIntParameter(request, "reportid");
    int schemeId = getIntParameter(request, "schemeId");
    int currPage = getIntParameter(request, "currPage");
    int rowsPerPage = getIntParameter(request, "rowsPerPage");
    if (currPage < 1)
        currPage = 1;
    if (rowsPerPage == 0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new", request.getCookies()));
    if (rowsPerPage <= 0)
        rowsPerPage = 20;
    String pageName = request.getServletPath();
    int pindex = pageName.lastIndexOf("/");
    if (pindex != -1)
        pageName = pageName.substring(pindex + 1);
    String tableName = CmsCache.getChannel("user_performance").getTableName();
    String ListSql = "select * from " + tableName + " where report_id = " + reportid + " order by score desc";
    String CountSql = "select count(*) from " + tableName + " where report_id = " + reportid + " order by score desc";
    String sql1 = "select AssessIndicator from channel_jixiao_scheme where id=" + schemeId;
    TableUtil tu = new TableUtil();
    ResultSet resultSet = tu.executeQuery(sql1);
    String AssessIndicator = "";
    if (resultSet.next()) {
        AssessIndicator = resultSet.getString("AssessIndicator");
    }
    tu.closeRs(resultSet);
    System.out.println(tu == null);
    ResultSet rs = null;
    try {
        rs = tu.List(ListSql, CountSql, currPage, rowsPerPage);
    } catch (Exception e) {
        e.printStackTrace();
    }
    int TotalPageNumber = tu.pagecontrol.getMaxPages();
    int TotalNumber = tu.pagecontrol.getRowsCount();
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

        table table.table-fixed th, table.table-fixed td {
            border: 1px solid #dee2e6;
            border-collapse: collapse !important;
        }

        .list-pic-box {
            width: 100%;
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .list-pic-box .list-img-contanier img {
            width: auto;
            max-height: 100%;
            max-width: 100%;
        }

        @media (max-width: 575px) {
            #content-table .hidden-xs-down {
                word-break: normal;
            }
        }

        .hidden-xs-down {
            text-align: center;
        }

        .tide_item {
            height: 50px;
        }
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
    <script>

        var listType = 1;
        var pageName = "<%=pageName%>";
        if (pageName == "") pageName = "look_perfor_content.jsp";

        function gopage(currpage) {
            var url = pageName + "?reportid=<%=reportid%>&schemeId=<%=schemeId%>&currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%>";
            this.location = url;
        }

        function change1(s) {
            var value = jQuery(s).val();
            var exp = new Date();
            exp.setTime(exp.getTime() + 300 * 24 * 60 * 60 * 1000);
            document.cookie = "rowsPerPage_new=" + value;
            window.location.href = pageName + "?reportid=<%=reportid%>&schemeId=<%=schemeId%>&rowsPerPage=" + value;
        }

        function exportExcel() {

            var url = "export_excel_look_jixiao.jsp?schemeId=<%=schemeId%>&reportid=<%=reportid%>";
            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (msg) {
                    if (msg.message == "") {
                        var filename = msg.filename;//获取Excel文件名称
                        var frame = '<iframe id="Download_excel"  name="Download_excel" style="display:none;width:0px;height:0px;"></iframe>';
                        jQuery("body").append(frame);
                        window.frames["Download_excel"].location = "/tcenter/wenzheng/excel_download.jsp?Charset=utf-8&FileName=" + filename + "";
                    } else {
                        alert(msg.message)
                    }
                }

            })
        }
    </script>
</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">工作绩效管理系统 / 查看绩效</span>
        </nav>
    </div>
    <div class=" align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30" style="height: 60px;">

        <!--上一页 下一页-->
        <div class="btn-group" style="float: right;">
            <a href="javascript:gopage(2)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
        </div>
        <div class="btn-group float-right mg-r-30 hidden-xs-down">
            <a href="javascript:exportExcel();" class="btn btn-outline-info">导出</a>
        </div>
    </div>

    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0" id="content-table" style="text-align: center">
                <thead>
                <tr>
                    <th class="wd-5p wd-50 hidden-xs-down">排名</th>
                    <th class="tx-12-force tx-mont tx-medium wd-100 hidden-xs-down">姓名</th>
                    <%if (AssessIndicator.contains("1")) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">网站发稿量分值</th>
                    <%}%>
                    <%if (AssessIndicator.contains("2")) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">网站稿件PV分值</th>
                    <%}%>
                    <%if (AssessIndicator.contains("3")) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">客户端发稿量分值</th>
                    <%}%>
                    <%if (AssessIndicator.contains("4")) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">客户端稿件PV分值</th>
                    <%}%>
                    <%if (AssessIndicator.contains("5")) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">微信发稿分值</th>
                    <%}%>
                    <%if (AssessIndicator.contains("6")) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">微信稿件PV分值</th>
                    <%}%>
                    <%if (AssessIndicator.contains("7")) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">选题采用量分值</th>
                    <%}%>
                    <%if (AssessIndicator.contains("8")) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">视频上传量分值</th>
                    <%}%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down">总分值</th>
                </tr>
                </thead>
                <tbody>
                <%

                    int j = 0;
                    while (rs.next()) {
                        int user_id = rs.getInt("user_id");
                        double score = rs.getDouble("score");
                        String userName = Util.connectHttpUrl("http://183.58.24.156:888/jushi/jixiao/getUserNameById.jsp?userid=" + user_id, "UTF-8");
                        double web_score = rs.getDouble("web_score");
                        double web_pv_score = rs.getDouble("web_pv_score");
                        double app_score = rs.getDouble("app_score");
                        double app_pv_score = rs.getDouble("app_pv_score");
                        double weixin_score = rs.getDouble("weixin_score");
                        double weixin_pv_score = rs.getDouble("weixin_pv_score");
                        double subject_score = rs.getDouble("subject_score");
                        double video_score = rs.getDouble("video_score");
                        j++;
                %>
                <tr No="<%=j%>" ItemID="" OrderNumber="" status="" GlobalID="" id="item_" class="tide_item">
                    <td class="hidden-xs-down">
                        <%=j%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=userName%>
                    </td>
                    <%if (AssessIndicator.contains("1")) {%>
                    <td class="hidden-xs-down">
                        <%=web_score%>
                    </td>
                    <%}%>
                    <%if (AssessIndicator.contains("2")) {%>
                    <td class="hidden-xs-down">
                        <%=web_pv_score%>
                    </td>
                    <%}%>
                    <%if (AssessIndicator.contains("3")) {%>
                    <td class="hidden-xs-down">
                        <%=app_score%>
                    </td>
                    <%}%>
                    <%if (AssessIndicator.contains("4")) {%>
                    <td class="hidden-xs-down">
                        <%=app_pv_score%>
                    </td>
                    <%}%>
                    <%if (AssessIndicator.contains("5")) {%>
                    <td class="hidden-xs-down">
                        <%=weixin_score%>
                    </td>
                    <%}%>
                    <%if (AssessIndicator.contains("6")) {%>
                    <td class="hidden-xs-down">
                        <%=weixin_pv_score%>
                    </td>
                    <%}%>
                    <%if (AssessIndicator.contains("7")) {%>
                    <td class="hidden-xs-down">
                        <%=subject_score%>
                    </td>
                    <%}%>
                    <%if (AssessIndicator.contains("8")) {%>
                    <td class="hidden-xs-down">
                        <%=video_score%>
                    </td>
                    <%}%>
                    <td class="hidden-xs-down">
                        <%=score%>
                    </td>
                </tr>
                <%
                    }
                    tu.closeRs(rs);
                %>
                </tbody>
            </table>

            <%if (TotalPageNumber > 0) {%>
            <!--分页-->
            <div id="tide_content_tfoot">
                <span class="mg-r-20 ">共<%=TotalNumber%>条</span>
                <span class="mg-r-20 "><%=currPage%>/<%=TotalPageNumber%>页</span>

                <%if (TotalPageNumber > 1) {%>
                <div class="jump_page ">
                    <span class="">跳至:</span>
                    <label class="wd-60 mg-b-0">
                        <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                    </label>
                    <span class="">页</span>
                    <a href="javascript:jumpPage();" class="tx-14">Go</a>
                </div>
                <%}%>
                <div class="each-page-num mg-l-auto d-flex align-items-center">
                    <span class="">每页显示:</span>
                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder=""
                            onChange="change1('#rowsPerPage');" id="rowsPerPage">
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="20">20</option>
                        <option value="25">25</option>
                        <option value="30">30</option>
                        <option value="50">50</option>
                        <option value="80">80</option>
                        <option value="100">100</option>
                        <option value="500">500</option>
                        <option value="1000">1000</option>
                        <option value="5000">5000</option>
                    </select>
                    <span class="">条</span>
                </div>
                <%}%>
            </div>

            <div class="table-page-info" style="display: none;">
                <div class="ckbox-parent">
                    <label class="ckbox mg-b-0">
                        <input type="checkbox" id="checkAll"><span></span>
                    </label>
                </div>
            </div>

        </div>
    </div>

    <div class="align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
        <!--上一页 下一页-->
        <div class="btn-group float-right">
            <%if (currPage > 1) {%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i
                    class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if (currPage < TotalPageNumber) {%>
            <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i
                    class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
    </div>
</div>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script src="../common/2018/bracket.js"></script>
<script type="text/javascript" src="../common/2018/jquery.contextmenu.js"></script>
<script type="text/javascript" src="../common/jquery.tablesorter.js"></script>
<script>
    $(function () {
        $(".btn-search").click(function () {
            $(".search-box").toggle(100);
        })
    })
    var page = {
        currPage: '<%=currPage%>',
        rowsPerPage: '<%=rowsPerPage%>',
        TotalPageNumber: <%=TotalPageNumber%>
    };
</script>
</body>

</html>
