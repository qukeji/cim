<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 tidemedia.cms.user.*,
                 java.util.*,
                 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%@ include file="workes.jsp" %>
<%!
    //将yyyy-MM-dd变为yyyy-MM-dd HH:mm:ss格式
    public static String formatDate(String time) {
        if (time != null && time != "") {
            time = time.replace("\"", "");
            if (!time.contains("00")) {
                time += " 00:00:00";
            }
            return time;
        } else return "";
    }
%>
<%
    /**
     * 用途：文档列表页
     * 1,李永海 20140101 创建
     * 2,王海龙 20150408  修改	 定制列表页无需再删除重定向代码
     * 3,王海龙 20150609 修改     261行使用user数据源，解决按用户搜索bug
     */

    int listType = 0;
    listType = getIntParameter(request, "listtype");
    int type_flow = getIntParameter(request, "type");
    //if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list_new",request.getCookies()));
    if (listType == 0) listType = 1;

    boolean listAll = false;
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
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
    <script>
        var listType = <%=listType%>;
    </script>

</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">我的稿件</span>
        </nav>
    </div>
    <!-- br-pageheader -->
    <%
        int userinfo_sessionid = userinfo_session.getId();
        int S_Status = getIntParameter(request, "Status1");
        int currPage = getIntParameter(request, "currPage");//页码
        int rowsPerPage = getIntParameter(request, "rowsPerPage");//每页显示数量
        String S_Title = getParameter(request, "Title");
        String S_startDate = getParameter(request, "startDate");
        String S_endDate = getParameter(request, "endDate");
        S_startDate = formatDate(S_startDate);
        S_endDate = formatDate(S_endDate);
        int IsDelete = getIntParameter(request, "IsDelete");
        if (currPage < 1) currPage = 1;
        if (rowsPerPage <= 0) rowsPerPage = 20;

        String querystring = "";
        querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate+"&Status1="+S_Status+"&IsDelete="+IsDelete;
        if (IsDelete == 1) {
            IsDelete = 0;
        } else {
            IsDelete = 1;
        }
        JSONObject jsonObject = searchItemSnap(S_Title, userinfo_sessionid, true, S_startDate, S_endDate, S_Status, IsDelete, currPage, rowsPerPage, "CreateDate", userinfo_session, type_flow);
        int rowsCout = jsonObject.getInt("rowsCout");
        String globalids = jsonObject.getString("globalids");
        for (String globalid : globalids.split(",")) {
            if (globalid.length() > 0) {
                int GlobalID = Integer.parseInt(globalid);
                Document document = new Document(GlobalID);
                int ChannelID = document.getChannelID();
                Channel channel = CmsCache.getChannel(ChannelID);
                if (!channel.hasRight(userinfo_session, 1) && !channel.hasRight(userinfo_session, 12)) {
                    rowsCout--;
                    continue;
                }
            }
        }
        int TotalPageNumber = 0;
        if (rowsCout <= rowsPerPage) {
            TotalPageNumber = 1;
        } else {
            TotalPageNumber = rowsCout / rowsPerPage;
            if (rowsCout % rowsPerPage > 0) {
                TotalPageNumber++;
            }
        }
        String pageName = request.getServletPath();
        int pindex = pageName.lastIndexOf("/");
        if (pindex != -1)
            pageName = pageName.substring(pindex + 1);
    %>
    <!--操作-->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
            <div class="dropdown-menu pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:list();" class="nav-link list_all">全部</a>
                    <a href="javascript:list('Status1=1');" class="nav-link list_draft">草稿</a>
                    <a href="javascript:list('Status1=2');" class="nav-link list_publish">已发</a>
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
            <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_draft">草稿</a>
            <a href="javascript:list('Status1=2');" class="btn btn-outline-info list_publish">已发</a>
            <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <a href="javascript:siderightNewContent2();" class="btn btn-outline-info">新建</a>
            <a href="javascript:Preview_();" class="btn btn-outline-info">预览</a>
            <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>

        </div>

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
            <form name="search_form" action="<%=pageName%>?rowsPerPage=<%=rowsPerPage%>" method="post"
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
                                   value="me">
                        </div>
                    </div>
                    <!--状态-->
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="状态" name="Status1">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                            <option value="2" <%=(S_Status == 1 ? "selected" : "")%>>已发</option>
                            <option value="1" <%=(S_Status == -1 ? "selected" : "")%>>草稿</option>
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

    <%if (1 == 1) {%>
    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" id="content-table">
                <thead>
                <tr>
                    <th class="wd-5p wd-50">选择</th>
                    <th class="tx-12-force tx-mont tx-medium">标题</th>
                    <th class="tx-12-force wd-350 tx-mont tx-medium hidden-xs-down wd-60">节点</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">稿件状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-200">创建时间</th>
                    <th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-160">操作</th>
                </tr>
                </thead>
                <tbody>
                <%

                    int j = 0;
                    int m = 0;
                    int temp_gid = 0;
                    String doc_typeString = "";
                    for (String globalid : globalids.split(",")) {
                        if (globalid.length() > 0) {
                            int GlobalID = Integer.parseInt(globalid);
                            Document document = new Document(GlobalID);
                            int id_ = document.getId();
                            int ChannelID = document.getChannelID();
                            String Title = convertNull(document.getTitle());
                            String CreateDate = document.getCreateDate();
                            int active = document.getActive();
                            String ModifiedDate = document.getModifiedDate();
                            String UserName = document.getUserName();
                            int category = document.getCategoryID();
                            Channel channel = CmsCache.getChannel(ChannelID);
                            boolean canDelete = channel.hasRight(userinfo_session, ChannelPrivilegeItem.CanDelete);
                            if (!channel.hasRight(userinfo_session, 1) && !channel.hasRight(userinfo_session, 12)) {
                                continue;
                            }
                            String channelName = channel.getName();
                            String parentChannelPath2 = CmsCache.getChannel(ChannelID).getParentChannelPath().replaceAll("/", ">");
                            int Status = document.getStatus();
                            String StatusDesc = "";
                            if(IsDelete!=0){
                                if (Status == 0) {
                                    StatusDesc = "<span class='tx-orange'>草稿</span>";
                                } else if (Status == 1) {
                                    StatusDesc = "<span class='tx-success'>已发</span>";
                                }
                            }else {
                                StatusDesc = "<span class='tx-danger'>已删除</span>";
                            }
                            int OrderNumber = rowsCout - j - ((currPage - 1) * rowsPerPage);
                            j++;
                %>
                <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>"
                    GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item">
                    <td class="valign-middle">
                        <label class="ckbox mg-b-0">
                            <input type="checkbox" name="id" value="<%=id_%>"
                                   data-channelid="<%=ChannelID%>"><span></span>
                        </label>
                    </td>
                    <td ondragstart="OnDragStart(event)">
                        <span class="pd-l-5 tx-black"><%=Title%></span>
                    </td>
                    <td class="hidden-xs-down">
                        <a href="../lib/webIndex.jsp?channelid=<%=ChannelID%>" class="btn pd-0 mg-r-5" title="删除"
                           target="blank"><%=parentChannelPath2%>
                        </a>
                    </td>
                    <td class="hidden-xs-down">
                        <%=StatusDesc%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=ModifiedDate%>
                    </td>
                    <td class="dropdown hidden-xs-down">
                        <%if (active == 1) {%>
                        <a href="javascript:Preview_(<%=id_%>);" class="btn pd-0 mg-r-5" title="预览"><i
                                class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                        <a href="javascript:Preview3(<%=id_%>);" class="btn pd-0 mg-r-5" title="正式地址预览"><i
                                class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                        <%}%>
                        <a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i
                                class="icon ion-more"></i></a>
                        <div class="dropdown-menu dropdown-menu-right pd-10">
                            <nav class="nav nav-style-1 flex-column">
                                <a href="javascript:editDocument(<%=id_%>);" class="nav-link">编辑</a>
                                <%if (canDelete) {%>
                                <a href="javascript:deleteFile1(<%=id_%>,<%=ChannelID%>);" class="nav-link">删除</a>
                                <%}%>
                                <a href="javascript:copy(0);" class="nav-link">复制</a>
                                <a href="javascript:copy(1);" class="nav-link">移动</a>
                            </nav>
                        </div>
                        <!-- dropdown-menu -->
                    </td>
                </tr>
                <%
                        }
                    }

                %>
                </tbody>
            </table>
            <script>
                var page = {
                    currPage: '<%=currPage%>',
                    rowsPerPage: '<%=rowsPerPage%>',
                    TotalPageNumber: <%=TotalPageNumber%>
                };
            </script>
            <%if (TotalPageNumber > 0) {%>
            <!--分页-->
            <div id="tide_content_tfoot">
                <label class="ckbox mg-b-0 mg-r-30 ">
                    <input type="checkbox" id="checkAll_1"><span></span>
                </label>
                <span class="mg-r-20 ">共<%=rowsCout%>条</span>
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
                            onChange="change('#rowsPerPage','');" id="rowsPerPage">
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
                    }
                %>
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
        <div class="btn-group hidden-xs-down">
            <a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i
                    class="fa fa-th"></i></a>
            <a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i
                    class="fa fa-th-list"></i></a>
        </div>
        <!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
            <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_draft">草稿</a>
            <a href="javascript:list('Status1=2');" class="btn btn-outline-info list_publish">已发</a>
            <a href="javascript:list('IsDelete=1');" class="btn btn-outline-info list_delete">已删除</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <a href="javascript:addDocument();" class="btn btn-outline-info">新建</a>
            <a href="javascript:Preview_();" class="btn btn-outline-info">预览</a>
            <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
        </div>
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

    </script>
    <script>
        //==========================================
        //设置高亮
        var Status1_ = <%=S_Status%>;
        var IsDelete_ = <%=IsDelete%>;
        var pageName = "<%=pageName%>";
        var Parameter = "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
        var currRowsPerPage = <%=rowsPerPage%>;
        var currPage = <%=currPage%>;
        $(function () {

            if (Status1_ == 1) {

                $(".list_draft").addClass("active");

            } else if (Status1_ == 2) {

                $(".list_publish").addClass("active");

            } else if (IsDelete_ == 0) {

                $(".list_delete").addClass("active");

            } else {
                $(".list_all").addClass("active");
            }

            $(".btn.btn-outline-info").click(function () {
                $(this).parent().children().removeClass("active");
                $(this).addClass("active");
            })

        });

        function deleteFile1(id, channelid) {
            var a = "&ChannelID=" + channelid;
            var message = "确实要删除这1项吗？";
            if (confirm(message)) {
                deleteFile_confirm(id, 0, a);
            }
        }

        function deleteFile_confirm(id, length, a) {

            var url = "../content/document_delete.jsp?check=1&ItemID=" + id + Parameter + a;
            $.ajax({
                type: "GET",
                url: url,
                dataType: "json",
                success: function (msg) {
                    if (msg.status == 0) {
                        var msg2 = "文章已被推荐，是否删除？";
                        if (length > 1) msg2 = "选中的文章有被推荐，是否删除？";

                        if (confirm(msg2)) {
                            deleteFile_(id);
                        }
                    } else {
                        document.location.href = document.location.href;
                    }
                }
            });
        }

        function getCheckbox() {
            var id = "";
            var channelid = "";
            jQuery("#content-table input:checked").each(function (i) {
                if (i == 0) {
                    id += jQuery(this).val();
                    channelid += jQuery(this).attr("data-channelid");
                } else {
                    id += "," + jQuery(this).val();
                    channelid += "," + jQuery(this).attr("data-channelid");
                }
            });
            var obj = {length: jQuery("#content-table input:checked").length, id: id, channelid: channelid};
            return obj;
        }

        //多端预览
        function Preview_() {
            var obj = getCheckbox();
            if (obj.length == 0) {
                TideAlert("提示", "请先选择要预览的文件！");
            } else if (obj.length > 1) {
                TideAlert("提示", "请选择一个预览的文件！");
            } else {
                Preview2_(obj.id, obj.channelid);//window.open("../content/document_preview.jsp?ItemID=" + obj.id + Parameter);
            }
        }

        function Preview2_(id, channelid) {
            window.open("../content/three_terminal_preview.jsp?ItemID=" + id + "&ChannelID=" + channelid + Parameter);
        }

        //编辑
        function editDocument1() {
            var obj = getCheckbox();
            if (obj.length == 0) {
                TideAlert("提示", "请先选择要编辑的文件！");
            } else if (obj.length > 1) {
                TideAlert("提示", "请先选择一个要编辑的文件！");
            } else {
                editDocument(obj.id, obj.channelid);
            }
        }

        function editDocument(itemid, channelid) {
            var code = approve_check_2(itemid, 1);
            /*if(!approve_check_2(itemid,1)){
                TideAlert("提示","审核中的文档不能进行编辑！");
                return;
            }*/
            if (code == 1) {
                TideAlert("提示", "该环节审核方案未开启编辑功能！");
                return;
            } else if (code == 3) {
                TideAlert("提示", "不是未提交审核或审核被驳回的稿件！");
                return;
            } else if (code == 4) {
                TideAlert("提示", "终审通过的稿件不能编辑！");
                return;
            }

            var url = "../content/document.jsp?ItemID=" + itemid + "&ChannelID=" + channelid;
            window.open(url);
        }

        function list(str) {
            var url = pageName + "?rowsPerPage=<%=rowsPerPage%>";
            if (typeof (str) != 'undefined')
                url += "&" + str;
            this.location = url;
        }

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
        function gopage(currpage) {
            var url = pageName + "?currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
            this.location = url;
        }
    </script>

</div>
</body>

</html>
