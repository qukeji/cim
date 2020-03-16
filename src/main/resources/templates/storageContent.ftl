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
    <link rel="stylesheet" href="${request.contextPath}/style/2018/bracket.css">
    <link rel="stylesheet" href="${request.contextPath}/style/2018/common.css">
    <link href="${request.contextPath}/style/contextMenu.css" type="text/css" rel="stylesheet"/>
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

    <script src="${request.contextPath}/lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="${request.contextPath}/common/2018/common2018.js"></script>
    <script type="text/javascript" src="${request.contextPath}/common/2018/content.js"></script>
    <script>
        var listType = 1;
        var currRowsPerPage = ${rowsPerPage};
        var currPage = ${currPage};
        var Parameter = "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
        var pageName = "${pageName}";
        if (pageName == "") pageName = "content.jsp";

        function gopage(currpage) {
            var url = pageName + "?currPage=" + currpage + "&rowsPerPage=${rowsPerPage}${querystring}";
            this.location = url;
        }

        function list(str) {
            var url = pageName + "?rowsPerPage=${rowsPerPage}";
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

        function edit(id, usePhotoSpace, useVideoSpace, useFileSpace, space) {

            var url = "${request.contextPath}/company/space/details?id=" + id + "&usePhotoSpace=" + usePhotoSpace + "&useVideoSpace=" + useVideoSpace + "&useFileSpace=" + useFileSpace + "&space=" + space;
            var dialog = new top.TideDialog();
            dialog.setWidth(600);
            dialog.setHeight(450);
            dialog.setUrl(url);
            dialog.setTitle("编辑空间");
            dialog.show();
        }


    </script>
</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">存储管理</span>
        </nav>
    </div>
    <!-- br-pageheader -->

    <!--操作-->
    <div class="align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

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

        <!-- btn-group -->
        <div class="btn-group hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_albtn btn-outline-info list_publishl">全部</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <!--上一页 下一页-->
        <div class="btn-group mg-l-10" style="float:right;">
            <#if (currPage > 1)>
                <a href="javascript:gopage(${currPage}-1)" class="btn btn-outline-info "><i
                            class="fa fa-chevron-left"></i></a>
            </#if>

            <#if (currPage < TotalPageNumber)>
                <a href="javascript:gopage(${currPage}+1)" class="btn btn-outline-info"><i
                            class="fa fa-chevron-right"></i></a>
            </#if>
        </div>
        <!-- btn-group -->

    </div>
    <!--操作-->

    <!--搜索-->
    <div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
        <div class="search-content bg-white">
            <form name="search_form" action="${request.contextPath}/company/space/list?rowsPerPage=${rowsPerPage}" method="post"
                  onsubmit="return check();">
                <div class="row">
                    <!--标题-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <input class="form-control search-title" placeholder="租户名称" type="text" name="companyName"
                               value="${CompanyName}" onClick="this.select()">
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
                <#if listType == 1>
                    <thead>
                    <tr>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down"><span class="mg-l-10">租户名称</span></th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">总空间</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">图片占用</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">视频占用</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">文件占用</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">剩余空间</th>
                        <th class="tx-12-force tx-mont tx-medium hidden-xs-down">存储超出</th>
                        <th class="tx-12-force wd-100 tx-mont tx-medium hidden-xs-down">操作</th>
                    </tr>
                    </thead>
                </#if>
                <tbody>

                <#list list as key>
                <#--<#list map?keys as key>-->
                    <#if listType == 1>
                        <tr id="${key.id}" class="tide_item">
                            <td class="hidden-xs-down">
                                <span class="mg-l-10">${key.companyName}</span>
                            </td>
                            <td class="hidden-xs-down">
                                ${key.space}
                            </td>
                            <td class="hidden-xs-down">
                                ${key.usePhotoSpace}
                            </td>
                            <td class="hidden-xs-down">
                                ${key.useVideoSpace}
                            </td>
                            <td class="hidden-xs-down">
                                ${key.useFileSpace}
                            </td>
                            <td class="hidden-xs-down residue">
                                <span class="residue-detail">${key.space1}</span>G
                            </td>
                            <td class="hidden-xs-down overflow">
                                <#if key.space2?length gt 1 >
                                    ${key.space2}G
                                </#if>
                            </td>
                            <td class="dropdown hidden-xs-down">
                                <a href="javascript:edit(${key.id},'${key.usePhotoSpace}','${key.useVideoSpace}','${key.useFileSpace}','${key.space}');"
                                   class="btn pd-0 mg-r-5" title="编辑">
                                    <i class="menu-item-icon fa fa-edit tx-22"></i>
                                </a>
                            </td>
                        </tr>
                    </#if>
                </#list>
                </tbody>
            </table>

            <script>
                var page = {
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
                            <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder=""
                                    onChange="change('#rowsPerPage');" id="rowsPerPage">
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

    <div class="align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

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
        
        <!-- btn-group -->
        <div class="btn-group hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_albtn btn-outline-info list_publishl">全部</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <!--上一页 下一页-->
        <div class="btn-group mg-l-10" style="float:right;">
            <#if (currPage > 1)>
                <a href="javascript:gopage(${currPage}-1)" class="btn btn-outline-info "><i
                            class="fa fa-chevron-left"></i></a>
            </#if>

            <#if (currPage < TotalPageNumber)>
                <a href="javascript:gopage(${currPage}+1)" class="btn btn-outline-info"><i
                            class="fa fa-chevron-right"></i></a>
            </#if>
        </div>
        <!-- btn-group -->

    </div>


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
        //var Status1_ = ${Status1};
        //var IsDelete_ = ${IsDelete};
        /*$(function () {

            if (Status1_ == -1) {

                $(".list_draft").addClass("active");

            } else if (Status1_ == 1) {

                $(".list_publish").addClass("active");

            } else if (IsDelete_ == 1) {

                $(".list_delete").addClass("active");

            } else {
                $(".list_all").addClass("active");
            }
        });*/


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
            $(".residue").each(function () {
                var residue = parseInt( $(this).find(".residue-detail").text() );
                if (residue == 0) {
                    $(this).addClass("tx-danger");
                } else if (residue < 10) {
                    $(this).addClass("tx-warning");
                } else if (residue > 10) {
                    $(this).addClass("tx-success");
                }
            })
            $(".overflow").addClass("tx-danger");
        })
    </script>

</div>
</body>

</html>
