<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 tidemedia.cms.user.*,
                 org.json.*,
                 java.util.*,
                 java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="../config.jsp" %>
<%
    /**
     * 用途：文档列表页
     * 1,李永海 20140101 创建
     * 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
     * 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
     */
    String uri = request.getRequestURI();
    long begin_time = System.currentTimeMillis();
    int id = getIntParameter(request, "id");
    int currPage = getIntParameter(request, "currPage");
    int rowsPerPage = getIntParameter(request, "rowsPerPage");
    int sortable = getIntParameter(request, "sortable");
    int rows = getIntParameter(request, "rows");
    int cols = getIntParameter(request, "cols");
    int companyId = userinfo_session.getCompany();

    int Action = getIntParameter(request, "Action");
    String ListSql = "";

    String globalids = "";
    if (currPage < 1)
        currPage = 1;

    if (rowsPerPage == 0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new", request.getCookies()));

    if (rowsPerPage <= 0)
        rowsPerPage = 20;

    if (rows == 0)
        rows = Util.parseInt(Util.getCookieValue("rows_new", request.getCookies()));
    if (cols == 0)
        cols = Util.parseInt(Util.getCookieValue("cols_new", request.getCookies()));

    if (rows == 0)
        rows = 10;
    if (cols == 0)
        cols = 5;

    //分租户逻辑
    String sql = "select id from approve_scheme where company = " + companyId;
    System.out.println("sql="+sql);
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    int schemeId = 0;
    if (rs.next()) {
        schemeId = rs.getInt("id");
    }
    String sql1 = "select id from approve_items where parent = " + schemeId;
    System.out.println("sql1="+sql1);
    ResultSet rs1 = tu.executeQuery(sql1);
    String itemsIds = "";
    while (rs1.next()) {
        if (itemsIds.length() == 0) {
            itemsIds += rs1.getInt("id");
        } else {
            itemsIds += "," + rs1.getInt("id");
        }
    }
    tu.closeRs(rs);
    tu.closeRs(rs1);
    Channel channel = CmsCache.getChannel(id);

    boolean IsTopStatus = false;//是否置顶
    if (channel.getIsTop() == 1) {
        IsTopStatus = true;
    }


    Channel parentchannel = null;
    int ChannelID = channel.getId();
    String ChannelName = channel.getName();
    int IsWeight = channel.getIsWeight();
    int IsComment = channel.getIsComment();
    int IsClick = channel.getIsClick();
    String gids = "";


    if (channel.getListProgram().length() > 0 && uri.endsWith("/content/content2018.jsp")) {
        response.sendRedirect(channel.getListProgram() + "?id=" + id);
        return;
    }

    int ApproveScheme = channel.getApproveScheme();
    if (ApproveScheme != 0) {
        response.sendRedirect("../approve/content_approve.jsp?id=" + id);
        return;
    }

    String S_Title = getParameter(request, "Title");
    String S_startDate = getParameter(request, "startDate");
    String S_endDate = getParameter(request, "endDate");
    String S_User = getParameter(request, "User");
    int S_IsIncludeSubChannel = getIntParameter(request, "IsIncludeSubChannel");
    int S_Status = getIntParameter(request, "Status");
    int S_IsPhotoNews = getIntParameter(request, "IsPhotoNews");
    int S_OpenSearch = getIntParameter(request, "OpenSearch");
    int IsDelete = getIntParameter(request, "IsDelete");

    int Status1 = getIntParameter(request, "Status1");

    int listType = 0;
    listType = getIntParameter(request, "listtype");
    if (listType == 0) listType = Util.parseInt(Util.getCookieValue(id + "_list_new", request.getCookies()));
    if (listType == 0) listType = 1;

    boolean listAll = false;

    if (channel.getParent() == -1) {//说明是站点
        S_IsIncludeSubChannel = 0;
    }

    if (channel.isTableChannel() && channel.getType2() == 8) listAll = true;
    if (channel.getIsListAll() == 1) listAll = true;
    if (S_IsIncludeSubChannel == 1) listAll = true;

    if (channel.getType() == 2) {
        response.sendRedirect("../page/content_page.jsp?id=" + id);
        return;
    }


//如果是“新建应用”；
    if (channel.getType() == 3) {
        response.sendRedirect("app.jsp?id=" + id);
        return;
    }


    String querystring = "";
    querystring = "&Title=" + java.net.URLEncoder.encode(S_Title, "UTF-8") + "&startDate=" + S_startDate + "&endDate=" + S_endDate + "&User=" + S_User + "&Status=" + S_Status;

    String pageName = request.getServletPath();
    int pindex = pageName.lastIndexOf("/");
    if (pindex != -1)
        pageName = pageName.substring(pindex + 1);

    if (!channel.hasRight(userinfo_session, 1)) {

    }
    boolean canApprove = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanApprove);
    boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);
    boolean canAdd = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanAdd);
    boolean createCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);
    int canExcel = channel.getIsExportExcel();//是否导出Excel
    int canWord = channel.getIsImportWord();//是否导出world
    String SiteAddress = channel.getSite().getUrl();

    int userinfo_sessionid = userinfo_session.getId();
//获取频道路径
    String parentChannelPath = channel.getParentChannelPath().replaceAll(">", " / ");
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
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script>
        var listType = <%=listType%>;

    </script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>

</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">全部审核</span>
        </nav>
    </div>
    <!-- br-pageheader -->
    <%
        int S_UserID = 0;
        if (!S_User.equals("")) {
            String sql2 = "select * from userinfo where Name='" + S_User + "'";
            TableUtil tu2 = new TableUtil("user");
            ResultSet rs2 = tu2.executeQuery(sql2);
            if (rs2.next()) {
                S_UserID = rs2.getInt("id");
            } else {
                S_UserID = 0;
            }
        }

        if (channel.getIsWeight() == 1) {
            //权重排序
            java.util.Calendar nowDate = new java.util.GregorianCalendar();
            nowDate.set(Calendar.HOUR_OF_DAY, 0);
            nowDate.set(Calendar.MINUTE, 0);
            nowDate.set(Calendar.SECOND, 0);
            nowDate.set(Calendar.MILLISECOND, 0);
            long weightTime = nowDate.getTimeInMillis() / 1000;
        }
        JSONObject object = new ApproveDocument().getMyApprove(itemsIds,S_UserID, S_Status, request, "", currPage, rowsPerPage, S_Title, S_startDate, S_endDate);
        JSONArray jsonArray = object.getJSONArray("list");
        System.out.println(object);
        int sum = object.getInt("sum");
        int pageNum = object.getInt("pageNum");
        String Table = "approve_document";
        String CountSql = "";
        if (Action == 0) {
            ListSql = "select * from (select * from " + Table + " where Action > -1 order by CreateDate desc) a";
            CountSql = "select count(*) from (select * from (select * from " + Table + " where Action > -1 order by CreateDate desc) a";
        } else {
            ListSql = "select * from (select * from approve_document where Action = " + (Action - 1) + " order by ActionDate desc) a";
            CountSql = "select count(*) from (select * from (select * from " + Table + " where Action = " + (Action - 1) + " order by CreateDate desc) a";
        }

        String WhereSql = " where 1=1";

        if (!S_Title.equals("")) {
            String tempTitle = S_Title.replaceAll("%", "\\\\%");
            WhereSql += " and Title like '%" + channel.SQLQuote(tempTitle) + "%'";
        }
        if (!S_startDate.equals("")) {
            long startTime = Util.getFromTime(S_startDate, "");
            WhereSql += " and CreateDate>=" + startTime;
        }
        if (!S_endDate.equals("")) {
            long endTime = Util.getFromTime(S_endDate, "");
            WhereSql += " and CreateDate<" + (endTime + 86400);
        }

        /*if(S_Status!=0){
            WhereSql += " and Status=" + (S_Status-1);
        }*/

        ListSql += WhereSql;
        CountSql += WhereSql;

        ListSql += " group by GlobalID order by CreateDate desc";
        CountSql += " group by GlobalID ) b order by CreateDate desc";
// out.println(ListSql);

        int listnum = rowsPerPage;
        if (listType == 2) listnum = cols * rows;

        TableUtil tu1 = channel.getTableUtil();
        ResultSet rs2 = tu1.List(ListSql, CountSql, currPage, listnum);
        int TotalPageNumber = tu1.pagecontrol.getMaxPages();
        int TotalNumber = tu1.pagecontrol.getRowsCount();

    %>
    <!--操作-->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
            <div class="dropdown-menu pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:list();" class="nav-link list_all">全部</a>
                    <a href="javascript:list('Status1=-1');" class="nav-link list_draft">草稿</a>
                    <a href="javascript:list('Status1=1');" class="nav-link list_publish">已发</a>
                    <a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
                    <a href="#" class="nav-link">搜索</a>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端-->

        <div class="btn-group hidden-xs-down">
            <a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i
                    class="fa fa-th"></i></a>
            <a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i
                    class="fa fa-th-list"></i></a>
        </div>
        <!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
            <a href="javascript:list('Status=1');" class="btn btn-outline-info list_draft">未审核</a>
            <a href="javascript:list('Status=2');" class="btn btn-outline-info list_publish">审核通过</a>
            <a href="javascript:list('Status=3');" class="btn btn-outline-info list_delete">审核未通过</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <%if (canApprove) {%>
            <a href="javascript:approve();" class="btn btn-outline-info">发布</a>
            <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
            <%} else {%>
            <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
            <%}%>
            <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
            <a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>
            <%if (!channel.getRecommendOut().equals("")) {%>
            <a href="javascript:recommendOut()" class="btn btn-outline-info">推荐</a>
            <%}%>
            <%if (!channel.getAttribute1().equals("")) {%>
            <a href="javascript:recommendIn();" class="btn btn-outline-info hidden-md-1500-down">引用</a>
            <%}%>
            <a href="javascript:copy(0)" class="btn btn-outline-info hidden-md-1500-down">复制</a>
            <a href="javascript:copy(1)" class="btn btn-outline-info hidden-md-1500-down">移动</a>

            <%if (IsTopStatus) {%>
            <a href="javascript:ChangeTop(<%=id%>,1);" class="btn btn-outline-info hidden-md-1500-down">置顶</a>
            <a href="javascript:ChangeTop(<%=id%>,2);" class="btn btn-outline-info hidden-md-1500-down">撤销置顶</a>
            <%}%>
            <%if (canDelete) {%>
            <a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
            <%}%>

        </div>
        <!-- START: 按钮过多时的部分功能下拉 -->
        <div class="dropdown hidden-md-1500-up hidden-sm-down mg-l-10">
            <a href="#" class="btn btn-outline-info" data-toggle="dropdown">操作 <i
                    class="fa fa-angle-down mg-l-5"></i></a>
            <div class="dropdown-menu dropdown-menu-right pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <%if (!channel.getAttribute1().equals("")) {%>
                    <a href="javascript:recommendIn();" class="nav-link">引用</a>
                    <%}%>
                    <a href="javascript:copy(0);" class="nav-link">复制</a>
                    <a href="javascript:copy(1);" class="nav-link">移动</a>

                    <%if (IsTopStatus) {%>
                    <a href="javascript:ChangeTop(<%=id%>,1);" class="nav-link">置顶</a>
                    <a href="javascript:ChangeTop(<%=id%>,2);" class="nav-link">撤销置顶</a>
                    <%}%>
                    <%if (createCategory) {%>
                    <a href="javascript:createCategory(<%=ChannelID%>);" class="nav-link">新建分类</a>
                    <%}%>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 按钮过多时的部分功能下拉 -->
        <!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i
                    class="fa fa-angle-down mg-l-5"></i></a>
            <div class="dropdown-menu dropdown-menu-right pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:addDocument();" class="nav-link">新建</a>
                    <%if (canApprove) {%>
                    <a href="javascript:approve();" class="nav-link">发布</a>
                    <a href="javascript:Preview();" class="nav-link">预览</a>
                    <%} else {%>
                    <a href="javascript:Preview();" class="nav-link">预览</a>
                    <%}%>
                    <a href="javascript:editDocument1();" class="nav-link">编辑</a>
                    <a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
                    <%if (!channel.getRecommendOut().equals("")) {%>
                    <a href="javascript:recommendOut()" class="nav-link">推荐</a>
                    <%}%>
                    <%if (!channel.getAttribute1().equals("")) {%>
                    <a href="javascript:recommendIn();" class="nav-link">引用</a>
                    <%}%>
                    <a href="javascript:copy(0);" class="nav-link">复制</a>
                    <a href="javascript:copy(1);" class="nav-link">移动</a>

                    <%if (IsTopStatus) {%>
                    <a href="javascript:ChangeTop(<%=id%>,1);" class="nav-link">置顶</a>
                    <a href="javascript:ChangeTop(<%=id%>,2);" class="nav-link">撤销置顶</a>
                    <%}%>
                    <%if (canDelete) {%>
                    <a href="javascript:deleteFile();" class="nav-link">删除</a>
                    <%}%>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <!--上一页 下一页-->
        <div class="btn-group mg-l-10">
            <%if (currPage > 1) {%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i
                    class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if (currPage < TotalPageNumber) {%>
            <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i
                    class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
        <!-- btn-group -->

    </div>
    <!--操作-->

    <!--搜索-->
    <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
        <div class="search-content bg-white">
            <form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post"
                  onsubmit="return check();">
                <div class="row">
                    <!--标题-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <input class="form-control search-title" placeholder="标题" type="text" name="Title"
                               value="<%=S_Title%>" onClick="this.select()">
                    </div>
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
                    <!--状态-->
                    <%--<div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="状态" name="Status">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                            <option value="2" <%=(S_Status==2?"selected":"")%>>已发</option>
                            <option value="1" <%=(S_Status==1?"selected":"")%>>草稿</option>
                        </select>
                    </div>--%>
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

    <%if (1 == 1) {%>
    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" id="content-table">
                <%if (listType == 1) {%>
                <thead>
                <tr>
                    <th class="wd-5p wd-50">选择</th>
                    <th class="tx-12-force tx-mont tx-medium">标题</th>
                    <%if (IsWeight == 1) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">权重</th>
                    <%}%>
                    <th class="tx-12-force wd-350 tx-mont tx-medium hidden-xs-down wd-60">节点</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">审核状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">稿件状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">创建时间</th>
                    <%if (IsComment == 1) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">评论</th>
                    <%}%>
                    <%if (IsClick == 1) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">点击量</th>
                    <%}%>
                    <th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-160">操作</th>
                </tr>
                </thead>
                <%}%>
                <tbody>
                <%
                    int j = 0;
                    int m = 0;
                    for (int i = 0; i < jsonArray.length(); i++) {
                        JSONObject o = jsonArray.getJSONObject(i);
                        int GlobalID = (int) o.get("GlobalID");
                        Document document = CmsCache.getDocument(GlobalID);
                        int Status = document.getStatus();
                        int ChannelID2 = (int) o.get("ChannelID");
                        int id_ = (int) o.get("id");
                        String Title = o.get("title") + "";
                        String ApproveItemName = o.get("ApproveItemName") + "";
                        String documentStatus = o.get("documentStatus") + "";
                        String approveStatus = o.get("StatusDesc") + "";
                        String CreateDate = o.get("date") + "";
                        int TopStatus = 0;
                        int IsPhotoNews = document.getIsPhotoNews();
                        int category = document.getCategoryID();
                        int Weight = document.getWeight();
                        int active = document.getActive();
                        Channel channel2 = CmsCache.getChannel(ChannelID2);
                        String channelName = channel.getName();
                        String parentChannelPath2 = channel2.getParentChannelPath().replaceAll("/", ">");
                        int OrderNumber = TotalNumber - j - ((currPage - 1) * rowsPerPage);
                        j++;
                        if (listType == 1) {
                %>
                <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>"
                    GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
                    <td class="valign-middle">
                        <label class="ckbox mg-b-0">
                            <input type="checkbox" name="id" value="<%=id_%>"
                                   data-channelid="<%=ChannelID2%>"><span></span>
                        </label>
                    </td>
                    <td ondragstart="OnDragStart(event)">
                        <%if (IsPhotoNews == 1) {%>
                        <i class="fa fa-picture-o drag-list tx-18 tx-primary lh-0 valign-middle" id="img_<%=j%>"></i>
                        <%} else {%>
                        <i class="icon drag-list ion-clipboard tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i>
                        <%}%>
                        <%if (TopStatus == 0) {%><%} else {%>
                        <i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_<%=j%>" title="置顶"></i>
                        <%}%>
                        <span class="pd-l-5 tx-black"><%=Title%></span>
                    </td>
                    <td class="hidden-xs-down">
                        <a href="../lib/webIndex.jsp?channelid=<%=category%>" class="btn pd-0 mg-r-5"
                           title="<%=category%>" target="blank"><%=parentChannelPath2%>
                        </a>
                    </td>
                    <%if (IsWeight == 1) {%>
                    <td class="hidden-xs-down"><span ItemID="<%=id_%>"><%=Weight%></span></td>
                    <%}%>
                    <td class="hidden-xs-down">
                        <%=approveStatus%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=documentStatus%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=CreateDate%>
                    </td>

                    <%if (IsComment == 1) {%>
                    <td class="hidden-xs-down"><span id="comment_<%=GlobalID%>"></span></td>
                    <%}%>
                    <%if (IsClick == 1) {%>
                    <td class="hidden-xs-down"><span id="click_<%=GlobalID%>"></span></td>
                    <%}%>
                    <td class="dropdown hidden-xs-down">
                        <%if (active == 1 && canApprove) {%>
                        <a href="javascript:approve2(<%=id_%>);" class="btn pd-0 mg-r-5" title="发布"><i
                                class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
                        <%}%>
                        <%if (active == 1) {%>
                        <a href="javascript:Preview2(<%=id_%>);" class="btn pd-0 mg-r-5" title="预览"><i
                                class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                        <a href="javascript:Preview3(<%=id_%>);" class="btn pd-0 mg-r-5" title="正式地址预览"><i
                                class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                        <%}%>
                        <a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i
                                class="icon ion-more"></i></a>
                        <div class="dropdown-menu dropdown-menu-right pd-10">
                            <nav class="nav nav-style-1 flex-column">
                                <%if (active == 1 && canApprove) {%>
                                <!-- <a href="javascript:approve2(<%=id_%>);" class="nav-link">发布</a> -->
                                <%}%>
                                <%if (active == 0 && canDelete) {%>
                                <a href="javascript:resume(<%=id_%>);" class="nav-link">恢复</a>A
                                <%} else {%>
                                <!-- <a href="javascript:Preview2(<%=id_%>);" class="nav-link">预览</a>
							<a href="javascript:Preview3(<%=id_%>);" class="nav-link">正式地址预览</a> -->
                                <a href="javascript:editDocument(<%=id_%>);" class="nav-link">编辑</a>
                                <a href="javascript:deleteFile3(<%=id_%>);" class="nav-link">撤稿</a>
                                <%if (!channel.getRecommendOut().equals("")) {%>
                                <a href="javascript:recommendOut1(<%=id_%>);" class="nav-link">推荐</a>
                                <%}%>
                                <a href="javascript:copy(0);" class="nav-link">复制</a>
                                <a href="javascript:copy(1);" class="nav-link">移动</a>
                                <%if (IsTopStatus) {%>
                                <a href="javascript:CancleTop(<%=ChannelID%>,1,<%=id_%>);" class="nav-link">置顶</a>
                                <a href="javascript:CancleTop(<%=ChannelID%>,2,<%=id_%>);" class="nav-link">撤销置顶</a>
                                <%}%>
                                <%if (canDelete) {%>
                                <a href="javascript:deleteFile1(<%=id_%>);" class="nav-link">删除</a>
                                <%}%>
                                <%if (createCategory) {%>
                                <a href="javascript:createCategory(<%=ChannelID%>);" class="nav-link">新建分类</a>
                                <%}%>
                                <%}%>
                            </nav>
                        </div>
                        <!-- dropdown-menu -->
                    </td>
                </tr>
                <%
                    }
                    if (listType == 2) {
                        String Photo = convertNull(rs2.getString("Photo"));
                        String photoAddr = "";
                        if (Photo.startsWith("http://"))
                            photoAddr = Photo;
                        else
                            photoAddr = SiteAddress + Photo;

                        if (m == 0) out.println("<tr>");
                        m++;
                %>
                <td id="item_<%=id_%>" status="<%=Status%>" class="tide_item" class="c">
                    <div class="row">
                        <div class="col-md">
                            <div class="card bd-0">
                                <div class="list-pic-box">
                                    <div class="list-img-contanier">
                                        <img class="card-img-top" src="<%=photoAddr%>" alt="Image"
                                             onerror="checkLoad(this);">
                                    </div>
                                </div>
                                <div class="card-body bd-t-0 rounded-bottom">
                                    <p class="card-text"><%if (IsPhotoNews == 1) {%><i
                                            class="icon ion-image tx-22 tx-warning lh-0 valign-middle"></i><%}%><%=Title%>
                                        (<%=documentStatus%>)</p>
                                    <div class="row mg-l-0 mg-r-0 mg-t-5">
                                        <label class="ckbox mg-b-0 d-inline-block mg-r-5">
                                            <input name="id" value="<%=id_%>" type="checkbox"><span></span>
                                        </label>
                                        <%if (active == 1 && canApprove) {%>
                                        <a href="javascript:approve2(<%=id_%>);" class="btn pd-0 mg-r-5" title="发布"><i
                                                class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
                                        <%}%>
                                        <%if (active == 0 && canDelete) {%>
                                        <a href="javascript:resume(<%=id_%>);" class="btn pd-0 mg-r-5" title="恢复"><i
                                                class="fa fa-reply tx-18 handle-icon" aria-hidden="true"></i></a>
                                        <%} else {%>
                                        <a href="javascript:Preview2(<%=id_%>);" class="btn pd-0 mg-r-5" title="预览"><i
                                                class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                                        <a href="javascript:Preview3(<%=id_%>);" class="btn pd-0 mg-r-5" title="正式地址预览"><i
                                                class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                                        <%}%>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </td>
                <%
                            if (m == cols) {
                                out.println("</tr>");
                                m = 0;
                            }
                        }
                    }
                    if (listType == 2 && m < cols) out.println("</tr>");
                    tu.closeRs(rs2);
                %>
                </tbody>
            </table>

            <script>
                var page = {
                    id: '<%=id%>',
                    currPage: '<%=currPage%>',
                    rowsPerPage: '<%=rowsPerPage%>',
                    querystring: '<%=querystring%>',
                    TotalPageNumber: <%=TotalPageNumber%>
                };
            </script>

            <%if (TotalPageNumber > 0) {%>
            <!--分页-->
            <div id="tide_content_tfoot">
                <label class="ckbox mg-b-0 mg-r-30 ">
                    <input type="checkbox" id="checkAll_1"><span></span>
                </label>
                <span class="mg-r-20 ">共<%=sum%>条</span>
                <span class="mg-r-20 "><%=currPage%>/<%=pageNum%>页</span>

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
                <%if (listType == 1) {%>
                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder=""
                            onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
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
                <%
                    }
                    if (listType == 2) {
                %>

                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rows" class="form-control select2 wd-80" data-placeholder=""
                            onChange="changeRowsCols();" id="rows">
                        <option value="3">3</option>
                        <option value="5">5</option>
                        <option value="8">8</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                    </select>
                    <span class="">行</span>
                    <select name="cols" class="form-control select2 wd-80" data-placeholder=""
                            onChange="changeRowsCols();" id="cols">
                        <option value="3">3</option>
                        <option value="4">4</option>
                        <option value="5">5</option>
                        <option value="6">6</option>
                        <option value="7">7</option>
                        <option value="8">8</option>
                        <option value="10">10</option>
                        <option value="16">16</option>
                    </select>
                    <span class="">列</span>
                </div>

                <%}%>
            </div>
            <!--分页-->
            <%}%>
            <div class="table-page-info" style="display: none;">
                <div class="ckbox-parent">
                    <label class="ckbox mg-b-0">
                        <input type="checkbox" id="checkAll"><span></span>
                    </label>
                </div>
            </div>

        </div>
    </div>
    <!--列表-->

    <!--操作-->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!--<button id="showSubLeft" class="btn btn-secondary mg-r-10 hidden-lg-up"><i class="fa fa-navicon"></i></button>-->

        <!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
            <div class="dropdown-menu pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:list();" class="nav-link list_all">全部</a>
                    <a href="javascript:list('Status1=-1');" class="nav-link list_draft">草稿</a>
                    <a href="javascript:list('Status1=1');" class="nav-link list_publish">已发</a>
                    <a href="javascript:list('IsDelete=1');" class="nav-link list_delete">已删除</a>
                    <a href="#" class="nav-link">搜索</a>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->
        <div class="btn-group hidden-xs-down">
            <a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i
                    class="fa fa-th"></i></a>
            <a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i
                    class="fa fa-th-list"></i></a>
        </div>
        <!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
            <a href="javascript:list('Status=1');" class="btn btn-outline-info list_draft">未审核</a>
            <a href="javascript:list('Status=2');" class="btn btn-outline-info list_publish">审核通过</a>
            <a href="javascript:list('Status=3');" class="btn btn-outline-info list_delete">审核未通过</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <%if (canApprove) {%>
            <a href="javascript:approve();" class="btn btn-outline-info">发布</a>
            <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
            <%} else {%>
            <a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
            <%}%>
            <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
            <a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>
            <%if (!channel.getRecommendOut().equals("")) {%>
            <a href="javascript:recommendOut()" class="btn btn-outline-info">推荐</a>
            <%}%>
            <%if (!channel.getAttribute1().equals("")) {%>
            <a href="javascript:recommendIn();" class="btn btn-outline-info hidden-md-1500-down">引用</a>
            <%}%>
            <a href="javascript:copy(0)" class="btn btn-outline-info hidden-md-1500-down">复制</a>
            <a href="javascript:copy(1)" class="btn btn-outline-info hidden-md-1500-down">移动</a>

            <%if (IsTopStatus) {%>
            <a href="javascript:ChangeTop(<%=id%>,1);" class="btn btn-outline-info hidden-md-1500-down">置顶</a>
            <a href="javascript:ChangeTop(<%=id%>,2);" class="btn btn-outline-info hidden-md-1500-down">撤销置顶</a>
            <%}%>
            <%if (canDelete) {%>
            <a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a>
            <%}%>

        </div>

        <!-- START: 按钮过多时的部分功能下拉 -->
        <div class="dropdown hidden-md-1500-up hidden-sm-down mg-l-10">
            <a href="#" class="btn btn-outline-info" data-toggle="dropdown">操作 <i
                    class="fa fa-angle-down mg-l-5"></i></a>
            <div class="dropdown-menu dropdown-menu-right pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <%if (!channel.getAttribute1().equals("")) {%>
                    <a href="javascript:recommendIn();" class="nav-link">引用</a>
                    <%}%>
                    <a href="javascript:copy(0);" class="nav-link">复制</a>
                    <a href="javascript:copy(1);" class="nav-link">移动</a>

                    <%if (IsTopStatus) {%>
                    <a href="javascript:ChangeTop(<%=id%>,1);" class="nav-link">置顶</a>
                    <a href="javascript:ChangeTop(<%=id%>,2);" class="nav-link">撤销置顶</a>
                    <%}%>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 按钮过多时的部分功能下拉 -->
        <!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i
                    class="fa fa-angle-down mg-l-5"></i></a>
            <div class="dropdown-menu dropdown-menu-right pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:addDocument();" class="nav-link">新建</a>
                    <%if (canApprove) {%>
                    <a href="javascript:approve();" class="nav-link">发布</a>
                    <a href="javascript:Preview();" class="nav-link">预览</a>
                    <%} else {%>
                    <a href="javascript:Preview();" class="nav-link">预览</a>
                    <%}%>
                    <a href="javascript:editDocument1();" class="nav-link">编辑</a>
                    <a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
                    <%if (!channel.getRecommendOut().equals("")) {%>
                    <a href="javascript:recommendOut()" class="nav-link">推荐</a>
                    <%}%>
                    <%if (!channel.getAttribute1().equals("")) {%>
                    <a href="javascript:recommendIn();" class="nav-link">引用</a>
                    <%}%>
                    <a href="javascript:copy(0);" class="nav-link">复制</a>
                    <a href="javascript:copy(1);" class="nav-link">移动</a>

                    <%if (IsTopStatus) {%>
                    <a href="javascript:ChangeTop(<%=id%>,1);" class="nav-link">置顶</a>
                    <a href="javascript:ChangeTop(<%=id%>,2);" class="nav-link">撤销置顶</a>
                    <%}%>
                    <%if (canDelete) {%>
                    <a href="javascript:deleteFile();" class="nav-link">删除</a>
                    <%}%>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->
        <!-- btn-group -->
        <!--<div class="btn-group mg-l-10 hidden-sm-down">-->
        <div class="btn-group mg-l-10">
            <%if (currPage > 1) {%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i
                    class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if (currPage < TotalPageNumber) {%><a href="javascript:gopage(<%=currPage+1%>)"
                                                    class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
        <!-- btn-group -->
    </div>
    <!--操作-->

    <%} else {%>
    <script>
        var page = {
            id: '<%=id%>',
            currPage: '<%=currPage%>',
            rowsPerPage: '<%=rowsPerPage%>',
            querystring: '<%=querystring%>',
            TotalPageNumber: 0
        };
    </script>
    <%}%>


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

        var rows = <%=rows%>;
        var cols = <%=cols%>;
        var ChannelID =<%=ChannelID%>;

        var currRowsPerPage = <%=rowsPerPage%>;
        var currPage = <%=currPage%>;
        var ChannelName = "<%=ChannelName%>";
        var Parameter = "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
        var pageName = "<%=pageName%>";
        if (pageName == "") pageName = "my_approveContent.jsp";

        function gopage(currpage) {
            var url = pageName + "?currPage=" + currpage + "&rowsPerPage=" + currRowsPerPage + "<%=querystring%>";
            console.log(url);
            this.location = url;
        }

        function list(str) {
            var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
            if (typeof (str) != 'undefined')
                url += "&" + str;
            this.location = url;
        }

        function recommendOut1(id) {
            var dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(400);
            dialog.setUrl("../recommend/out_index.jsp?ChannelID=" + ChannelID + "&ItemID=" + id);
            dialog.setTitle('推荐');
            dialog.setChannelName(ChannelName);
            dialog.show();

        }


    </script>
    <script>
        //==========================================
        //设置高亮
        var Status1_ = <%=S_Status%>;
        var IsDelete_ = <%=IsDelete%>;
        $(function () {

            if (Status1_ == 1) {

                $(".list_draft").addClass("active");

            } else if (Status1_ == 2) {

                $(".list_publish").addClass("active");

            } else if (Status1_ == 3) {

                $(".list_delete").addClass("active");

            } else {
                $(".list_all").addClass("active");
            }
        });


        //===========================================
        $(function () {
            'use strict';

            //show only the icons and hide left menu label by default
            $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

            $(document).on('mouseover', function (e) {
                e.stopPropagation();
                if ($('body').hasClass('collapsed-menu')) {
                    var targ = $(e.target).closest('.br-sideleft').length;
                    if (targ) {
                        $('body').addClass('expand-menu');

                        // show current shown sub menu that was hidden from collapsed
                        $('.show-sub + .br-menu-sub').slideDown();

                        var menuText = $('.menu-item-label,.menu-item-arrow');
                        menuText.removeClass('d-lg-none');
                        menuText.removeClass('op-lg-0-force');

                    } else {
                        $('body').removeClass('expand-menu');

                        // hide current shown menu
                        $('.show-sub + .br-menu-sub').slideUp();

                        var menuText = $('.menu-item-label,.menu-item-arrow');
                        menuText.addClass('op-lg-0-force');
                        menuText.addClass('d-lg-none');
                    }
                }
            });

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


            $("#content-table tr:gt(0) td").click(function () {
                var _tr = $(this).parent("tr")
                if (!$("#content-table").hasClass("table-fixed")) {
                    if (_tr.find(":checkbox").prop("checked")) {
                        _tr.find(":checkbox").removeAttr("checked");
                        $(this).parent("tr").removeClass("bg-gray-100");
                    } else {
                        _tr.find(":checkbox").prop("checked", true);
                        $(this).parent("tr").addClass("bg-gray-100");
                    }
                }
            });

            $("#checkAll,#checkAll_1").click(function () {
                if ($("#content-table").hasClass("table-fixed")) {
                    var checkboxAll = $("#content-table tr").find("td").find(":checkbox");
                } else {
                    var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox");
                }
                var existChecked = false;
                for (var i = 0; i < checkboxAll.length; i++) {
                    if (!checkboxAll.eq(i).prop("checked")) {
                        existChecked = true;
                    }
                }
                if (existChecked) {
                    checkboxAll.prop("checked", true);
                    checkboxAll.parents("tr").addClass("bg-gray-100");
                    $(this).prop("checked", true);
                } else {
                    checkboxAll.removeAttr("checked");
                    checkboxAll.parents("tr").removeClass("bg-gray-100");
                    $(this).prop("checked", false);
                }
                return;
            })
            $(".btn-search").click(function () {
                $(".search-box").toggle(100);
            })
            //表头排序
            $("#content-table").tablesorter({headers: {0: {sorter: false}}});
            // Datepicker
            tidecms.setDatePicker(".fc-datepicker");

        });

        $(function () {

            <%if(S_OpenSearch!=1){%>
            sortable();
            sortableEnable();
            //sortableDisable();
            <%if(sortable==1){%>
            //sortableEnable();
            <%}%>
            <%}%>

            $('tbody').on('mousedown', 'tr td', function (e) {

                /*			if($("#content-table").hasClass("table-fixed")){
                                var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
                            }else{
                                var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
                            }
                            checkboxAll.removeAttr("checked");
                            $(this).parent("tr").find("td").find(":checkbox").prop("checked", true);
                            $("tbody tr").removeClass("bg-gray-100");
                            $(this).parent("tr").addClass("bg-gray-100") ;
                */
            })
            var beforeShowFunc = function () {
                //console.log( getActiveNav() )
            };
            var menu = [
                <%if(canApprove){%>
                {
                    '<i class="fa fa-search mg-r-5"></i>发布': function (menuItem, menu) {
                        approve();
                    }
                },
                <%}%>
                {
                    '<i class="fa fa fa-eye mg-r-5"></i>预览': function (menuItem, menu) {
                        Preview();
                    }
                },
                {
                    '<i class="fa fa-edit mg-r-5 fa"></i>编辑': function (menuItem, menu) {
                        editDocument1();
                    }
                },
                {
                    '<i class="fa fa-arrow-down mg-r-5 fa"></i>撤稿': function (menuItem, menu) {
                        deleteFile2();
                    }
                },
                <%if(!channel.getRecommendOut().equals("")){%>
                {
                    '<i class="fa fa-share mg-r-5 fa"></i>推荐': function (menuItem, menu) {
                        recommendOut();
                    }
                },
                <%}%>
                <%if(!channel.getAttribute1().equals("")){%>
                {
                    '<i class="fa fa-reply mg-r-5 fa"></i>引用': function (menuItem, menu) {
                        recommendIn();
                    }
                },
                <%}%>
                {
                    '<i class="fa fa-clone mg-r-5 fa"></i>复制': function (menuItem, menu) {
                        copy(0)
                    }
                },
                {
                    '<i class="fa fa-arrows mg-r-5 fa"></i>移动': function (menuItem, menu) {
                        copy(1)
                    }
                },

                <%if(IsTopStatus){%>
                {
                    '<i class="fa fa-upload mg-r-5 fa"></i>置顶': function (menuItem, menu) {
                        ChangeTop(<%=id%>, 1)
                    }
                },
                {
                    '<i class="fa fa-arrow-circle-o-down mg-r-5 fa"></i>撤销置顶': function (menuItem, menu) {
                        ChangeTop(<%=id%>, 2)
                    }
                },
                <%}%>
                // {'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }}
                <%if(canDelete){%>
                {
                    '<i class="fa fa-trash mg-r-5"></i><font style="color:red;">删除</font>': function (menuItem, menu) {
                        deleteFile();
                    }
                }
                <%}%>
            ];
            $('.tide_item').contextMenu(menu, {theme: 'vista', beforeShow: beforeShowFunc});
        })


        function siderightNewContent2() {

            var url = "../lib/sidebar_new_content.jsp";
            var dialog = new top.TideDialog();
            dialog.setWidth(750);
            dialog.setHeight(600);
            dialog.setUrl(url);
            dialog.setTitle('新建内容');
            //dialog.setChannelName('资源栏目');
            dialog.show();
        }
    </script>

</div>
<%
    if (channel.getListJS().length() > 0) {
        out.println("<script type=\"text/javascript\">");
        out.println(channel.getListJS());
        out.println("</script>");
    }
%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>

</html>
