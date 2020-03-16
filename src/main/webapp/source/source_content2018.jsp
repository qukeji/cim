<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

long begin_time = System.currentTimeMillis();
int id = getIntParameter(request,"id");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");
int sortable = getIntParameter(request,"sortable");
int rows = getIntParameter(request,"rows");
int cols = getIntParameter(request,"cols");
if(currPage<1)
	currPage = 1;

if(rowsPerPage==0)
	rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage",request.getCookies()));

if(rowsPerPage<=0)
	rowsPerPage = 20;

if(rows==0)
	rows = Util.parseInt(Util.getCookieValue("rows",request.getCookies()));
if(cols==0)
	cols = Util.parseInt(Util.getCookieValue("cols",request.getCookies()));

if(rows==0)
	rows = 10;
if(cols==0)
	cols = 5;

int ChannelID = id;
int listType = 0;

boolean listAll = false;

String S_Title			=	getParameter(request,"Title");
String S_CreateDate		=	getParameter(request,"CreateDate");
String S_CreateDate1	=	getParameter(request,"CreateDate1");
String S_User			=	getParameter(request,"User");
int S_IsIncludeSubChannel =	getIntParameter(request,"IsIncludeSubChannel");
int S_Status			=	getIntParameter(request,"Status");
int S_IsPhotoNews		=	getIntParameter(request,"IsPhotoNews");
int S_OpenSearch		=	getIntParameter(request,"OpenSearch");
int IsDelete			=	getIntParameter(request,"IsDelete");

int Status1			=	getIntParameter(request,"Status1");

String querystring = "";
querystring = "&Title="+java.net.URLEncoder.encode(S_Title,"UTF-8")+"&CreateDate="+S_CreateDate+"&CreateDate1="+S_CreateDate1+"&User="+S_User+"&Status="+S_Status+"&IsPhotoNews="+S_IsPhotoNews+"&OpenSearch="+S_OpenSearch+"&IsDelete="+IsDelete+"&Status1="+Status1;

String sys_cloud_source = CmsCache.getParameterValue("sys_cloud_source");

String pageName = request.getServletPath();
int pindex = pageName.lastIndexOf("/");
if(pindex!=-1)
	pageName = pageName.substring(pindex+1);

int TotalPageNumber  = 0;
int TotalNumber = 0;
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
	<style>
		.collapsed-menu .br-mainpanel-file {
			margin-left: 0;
			margin-top: 0;
		}
	</style>

	<script type="text/javascript" src="../common/jquery.js"></script>
	<script type="text/javascript" src="../common/2018/content.js"></script>

	<script>
		var listType = <%=listType%>;
		var rows = <%=rows%>;
		var cols = <%=cols%>;
		var ChannelID = <%=ChannelID%>;
		var currRowsPerPage = <%=rowsPerPage%>;
		if (currRowsPerPage == 0) {
			currRowsPerPage = 20;
		}
		var currPage = <%=currPage%>;
		var Parameter = "&ChannelID=" + ChannelID + "&rowsPerPage=" + currRowsPerPage + "&currPage=" + currPage;
		var pageName = "<%=pageName%>";
		var total = 0;
		var totalpagenum = 0;
		if (pageName == "") pageName = "content.jsp";
		$(document).ready(function() {
			if (typeof(page) == "object") {
				$("#rowsPerPage").val(page.rowsPerPage);
			}
		})

		function gopage(currpage) {
			currPage = currpage;
			loaditems()
		}

		function list(str) {
			var url = pageName + "?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>";
			if (typeof(str) != 'undefined')
				url += "&" + str;
			this.location = url;
		}
		var pageNum = 1;
		var total = 0;
		var cid = 0;

		function loaditems() {
			$("#msg_load").show();
			$.ajax({
				url: "<%=sys_cloud_source%>getitems.jsp",
				data: "id=" + ChannelID + "&currPage=" + currPage + "&rowsPerPage=" + currRowsPerPage + "<%=querystring%>",
				dataType: "jsonp",
				type: "get",
				success: function(o) {
					$("#msg_load").hide();

					var channelPath = o.channelPath;
					$("#parentChannelPath").html(channelPath);

					var items = o.items;
					total = o.total;

					var html = "";
					//alert(items.length);
					for (var i = 0; i < items.length; i++) {
						var status_ = "";
						var item = items[i];
						html += '<tr class="tide_item" channelid="' + item.channelid + '" id="item_' + item.id + '" url="' + item.SpiderUrl + '" status="' + item.Status + '"><td class="valign-middle"><label class="ckbox mg-b-0"><input name="id" value="' + item.id + '" type="checkbox"/><span></span></label></td><td ondragstart="OnDragStart (event)">	<i class="icon ion-clipboard tx-22 tx-warning lh-0 valign-middle"></i><span class="pd-l-5">' + item.Title + '</span></td>';
						html += '<td class="hidden-xs-down">' + item.ContentDesc + '</td><td class="hidden-xs-down">';
						if (item.Status == "0") {
							status_ = "<font color=red>草稿</font>";
						} else {
							status_ = "<font color=blue>已发</font>";
						}
						html += status_ + '</td><td class="hidden-xs-down"> ' + item.PublishDate + ' </td>	<td class="dropdown hidden-xs-down"><a href="javascript:Preview2(\'' + item.SpiderUrl + '\');" class="btn pd-0 mg-r-5" title="预览"><i class="fa fa-search tx-18 handle-icon" aria-hidden="true"></i></a></td></tr>';
						//total=item.total;
						cid = item.channelid;

					}
					totalpagenum = (total % currRowsPerPage) > 0 ? (Math.floor(total / currRowsPerPage) + 1) : Math.floor(total / currRowsPerPage);

					addPages(); //加载分页
					$("#tbody_list").html(html);
					//click_();//加载点击事件
					$("#rowsPerPage").val(currRowsPerPage);
					trClick();
				}
			});
		}
		function trClick(){
			console.log(122);
        	$("#content-table tr:gt(0)").click(function() {
				console.log(123)
				if ($(this).find(":checkbox").prop("checked"))  
				{
					$(this).find(":checkbox").removeAttr("checked");
					$(this).removeClass("bg-gray-100");
				} else {
					$(this).find(":checkbox").prop("checked", true);
					$(this).addClass("bg-gray-100");
				}
				return ;
			});
        }
		//单击
		function click_() {
			$("#content-table .tide_item").click(function(e) {

				var o = $(this);
				var oo = $(e.target);
				if (o.hasClass("cur"))
					unselectOne(o);
				else {
					if (e.target.nodeName != "INPUT" && !oo.hasClass("checkbox")) $("#selectNo").trigger("click");
					selectOne(o);
				}
			});
		}

		function recommendOut() {
			var id = "";
			var approved = true;
			var fromchannelid = 0;
			$("#content-table input:checked").each(function(i) {
				if (i == 0)
					id += $(this).val();
				else
					id += "," + $(this).val();
				var status = $("#item_" + $(this).val()).attr("status");
				fromchannelid = $("#item_" + $(this).val()).attr("channelid");

				if (status != "1") approved = false;
			});

			var obj = getCheckbox();
			if (id == "") {
				alert("请选择要被采用的文档！");
				return;
			}

			var dialog = new top.TideDialog();
			dialog.setWidth(500);
			dialog.setHeight(450);
			dialog.setUrl("../source/recommend_out_index.jsp?ItemID=" + id + "&fromchannelid=" +
				fromchannelid + "&SourceChannelID=" + ChannelID);
			dialog.setTitle("采用");
			dialog.show();
		}

		function Preview() {
			var obj = getCheckbox();
			if (obj.length == 0) {
				alert("请先选择要预览的文件！");
			} else if (obj.length > 1) {
				alert("请先选择一个预览的文件！");
			} else {
				//window.console.info(obj.id);
				var trid = "item_" + obj.id;
				var url = $("#" + trid).attr("url");
				Preview2(url);
			}
		}

		function Preview2(href) {
			window.open(href);
		}

		function caiyong() {

		}

		var t;

		function refresh() {
			//window.console.info("refresh "+$("#auto_refresh").attr("checked"));
			clearInterval(t);
			if ($("#auto_refresh").prop("checked")) {
				//window.console.info("refresh2");
				var sec = $("#selectTime").val();
				t = setInterval("loaditems()", sec * 1000);
			}
		}

		$(document).ready(function() {
			loaditems();
		});
	</script>
</head>

<body class="collapsed-menu email">

	<div class="br-mainpanel br-mainpanel-file" id="js-source">

		<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
			  <span class="breadcrumb-item active" id="parentChannelPath"></span>
			</nav>
		</div><!-- br-pageheader -->

		<!--<div class="br-pageheader pd-y-15 pd-md-l-20">
			<nav class="breadcrumb pd-0 mg-0 tx-12">
				<span class="breadcrumb-item active"><span id="msg_load"><font color=red><b>正在加载 ... </b></font></span></span>
			</nav>
		</div>-->
		<!-- br-pageheader -->

		<!--操作-->
		<div class="d-flex align-items-center justify-content-start pd-x-20 pd-sm-x-30 pd-t-25 mg-b-20 mg-sm-b-30">
			<!--<div class="btn-group hidden-xs-down">
				<a href="#" class="btn btn-outline-info"><i class="fa fa-th"></i></a>
				<a href="#" class="btn btn-outline-info active"><i class="fa fa-th-list"></i></a>
			</div>-->
			
			<!-- START: 只显示在移动端 -->
			<div class="dropdown hidden-sm-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown"><i class="icon ion-more"></i></a>
				<div class="dropdown-menu pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:list();" class="nav-link list_all">全部</a>
						<a href="javascript:list('Status1=-1');" class="nav-link list_draft">草稿</a>
						<a href="javascript:list('Status1=1');" class="nav-link list_publish">已发</a>
						<a href="#" class="nav-link">搜索</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->
			<!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-xs-down">
				<a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
				<a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">草稿</a>
				<a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已发</a>
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<!-- btn-group -->

			<!--<div class="row mg-l-20 search-item" style="align-items: center;">
				<span class="">自动刷新:</span>
				<label class="ckbox mg-b-0">
					<input type="checkbox" id="auto_refresh" onClick="refresh();"><span></span>
				</label>
                <span>
				<select class="form-control select2" id="selectTime" onChange="refresh();">
					<option value="5">5</option>
					<option value="10">10</option>
					<option value="30">30</option>
					<option value="60">60</option>
					<option value="120">120</option>
					<option value="300">300</option>
				</select>
				</span>
			</div>-->

			<div class="btn-group mg-l-auto hidden-sm-down">
				<a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
				<a href="javascript:recommendOut()" class="btn btn-outline-info">采用</a>
			</div>
			<!-- btn-group -->

			<!-- START: 只显示在移动端 -->
			<div class="dropdown mg-l-auto hidden-md-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:Preview();" class="nav-link">预览</a>
						<a href="javascript:recommendOut()" class="nav-link">采用</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->

			<div class="btn-group mg-l-10 hidden-sm-down">
			<%if(currPage>1){%>
				<a href="javascript:gopage(<%=currPage-1%>)" class="btn btn-outline-info "><i class="fa fa-chevron-left"></i></a>
			<%}%>
			<%if(currPage<TotalPageNumber){%>
				<a href="javascript:gopage(<%=currPage+1%>)" class="btn btn-outline-info"><i class="fa fa-chevron-right"></i></a>
			<%}%>
            </div>
            <!-- btn-group -->
		</div>
		<!--操作-->

		<!--搜索-->
		<div class="search-box pd-x-20 pd-sm-x-30" style="display:none;">
			<div class="search-content bg-white">
				<form name="search_form" action="<%=pageName%>?id=<%=id%>&rowsPerPage=<%=rowsPerPage%>" method="post">
					<div class="row">
						<!--标题-->
						<div class="mg-r-10 mg-b-30 search-item">
							<input class="form-control search-title" placeholder="标题" type="text" name="Title" value="<%=S_Title%>">
						</div>
						<!--日期-->
						<div class="wd-200 mg-b-30 mg-r-10 search-item">
							<div class="input-group">
								<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
								<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="startDate">
							</div>
						</div>
						<div class="wd-20 mg-b-30 mg-r-10 ht-40 d-flex align-items-center justify-content-start">至</div>
						<div class="wd-200 mg-b-30 mg-r-10 search-item">
							<div class="input-group">
								<span class="input-group-addon"><i class="icon ion-calendar tx-16 lh-0 op-6"></i></span>
								<input type="text" class="form-control fc-datepicker search-time" placeholder="YYYY-MM-DD" name="endDate">
							</div>
						</div>
						<!-- wd-200 -->
						<!--作者-->
						<div class="mg-r-10 mg-b-30 search-item">
							<div class="input-group">
								<span class="input-group-addon"><i class="icon ion-person tx-16 lh-0 op-6"></i></span>
								<input type="text" class="form-control search-author" placeholder="作者" name="User" value="<%=S_User%>">
							</div>
						</div>
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
							<input type="submit" name="Submit" value="搜索" class="btn btn-outline-info active pd-x-10 pd-y-10 tx-uppercase tx-bold tx-spacing-6 tx-14">
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
							<th class="wd-5p">
								<label class="ckbox mg-b-0">
									<input type="checkbox" id="checkAll"><span></span>
								</label>
							</th>
							<th class="tx-12-force tx-mont tx-medium">标题</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-150 wd-content">内容</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-80">状态</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-180">日期</th>
							<th class="tx-12-force tx-mont tx-medium hidden-xs-down wd-80">操作</th>
						</tr>
					</thead>
					<tbody id="tbody_list">

					</tbody>
				</table>

				<script>
					var page = {
						id: '<%=id%>',
						currPage: '<%=currPage%>',
						rowsPerPage: '<%=rowsPerPage%>',
						querystring: '<%=querystring%>',
						TotalPageNumber: totalpagenum
					};

					function addPages() {
						if (total > 0) {
							var html2 = "";
							html2 += '<label class="ckbox mg-b-0 mg-r-30 "><input type="checkbox" id="checkAll_1"><span></span></label>' +
								'<span class="mg-r-20 ">共' + total + '条</span><span class="mg-r-20 ">' + currPage + '/' + totalpagenum + '页</span>';

							if (totalpagenum > 1) {
								html2 += '<div class="jump_page"><span class="">跳至:</span><label class="wd-60 mg-b-0"><input class="form-control" placeholder="" type="text" name="jumpNum" id="jumpNum"></label><span class="">页</span><a href="javascript:jumpPage();" class="tx-14">Go</a></div>';
							}

							html2 += '<div class="each-page-num mg-l-20 ">' +
								'<span class="">每页显示:</span>' +
								'<select name="rowsPerPage" class="form-control select2 wd-80" onChange="change(\'#rowsPerPage\',' + cid + ');" id="rowsPerPage">' +
								'<option value="10">10</option>' +
								'<option value="15">15</option>' +
								'<option value="20">20</option>' +
								'<option value="25">25</option>' +
								'<option value="30">30</option>' +
								'<option value="50">50</option>' +
								'<option value="80">80</option>' +
								'<option value="100">100</option>' +
								'</select>' +
								'<span class="">条</span></div>';
							$(".viewpane_pages").html(html2);

							jQuery("#goToId").click(function() {
								var num = jQuery("#jumpNum").val();
								if (num == "") {
									alert("请输入数字!");
									jQuery("#jumpNum").focus();
									return;
								}
								var reg = /^[0-9]+$/;
								if (!reg.test(num)) {
									alert("请输入数字!");
									jQuery("#jumpNum").focus();
									return;
								}

								if (num > totalpagenum)
									num = totalpagenum;
								if (num < 1)
									num = 1;
								gopage(num);
							});
						}
					}


					function change(s, id) {
						var value = jQuery(s).val();
						var exp = new Date();
						exp.setTime(exp.getTime() + 300 * 24 * 60 * 60 * 1000);
						document.cookie = "rowsPerPage=" + value;
						currRowsPerPage = value;
						loaditems();
						//document.location.href = pageName+"?id="+cid+"&rowsPerPage="+value;
					}
				</script>

				<!--分页-->
				<div id="tide_content_tfoot">
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
						<a href="#" class="nav-link">搜索</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->

			<div class="btn-group hidden-xs-down">
				<a href="#" class="btn btn-outline-info"><i class="fa fa-th"></i></a>
				<a href="#" class="btn btn-outline-info active"><i class="fa fa-th-list"></i></a>
			</div>
			<!-- btn-group -->
			<div class="btn-group mg-l-10 hidden-xs-down">
				<a href="javascript:list();" class="btn btn-outline-info list_all">全部</a>
				<a href="javascript:list('Status1=-1');" class="btn btn-outline-info list_draft">草稿</a>
				<a href="javascript:list('Status1=1');" class="btn btn-outline-info list_publish">已发</a>
				<a href="#" class="btn btn-outline-info btn-search">搜索</a>
			</div>
			<!-- btn-group -->

			<div class="btn-group mg-l-auto hidden-sm-down">
				<a href="javascript:Preview();" class="btn btn-outline-info">预览</a>
				<a href="javascript:recommendOut()" class="btn btn-outline-info">采用</a>
			</div>
			<!-- btn-group -->

			<!-- START: 只显示在移动端 -->
			<div class="dropdown mg-l-auto hidden-md-up">
				<a href="#" class="btn btn-outline-secondary" data-toggle="dropdown">操作 <i class="fa fa-angle-down mg-l-5"></i></a>
				<div class="dropdown-menu dropdown-menu-right pd-10">
					<nav class="nav nav-style-1 flex-column">
						<a href="javascript:Preview();" class="nav-link">预览</a>
						<a href="javascript:recommendOut()" class="nav-link">采用</a>
					</nav>
				</div>
				<!-- dropdown-menu -->
			</div>
			<!-- dropdown -->
			<!-- END: 只显示在移动端 -->

		</div>
		<!--操作-->

		<script src="../lib/2018/jquery/jquery.js"></script>
		<script src="../lib/2018/popper.js/popper.js"></script>
		<script src="../lib/2018/bootstrap/bootstrap.js"></script>
		<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
		<script src="../lib/2018/moment/moment.js"></script>
		<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
		<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
		<script src="../lib/2018/peity/jquery.peity.js"></script>

		<script src="../lib/2018/jt.timepicker/jquery.timepicker.js"></script>
		<script src="../lib/2018/select2/js/select2.min.js"></script>
		<script src="../common/2018/bracket.js"></script>

		<script>
			//==========================================
			//设置高亮
			var Status1_ = <%=Status1%>;
			var IsDelete_ = <%=IsDelete%>;
			$(function() {

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

                
				
				$("#checkAll,#checkAll_1").click(function() {
					var checkboxAll = $("#content-table tr").find("td:first-child").find(":checkbox");
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

				// Datepicker
				$('.fc-datepicker').datepicker({
					showOtherMonths: true,
					selectOtherMonths: true,
					dateFormat: "yy-mm-dd"
				});

			});
		</script>
	</div>
	<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>