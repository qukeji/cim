<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../tcenter/config.jsp"%>
<%!
	//获取用户一月内登录次数
	public int getCount(int userId) throws MessageException,SQLException{
		int login_count = 0 ;

		String sql = "";
		TableUtil tu = new TableUtil("user");

		Calendar calendar = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		calendar.add(Calendar.DATE, +1);
		String  endDate = sdf.format(calendar.getTime());
		calendar.add(Calendar.DATE, -30);
		String  startDate = sdf.format(calendar.getTime());

		sql= "select count(*) from login_log where Date>='"+startDate+"' and Date<'"+endDate+"' and User=" +userId;
		ResultSet Rs = tu.executeQuery(sql);
		while(Rs.next()) {
			login_count = Rs.getInt(1);
		}
		tu.closeRs(Rs);

		return login_count ;
	}
%>
<%

	Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
	cookie.setMaxAge(60*60*24*365);
	response.addCookie(cookie);
	String url = request.getRequestURL()+"";
	String base = url.replace(request.getRequestURI(),"");

	String system_logo = CmsCache.getParameter("system_logo").getContent();

//当前登录用户的租户id
	int companyid = userinfo_session.getCompany();

	String sql = "";
	TableUtil tu = new TableUtil("user");

//用户管理数量
	int user_count = 0 ;
	sql= "select count(*) from userinfo";
	if(companyid!=0){
		sql += " where company="+companyid;
	}
	ResultSet Rs = tu.executeQuery(sql);
	while(Rs.next()) {
		user_count = Rs.getInt(1);
	}
	tu.closeRs(Rs);

//产品应用数量
	int product_count = 0 ;
	String products = new Company(companyid).getProducts();
	product_count = products.split(",").length;
/*sql= "select count(*) from tide_products";
ResultSet Rs1 = tu.executeQuery(sql);
while(Rs1.next()) {
	product_count = Rs1.getInt(1);
}
tu.closeRs(Rs1);
*/

//获取同租户下的用户
	String userids = "";
	if(companyid!=0){
		String sql2="select * from userinfo where company="+companyid;
		TableUtil tu2 = new TableUtil("user");
		ResultSet Rs2 = tu2.executeQuery(sql2);
		while(Rs2.next()){
			if(!userids.equals("")){
				userids += ",";
			}
			userids += Rs2.getInt("id");
		}
		tu2.closeRs(Rs2);
	}
//本日登录次数
	int login_count = 0 ;
	Calendar calendar = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	String nowDate = sdf.format(calendar.getTime());
	calendar.add(Calendar.DATE, +1);
	String  endDate = sdf.format(calendar.getTime());
	sql= "select count(*) from login_log where Date>='"+nowDate+"' and Date<'"+endDate+"'";
	if(!userids.equals("")){
		sql +=" and User in ("+userids+")";
	}
	ResultSet Rs2 = tu.executeQuery(sql);
	while(Rs2.next()) {
		login_count = Rs2.getInt(1);
	}
	tu.closeRs(Rs2);
%>

<!DOCTYPE html>

<html id="green">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="robots" content="noindex, nofollow">
	<link rel="Shortcut Icon" href="../<%=ico%>">
	<title><%=title_%></title>

	<link href="/tcenter/tcenter/lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="/tcenter/tcenter/lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="/tcenter/tcenter/lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
	<link href="/tcenter/tcenter/lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
	<link href="/tcenter/tcenter/lib/2018/rickshaw/rickshaw.min.css" rel="stylesheet">
	<link href="/tcenter/tcenter/lib/2018/chartist/chartist.css" rel="stylesheet">
	<link href="/tcenter/tcenter/lib/2018/morris.js/morris.css" rel="stylesheet">
	<link rel="stylesheet" href="/tcenter/tcenter/style/2018/bracket.css">

	<link rel="stylesheet" href="/tcenter/tcenter/style/2018/common.css">
	<link rel="stylesheet" href="/tcenter/tcenter/style/2018/tcenter.css">
	<link rel="stylesheet" href="/tcenter/tcenter/style/theme/theme.css">

	<script type="text/javascript" src="/tcenter/tcenter/lib/2018/jquery/jquery.js"></script>
	<script type="text/javascript" src="/tcenter/tcenter/common/2018/common2018.js"></script>
	<style>
		#zh_yy_gailan .zh_bg_item{text-align:center;position:relative}
		#zh_yy_gailan .zh_bg_item .zh_enter{position:absolute;right:5px;top:5px;width:40px;height:40px}
		#zh_yy_gailan .zh_bg_item .zh_enter a{color:#eee}
		#zh_yy_gailan .zh_bg_item .zh_enter a:hover{color:#fff}
		.column-1px{width:1px;background:#eee;height:50px;margin:0 20px 0 30px}
		.mh-18{min-height: 18px;}
		#zh_yy_gailan .zh_bg_item p{text-align: left;}
	</style>
</head>
<script>

	$(function() {
		$.ajax({
			type : "post",
			url : 'operate_statistics.jsp',
			dataType:"json",
			success : function(data) {
				var pic_size = data.pic_size;
				var video_size = data.video_size;
				var userCount = data.userCount;
				var jobCount = data.jobCount;
				var todayJobCount = data.todayJobCount;
				var companyCount = data.companyCount;
				var useFileSpace = data.useFileSpace;
				var productCount = data.productCount;
				$("#file-use-p").text(useFileSpace+"G");
				$("#video-use-p").text(video_size+"G");
				$("#img-use-p").text(pic_size+"G");
				$("#userCount").text(userCount);
				$("#todayJobCount").text("今日处理："+todayJobCount);
				$("#companyCount").text(companyCount);
				$("#jobCount").text(jobCount);
				$("#productCount").text(productCount);
				$("#main_num").html("本系统下目前管理"+data.sitenum+"个站点、"+data.channelnum+"个子节点内容");
			}
		});
		$.ajax({
			type : "post",
			url : 'company_size_list.jsp',
			dataType:"json",
			success : function(data) {
				var length = 10;
				if(data.length<10){
					var length = data.length;
				}
				for(var i=0;i<length;i++){
					var id = i+1;
					$("#comList").append("<tr><td class=\"pd-l-0-force wd-5p\">"+id+"</td><td>"+data[i].companyName+"</td><td class=\"mg-r-20\">空间使用："+data[i].useSize+" G</td><td><span class=\"mg-r-10\">图片："+data[i].companyPicSize+" G</span><span class=\"mg-r-10\">文件："+data[i].companyFileSize+" G</span> <span class=\"mg-r-10\">视频："+data[i].companyVideoSize+" G</span> </td> </tr>");
				}


			}
		});
	});

</script>
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">
<div class="br-logo">
	<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
		<img class="ht-100p" src="/tcenter/tcenter/img/2019/<%=system_logo%>">
	</a>
</div>

<div class="br-sideleft overflow-y-auto">
	<label class="sidebar-label pd-x-15 mg-t-20"></label>

	<div class="br-sideleft-menu">

		<a href="#" class="br-menu-link active menu-home">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-home tx-22"></i>
				<span class="menu-item-label">概览</span>
			</div>
			<!-- menu-item -->
		</a>
		<a href="" class="br-menu-link menu-company">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-user-plus tx-20"></i>
				<span class="menu-item-label">租户管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<ul class="br-menu-sub nav flex-column" id="system-menu-company">
			<li class="nav-item"><a href="../tcenter/company/operate_index.jsp" class="nav-link system-menu3" id="system-menu-cms-company">所有租户</a></li>
			<li class="nav-item"><a href="request/request_index.jsp" class="nav-link system-menu3" id="system-menu-cms-request">开通申请</a></li>
		</ul>
		<a href="storage/storage_index.jsp" class="br-menu-link menu-storage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-hdd-o tx-20"></i>
				<span class="menu-item-label">存储管理</span>
			</div>
		</a>
		<a href="../user/operate_index.jsp" class="br-menu-link menu-users">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-users tx-20"></i>
				<span class="menu-item-label">用户管理</span>
			</div>
		</a>
		<a href="../tcenter/notice/operate_index.jsp" class="br-menu-link  menu-notice">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-bell tx-22-force"></i>
				<span class="menu-item-label">通知管理</span>
			</div>
			<!-- menu-item -->
		</a>

		<a href="#" class="br-menu-link  menu-product">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-cubes tx-20"></i>
				<span class="menu-item-label">产品管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-product">
			<li class="nav-item"><a href="/tcenter/tcenter/product/operate_index.jsp" class="nav-link system-menu3" id="system-menu-cms-product">所有产品</a></li>
			<li class="nav-item"><a href="/tcenter/tcenter/navigation/operate_index.jsp" class="nav-link system-menu3" id="system-menu-navigation-product">快捷导航管理</a></li>
		</ul>
		<a href="job/job_index.jsp" class="br-menu-link  menu-job">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-list-ol tx-22-force"></i>
				<span class="menu-item-label">工单管理</span>
			</div>
			<!-- menu-item -->
		</a>

		<!-- 工作量统计-->
		<a href="#" class="br-menu-link menu-report">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-calculator tx-20"></i>
				<span class="menu-item-label">工作量统计</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link -->
		<ul class="br-menu-sub nav flex-column" id="system-menu-report">
			<li class="nav-item"><a href="/tcenter/report/operate_index.jsp" class="nav-link system-menu3" id="system-menu-cms-report">内容工作量统计</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/report/operate_index.jsp" class="nav-link system-menu3" id="system-menu-vms-report">媒资工作量统计</a></li>
		</ul>

		<!-- 日志管理-->
		<a href="#" class="br-menu-link menu-log" id="system-manage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-wpforms tx-20"></i>
				<span class="menu-item-label">日志管理</span>
				<i class="menu-item-arrow fa fa-angle-down"></i>
			</div>
		</a>
		<!-- br-menu-link
		<ul class="br-menu-sub nav flex-column" id="system-menu-log">
			<li class="nav-item"><a href="/tcenter/system/pingtai_log_index.jsp" class="nav-link system-menu3" id="system-menu-cms-log">内容日志管理</a></li>
			<li class="nav-item"><a href="/vms/system/pingtai_log_index.jsp" class="nav-link system-menu3" id="system-menu-vms-log">媒资日志管理</a></li>
		</ul>-->
		<ul class="br-menu-sub nav flex-column" id="system-manager-menu">
			<li class="nav-item"><a href="/tcenter/system/operate_index.jsp?id=1" class="nav-link system-menu3" id="system-menu-operate">内容操作日志</a></li>
			<li class="nav-item"><a href="/tcenter/system/operate_index.jsp?id=2" class="nav-link system-menu3" id="system-menu-login">内容登陆日志</a></li>
			<li class="nav-item"><a href="/tcenter/system/operate_index.jsp?id=3" class="nav-link system-menu3"	id="system-menu-error">内容错误日志</a></li>
			<li class="nav-item"><a href="/tcenter/system/operate_index.jsp?id=4" class="nav-link system-menu3" id="system-menu-system">内容系统日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/operate_index.jsp?id=5" class="nav-link system-menu3" id="system-menu-vms-operate">媒资操作日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/operate_index.jsp?id=6" class="nav-link system-menu3" id="system-menu-vms-login">媒资登陆日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/operate_index.jsp?id=7" class="nav-link system-menu3"	id="system-menu-vms-error">媒资错误日志</a></li>
			<li class="nav-item"><a href="/vms/index_tcenter.jsp?url=/vms/system/operate_index.jsp?id=8" class="nav-link system-menu3" id="system-menu-vms-system">媒资系统日志</a></li>
		</ul>
	</div>
	<!-- br-sideleft-menu -->
</div>
<!-- br-sideleft -->

<div class="br-header">
	<div class="br-header-left">
		<div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
		<div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
		<div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i>租户运营中心</a></div>
	</div>
	<!-- br-header-left -->
	<script language=javascript>var navi_menu = "运营支撑";</script>
	<%@include file="../include/header_navigate.jsp"%><!--静态包含-->
	<!-- br-header-right -->
</div>
<!-- br-header -->

<!-- ########## START: MAIN PANEL ########## -->
<div class="br-mainpanel with-first-nav">
		<div class="pd-30">
			<h4 class="tx-gray-800 mg-b-5">概览</h4>
			<p class="mg-b-0" id="main_num">本系统下目前管理0个站点、0个子节点内容</p>
		</div>

	<div class="br-pagebody mg-t-5 pd-x-30 " id="zh_yy_gailan">
		<div class="row row-sm">
			<div class="col-sm-6 col-xl-3 mg-b-20">
				<div class="bg-primary rounded overflow-hidden zh_bg_item tx-white">
					<div class="pd-25 d-flex align-items-center">
						<i class="fa fa-wpforms tx-60 lh-0 tx-white op-7"></i>
						<div class="mg-l-20">
							<p class="tx-10 tx-spacing-1 tx-left tx-mont tx-uppercase tx-white-8 mg-b-10">工单总计</p>
							<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1" id="jobCount">0 </p>
							<p class="tx-11 tx-roboto tx-left tx-white-6 mh-18" id="todayJobCount">今日处理：1222</p>
						</div>
					</div>
					<div class="zh_enter">
						<a href="/tcenter/operate/job/job_index.jsp" class="tx-white tx-24" title="进入"><i class="fa fa-sign-in"></i></a>
					</div>
				</div>
			</div>
			<div class="col-sm-6 col-xl-3 mg-b-20">
				<div class="bg-danger rounded overflow-hidden zh_bg_item tx-white">
					<div class="pd-25 d-flex align-items-center">
						<i class="fa fa-user-plus tx-60 lh-0 tx-white op-7"></i>
						<div class="mg-l-20">
							<p class="tx-10 tx-spacing-1 tx-left tx-mont tx-uppercase tx-white-8 mg-b-10">租户数量</p>
							<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1" id="companyCount">0 </p>
							<p class="tx-11 tx-roboto tx-left tx-white-6 mh-18"></p>
						</div>
					</div>
					<div class="zh_enter">
						<a href="/tcenter/tcenter/company/operate_index.jsp" class="tx-white tx-24" title="进入"><i class="fa fa-sign-in"></i></a>
					</div>
				</div>
			</div>
			<div class="col-sm-6 col-xl-3 mg-b-20">
				<div class="bg-warning rounded overflow-hidden zh_bg_item tx-white">
					<div class="pd-25 d-flex align-items-center">
						<i class="fa fa-users tx-60 lh-0 tx-white op-7"></i>
						<div class="mg-l-20">
							<p class="tx-10 tx-spacing-1 tx-left tx-mont tx-uppercase tx-white-8 mg-b-10">用户统计</p>
							<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1" id="userCount">0 </p>
							<p class="tx-11 tx-roboto tx-left tx-white-6 mh-18"></p>
						</div>
					</div>
					<div class="zh_enter">
						<a href="/tcenter/user/operate_index.jsp" class="tx-white tx-24" title="进入"><i class="fa fa-sign-in"></i></a>
					</div>
				</div>
			</div>
			<div class="col-sm-6 col-xl-3 mg-b-20">
				<div class="bg-teal rounded overflow-hidden zh_bg_item tx-white">
					<div class="pd-25 d-flex align-items-center">
						<i class="fa fa-cubes  tx-60 lh-0 tx-white op-7"></i>
						<div class="mg-l-20">
							<p class="tx-10 tx-spacing-1 tx-left tx-mont tx-uppercase tx-white-8 mg-b-10">产品总计</p>
							<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1" id="productCount">0 </p>
							<p class="tx-11 tx-roboto tx-left tx-white-6 mh-18"></p>
						</div>
					</div>
					<div class="zh_enter">
						<a href="/tcenter/tcenter/product/operate_index.jsp" class="tx-white tx-24" title="进入"><i class="fa fa-sign-in"></i></a>
					</div>
				</div>
			</div>

		</div>
		<!-- row -->
		<div class="row row-sm mg-t-0">
			<div class="col-sm-6 col-xl-4" id="video-use">
				<div class="bg-white rounded overflow-hidden">
					<div class="pd-25 d-flex align-items-center">
						<i class="fa fa-video-camera tx-50 lh-0 tx-warning"></i>
						<span class="column-1px"></span>
						<div class="mg-l-10">
							<p class="tx-14 tx-spacing-1 tx-mont tx-medium tx-black tx-uppercase mg-b-10 op-7">视频使用空间</p>
							<p class="tx-26 tx-lato tx-bold tx-black mg-b-2 lh-1" id="video-use-p">300G</p>
						</div>
					</div>
				</div>
			</div>
			<!-- col-3 -->
			<div class="col-sm-6 col-xl-4 mg-t-20 mg-sm-t-0" id="img-use">
				<div class="bg-white rounded overflow-hidden">
					<div class="pd-25 d-flex align-items-center">
						<i class="fa fa-picture-o tx-50 lh-0 tx-teal"></i>
						<span class="column-1px"></span>
						<div class="mg-l-10 ">
							<p class="tx-14 tx-spacing-1 tx-mont tx-medium tx-black tx-uppercase mg-b-10 op-7">图片使用空间</p>
							<p class="tx-26 tx-lato tx-bold tx-black mg-b-2 lh-1" id="img-use-p">2G</p>
						</div>
					</div>
				</div>
			</div>
			<!-- col-3 -->
			<div class="col-sm-6 col-xl-4 mg-t-20 mg-xl-t-0" id="file-use">
				<div class="bg-white rounded overflow-hidden">
					<div class="pd-25 d-flex align-items-center">
						<i class="fa fa-file tx-50 lh-0 tx-danger"></i>
						<span class="column-1px"></span>
						<div class="mg-l-10">
							<p class="tx-14 tx-spacing-1 tx-mont tx-medium tx-black tx-uppercase mg-b-10 op-7">文件使用空间</p>
							<p class="tx-26 tx-lato tx-bold tx-black mg-b-2 lh-1" id="file-use-p">0G</p>
						</div>
					</div>
				</div>
			</div>

		</div>
		<!-- row -->


		<div class="row row-sm mg-t-20">
			<div class="col-sm-12 col-xl-8">
				<div class="card bd-0 shadow-base pd-30 mg-t-0">
					<div class=" pd-b-15">
						<div class="d-flex align-items-center justify-content-between">
							<div>
								<p class="tx-13 tx-uppercase tx-inverse tx-spacing-1 tx-18">
									<i class="fa fa-user-circle-o theme-tx-color mg-r-5 tx-20"></i>租户存储使用排行
								</p>
							</div>
						</div>
					</div>
					<table class="table  table-valign-middle mg-b-0">
						<tbody id="comList">


						</tbody>
					</table>
				</div><!-- card -->
			</div>
			<!-- col-9 -->
			<div class="col-sm-12 col-xl-4">
				<iframe class="wd-100p"  src="../tcenter/include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
			</div>
			<!-- col-3 -->
		</div>
		<!-- row -->
	</div>

</div>
<!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->
<script src="/tcenter/tcenter/lib/2018/popper.js/popper.js"></script>
<script src="/tcenter/tcenter/lib/2018/bootstrap/bootstrap.js"></script>
<script src="/tcenter/tcenter/lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="/tcenter/tcenter/lib/2018/moment/moment.js"></script>
<script src="/tcenter/tcenter/lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="/tcenter/tcenter/lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="/tcenter/tcenter/common/2018/bracket.js"></script>

<script>

	$(function() {
		'use strict'

		$(window).resize(function() {
			minimizeMenu();
		});

		minimizeMenu();

		function minimizeMenu() {
			if (window.matchMedia('(min-width: 992px)').matches && window.matchMedia('(max-width: 1299px)').matches) {
				$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
				$('body').addClass('collapsed-menu');
				$('.show-sub + .br-menu-sub').slideUp();
			} else if (window.matchMedia('(min-width: 1300px)').matches && !$('body').hasClass('collapsed-menu')) {
				$('.menu-item-label,.menu-item-arrow').removeClass('op-lg-0-force d-lg-none');
				$('body').removeClass('collapsed-menu');
				$('.show-sub + .br-menu-sub').slideDown();
			}
		}
	});

</script>
</body>
</html>
