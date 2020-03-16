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
    <link href="${request.contextPath}/style/contextMenu.css" type="text/css" rel="stylesheet" />
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
    </style>

    <script src="${request.contextPath}/lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="${request.contextPath}/common/2018/common2018.js"></script>
    <script type="text/javascript" src="${request.contextPath}/common/2018/content.js"></script>
    <script>
        var listType = ${listType};
        var rows = ${rows};
        var cols = ${cols};
        var currRowsPerPage = ${rowsPerPage};
        var currPage = ${currPage};
        var TotalPageNumber = ${TotalPageNumber};
        var Parameter = "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
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
        $(function () {
            double_click();
        })
        function double_click()
        {
            jQuery("#oTable .tide_item").dblclick(function(){

            });

        }
       function  dbcli(id) {
            details(id);
       }


        function gopage(currpage) {
            var url = pageName + "?currPage=" + currpage + "&rowsPerPage=${rowsPerPage}${querystring}";
            this.location = url;
        }

        function jumpPage(){
            var num=jQuery("#jumpNum").val();
            if(num==""){
                var	dialog = new top.TideDialog();
                dialog.showAlert("请输入数字","danger");
                jQuery("#jumpNum").focus();
                return;
            }
            var reg=/^[0-9]+$/;
            if(!reg.test(num)){
                var	dialog = new top.TideDialog();
                dialog.showAlert("请输入数字","danger");
                jQuery("#jumpNum").focus();
                return;
            }

            if(num>TotalPageNumber)
                num=TotalPageNumber;
            if(num<1)
                num=1;
            gopage(num);
        }
        function list(str) {
            var url = pageName + "?rowsPerPage=${rowsPerPage}";
            if (typeof(str) != 'undefined')
                url += "&" + str;
            this.location = url;
        }

        function details(id){
            var	dialog = new top.TideDialog();
            dialog.setWidth(400);
            dialog.setHeight(350);
            dialog.setUrl("/tcenter/operate/request/request_details.jsp?id="+id);
            dialog.setTitle("租户请求");
            dialog.show();
        }
        function open(){
            $("#open").attr("href","");
            var ids = getCheckbox().id;
            var length = getCheckbox().length;
            var status="";
            if(length==0){
                var	dialog = new top.TideDialog();
                $("#open").attr("href","javascript:open();");
               dialog.showAlert("请选择一条请求","danger");
                //alert("请选择一条请求");
                return;
            }
            jQuery("#content-table input:checked").each(function(i){
                if(i==0)
                    status+=jQuery(this).attr("status");
                else
                    status+=","+jQuery(this).attr("status");
            });
            if(status.indexOf("1")!=-1){
                $("#open").attr("href","javascript:open();");
                var	dialog = new top.TideDialog();
                dialog.showAlert("请选择未开通的请求","danger");
                //alert("请选择未开通的请求");
                return;
            }
            var data={"ids":ids}
            $.ajax({
                type : "post",
                url : '${request.contextPath}/company/request/update',
                data :data,
                dataType:"json",
                success:function(data){
                    var	dialog = new top.TideDialog();
                    //alert(data.message);
                    if(data.status==200){
                        $("#open").attr("href","javascript:open();");
                        dialog.showAlert("开通成功");
                        top.TideDialogClose({refresh:'right'});
                    }

                }
            });

        }

        function open_(id){
            $("#open_").attr("href","");
            var data={"ids":id}
            $.ajax({
                type : "post",
                url : '${request.contextPath}/company/request/update',
                data :data,
                dataType:"json",
                success:function(data){
                    var	dialog = new top.TideDialog();
                    if(data.status==200){
                        dialog.showAlert("开通成功");
                        top.TideDialogClose({refresh:'right'});
                    }

                }
            });

        }
    </script>
</head>

<body class="collapsed-menu email">
<div class="br-mainpanel br-mainpanel-file" id="js-source">
    <div class="br-pageheader pd-y-15 pd-md-l-20">
        <nav class="breadcrumb pd-0 mg-0 tx-12">
            <span class="breadcrumb-item active">租户管理 / 开通申请</span>
        </nav>
    </div>
    <!-- br-pageheader -->

    <!--操作-->
    <div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">

        <!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
            <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已开通</a>
            <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">未开通</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <a href="javascript:open();" class="btn btn-outline-info" id="open">开通</a>
        </div>

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
            <form name="search_form" action="${pageName}?rowsPerPage=${rowsPerPage}" method="post" onsubmit="return check();">
                <div class="row">
                    <!--租户名称-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <input class="form-control search-title" placeholder="租户名称" type="text" name="companyName" value="${S_companyName}" onClick="this.select()">
                    </div>
                    <!--产品名称-->
                    <div class="mg-r-10 mg-b-30 search-item">
                        <input class="form-control search-title" placeholder="产品名称" type="text" name="productName" value="${S_productName}" onClick="this.select()">
                    </div>
                    <!--日期-->
                    <div class="wd-200 mg-b-30 mg-r-10 search-item">
                        <div class="input-group">
                            <span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
                            <input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="requestDate" value="${S_requestDate}" id="startDate">
                        </div>
                    </div>
                    <!--状态-->
                    <div class=" mg-lg-t-0 mg-r-10 mg-b-30 search-item">
                        <select class="form-control select2" data-placeholder="状态" name="Status">
                            <option label="Choose one"></option>
                            <option value="0">全部</option>
                            <option value="2" ${(S_Status==2)?string('selected','')} >已开通</option>
                            <option value="1" ${(S_Status==1)?string('selected','')} >未开通</option>
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


    <!--列表-->
    <div class="br-pagebody pd-x-20 pd-sm-x-30">
        <div class="card bd-0 shadow-base">
            <table class="table mg-b-0 " id="content-table">
            <thead>
            <tr>
                <th class="wd-5p wd-50">选择</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">租户名称</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">产品</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">状态</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">申请日期</th>
                <th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150">开通日期</th>
                <th class="tx-12-force wd-100 tx-mont tx-medium ">操作</th>
            </tr>
            </thead>
            <tbody>

            <#list list as key>
                <#--<#list map?keys as key>-->
                             <tr  class="tide_item" ondblclick="dbcli(${key.id});">
                                 <td class="valign-middle">
                                     <label class="ckbox mg-b-0">
                                         <input type="checkbox" name="id" status="${key.status}" value="${key.id}"><span></span>
                                     </label>
                                 </td>
                                 <td ondragstart="OnDragStart(event)">
                                     <span class="pd-l-5 tx-black">${key.companyName}</span>
                                 </td>
                                 <td class="hidden-xs-down">
                                     <span class="pd-l-5 tx-black">${key.productName}</span>
                                 </td>
                                 <td class="hidden-xs-down">
                                     <#if key.status==0>
                                         <span class="pd-l-5 tx-danger" >未开通</span>
                                     </#if>
                                     <#if key.status==1>
                                         <span class="pd-l-5 tx-success" >已开通</span>
                                     </#if>
                                 </td>
                                 <td class="hidden-xs-down">
                                     <span class="pd-l-5 tx-black">${key.requestDate?replace(".0","")}</span>
                                 </td>
                                 <td class="hidden-xs-down">
                                         <span class="pd-l-5 tx-black">${key.openDate?replace(".0","")} </span>
                                 </td>
                                 <td class="dropdown hidden-xs-down">
                                     <#if key.status==0>
                                     <a href="javascript:open_(${key.id});" class="btn pd-0 mg-r-5" title="开通" id="open_"><i class="fa fa-check-square-o tx-18 handle-icon" aria-hidden="true"></i></a>
                                     </#if>
                                 </td>
                             </tr>
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

                <div class="each-page-num mg-l-auto">
                    <span class="">每页显示:</span>
                    <select name="rowsPerPage" class="form-control select2 wd-80" data-placeholder="" onChange="change('#rowsPerPage');" id="rowsPerPage">
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

        <!-- btn-group -->
        <div class="btn-group mg-l-10 hidden-xs-down">
            <a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
            <a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已开通</a>
            <a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">未开通</a>
            <a href="#" class="btn btn-outline-info btn-search">搜索</a>
        </div>
        <!-- btn-group -->

        <div class="btn-group mg-l-auto hidden-sm-down">
            <a href="javascript:open();" class="btn btn-outline-info">开通</a>
        </div>
        <!-- btn-group -->
        <!--<div class="btn-group mg-l-10 hidden-sm-down">-->
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


    <script>
        var page = {
            currPage: '${currPage}',
            rowsPerPage: '${rowsPerPage}',
            querystring: '${querystring}',
            TotalPageNumber: 0
        };
    </script>



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
        var Status1_ = ${Status1};

        $(function() {

            if (Status1_ == -1) {

                $(".list_draft").addClass("active");

            } else if (Status1_ == 1) {

                $(".list_publish").addClass("active");

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


            $('tbody').on('mousedown','tr td',function(e){

            })
            var beforeShowFunc = function() {
                //console.log( getActiveNav() )
            };
            var menu = [

            {'<i class="fa fa fa-eye mg-r-5"></i>详情':function(menuItem,menu) {details(getCheckbox().id); }},


        ];
            $('.tide_item').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
        })
    </script>

</div>

<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>

</html>
