<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="Shortcut Icon" href="${request.contextPath}/favicon.ico">
    <title>TideCMS 列表</title>
    <link href="${request.contextPath}/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/select2/css/select2.min.css" rel="stylesheet">
    <link href="${request.contextPath}/lib/2018/jt.timepicker/jquery.timepicker.css" rel="stylesheet">
    <link rel="stylesheet" href="/tcenter/style/2018/bracket2019.css">
    <link rel="stylesheet" href="${request.contextPath}/style/2018/common.css">
    <link href="${request.contextPath}/style/contextMenu.css" type="text/css" rel="stylesheet" />
    <style>
        .collapsed-menu .br-mainpanel-file {margin-left: 0;margin-top: 0;background: #f9fafc;}
        table.table-fixed{table-layout: fixed;word-break: break-all;word-wrap: break-word}
        table.table-fixed,table.table-fixed th,table.table-fixed td{border:1px solid #dee2e6;
            border-collapse: collapse !important;}
        .list-pic-box{width: 100%;height: 0;padding-bottom: 56.25%;overflow: hidden;text-align: center;position: relative;}
        /*.list-pic-box img{max-width: 100%;min-width:100%;min-height: 100%;height: auto;display: block;}*/
        .list-pic-box .list-img-contanier{width: 100%;position: absolute;left: 0;top: 0;height: 100%;display: flex;justify-content: center;align-items: center;}
        .list-pic-box .list-img-contanier img{width: auto;max-height: 100%;max-width: 100%;}
        @media (max-width: 575px){
            #content-table .valign-middle {word-break: normal;	}
        }
        body{
            background:#e9ecef;
        }
    </style>

    <script src="${request.contextPath}/lib/2018/jquery/jquery.js"></script>
    <script src="${request.contextPath}/js/userColor.js"></script>
    <script type="text/javascript" src="${request.contextPath}/common/2018/common2018.js"></script>
    <script type="text/javascript" src="${request.contextPath}/common/2018/content.js"></script>
    <script>
        var listType = ${listType!''};
        var rows = ${rows};
        var cols = ${cols};

        var ChannelID = "${ChannelID}";
        console.log(ChannelID);
        var currRowsPerPage = ${rowsPerPage};
        var currPage = ${currPage};
        var ChannelName = "${ChannelName}";
        var Parameter = "&ChannelID=" + ChannelID + "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
        var pageName = "${pageName}";
        if (pageName == "") pageName = "content.jsp";

        // add by glp
        <#--var canApprove = ${canApprove?string('true','false')};-->
        <#--var createCategory = ${createCategory?string('true','false')};-->
        <#--var channel = ${channel};-->
        <#--var IsWeight = ${IsWeight};-->
        <#--var IsTopStatus = ${IsTopStatus?string('true','false')};-->
        <#--var canDelete = ${canDelete?string('true','false')};-->
        <#--var hasRight = ${hasRight?string('true','false')};-->
        <#--var IsComment = ${IsComment};-->
        <#--var IsClick = ${IsClick};-->
        <#--var TotalPageNumber = ${TotalPageNumber};-->

        function gopage(currpage) {
            var url = pageName + "?currPage=" + currpage + "&id=${id}&rowsPerPage=${rowsPerPage}${querystring}";
            this.location = url;
        }

        function list(str) {
            var url = pageName + "?id=${id}&rowsPerPage=${rowsPerPage}";
            if (typeof(str) != 'undefined')
                url += "&" + str;
            this.location = url;
        }

        function orderReply(id)
        {
            var url = "../operate/workorder_preview?ItemID="+id;
            // this.location = url;
            window.open(url);
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
        function addDocument_()
        {
            // var url="../default/document2019?ItemID=0&ChannelID=" + ChannelID;
            var url="../default/orderlist2019?ItemID=0&ChannelID=" + ChannelID;
            window.open(url);
        }

        //编辑
        function editDocument(itemid)
        {
            var url="${request.contextPath}/operate/training?id="+itemid;
            location.href=url;
        }

        // update
        function editDocument1_()
        {
            var obj=getCheckbox();
            if(obj.length==0){
                TideAlert("提示","请先选择要编辑的文件！");
            }else if(obj.length>1){
                TideAlert("提示","请先选择一个要编辑的文件！");
            }else{
                editDocument_(obj.id);
            }
        }
        function editDocument_(itemid)
        {

            var url="${request.contextPath}/operate/workorder_preview?ItemID="+itemid+"&ChannelID=" + ChannelID;
            window.open(url);
        }

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
</head>

<body class="collapsed-menu email"  id="green">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20" style="background:rgb(249, 250, 252)">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">${parentChannelPath}</span>
        </nav>
    </div>
    <!-- br-pageheader -->

    <!--操作-->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!-- START: 只显示在移动端 -->
        <div class="dropdown hidden-sm-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
            <div class="dropdown-menu pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:list();" class="nav-link list_all">全部</a>
                    <a href="javascript:list('operation_status=1');" class="btn btn-outline-info list_delete">文件</a>
                    <a href="javascript:list('operation_status=2');" class="btn btn-outline-info list_publish">视频</a>
                    <a href="#" class="nav-link">搜索</a>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>


        <!-- dropdown -->
        <!-- END: 只显示在移动端-->

    <#--        <div class="btn-group valign-middle">-->
    <#--            <a href="javascript:changeList(2);" class="btn btn-outline-info ${(listType == 0)?string('active','')}"><i class="fa fa-th"></i></a>-->
    <#--            <a href="javascript:changeList(1);" class="btn btn-outline-info ${(listType == 1)?string('active','')}"><i class="fa fa-th-list"></i></a>-->
    <#--        </div>-->
        <!-- btn-group -->
        <div class="btn-group mg-l-10 valign-middle">
            <a href="javascript:list();" class="btn btn-outline-info list_albtn btn-outline-info list_publishl">全部</a>
            <a href="javascript:list('operation_status=2');" class="btn btn-outline-info list_publish">视频</a>
            <a href="javascript:list('operation_status=1');" class="btn btn-outline-info list_delete">文件</a>
        </div>
        <div class="btn-group mg-l-10 valign-middle">
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <a href="javascript:editDocument1();" class="btn btn-outline-info">查看</a>
        <#--<a href="javascript:editDocument1();" class="btn btn-outline-info">下载</a>-->
            <#if canDelete = true >
                <!-- <a href="javascript:deleteFile();" class="btn btn-outline-info">删除</a> -->
            </#if>
        </div>

        <!-- dropdown -->
        <!-- END: 按钮过多时的部分功能下拉 -->
        <!-- START: 只显示在移动端 -->
        <div class="dropdown mg-l-auto hidden-md-up">
            <a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
            <div class="dropdown-menu dropdown-menu-right pd-10">
                <nav class="nav nav-style-1 flex-column">
                    <a href="javascript:editDocument1();" class="nav-link">查看</a>
                    <a href="javascript:addDocument();" class="nav-link">下载</a>
                    <#if canDelete = true >
                       <!-- <a href="javascript:deleteFile();" class="nav-link">删除</a>-->
                    </#if>
                </nav>
            </div>
            <!-- dropdown-menu -->
        </div>
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <!--上一页 下一页-->
        <div class="btn-group mg-l-10">
            <#if (currPage > 1)>
                <a href="javascript:gopage(${currPage}-1)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
            </#if>

            <#if (currPage < TotalPageNumber)>
                <a href="javascript:gopage(${currPage}+1)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
            </#if>
        </div>
        <!-- btn-group -->

    </div>
    <!--操作-->

    <!--搜索-->
    <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
        <div class="search-content bg-white">
            <form name="search_form" action="${pageName}?id=${id}&rowsPerPage=${rowsPerPage}" method="post" onsubmit="return check();">
                <div class="row">
                    <!--标题-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <input class="form-control search-title" placeholder="标题" type="text" name="Title" value="${S_Title}" onClick="this.select()">
                    </div>
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="状态" name="operation_status">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                            <option value="2" ${(S_Status==2)?string('selected','')} >视频</option>
                            <option value="1" ${(S_Status==1)?string('selected','')} >文件</option>
                        </select>
                    </div>
                    <!--日期-->
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="startDate" value="${S_startDate}" id="startDate">
                        </div>
                    </div>
                    <div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="endDate" value="${S_endDate}" id="endDate">
                        </div>
                    </div>
                    <!-- wd-200 -->
                    <!--状态-->

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

    <#if hasRight == true>
    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0 ${(listType==2)?string('table-fixed','')}" id="content-table">
            <#if listType == 1>
            <thead>
            <tr>
                <th class="wd-5p wd-50">选择</th>
                <th class="tx-12-force tx-mont tx-medium valign-middle wd-300">标题</th>
                <th class="tx-12-force tx-mont tx-medium valign-middle wd-100">类型</th>
                <th class="tx-12-force tx-mont tx-medium valign-middle wd-150">更新时间</th>
                <th class="tx-12-force wd-100 tx-mont tx-medium valign-middle wd-100">操作</th>
            </tr>
            </thead>
            </#if>
                <tbody>

            <#list list as key>
            <#--<#list map?keys as key>-->
                <#if listType == 1>
                             <tr No="${key.j}" ItemID="${key.id_}" OrderNumber="${key.OrderNumber}" status="${key.Status}" GlobalID="${key.GlobalID}" id="item_${key.id_}" class="tide_item">
                                 <td class="valign-middle">
                                     <label class="ckbox mg-b-0">
                                         <input type="checkbox" name="id" value="${key.id_}"><span></span>
                                     </label>
                                 </td>
                                 <td ondragstart="OnDragStart(event)">
                                     <span class="pd-l-5 tx-black">${key.Title}</span>
                                 </td>
                                 <td class="valign-middle">
                                     ${key.StatusDesc}
                                 </td>
                                 <td class="valign-middle">
                                     ${key.PublishDate}
                                 </td>
                                 <td class="dropdown valign-middle">
                                     <label><button onclick="editDocument(${key.id_})" class=" btn btn-info btn-sm mg-r-8 mg-b-8 tx-13">查看</button></label>
                                 </td>
                             </tr>
                <#elseif listType == 2>

                    <#if key.m==0>
                                 <tr>
                    </#if>

                             <td id="item_${key.id_}" status="${key.Status}" class="tide_item" class="c">
                                 <div class="row">
                                     <div class="col-md">
                                         <div class="card bd-0">
                                             <div class="list-pic-box">
                                                 <div class="list-img-contanier">
                                                     <img class="card-img-top" src="${key.photoAddr}" alt="Image" onerror="checkLoad(this);" >
                                                 </div>
                                             </div>
                                             <div class="card-body bd-t-0 rounded-bottom">
                                                 <p class="card-text">
                                                     <#if key.IsPhotoNews == 1>
                                                        <i class="icon ion-image tx-22 tx-warning lh-0 valign-middle"></i>
                                                     </#if>
                                                     ${key.Title}(${key.StatusDesc})</p>
                                                 <div class="row mg-l-0 mg-r-0 mg-t-5">
                                                     <label class="ckbox mg-b-0 d-inline-block mg-r-5">
                                                         <input name="id" value="${key.id_}" type="checkbox"><span></span>
                                                     </label>
                                                     <#if (key.active == 1) && (canApprove == true)>
                                                     <a href="javascript:approve2(${key.id_});" class="btn pd-0 mg-r-5" title="发布发布发布发布发布"><i class="fa fa-cloud-upload tx-18 handle-icon" aria-hidden="true"></i></a>
                                                     </#if>
                                                     <#if (key.active == 0) && (canDelete == true)>
                                                     <a href="javascript:resume(${key.id_});" class="btn pd-0 mg-r-5" title="恢复"><i class="fa fa-reply tx-18 handle-icon" aria-hidden="true"></i></a>
                                                     <#else >
                                                     <a href="javascript:Preview2(${key.id_});" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a>
                                                     <a href="javascript:Preview3(${key.id_});" class="btn pd-0 mg-r-5" title="正式地址预览"><i class="fa fa-eye tx-18 handle-icon" aria-hidden="true"></i></a>
                                                     </#if>
                                                 </div>
                                             </div>
                                         </div>
                                     </div>
                                 </div>
                             </td>

                    <#if key.m==cols>
                                </tr>
                    </#if>

                <#else >
                </#if>

            </#list>

            <#if (m_<cols)&&(listType == 2)>
                     </tr>
            </#if>

                </tbody>
            </table>

            <script>
                var page = {
                    id: '${id}',
                    currPage: '${currPage}',
                    rowsPerPage: '${rowsPerPage}',
                    querystring: '${querystring}',
                    TotalPageNumber: '${TotalPageNumber}'
                };
            </script>

            <#if (TotalPageNumber > 0)>
            <!--分页-->
            <div id="tide_content_tfoot">
                <label class="ckbox mg-b-0 mg-r-30 ">
                    <input type="checkbox" id="checkAll_1"><span></span>
                </label>
                <span class="mg-r-20 ">共${TotalNumber}条</span>
                <span class="mg-r-20 ">${currPage}/${TotalPageNumber}页</span>

                <#if (TotalPageNumber > 1)>
                <div class="jump_page ">
                    <span class="">跳至:</span>
                    <label class="wd-60 mg-b-0">
                        <input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum">
                    </label>
                    <span class="">页</span>
                    <a href="javascript:jumpPage();" class="tx-14">Go</a>
                </div>
                </#if>
                <#if listType == 1>
                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage','${id}');" id="rowsPerPage">
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
                </#if>
                <#if listType == 2>

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

                </#if>
            </div>
            <!--分页-->
            </#if>
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
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->
    <#--        <div class="btn-group valign-middle">-->
    <#--            <a href="javascript:changeList(2);" class="btn btn-outline-info ${(listType==2)?string('active','')}"><i class="fa fa-th"></i></a>-->
    <#--            <a href="javascript:changeList(1);" class="btn btn-outline-info ${(listType==1)?string('active','')}"><i class="fa fa-th-list"></i></a>-->
    <#--        </div>-->
        <!-- btn-group -->
        <!-- btn-group -->


        <!-- dropdown -->
        <!-- END: 按钮过多时的部分功能下拉 -->
        <!-- START: 只显示在移动端 -->
        <!-- dropdown -->
        <!-- END: 只显示在移动端 -->

        <!--上一页 下一页-->
    <#--        <div class="btn-group mg-l-10">
                <#if (currPage > 1)>
                    <a href="javascript:gopage(${currPage}-1)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
                </#if>

                <#if (currPage < TotalPageNumber)>
                    <a href="javascript:gopage(${currPage}+1)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
                </#if>
            </div>-->
        <!-- btn-group -->
    </div>
    <!--操作-->

    <#elseif hasRight == false>
    <script>
        var page = {
            id: '${id}',
            currPage: '${id}',
            rowsPerPage: '${rowsPerPage}',
            querystring: '${querystring}',
            TotalPageNumber: 0
        };
    </script>
    </#if>


    <script src="${request.contextPath}/lib/2018/popper.js/popper.js"></script>
    <script src="${request.contextPath}/lib/2018/bootstrap/bootstrap.js"></script>
    <script src="${request.contextPath}/lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
    <script src="${request.contextPath}/lib/2018/moment/moment.js"></script>
    <script src="${request.contextPath}/lib/2018/jquery-ui/jquery-ui.js"></script>
    <script src="${request.contextPath}/lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
    <!--<script src="../lib/2018/peity/jquery.peity.js"></script>-->

    <script src="${request.contextPath}/lib/2018/jt.timepicker/jquery.timepicker.js"></script>
    <script src="${request.contextPath}/lib/2018/select2/js/select2.min.js"></script>
    <script src="${request.contextPath}/common/2018/bracket.js"></script>
    <script type="text/javascript" src="${request.contextPath}/common/2018/jquery.contextmenu.js"></script>
    <script type="text/javascript" src="${request.contextPath}/common/jquery.tablesorter.js"></script>
    <script>
        //==========================================
        //设置高亮
        var operation_status = ${operation_status};
        var IsDelete_ = ${IsDelete};
        $(function() {

            if (operation_status == 0) {

                $(".list_draft").addClass("active");

            } else if (operation_status == 2) {

                $(".list_publish").addClass("active");

            } else if (operation_status == 1) {

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

        <#if (S_OpenSearch != 1)>
                sortable();
                sortableEnable();
                //sortableDisable();
            <#if (sortable==1) >
                    //sortableEnable();
            </#if>
        </#if>

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
            <#if (canApprove == true)>
                //{'<i class="fa fa-search mg-r-5"></i>发布':function(menuItem,menu) {approve();} },
            </#if>
                //{'<i class="fa fa fa-eye mg-r-5"></i>预览':function(menuItem,menu) {Preview(); }},
                {'<i class="fa fa-edit mg-r-5 fa"></i>查看':function(menuItem,menu) {editDocument1(); }},
                //{'<i class="fa fa-arrow-down mg-r-5 fa"></i>撤稿':function(menuItem,menu) {deleteFile2(); }},
    <#if (channel.RecommendOut)??>
               // {'<i class="fa fa-share mg-r-5 fa"></i>推荐':function(menuItem,menu) {recommendOut();}},
    </#if>
    <#if (channel.Attribute1)??>
                //{'<i class="fa fa-reply mg-r-5 fa"></i>引用':function(menuItem,menu) {recommendIn();}},
    </#if>
                //{'<i class="fa fa-clone mg-r-5 fa"></i>复制':function(menuItem,menu) {copy(0)}},
                //{'<i class="fa fa-arrows mg-r-5 fa"></i>移动':function(menuItem,menu) {copy(1)}},
    <#if IsWeight != 1>
               // {'<i class="fa fa-sort-alpha-desc mg-r-5 fa"></i>排序':function(menuItem,menu) {SortDoc(); }},
    </#if>
    <#if IsTopStatus = true >
               // {'<i class="fa fa-upload mg-r-5 fa"></i>置顶':function(menuItem,menu) { ChangeTop(${id},1) } },
               // {'<i class="fa fa-arrow-circle-o-down mg-r-5 fa"></i>撤销置顶':function(menuItem,menu) { ChangeTop(${id},2)} },
    </#if>
                // {'<img src="../images/inner_menu_cache.gif" title="刷新Cache"/>刷新Cache':function(menuItem,menu) {RefreshItem(); }}
    <#if canDelete = true>
               // {'<i class="fa fa-trash mg-r-5"></i><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFile();}}
    </#if>
            ];
            $('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
        })
    </script>

</div>

<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>

</html>
