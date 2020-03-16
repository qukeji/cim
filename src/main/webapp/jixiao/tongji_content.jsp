<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp" %>
<%
    /**
     * 用途：文档列表页
     * 1,李永海 20140101 创建
     * 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
     * 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
     */
    String uri = request.getRequestURI();
    long begin_time = System.currentTimeMillis();
    String type = getParameter(request, "type");
    String assessIndicator = "";
    String ListSql = "";
    String CountSql = "";
    JiXiaoUtil jiXiaoUtil = new JiXiaoUtil();
    boolean b = false;
    if (type.equals("appscore")) {//客户端发稿量
        assessIndicator = "客户端发稿量";
        String tableName = jiXiaoUtil.getTableNameByCompany(0, 3);
        ListSql = "select user,count(*) sum,ModifiedDate,FROM_UNIXTIME(PublishDate,'%Y-%m-%d') pd from " + tableName;
        CountSql = "select count(*) from (select FROM_UNIXTIME(PublishDate,'%Y-%m-%d') pd from " + tableName;
        b = true;
    } else if (type.equals("weixin_score")) {
        assessIndicator = "微信发稿量";
        String tableName = jiXiaoUtil.getTableNameByCompany(0, 5);
        ListSql = "select user,count(*) sum,ModifiedDate,FROM_UNIXTIME(PublishDate,'%Y-%m-%d') pd from " + tableName;
        CountSql = "select count(*) from (select FROM_UNIXTIME(PublishDate,'%Y-%m-%d') pd from " + tableName;
        b = true;
    } else if (type.equals("subject_score")) {
        response.sendRedirect("subject.jsp?type=" + type);
    } else if (type.equals("video_score")) {
        response.sendRedirect("video.jsp?type=" + type);
    }
    String S_User = getParameter(request, "User");
    String S_startDate = getParameter(request, "startDate");
    String S_endDate = getParameter(request, "endDate");
    int currPage = getIntParameter(request, "currPage");
    int rowsPerPage = getIntParameter(request, "rowsPerPage");
    int rows = getIntParameter(request, "rows");
    int cols = getIntParameter(request, "cols");
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
    String whereSql = " where 1=1";

    int UserId = 0;

    if (!S_User.equals("")) {
        String sql2 = "select * from userinfo where Name='" + S_User + "'";
        TableUtil tu2 = new TableUtil("user");
        ResultSet Rs2 = tu2.executeQuery(sql2);
        if (Rs2.next()) {
            UserId = Rs2.getInt("id");
        } else {
            UserId = 0;
        }
    }

    String querystring = "";
    querystring = "&startDate=" + S_startDate + "&endDate=" + S_endDate + "&User=" + UserId;

    if (UserId != 0) {
        whereSql += " and user=" + UserId;
    }
    if (!S_startDate.equals("")) {
        long startTime = Util.getFromTime(S_startDate, "");
        whereSql += " and PublishDate>=" + startTime;
    }
    if (!S_endDate.equals("")) {
        long endTime = Util.getFromTime(S_endDate, "");
        whereSql += " and PublishDate<" + (endTime + 86400);
    }
    ListSql += whereSql + " group by pd,user order by pd desc";
    CountSql += whereSql + " group by pd,user) a order by pd desc";
    int listnum = rowsPerPage;
    System.out.println("ListSql=" + ListSql);
    System.out.println("CountSql=" + CountSql);
    TableUtil tu = new TableUtil();
    int TotalPageNumber = 0;
    int TotalNumber = 0;
    ResultSet rs = null;
    if (b) {
        rs = tu.List(ListSql, CountSql, currPage, listnum);
        TotalPageNumber = tu.pagecontrol.getMaxPages();
        TotalNumber = tu.pagecontrol.getRowsCount();
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

        table.table-fixed {
            table-layout: fixed;
            word-break: break-all;
            word-wrap: break-word
        }

        table.table-fixed, table.table-fixed th, table.table-fixed td {
            border: 1px solid #dee2e6;
            border-collapse: collapse !important;
        }

        .list-pic-box {
            width: 100%;
            height: 0;
            padding-bottom: 56.25%;
            overflow: hidden;
            text-align: center;
            position: relative;
        }

        /*.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}*/
        .list-pic-box .list-img-contanier {
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
        var rows = <%=rows%>;
        var cols = <%=cols%>;
        var pageName = "<%=pageName%>";
        if (pageName == "") pageName = "tongji_pv_content.jsp";

        function gopage(currpage) {
            var url = pageName + "?type=<%=type%>&currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
            this.location = url;
        }

        function change1(s) {
            var value = jQuery(s).val();
            var exp = new Date();
            exp.setTime(exp.getTime() + 300 * 24 * 60 * 60 * 1000);
            document.cookie = "rowsPerPage_new=" + value;
            window.location.href = pageName + "?type=<%=type%>&rowsPerPage=" + value;
        }
    </script>
</head>
<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">工作绩效管理系统 / 统计数据</span>
        </nav>
    </div>
    <div class="mg-sm-b-30 mg-sm-t-30">
        <div class="btn-group mg-l-30 hidden-xs-down">
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>

        <!--上一页 下一页-->
        <div class="btn-group mg-r-30" style="float: right;">
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
    <!--搜索-->
    <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
        <div class="search-content bg-white">
            <form name="search_form" action="<%=pageName%>?type=<%=type%>&rowsPerPage=<%=rowsPerPage%>"
                  method="post" onsubmit="return check();">
                <div class="row">
                    <!--日期-->
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD"
                                   name="startDate" value="<%=S_startDate%>" id="startDate">
                        </div>
                    </div>
                    <div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD"
                                   name="endDate" value="<%=S_endDate%>" id="endDate">
                        </div>
                    </div>
                    <!-- wd-200 -->
                    <!--作者-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-person tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control search-author" placeholder="作者" name="User"
                                   value="<%=S_User%>">
                        </div>
                    </div>
                    <div class="search-item mg-b-30">
                        <input type="hidden" name="IsIncludeSubChannel" value="1">
                        <input type="submit" name="Submit" value="搜索"
                               class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                        <input type="hidden" name="OpenSearch" id="OpenSearch" value="1">
                    </div>
                </div>
                <!-- row -->
            </form>
        </div>
    </div>
    <!--搜索-->

    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0" id="content-table">
                <thead>
                <tr>
                    <th class="">姓名</th>
                    <th class="tx-12-force tx-mont tx-medium">发稿量</th>
                    <th class="tx-12-force tx-mont tx-medium">统计日期</th>
                    <th class="tx-12-force tx-mont tx-medium">最后更新时间</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (b) {
                        int j = 0;
                        int m = 0;
                        while (rs.next()) {
                            int user_id = rs.getInt("user");
                            String name = CmsCache.getUser(user_id).getName();
                            String userName = CmsCache.getUser(user_id).getName();
                            int sum = rs.getInt("sum");
                            String PublishDate = rs.getString("pd");
                            String ModifiedDate = rs.getString("ModifiedDate");
                            ModifiedDate = Util.FormatTimeStamp("yyyy-MM-dd HH:mm", Long.parseLong(ModifiedDate));
                            j++;
                %>
                <tr No="<%=j%>" ItemID="" OrderNumber="" status="" GlobalID="" id="item_" class="tide_item">
                    <td class="">
                        <%=userName%>
                    </td>
                    <td class="">
                        <%=sum%>
                    </td>
                    <td class="">
                        <%=PublishDate%>
                    </td>
                    <td class="">
                        <%=ModifiedDate%>
                    </td>
                </tr>
                <%
                        }
                        tu.closeRs(rs);
                    }
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
                <div class="each-page-num mg-l-auto">
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
            <!--分页-->
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
        <div class="btn-group mg-r-30 float-right">
            <%if (currPage > 1) {%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if (currPage < TotalPageNumber) {%>
            <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
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
        // Datepicker
        tidecms.setDatePicker(".fc-datepicker");
    })
    var page = {
        currPage: '<%=currPage%>',
        rowsPerPage: '<%=rowsPerPage%>',
        querystring: '<%=querystring%>',
        TotalPageNumber: <%=TotalPageNumber%>
    };
</script>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->

</body>

</html>
