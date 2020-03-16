<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 tidemedia.cms.user.*,
                 java.util.*,
                 org.json.*,
                 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%@ include file="../approve/approve_config.jsp" %>

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
    int userId = userinfo_session.getId();
    int mytopic = getIntParameter(request, "mytopic");
    int isCompany = getIntParameter(request, "isCompany");
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

    Channel channel = CmsCache.getChannel(id);

    boolean IsTopStatus = false;//是否置顶
    if (channel.getIsTop() == 1) {
        IsTopStatus = true;
    }
    if (channel == null || channel.getId() == 0) {
        response.sendRedirect("../content/content_nochannel.jsp");
        return;
    }
    Channel parentchannel = null;
    int ChannelID = channel.getId();
    String ChannelName = channel.getName();
    int IsWeight = channel.getIsWeight();
    int IsComment = channel.getIsComment();
    int IsClick = channel.getIsClick();
    String gids = "";
    int userrole = userinfo_session.getRole();

    if (channel.getListProgram().length() > 0 && uri.endsWith("/content/content2018.jsp")) {
        response.sendRedirect(channel.getListProgram() + "?id=" + id);
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
    int S_ApproveStatus = getIntParameter(request, "ApproveStatus");
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
    querystring = "&Title=" + java.net.URLEncoder.encode(S_Title, "UTF-8") + "&startDate=" + S_startDate + "&endDate=" + S_endDate + "&User=" + S_User + "&Status=" + S_Status + "&IsPhotoNews=" + S_IsPhotoNews + "&OpenSearch=" + S_OpenSearch + "&IsDelete=" + IsDelete + "&Status1=" + Status1;

    String pageName = request.getServletPath();
    int pindex = pageName.lastIndexOf("/");
    if (pindex != -1)
        pageName = pageName.substring(pindex + 1);

    if (!channel.hasRight(userinfo_session, 1)) {
        response.sendRedirect("../noperm.jsp");
        return;
    }
    boolean canApprove = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanApprove);
    boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);
    boolean canAdd = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanAdd);
    boolean createCategory = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CreateCategory);
    int canExcel = channel.getIsExportExcel();//是否导出Excel
    int canWord = channel.getIsImportWord();//是否导出world
    String SiteAddress = channel.getSite().getUrl();
    int schemdId = channel.getApproveScheme();
    ApproveScheme aps =  CmsCache.getApprove(schemdId);
    int editable = aps.getEditable();


//获取频道路径
    String parentChannelPath = channel.getParentChannelPath().replaceAll(">", " / ");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
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
        }

        .list-pic-box img {
            max-width: 100%;
            min-width: 100%;
            min-height: 100%;
            height: auto;
            display: block;
        }

        @media (max-width: 575px) {
            #content-table .hidden-xs-down {
                word-break: normal;
            }
        }

        /*审核弹窗样式相关*/
        table td {
            position: relative;
        }

        table .sh-td {
        }

        table .pop-start {
            position: relative;
        }

        table .pop-box {
            position: absolute;
            left: -180px;
            top: 45px;
            display: none;
            z-index: 999;
        }

        table .pop-content {
            width: 400px;
            height: 290px;
            overflow: hidden;
            border-radius: 5px;
            background-color: #fff;
            box-shadow: 0px 0px 5px 1px #aaa;
            cursor: default;
            padding: 0 0 20px 0;
        }

        table .pop-title {
            margin: 0;
            padding: 0 0 0 20px;
            background: #f8f9fa;
            line-height: 40px;
            border-bottom: 1px solid #dbdbdb;
        }

        table .pop-triangle {
            position: absolute;
            right: 180px;
            top: -10px;
            width: 0;
            height: 0;
            border-left: 10px solid transparent;
            border-right: 10px solid transparent;
            border-bottom: 10px solid #e9e9e9;
        }

        table .pop-text {
            padding: 10px 20px;
            overflow-y: auto;
            height: 240px;
            line-height: 24px;
        }

        table .pop-text em {
            font-style: normal;
        }
    </style>

    <script src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
    <script src="../common/2018/TideDialog2018.js"></script>
    <script src="../lib/2018/popper.js/popper.js"></script>
    <script src="../lib/2018/bootstrap/bootstrap.js"></script>
    <script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="../lib/2018/moment/moment.js"></script>
    <script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>

    <!--<script src="../lib/2018/select2/js/select2.min.js"></script>-->

    <script src="../common/2018/bracket.js"></script>


    <!--<script src="../lib/2018/jquery-contextMenu/js/jquery.contextMenu.js"></script>
<script src="../lib/2018/jquery-contextMenu/js/jquery.ui.position.min.js"></script>-->
    <script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
    <script>
        //var dir = "subject";
        var userrole = <%=userrole%>;
        var listType = <%=listType%>;
        var rows = <%=rows%>;
        var cols = <%=cols%>;
        var ChannelID = <%=ChannelID%>;
        var editable = <%=editable%>;
        var currRowsPerPage = <%=rowsPerPage%>;
        var currPage = <%=currPage%>;
        var ChannelName = "<%=ChannelName%>";
        var Parameter = "&ChannelID=" + ChannelID + "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
        var pageName = "<%=pageName%>";
        if (pageName == "") pageName = "content.jsp";

        function gopage(currpage) {
            var url = pageName + "?currPage=" + currpage + "&id=<%=id%>&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
            this.location = url;
        }

        function list(str) {
            var url = pageName + "?id=<%=id%>&mytopic=<%=mytopic%>&rowsPerPage=<%=rowsPerPage%>";
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

        //审核预览
        function approve_preview(id, actionId) {
            if (actionId == 0) {
                alert("此稿件未进行审核");
                return;
            }
            window.open("approve_preview.jsp?ItemID=" + id + Parameter);
        }
    </script>
</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <%if (isCompany != 0) {%>
            <span class="breadcrumb-item active">全部选题</span>
            <%} else if(mytopic==1){%>
            <span class="breadcrumb-item active">我的选题</span>
            <%}else{%>
            <span class="breadcrumb-item active"><%=parentChannelPath%></span>
            <%}%>
        </nav>
    </div>

    <%
        int S_UserID = 0;
        long weightTime = 0;
        int IsActive = 1;
        if (IsDelete == 1) IsActive = 0;

        if (!S_User.equals("")) {
            String sql2 = "select * from userinfo where Name='" + S_User + "'";
            TableUtil tu2 = new TableUtil("user");
            ResultSet Rs2 = tu2.executeQuery(sql2);
            if (Rs2.next()) {
                S_UserID = Rs2.getInt("id");
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
            weightTime = nowDate.getTimeInMillis() / 1000;
        }

        String Table = channel.getTableName();
//添加判断有内容类型的频道
        String ListSql = "select id,Title,Photo,Weight,task_status,GlobalID,User,FROM_UNIXTIME(ModifiedDate) as ModifiedDate,Status,Active,Category,IsPhotoNews,ApproveStatus";

        String FieldStr = ",DocTop,DocTopTime";
        if (IsTopStatus) {
            ListSql += FieldStr;
        }


        if (listType == 2) {
            ListSql += ",Summary,Content,Keyword";
        }
        if (channel.getIsWeight() == 1)
            ListSql += ",case when CreateDate>" + weightTime + " then (Weight+" + weightTime + ") else CreateDate end  as newtime";
        ListSql += " from " + Table;
        String CountSql = "select count(*) from " + Table;

        if (!listAll && mytopic == 0) {
            if (channel.getType() == Channel.Category_Type) {
                ListSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
                CountSql += " where Category=" + channel.getId() + " and Active=" + IsActive;
            } else if (channel.getType() == Channel.MirrorChannel_Type) {
                Channel linkChannel = channel.getLinkChannel();
                if (linkChannel.getType() == Channel.Category_Type) {
                    ListSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                    CountSql += " where Category=" + linkChannel.getId() + " and Active=" + IsActive;
                } else {
                    ListSql += " where Category=0 and Active=" + IsActive;
                    CountSql += " where Category=0 and Active=" + IsActive;
                }
            } else {
                ListSql += " where " + (!listAll ? Table + ".Category=0 and " : "") + " Active=" + IsActive;
                CountSql += " where " + (!listAll ? Table + ".Category=0 and " : "") + " Active=" + IsActive;
            }
        } else {
            ListSql += " where ChannelCode like '" + channel.getChannelCode() + "%' and Active=" + IsActive;
            CountSql += " where ChannelCode like '" + channel.getChannelCode() + "%' and Active=" + IsActive;
        }

        String WhereSql = "";

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

/*
if(S_IsIncludeSubChannel==1)
{
	WhereSql += " and ChannelCode like '"+channel.getChannelCode() + "%'";
}*/

        if (S_UserID > 0) {
            WhereSql += " and User=" + S_UserID;
        }

        if (S_IsPhotoNews == 1)
            WhereSql += " and IsPhotoNews=1";
        if (S_Status != 0)
            WhereSql += " and Status=" + (S_Status - 1);

        if (Status1 != 0) {
            if (Status1 == -1)
                WhereSql += " and Status=0";
            else
                WhereSql += " and Status=" + Status1;
        }

        if (mytopic != 0) {
            WhereSql += " and User=" + userinfo_session.getId();
        }
        if(S_ApproveStatus!=0){
            if(S_ApproveStatus==-1){
                WhereSql += " and ApproveStatus=0" ;
            }else{
                WhereSql += " and ApproveStatus=" + S_ApproveStatus;
            }
        }
        ListSql += WhereSql;
        CountSql += WhereSql;

        if (channel.getIsWeight() == 1) {
            ListSql += " order by newtime desc,id desc";
        } else {
            if (IsTopStatus) {
                ListSql += " order by  DocTop desc ,DocTopTime  desc  ,OrderNumber desc ";
            } else {
                ListSql += " order by OrderNumber desc ";
            }
        }

// out.println(ListSql);
        System.out.println("listsql=" + ListSql);
        int listnum = rowsPerPage;
        if (listType == 2) listnum = cols * rows;


        TableUtil tu = channel.getTableUtil();
        ResultSet Rs = tu.List(ListSql, CountSql, currPage, listnum);
        int TotalPageNumber = tu.pagecontrol.getMaxPages();
        int TotalNumber = tu.pagecontrol.getRowsCount();

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
            <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">草稿</a>
            <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已发</a>
            <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <a href="javascript:addDocument();" class="btn btn-outline-info">新建</a>
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
            <%if (IsWeight != 1) {%>
            <a href="javascript:SortDoc();" class="btn btn-outline-info hidden-md-1500-down">排序</a>
            <%}%>
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
                    <%if (IsWeight != 1) {%>
                    <a href="javascript:SortDoc();" class="nav-link">排序</a>
                    <%}%>
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
                    <%if (IsWeight != 1) {%>
                    <a href="javascript:SortDoc();" class="nav-link">排序</a>
                    <%}%>
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
            <form name="search_form" action="<%=pageName%>?id=<%=id%>&mytopic=<%=mytopic%>&rowsPerPage=<%=rowsPerPage%>"
                  method="post"
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
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="状态" name="Status">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                            <option value="2" <%=(S_Status == 2 ? "selected" : "")%>>已发</option>
                            <option value="1" <%=(S_Status == 1 ? "selected" : "")%>>草稿</option>
                        </select>
                    </div>
                    <!--审核环节-->
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="审核状态" name="ApproveStatus">
                            <option label="Choose one"></option>
                            <option value="-1" <%=(S_ApproveStatus == 2 ? "selected" : "")%>>未提交审核</option>
                            <%
                                ArrayList<ApproveItems> approveitems  = aps.getApproveitems();
                                for (int i = 0; i < approveitems.size(); i++) {
                                    ApproveItems api = approveitems.get(i);
                                    String  apiTitle = api.getTitle();
                                    int step = api.getStep();
                            %>
                            <option value="<%=step%>" <%=(S_ApproveStatus == step ? "selected" : "")%>><%=apiTitle%></option>
                            <%} %>
                            <option value="100" <%=(S_ApproveStatus == 2 ? "selected" : "")%>>审核通过</option>
                        </select>
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

    <%if (channel.hasRight(userinfo_session, 1)) {%>
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

                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">审核状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">选题状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">日期</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-120 wd-author">作者</th>
                    <%if (IsComment == 1) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">评论</th>
                    <%}%>
                    <%if (IsClick == 1) {%>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-40">点击量</th>
                    <%}%>
                    <th class="tx-12-force wd-160 tx-mont tx-medium hidden-xs-down">操作</th>
                </tr>
                </thead>
                <%}%>
                <tbody>
                <%

                    int j = 0;
                    int m = 0;
                    int temp_gid = 0;
                    while (Rs.next()) {
                        int id_ = Rs.getInt("id");
                        int Status = Rs.getInt("Status");
                        int category = Rs.getInt("Category");
                        if(category!=0){
                            channel = CmsCache.getChannel(category);
                            ChannelID = channel.getId();
                             schemdId = channel.getApproveScheme();
                             aps =  CmsCache.getApprove(schemdId);
                            approveitems  = aps.getApproveitems();
                        }
                        int user = Rs.getInt("User");
                        int active = Rs.getInt("Active");
                        String Title = convertNull(Rs.getString("Title"));
                        int task_status = Rs.getInt("task_status");
                        int IsPhotoNews = Rs.getInt("IsPhotoNews");
                        int TopStatus = 0;
                        int ApproveStatus = Rs.getInt("ApproveStatus");
                        if (IsTopStatus) {
                            TopStatus = Rs.getInt("DocTop");
                        }
                        if (listAll) {
                            if (category > 0)
                                Title = "[" + CmsCache.getChannel(category).getName() + "]" + Title;
                        }
                        int Weight = Rs.getInt("Weight");
                        int GlobalID = Rs.getInt("GlobalID");


                        if (temp_gid != 0) {
                            globalids += ",";
                        }
                        temp_gid++;
                        globalids += GlobalID + "";

                        String approveStatus = "未提交审核";
                        for (int i = 0; i < approveitems.size(); i++) {
                            ApproveItems api = approveitems.get(i);
                            int api_step = api.getStep();
                            String apiName = api.getTitle();
                            if(ApproveStatus==api_step){
                                approveStatus = apiName+"待审核";
                                break;
                            }
                        }
                        int end = 0;//是否终审
                        if(ApproveStatus==100){
                            approveStatus = approveitems.get(approveitems.size()-1).getTitle()+"通过";
                            end = 1;
                        }



                        String ModifiedDate = convertNull(Rs.getString("ModifiedDate"));
                        ModifiedDate = Util.FormatDate("yyyy-MM-dd HH:mm", ModifiedDate);
                        String UserName = CmsCache.getUser(user).getName();//convertNull(Rs.getString("userinfo.Name"));
                        String StatusDesc = "";

                        if (IsDelete != 1) {
                            if (Status == 0)
                                StatusDesc = "<span class='tx-orange'>草稿</span>";
                            else if (Status == 1)
                                StatusDesc = "<span class='tx-success'>已发</span>";
                        } else {
                            StatusDesc = "<span class='tx-danger'>已删除</span>";
                        }
                        String task_statusDesc = "";
                        if (task_status == 0) {
                            task_statusDesc = "<span class=''>未审核</span>";
                        } else if (task_status == 1) {
                            task_statusDesc = "<span class=''>审核通过</span>";
                        } else if (task_status == 2) {
                            task_statusDesc = "<span class='r'>审核未通过</span>";
                        } else {
                            task_statusDesc = "<span class=''>已完成</span>";
                        }

                        if (gids.length() > 0) {
                            gids += "," + GlobalID + "";
                        } else {
                            gids = GlobalID + "";
                        }

                        int OrderNumber = TotalNumber - j - ((currPage - 1) * rowsPerPage);
                        j++;

                        if (listType == 1) {
                %>
                <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>"
                    GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item" end="<%=end%>"
                    approve="1"  >
                    <td class="valign-middle">
                        <label class="ckbox mg-b-0">
                            <input type="checkbox" name="id" value="<%=id_%>"><span></span>
                        </label>
                    </td>
                    <td ondragstart="OnDragStart(event)">
                        <%if (IsPhotoNews == 1) {%>
                        <i class="fa fa-picture-o tx-18 tx-primary lh-0 valign-middle" id="img_<%=j%>"></i>
                        <%} else {%>
                        <i class="icon ion-clipboard tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i>
                        <%}%>
                        <%if (TopStatus == 0) {%><%} else {%>
                        <i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_<%=j%>" title="置顶"></i>
                        <%}%>
                        <span class="pd-l-5 tx-black"><%=Title%></span>
                    </td>
                    <%if (IsWeight == 1) {%>
                    <td class="hidden-xs-down"><span ItemID="<%=id_%>"><%=Weight%></span></td>
                    <%}%>


                    <td class="hidden-xs-down sh-td" data-id="<%=GlobalID%>">
                        <span class="pop-start"><%=approveStatus%></span>
                        <div class="pop-box">
                            <div class="pop-content">
                                <p class="pop-title">审核状态</p>
                                <div class="pop-text">
                                </div>
                            </div>
                            <div class="pop-triangle"></div>
                        </div>
                    </td>
                    <td class="hidden-xs-down">
                        <%=task_statusDesc%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=ModifiedDate%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=UserName%>
                    </td>
                    <%if (IsComment == 1) {%>
                    <td class="hidden-xs-down"><span id="comment_<%=GlobalID%>"></span></td>
                    <%}%>
                    <%if (IsClick == 1) {%>
                    <td class="hidden-xs-down"><span id="click_<%=GlobalID%>"></span></td>
                    <%}%>
                    <td class="dropdown hidden-xs-down">
                        <%if (active == 1 && canApprove && end == 1) {%>
                        <a href="javascript:approve2(<%=id_%>);" class="btn pd-0 mg-r-5" title="发布"><i
                                class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
                        <%}%>
                        <%if (active == 1) {%>
                        <%if (channel.getChannelTemplates(2).size() != 0) {%>
                        <a href="javascript:Preview2(<%=id_%>);" class="btn pd-0 mg-r-5" title="预览"><i
                                class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                        <%}%>
                        <a href="javascript:approve_preview(<%=id_%>,<%=ApproveStatus%>);" class="btn pd-0 mg-r-5" title="审核预览"><i
                                class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                        <%}%>
                        <a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i
                                class="icon ion-more"></i></a>
                        <div class="dropdown-menu dropdown-menu-right pd-10">
                            <nav class="nav nav-style-1 flex-column">
                                <%if (active == 0) {%>
                                <a href="javascript:resume(<%=id_%>);" class="nav-link">恢复</a>
                                <%} else {%>
                                <a href="javascript:Preview3(<%=id_%>);" class="nav-link">正式地址预览</a>
                                <%if (ApproveStatus == 0 ) {%>
                                <a href="javascript:editDocument(<%=id_%>);" class="nav-link">编辑</a>
                                <%}%>
                                <%if (end == 1) {%>
                                <a href="javascript:deleteFile3(<%=id_%>);" class="nav-link">撤稿</a>
                                <%if (!channel.getRecommendOut().equals("")) {%>
                                <a href="javascript:recommendOut1(<%=id_%>);" class="nav-link">推荐</a>
                                <%}%>
                                <a href="javascript:copy(0);" class="nav-link">复制</a>
                                <a href="javascript:copy(1);" class="nav-link">移动</a>
                                <%if (IsWeight != 1) {%>
                                <a href="javascript:SortDoc1(<%=id_%>);" class="nav-link">排序</a>
                                <%}%>
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
                                <%}%>
                            </nav>
                        </div>
                        <!-- dropdown-menu -->
                    </td>
                </tr>
                <%
                    }
                    if (listType == 2) {
                        String Photo = convertNull(Rs.getString("Photo"));
                        String photoAddr = "";
                        if (Photo.startsWith("http://"))
                            photoAddr = Photo;
                        else
                            photoAddr = SiteAddress + Photo;

                        if (m == 0) out.println("<tr>");
                        m++;
                %>
                <td id="item_<%=id_%>" status="<%=Status%>" class="tide_item" class="c" end="<%=end%>"
                    approve="1">
                    <div class="row">
                        <div class="col-md">
                            <div class="card bd-0">
                                <div class="list-pic-box">
                                    <img class="card-img-top" src="<%=photoAddr%>" alt="Image"
                                         onerror="checkLoad(this);">
                                </div>
                                <div class="card-body bd-t-0 rounded-bottom">
                                    <p class="card-text"><%if (IsPhotoNews == 1) {%><i
                                            class="icon ion-image tx-22 tx-warning lh-0 valign-middle"></i><%}%><%=Title%>
                                        (<%=StatusDesc%>)</p>
                                    <div class="row mg-l-0 mg-r-0 mg-t-5">
                                        <label class="ckbox mg-b-0 d-inline-block mg-r-5">
                                            <input name="id" value="<%=id_%>" type="checkbox"><span></span>
                                        </label>
                                        <%if (active == 1 && canApprove) {%>
                                        <a href="javascript:approve2(<%=id_%>);" class="btn pd-0 mg-r-5" title="发布"><i
                                                class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
                                        <%}%>
                                        <%if (active == 0) {%>
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
                    tu.closeRs(Rs);
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
            <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">草稿</a>
            <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已发</a>
            <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <a href="javascript:addDocument();" class="btn btn-outline-info">新建</a>
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
            <%if (IsWeight != 1) {%>
            <a href="javascript:SortDoc();" class="btn btn-outline-info hidden-md-1500-down">排序</a>
            <%}%>
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
                    <%if (IsWeight != 1) {%>
                    <a href="javascript:SortDoc();" class="nav-link">排序</a>
                    <%}%>
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
                    <%if (IsWeight != 1) {%>
                    <a href="javascript:SortDoc();" class="nav-link">排序</a>
                    <%}%>
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
        //==========================================
        //设置高亮
        var Status1_ = <%=Status1%>;
        var IsDelete_ = <%=IsDelete%>;
        $(function () {

            if (Status1_ == -1) {

                $(".list_draft").addClass("active");

            } else if (Status1_ == 1) {

                $(".list_publish").addClass("active");

            } else if (IsDelete_ == 1) {

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

            var beforeShowFunc = function () {
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
                <%if(IsWeight!=1){%>
                {
                    '<i class="fa fa-sort-alpha-desc mg-r-5 fa"></i>排序': function (menuItem, menu) {
                        SortDoc();
                    }
                },
                <%}%>
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


            //审核提示样式相关
            function updateManagerDate(id) {
                $.ajax({
                    type: "get",
                    url: "../approve/approve_result.jsp?globalid=" + id,
                    success: function (msg) {

                        $(".pop-text").html(msg.trim());

                    }
                });
            }

            $(".sh-td").mouseenter(function () {
                var _id = $(this).attr("data-id");//你加一个data-id的自定义属性  方便请求接口
                if ($(".pop-box").is(":hidden")) {
                    updateManagerDate(_id);
                }
                $(this).find(".pop-box").fadeIn(100);
            }).mouseleave(function () {
                $(this).find(".pop-box").fadeOut(0);
            })


            var url = "tree2018.jsp";

            $.ajax({
                type: "GET",
                dataType: "json",
                url: url,
                success: function (json) {
                    var menu = $('.sidebar-menu');
                    for (var i = 0; i < json.length; i++) {
                        var html = '';
                        if (json[i].child && json[i].child.length > 0) {
                            if (i == 0) {
                                html = '<li class="treeview active">';
                            } else {
                                html = '<li class="treeview">';
                            }
                        } else {
                            if (i == 0) {
                                html = '<li class="active">';
                            } else {
                                html = '<li >';
                            }
                        }
                        if (json[i].load == 1 || (json[i].child != null && json[i].child.length > 0)) {
                            if (json[i].type == 0) {
                                html += '<a href="javascript:;" channelid="' + json[i].id + '" channeltype="' + json[i].type + '"><i class="fa fisrtNav fa-home " have="1"></i> <span>' + json[i].name + '</span></a>';
                            } else {
                                html += '<a href="javascript:;" channelid="' + json[i].id + '" channeltype="' + json[i].type + '"><i class="fa fisrtNav fa-home " have="1"></i> <span>' + json[i].name + '</span></a>';
                            }
                        } else {
                            if (json[i].type == 0) {
                                html += '<a href="javascript:;" channelid="' + json[i].id + '" channeltype="' + json[i].type + '"><i class="fa fisrtNav fa-home " have="0"></i> <span>' + json[i].name + '</span></a>';

                            } else {
                                html += '<a href="javascript:;" channelid="' + json[i].id + '" channeltype="' + json[i].type + '"><i class="fa fisrtNav fa-home " have="0"></i> <span>' + json[i].name + '</span></a>';
                            }

                        }


                        if (json[i].child && json[i].child.length > 0) {
                            html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
                        }
                        html += '</li>';
                        menu.append(html);
                    }
                    //activeFn();
                    //多级导航自定义
                    $.sidebarMenu(menu);
                    backToOriginal();  //频道记忆
                }
            });

            function activeFn() {
                var timer = setInterval(function () {
                    if ($(".sidebar-menu li.active a:first")) {
                        var activeChannel = $(".sidebar-menu li.active a:first");
                        try {
                            activeChannel[0].click();
                        } catch (err) {
                        }
                        clearInterval(timer)
                    }
                }, 20)
            }

            function get_menu_html(json) {
                var html = "";
                if (json.child && json.child.length > 0) {
                    var json_ = json.child;
                    for (var i = 0; i < json_.length; i++) {
                        html += '<li><a href="javascript:;" load="' + json_[i].load + '" channelid="' + json_[i].id + '" channeltype="' + json_[i].type + '">';

                        if (json_[i].load == 1 || (json_[i].child && json_[i].child.length > 0)) {
                            if (json_[i].type == 0) {
                                html += '<i class="fa fa-angle-double-right" hava="1"></i>';
                            } else {
                                html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>';
                            }

                        } else {
                            if (json_[i].type == 0) {
                                html += '<i class="fa fa-angle-right" hava="1"></i>';
                            } else {
                                html += '<i class="fa fa-angle-right op-5" hava="1"></i>';
                            }
                        }

                        html += '<span>' + json_[i].name + '</span></a>';

                        if (json_[i].child && json_[i].child.length > 0) {
                            html += '<ul class="treeview-menu">' + get_menu_html(json_[i]) + '</ul>';
                        }
                        html += '</li>';
                    }
                }
                return html;
            }

            //重新加载站点和站点下直系一级导航
            function reLoadSiteNav(_obj) {
                var url = "tree2018.jsp";
                var menu = $('.sidebar-menu').html("");
                $.ajax({
                    type: "GET",
                    dataType: "json",
                    url: url,
                    success: function (json) {
                        var menu = $('.sidebar-menu');
                        for (var i = 0; i < json.length; i++) {
                            var html = '';
                            if (json[i].child && json[i].child.length > 0) {
                                html = '<li class="treeview">';
                            } else {
                                html = '<li>';
                            }
                            if (json[i].load == 1 || (json[i].child != null && json[i].child.length > 0)) {
                                if (json[i].type == 0) {
                                    html += '<a href="javascript:;" channelid="' + json[i].id + '" channeltype="' + json[i].type + '"><i class="fa fisrtNav fa-home " have="1"></i> <span>' + json[i].name + '</span></a>';
                                } else {
                                    html += '<a href="javascript:;" channelid="' + json[i].id + '" channeltype="' + json[i].type + '"><i class="fa fisrtNav fa-home " have="1"></i> <span>' + json[i].name + '</span></a>';
                                }
                            } else {
                                if (json[i].type == 0) {
                                    html += '<a href="javascript:;" channelid="' + json[i].id + '" channeltype="' + json[i].type + '"><i class="fa fisrtNav fa-home " have="0"></i> <span>' + json[i].name + '</span></a>';

                                } else {
                                    html += '<a href="javascript:;" channelid="' + json[i].id + '" channeltype="' + json[i].type + '"><i class="fa fisrtNav fa-home " have="0"></i> <span>' + json[i].name + '</span></a>';
                                }

                            }
                            if (json[i].child && json[i].child.length > 0) {
                                html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
                            }
                            html += '</li>';
                            menu.append(html);
                        }
                        //多级导航自定义
                        //$.sidebarMenu(menu);
                        var $thisCurrent = $(".sidebar-menu a[channelid='" + _obj.currentid + "']");
                        if (_obj.parentid >= 0) {  //此时存在父频道id即操作站点下直系一级导航
                            var $thisParent = $(".sidebar-menu a[channelid='" + _obj.parentid + "']");
                            if (_obj.type == 3) {  //如果是排序
                                $thisParent.next().addClass("menu-open");
                                $thisCurrent.parent("li").addClass("active");
                            } else if (_obj.type == 2) {
                                $thisParent[0].click();
                            } else if (_obj.type == 1) {
                                $thisParent.next().addClass("menu-open");
                                $thisCurrent[0].click();
                            }
                        } else {   //操作站点
                            if (_obj.type == 3) {  //排序
                                $thisCurrent.parent("li").addClass("active");
                                $thisCurrent.next().css("display", "none");   //样式里面默认展开子频道了，这里不需要
                            } else {   //如果是删除
                                var $extralFirst = $(".sidebar-menu li.treeview:first a:first");
                                if ($extralFirst.lenth > 0) {
                                    var _id = $extralFirst.attr("channelid");
                                    $extralFirst.parent("li").addClass("active");  //选择（剩下的）第一个站点高亮
                                    $extralFirst.next().css("display", "none");
                                    changeFrameSrc(window.frames["content_frame"], "../channel/channel2018.jsp?ChannelID=" + _id)
                                }

                            }
                        }
                    }
                });
            }

            //重新加载二三四级导航
            function reLoadNav(obj) {
                console.log(obj);
                if (obj.site) {  //如果是操作站点
                    reLoadSiteNav(obj);
                    return;
                }
                var animationSpeed = 0;
                var $this = $(".sidebar-menu a[channelid='" + obj.parentid + "']");
                $this.next().remove();
                var url = "../channel/channel_json.jsp?ChannelID=" + obj.parentid;
                $.ajax({
                    type: "GET",
                    dataType: "json",
                    url: url,
                    success: function (json) {
                        var html = '<ul class="treeview-menu">';

                        for (var i = 0; i < json.length; i++) {
                            if (json[i].child && json[i].child.length > 0) {
                                html += '<li class="treeview">';
                            } else {
                                html += '<li>';
                            }
                            html += '<a href="javascript:;" load="' + json[i].load + '" channelid="' + json[i].id + '" channeltype="' + json[i].type + '">';

                            if (json[i].load == 1 || (json[i].child && json[i].child.length > 0)) {
                                if (json[i].type == 0) {
                                    html += '<i class="fa fa-angle-double-right" hava="1"></i>';
                                } else {
                                    html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>';
                                }

                            } else {

                                if (json[i].type == 0) {
                                    html += '<i class="fa fa-angle-right" hava="0"></i>';
                                } else {
                                    html += '<i class="fa fa-angle-right op-5" hava="0"></i>';
                                }
                            }
                            html += '<span>' + json[i].name + '</span></a>';

                            if (json[i].child && json[i].child.length > 0) {
                                html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
                            }
                            html += '</li>';
                        }
                        html += '</ul>';
                        $this.after($(html));
                        var checkElement = $this.next();
                        var $current = $(".sidebar-menu a[channelid='" + obj.currentid + "']");
                        console.log(obj.type)
                        if (obj.type == 3) {   //type 1新建 2删除 3排序	排序高亮自己，删除或者新建某个频道高亮父频道
                            //$(".sidebar-menu a[channelid='"+obj.currentid+"']")[0].click();  //不一定展开，不用点击
                            sidebarMenu_show(checkElement, animationSpeed, $current);
                        } else if (obj.type == 2) {
                            sidebarMenu_show(checkElement, animationSpeed, $this);
                            changeFrameSrc(window.frames["content_frame"], "../channel/channel2018.jsp?ChannelID=" + obj.parentid)
                        } else if (obj.type == 1) {
                            sidebarMenu_show(checkElement, animationSpeed, $current);
                            $(".sidebar-menu a[channelid='" + obj.currentid + "']")[0].click()
                        }
                    }
                });
            }

            function setChannelCookie(_id) {
                $.ajax({
                    type: "GET",
                    url: "../channel/getChannelPath.jsp?ChannelID=" + _id,
                    success: function (data) {
                        tidecms.setCookie("channel_path_jushi", data.trim());
                    }
                });
            }

            //返回最后一级导航
            function backToOne(ids) {
                var current = ids ? ids : _activeChannelid
                if (current) {
                    var currentChannrl = $(".sidebar-menu a[channelid='" + current + "']");
                    $(".sidebar-menu li").removeClass("active");
                    currentChannrl.parent("li").addClass("active");
                    changeFrameSrc(window.frames["content_frame"], "../channel/channel2018.jsp?ChannelID=" + current)
                }
            }

            //返回二三四级导航
            function backToOuter() {
                channelStart++;
                if (channelStart == channel_id_array.length - 1) {
                    backToOne(channel_id_array[channel_id_array.length - 1]);
                    return;
                }
                backToInner(channel_id_array[channelStart])
            }

            //二三四级导航
            function backToInner(_id) {
                var url = "../channel/channel_json.jsp?ChannelID=" + _id;
                var $this = $(".sidebar-menu a[channelid='" + _id + "']")
                var checkElement = $this.next();
                var load = $this.attr("load");
                $.ajax({
                    type: "GET",
                    dataType: "json",
                    url: url,
                    success: function (json) {
                        var html = '<ul class="treeview-menu">';

                        for (var i = 0; i < json.length; i++) {
                            if (json[i].child && json[i].child.length > 0) {
                                html += '<li class="treeview">';
                            } else {
                                html += '<li>';
                            }
                            html += '<a href="javascript:;" load="' + json[i].load + '" channelid="' + json[i].id + '" channeltype="' + json[i].type + '">';

                            if (json[i].load == 1 || (json[i].child && json[i].child.length > 0)) {
                                if (json[i].type == 0) {
                                    html += '<i class="fa fa-angle-double-right" hava="1"></i>';
                                } else {
                                    html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>';
                                }

                            } else {

                                if (json[i].type == 0) {
                                    html += '<i class="fa fa-angle-right" hava="0"></i>';
                                } else {
                                    html += '<i class="fa fa-angle-right op-5" hava="0"></i>';
                                }
                            }
                            html += '<span>' + json[i].name + '</span></a>';

                            if (json[i].child && json[i].child.length > 0) {
                                html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
                            }
                            html += '</li>';
                        }
                        html += '</ul>';
                        $this.after($(html));
                        $this.attr("load", 0);//加载完毕改变load属性
                        checkElement = $this.next();
                        sidebarMenu_show_back(checkElement, $this, backToOuter);
                    }
                });

            }

            var _activeChannelid = 0;  //记忆的频道号
            var channelStart = 0; //起始频道id
            var channel_id_array = null;

            function backToOriginal() {
                var channel_path = getCookie("channel_path_jushi");
                if (channel_path) {
                    channel_id_array = channel_path.split(",");
                } else {
                    activeFn();
                    return false;
                }
                if (channel_id_array.length == 1) {  //站点
                    var $this = $(".sidebar-menu a[channelid='" + channel_id_array[0] + "']");
                    $(".sidebar-menu li").removeClass("active");
                    $this.parent("li").addClass("active");
                    changeFrameSrc(window.frames["content_frame"], "../channel/channel2018.jsp?ChannelID=" + channel_id_array[0])
                    //return ;
                } else if (channel_id_array.length == 2) {    //站点下一级导航
                    var $this = $(".sidebar-menu a[channelid='" + channel_id_array[0] + "']");
                    _activeChannelid = channel_id_array[1];
                    var checkElement = $this.next();
                    sidebarMenu_show_back(checkElement, $this, backToOne)
                } else if (channel_id_array.length > 2) {   //二三四级导航
                    var $this = $(".sidebar-menu a[channelid='" + channel_id_array[0] + "']");
                    var checkElement = $this.next();
                    sidebarMenu_show_back(checkElement, $this, backToOuter)
                }
            }

            $.sidebarMenu = function (menu) {
                var animationSpeed = 150;

                $(menu).on("click", 'li a', function (e) {
                    //判断是否右键
                    var $this = $(this);
                    var channelid = $this.attr("channelid");
                    setChannelCookie(channelid);
                    var checkElement = $this.next();
                    var load = $this.attr("load");
                    var haveChild = $this.find("i").attr("have");
                    if (load == 1) {
                        var url = "../channel/channel_json.jsp?ChannelID=" + channelid;
                        $.ajax({
                            type: "GET",
                            dataType: "json",
                            url: url,
                            beforeSend: function () {
                                if (haveChild == 1) {
                                    var loadingHtml = '<ul class="treeview-menu nav-loading" style="display: block;"><li><a class="tx-white tx-13-force" href="javascript:;"><i class="fa tx-13-force fa-spinner" aria-hidden="true"></i>loading</a></li></ul>'
                                    $this.after(loadingHtml)
                                }
                            },
                            success: function (json) {
                                var html = '<ul class="treeview-menu">';

                                for (var i = 0; i < json.length; i++) {
                                    if (json[i].child && json[i].child.length > 0) {
                                        html += '<li class="treeview">';
                                    } else {
                                        html += '<li>';
                                    }
                                    html += '<a href="javascript:;" load="' + json[i].load + '" channelid="' + json[i].id + '" channeltype="' + json[i].type + '">';

                                    if (json[i].load == 1 || (json[i].child && json[i].child.length > 0)) {
                                        if (json[i].type == 0) {
                                            html += '<i class="fa fa-angle-double-right" hava="1"></i>';
                                        } else {
                                            html += '<i class="fa fa-angle-double-right op-5" hava="1"></i>';
                                        }

                                    } else {

                                        if (json[i].type == 0) {
                                            html += '<i class="fa fa-angle-right" hava="0"></i>';
                                        } else {
                                            html += '<i class="fa fa-angle-right op-5" hava="0"></i>';
                                        }
                                    }
                                    html += '<span>' + json[i].name + '</span></a>';

                                    if (json[i].child && json[i].child.length > 0) {
                                        html += '<ul class="treeview-menu">' + get_menu_html(json[i]) + '</ul>';
                                    }
                                    html += '</li>';
                                }
                                html += '</ul>';
                                $(".nav-loading").remove();
                                $this.nextAll().remove();
                                $this.after($(html));
                                $this.attr("load", 0);//加载完毕改变load属性
                                checkElement = $this.next();
                                sidebarMenu_show(checkElement, animationSpeed, $this);
                            }
                        });
                    } else {
                        sidebarMenu_show(checkElement, animationSpeed, $this);
                    }
                    if (window.frames["content_frame"]) {
                        changeFrameSrc(window.frames["content_frame"], "../channel/channel2018.jsp?ChannelID=" + channelid)
                    }
                });

            }

        })

    </script>
    <script>
        $(function () {
            $('.sidebar-menu').on('mousedown', 'li a', function (e) {
                $(".sidebar-menu li").removeClass("active");
                $(this).parent("li").addClass("active");
            })
            var beforeShowFunc = function () {

            };
            var menu = [
                {
                    '<i class="fa fa-pencil mg-r-5"></i>新建': function (menuItem, menu) {
                        newChannel();
                    }
                },
                {
                    '<i class="fa fa-edit mg-r-5"></i>编辑': function (menuItem, menu) {
                        editChannel();
                    }
                },
                {
                    '<i class="fa fa-sort-alpha-desc mg-r-5"></i>排序': function (menuItem, menu) {
                        Sort();
                    }
                }
                <%if((new UserPerm().canDeleteChannel(userinfo_session))){%>
                , {
                    '<i class="fa fa-trash mg-r-5"></i>删除</font>': function (menuItem, menu) {
                        deleteChannel();
                    }
                }
                <%}%>
            ];
            $('.br-subleft').contextMenu(menu, {theme: 'vista', beforeShow: beforeShowFunc});
        })
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
