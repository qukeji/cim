<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../config.jsp"%>
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
    int id = getIntParameter(request,"id");
    int currPage = getIntParameter(request,"currPage");
    int rowsPerPage = getIntParameter(request,"rowsPerPage");
    int sortable = getIntParameter(request,"sortable");
    int rows = getIntParameter(request,"rows");
    int cols = getIntParameter(request,"cols");
    int UserId = userinfo_session.getId();

    int listType = 0;
    listType = getIntParameter(request,"listtype");
    if(listType==0) listType = Util.parseInt(Util.getCookieValue(id+"_list_new",request.getCookies()));
    if(listType==0) listType = 1;

    if(currPage<1)
        currPage = 1;

    if(rowsPerPage==0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new",request.getCookies()));

    if(rowsPerPage<=0)
        rowsPerPage = 20;

    if(rows==0)
        rows = Util.parseInt(Util.getCookieValue("rows_new",request.getCookies()));
    if(cols==0)
        cols = Util.parseInt(Util.getCookieValue("cols_new",request.getCookies()));

    if(rows==0)
        rows = 10;
    if(cols==0)
        cols = 5;

    String S_Title				=	getParameter(request,"Title");
    String S_startDate			=	getParameter(request,"startDate");
    String S_endDate			=	getParameter(request,"endDate");
    int S_Status				=	getIntParameter(request,"Status");
    int S_OpenSearch			=	getIntParameter(request,"OpenSearch");
    int IsDelete				=	getIntParameter(request,"IsDelete");

    int Status1 = getIntParameter(request,"Status");

    String querystring = "";
    querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&startDate="+S_startDate+"&endDate="+S_endDate;

    String pageName = request.getServletPath();
    int pindex = pageName.lastIndexOf("/");
    if(pindex!=-1)
        pageName = pageName.substring(pindex+1);
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
    <link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
    <style>
        .collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;}
        table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
        table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
            border-collapse: collapse !important;}
        .list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;position: relative;}
        /*.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}*/
        .list-pic-box .list-img-contanier{width: 100%;position: absolute;left: 0;top: 0;height: 100%;display: flex;justify-content: center;align-items: center;}
        .list-pic-box .list-img-contanier img{width: auto;max-height: 100%;max-width: 100%;}
        @media (max-width: 575px){
            #content-table .hidden-xs-down {word-break: normal;	}
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
    <script>
        var listType = <%=listType%>;
        var rows = <%=rows%>;
        var cols = <%=cols%>;
        var ChannelID = 0;
        var currRowsPerPage = <%=rowsPerPage%>;
        var currPage = <%=currPage%>;
        var Parameter = "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
        var pageName = "<%=pageName%>";
        if (pageName == "") pageName = "my_approveContent.jsp";
        function gopage(currpage) {
            var url = pageName + "?currPage=" + currpage + "&rowsPerPage=<%=rowsPerPage%><%=querystring%>";
            console.log(url);
            this.location = url;
        }

        function list(str) {
            var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
            if (typeof(str) != 'undefined')
                url += "&" + str;
            this.location = url;
        }
        function recommendOut1(id)
        {
            var	dialog = new top.TideDialog();
            dialog.setWidth(500);
            dialog.setHeight(400);
            dialog.setUrl("../recommend/out_index.jsp?ChannelID="+ChannelID+"&ItemID="+id);
            dialog.setTitle('推荐');
            dialog.setChannelName(ChannelName);
            dialog.show();
        }
        //编辑
        function editDocument(itemid)
        {
            var code = approve_check_2(itemid,1);
            if(code ==1){
                TideAlert("提示","该环节审核方案未开启编辑功能！");
                return;
            }else if(code ==3){
                TideAlert("提示","不是未提交审核或审核被驳回的稿件！");
                return;
            }else if(code ==4){
                TideAlert("提示","终审通过的稿件不能编辑！");
                return;
            }
            if(typeof(itemid)=="undefined")
                itemid = obj.id;
            var url="../content/document.jsp?ItemID="+itemid+"&ChannelID=" + ChannelID;
            window.open(url);
        }
    </script>
</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">我的审核</span>
        </nav>
    </div>
    <!-- br-pageheader -->
    <%
        if(listType==2) rowsPerPage = cols*rows;
        JSONObject object = new ApproveDocument().getMyApprove("",UserId,S_Status,request,"",currPage,rowsPerPage,S_Title,S_startDate,S_endDate);
        JSONArray jsonArray = object.getJSONArray("list");
        int sum = object.getInt("sum");
        int pageNum = object.getInt("pageNum");
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
            <a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
            <a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
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
            <a href="javascript:Preview_();" class="btn btn-outline-info">预览</a>
            <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
            <a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>
            <%if(false){%>
            <a href="javascript:copy(0)" class="btn btn-outline-info hidden-md-1500-down">复制</a>
            <a href="javascript:copy(1)" class="btn btn-outline-info hidden-md-1500-down">移动</a>
            <%}%>
        </div>
        <!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
            <div class="dropdown-menu dropdown-menu-right pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:addDocument();" class="nav-link">新建</a>
                    <a href="javascript:Preview();" class="nav-link">预览</a>
                    <a href="javascript:editDocument1();" class="nav-link">编辑</a>
                    <a href="javascript:deleteFile2();" class="nav-link">撤稿</a>
                    <a href="javascript:copy(0);" class="nav-link">复制</a>
                    <a href="javascript:copy(1);" class="nav-link">移动</a>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <!--上一页 下一页-->
        <div class="btn-group mg-l-10">
            <%if(currPage>1){%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if(currPage<pageNum){%>
            <a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
        <!-- btn-group -->

    </div>
    <!--操作-->

    <!--搜索-->
    <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
        <div class="search-content bg-white">
            <form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post" onsubmit="return check();">
                <div class="row">
                    <!--标题-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <input class="form-control search-title" placeholder="标题" type="text" name="Title" value="<%=S_Title%>" onClick="this.select()">
                    </div>
                    <!--日期-->
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="startDate" value="<%=S_startDate%>" id="startDate">
                        </div>
                    </div>
                    <div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="endDate" value="<%=S_endDate%>" id="endDate">
                        </div>
                    </div>
                    <!-- wd-200 -->
                    <!--状态-->
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="状态" name="Status">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                            <option value="2" <%=(S_Status==2?"selected":"")%>>已发</option>
                            <option value="1" <%=(S_Status==1?"selected":"")%>>草稿</option>
                        </select>
                    </div>
                    <div class="search-item mg-b-30">
                        <input type="hidden" name="IsIncludeSubChannel" value="1">
                        <input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
                        <input type="hidden" name="OpenSearch" id="OpenSearch" value="1">
                    </div>
                </div>
                <!-- row -->
            </form>
        </div>
    </div>
    <!--搜索-->

    <%if(1==1){%>
    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0 <%=listType==2?"table-fixed":""%>" id="content-table">
                <%if(listType==1){%>
                <thead>
                <tr>
                    <th class="wd-5p wd-50">选择</th>
                    <th class="tx-12-force tx-mont tx-medium">标题</th>
                    <th class="tx-12-force wd-350 tx-mont tx-medium hidden-xs-down wd-60">节点</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">审核状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">稿件状态</th>
                    <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">创建时间</th>
                    <th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down wd-160">操作</th>
                </tr>
                </thead>
                <%}%>
                <tbody>
                <%
                    int j = 0;
                    int m = 0;
                    for(int i=0;i<jsonArray.length();i++){
                        JSONObject o = jsonArray.getJSONObject(i);
                        int GlobalID = (int)o.get("GlobalID");
                        int ChannelID1 = (int)o.get("ChannelID");
                        Channel channel1 = CmsCache.getChannel(ChannelID1);
                        String approve_status = "未提交审核";
                        ApproveAction approve = new ApproveAction(GlobalID, 0);//最近一次审核操作
                        int id_aa = approve.getId();//审核操作id
                        int approveId = approve.getApproveId();//审核环节id
                        int action = approve.getAction();//是否通过
                        int end = approve.getEndApprove();//是否终审
                        int editables = 0;

                        JSONObject json1 = null;
                        if (id_aa != 0) {//说明已配置审核环节
                            ApproveItems ai = new ApproveItems(approveId);//审核环节
                            if (approveId == 0) {//审核环节编号为0，此文章状态为提交审核
                                json1 = ai.getApproveName(channel1.getApproveScheme());
                                approve_status = json1.get("ApproveName") + "待审核";
                                editables = (int) json1.get("Editable");
                            } else {
                                json1 = ai.getApproveName(0);
                                approve_status = json1.get("ApproveName") + "待审核";
                                editables = (int) json1.get("Editable");
                                int endLink = (int) json1.get("endLink");
                                int type = ai.getType();
                                String userIds = ai.getUsers();

                                if (!userIds.equals("")) {
                                    String[] users = userIds.split(",");
                                    JSONObject json = getUserNames(users, getAction(GlobalID), GlobalID, ai.getId());
                                    int size = json.getInt("size");
                                    if (type == 1) {//并签要判断其他人是否审核通过
                                        if (size > 0) {
                                            approve_status = approve.getApproveName() + "待审核";
                                        }
                                        //确保最后环节为并签时有用户审核通过导致稿件不可编辑
                                        if (endLink == 1) {
                                            editables = 2;
                                        }
                                    }
                                }

                                if (action == 1) {//未通过
                                    approve_status = approve.getApproveName() + "驳回";
                                }
                                if (action == 0 && end == 1) {
                                    approve_status = approve.getApproveName() + "通过";
                                }
                            }

                        }

                        Document document = CmsCache.getDocument(GlobalID);
                        String SiteAddress = document.getChannel().getSite().getUrl();
                        int Status =document.getStatus();
                        int ChannelID2 = (int)o.get("ChannelID");
                        int id_ = (int)o.get("id");
                        String Title = o.get("title")+"";
                        String documentStatus = o.get("documentStatus")+"";
                        String approveStatus = o.get("StatusDesc")+"";
                        String CreateDate = o.get("date")+"";
                        int TopStatus = 0;
                        int IsPhotoNews=document.getIsPhotoNews();
                        int Weight=document.getWeight();
                        int active = document.getActive();
                        Channel channel2 = CmsCache.getChannel(ChannelID2);
                        String parentChannelPath2 = channel2.getParentChannelPath().replaceAll("/",">");
                        int OrderNumber = sum-j-((currPage-1)*rowsPerPage);
                        j++;
                        if(listType==1)
                        {
                %>
                <tr No="<%=j%>" ItemID="<%=id_%>" OrderNumber="<%=OrderNumber%>" status="<%=Status%>"
                    GlobalID="<%=GlobalID%>" id="item_<%=id_%>" class="tide_item" end="<%=end%>" actionId="<%=id_aa%>"
                    approve="1" ApproveAction="<%=action%>" Editables="<%=editables%>">
                    <td class="valign-middle">
                        <label class="ckbox mg-b-0">
                            <input type="checkbox" name="id" value="<%=id_%>" data-channelid="<%=ChannelID2%>"><span></span>
                        </label>
                    </td>
                    <td ondragstart="OnDragStart(event)">
                        <%if(IsPhotoNews==1){%>
                        <i class="fa fa-picture-o drag-list tx-18 tx-primary lh-0 valign-middle" id="img_<%=j%>"></i>
                        <%}else{%>
                        <i class="icon drag-list ion-clipboard tx-22 tx-warning lh-0 valign-middle" id="img_<%=j%>"></i>
                        <%}%>
                        <%if(TopStatus==0){%><%}else{%>
                        <i class="fa fa-upload tx-20 tx-warning lh-0 valign-middle" id="imgtop_<%=j%>" title="置顶"></i>
                        <%}%>
                        <span class="pd-l-5 tx-black"><%=Title%></span>
                    </td>
                    <td class="hidden-xs-down">
                        <a href="../lib/webIndex.jsp?channelid=<%=ChannelID2%>" class="btn pd-0 mg-r-5" title="<%=ChannelID2%>" target="blank"><%=parentChannelPath2%></a>
                    </td>
                    <td class="hidden-xs-down sh-td" data-id="<%=GlobalID%>">
                        <span class="pop-start"><%=approve_status%></span>
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
                        <%=documentStatus%>
                    </td>
                    <td class="hidden-xs-down">
                        <%=CreateDate%>
                    </td>

                    <td class="dropdown hidden-xs-down">
                        <%if(active==1){%>
                        <a href="javascript:Preview2_(<%=id_%>,<%=ChannelID2%>);" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                        <a href="javascript:Preview3_(<%=id_%>,<%=ChannelID2%>);" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                        <%}%>
                        <a href="#" data-toggle="dropdown" class="btn pd-y-3 tx-gray-500 hover-info"><i class="icon ion-more"></i></a>
                        <div class="dropdown-menu dropdown-menu-right pd-10">
                            <nav class="nav nav-style-1 flex-column">
                        <%}
                                    if(listType==2)
                                    {
                                        String Photo	= "";
                                        String photoAddr = "";
                                        if(Photo.startsWith("http://"))
                                            photoAddr = Photo;
                                        else
                                            photoAddr = SiteAddress + Photo;
                                        if(m==0) out.println("<tr>");
                                        m++;
                                %>
                    <td id="item_<%=id_%>" status="<%=Status%>" class="tide_item" class="c">
                        <div class="row">
                            <div class="col-md">
                                <div class="card bd-0">
                                    <div class="list-pic-box">
                                        <div class="list-img-contanier">
                                            <img class="card-img-top" src="<%=photoAddr%>" alt="Image" onerror="checkLoad(this);" >
                                        </div>
                                    </div>
                                    <div class="card-body bd-t-0 rounded-bottom">
                                        <p class="card-text"><%if(IsPhotoNews==1){%><i class="icon ion-image tx-22 tx-warning lh-0 valign-middle"></i><%}%><%=Title%>(<%=documentStatus%>)</p>
                                        <div class="row mg-l-0 mg-r-0 mg-t-5">
                                            <label class="ckbox mg-b-0 d-inline-block mg-r-5">
                                                <input name="id" value="<%=id_%>" data-channelid="<%=ChannelID2%>" type="checkbox"><span></span>
                                            </label>
                                            <a href="javascript:Preview2_(<%=id_%>,<%=ChannelID2%>);" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                                            <a href="javascript:Preview3_(<%=id_%>,<%=ChannelID2%>);" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </td>
                        <%
		                    if(m==cols){ out.println("</tr>");m=0;}
	                }
                }
                    if(listType==2 && m<cols) out.println("</tr>");
%>
                        <%--</div>--%>
                        <!-- dropdown-menu -->
                    </td>
                </tr>
                <%}%>
                </tbody>
            </table>

            <script>
                var page = {
                    id: '<%=id%>',
                    currPage: '<%=currPage%>',
                    rowsPerPage: '<%=rowsPerPage%>',
                    querystring: '<%=querystring%>',
                    TotalPageNumber: <%=sum%>
                };
            </script>

            <%if(pageNum>0){%>
            <!--分页-->
            <div id="tide_content_tfoot">
                <label class="ckbox mg-b-0 mg-r-30 ">
                    <input type="checkbox" id="checkAll_1"><span></span>
                </label>
                <span class="mg-r-20 ">共<%=sum%>条</span>
                <span class="mg-r-20 "><%=currPage%>/<%=pageNum%>页</span>

                <%if(pageNum>1){%>
                <div class="jump_page ">
                    <span class="">跳至:</span>
                    <label class="wd-60 mg-b-0">
                        <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                    </label>
                    <span class="">页</span>
                    <a href="javascript:jumpPage();" class="tx-14">Go</a>
                </div>
                <%}%>
                <%if(listType==1){%>
                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage','<%=id%>');" id="rowsPerPage">
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
                <%}
                    if(listType==2){%>

                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rows" class="form-control select2 wd-80" data-placeholder="" onChange="changeRowsCols();" id="rows">
                        <option value="3">3</option>
                        <option value="5">5</option>
                        <option value="8">8</option>
                        <option value="10">10</option>
                        <option value="20">20</option>
                        <option value="50">50</option>
                        <option value="100">100</option>
                    </select>
                    <span class="">行</span>
                    <select name="cols" class="form-control select2 wd-80" data-placeholder="" onChange="changeRowsCols();" id="cols">
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
            <a href="javascript:changeList(2);" class="btn btn-outline-info <%=listType==2?"active":""%>"><i class="fa fa-th"></i></a>
            <a href="javascript:changeList(1);" class="btn btn-outline-info <%=listType==1?"active":""%>"><i class="fa fa-th-list"></i></a>
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
            <a href="javascript:Preview_();" class="btn btn-outline-info">预览</a>
            <a href="javascript:editDocument1();" class="btn btn-outline-info">编辑</a>
            <a href="javascript:deleteFile2();" class="btn btn-outline-info">撤稿</a>
            <%if(false){%>
            <a href="javascript:copy(0)" class="btn btn-outline-info hidden-md-1500-down">复制</a>
            <a href="javascript:copy(1)" class="btn btn-outline-info hidden-md-1500-down">移动</a>
            <%}%>
        </div>

        <!-- btn-group -->
        <!--<div class="btn-group mg-l-10 hidden-sm-down">-->
        <div class="btn-group mg-l-10">
            <%if(currPage>1){%>
            <a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
            <%}%>
            <%if(currPage<pageNum){%><a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
            <%}%>
        </div>
        <!-- btn-group -->
    </div>
    <!--操作-->

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
        $(function() {
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
        $(function() {
            'use strict';

            //show only the icons and hide left menu label by default
            $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');

            $(document).on('mouseover', function(e) {
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

            $('#showMailBoxLeft').on('click', function(e) {
                e.preventDefault();
                if ($('body').hasClass('show-mb-left')) {
                    $('body').removeClass('show-mb-left');
                    $(this).find('.fa').removeClass('fa-arrow-left').addClass('fa-arrow-right');
                } else {
                    $('body').addClass('show-mb-left');
                    $(this).find('.fa').removeClass('fa-arrow-right').addClass('fa-arrow-left');
                }
            });
            <%if(listType==1){%>
            $("table tbody tr").click(function(){
                $(this).find("input:checkbox").click();
            })
            <%}%>
            $("table tbody tr").find("input:checkbox").click(function(){
                var parentTr = $(this).parents("tr");
                ChannelID =  $(this).attr('data-channelid');
                if(Parameter.indexOf("&ChannelID")!=0){
                    Parameter = "&ChannelID="+ChannelID+Parameter;
                }
            })

            //适配列表页平铺下的单个选中
            <%if(listType==2){%>
            $("#content-table tr td").click(function() {
                if($("#content-table").hasClass("table-fixed")){
                    if ($(this).find("input[type='checkbox']").prop("checked")){
                        $(this).find(":checkbox").prop("checked", false);
                        $(this).removeClass("bg-gray-100");
                    }else{
                        $(this).find("input[type='checkbox']").prop("checked", true);
                        $(this).addClass("bg-gray-100");
                    }
                    //checkAllCheckbox()
                }
                ChannelID = $(this).find(":checkbox").attr("data-channelid");
                if(Parameter.indexOf("&ChannelID")!=0){
                    Parameter = "&ChannelID="+ChannelID+Parameter;
                }
            });
            <%}%>

            $("#content-table tr:gt(0) td").click(function() {
                var _tr = $(this).parent("tr")
                if(!$("#content-table").hasClass("table-fixed")){
                    if( _tr.find(":checkbox").prop("checked") ){
                        _tr.find(":checkbox").removeAttr("checked");
                        $(this).parent("tr").removeClass("bg-gray-100");
                    }else{
                        _tr.find(":checkbox").prop("checked", true);
                        $(this).parent("tr").addClass("bg-gray-100");
                    }
                }
            });

            $("#checkAll,#checkAll_1").click(function() {
                if($("#content-table").hasClass("table-fixed")){
                    var checkboxAll = $("#content-table tr").find("td").find(":checkbox") ;
                }else{
                    var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox") ;
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
            $(".btn-search").click(function() {
                $(".search-box").toggle(100);
            })
            //表头排序
            $("#content-table").tablesorter({headers: { 0: { sorter: false}}});
            // Datepicker
            tidecms.setDatePicker(".fc-datepicker");

        });

        $(function(){

            <%if(S_OpenSearch!=1){%>
            sortable();
            sortableEnable();
            //sortableDisable();
            <%if(sortable==1){%>
            //sortableEnable();
            <%}%>
            <%}%>

            $('tbody').on('mousedown','tr td',function(e){

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
            var beforeShowFunc = function() {
                //console.log( getActiveNav() )
            };
            var menu = [
                {'<i class="fa fa fa-eye mg-r-5"></i>预览':function(menuItem,menu) {Preview(); }},
                {'<i class="fa fa-edit mg-r-5 fa"></i>编辑':function(menuItem,menu) {editDocument1(); }},
                {'<i class="fa fa-arrow-down mg-r-5 fa"></i>撤稿':function(menuItem,menu) {deleteFile2(); }},
                {'<i class="fa fa-clone mg-r-5 fa"></i>复制':function(menuItem,menu) {copy(0)}},
                {'<i class="fa fa-arrows mg-r-5 fa"></i>移动':function(menuItem,menu) {copy(1)}},
            ];
            $('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
        })



        function siderightNewContent2(){

            var url ="../lib/sidebar_new_content.jsp";
            var	dialog = new top.TideDialog();
            dialog.setWidth(750);
            dialog.setHeight(600);
            dialog.setUrl(url);
            dialog.setTitle('新建内容');
            //dialog.setChannelName('资源栏目');
            dialog.show();
        }
        function Preview2_(id,channelId)
        {
            var parameter1 = Parameter;
            Parameter = Parameter.substring(Parameter.indexOf("&rowsPerPage"));
            window.open("../content/three_terminal_preview.jsp?ItemID=" + id + parameter1);
        }
        function Preview3_(id,channelId)
        {
            var parameter1 = Parameter;
            Parameter = Parameter.substring(Parameter.indexOf("&rowsPerPage"));
            window.open("../content/three_terminal_preview.jsp?ItemID=" + id + parameter1+"&type=1");
        }
        function double_click()
        {
            jQuery("#content-table .tide_item").dblclick(function(){
                var obj=jQuery(":checkbox",jQuery(this));
                obj.trigger("click");
                editDocument(obj.val(),1);
            });
        }

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
        function editDocument1()
        {
            var obj=getCheckbox();
            if(obj.length==0){
                TideAlert("提示","请先选择要编辑的文件！");
            }else if(obj.length>1){
                TideAlert("提示","请先选择一个要编辑的文件！");
            }else{
                editDocument(obj.id);
            }
        }
    </script>

</div>
</body>

</html>