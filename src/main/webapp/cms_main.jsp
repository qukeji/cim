<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*,
				java.sql.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
String time = CmsCache.getExpiresDateStr();  
long current = System.currentTimeMillis();
time  = time.replaceAll("-","/");
Date date = new Date(time);
long ExpiresDate = date.getTime();
long diff = (ExpiresDate - current)/1000; //秒
//if(CmsCache.hasValidLicense()) diff = 1000000;//许可证永久有效
if(CmsCache.getLicenseType().equals("Commercial")) diff = 1000000;//正式许可证不提示

String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
String system_logo = CmsCache.getParameter("system_logo").getContent();

	int cms_site=0;
	int cms_channel=0;
	int cms_explore=0;
	TideJson menu_left = CmsCache.getParameter("sys_tcenter_system").getJson();
	if(menu_left!=null){
		cms_site=menu_left.getInt("tcenter_pingtai_site");
		cms_channel=menu_left.getInt("tcenter_pingtai_channel");
		cms_explore=menu_left.getInt("tcenter_pingtai_explorer");
	}

%>

<!DOCTYPE html>
<html>

<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> 
<meta name="renderer" content="webkit">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="<%=ico%>">
<title><%=title_%></title>

<link href="lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<!--<link href="lib/2018/rickshaw/rickshaw.min.css" rel="stylesheet">-->
<link href="lib/2018/chartist/chartist.css" rel="stylesheet">
<link rel="stylesheet" href="style/2018/bracket.css">
<link rel="stylesheet" href="style/2018/common.css">

<script type="text/javascript" src="lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="common/2018/common2018.js"></script>


<script language=javascript>
	function init() {
		window.status = "当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
		
		set_main_class("index");
		<%if(diff<15*24*3600){%>
		tidecms.dialog("system/license_notify.jsp", 500, 300, "许可证到期提醒", 2);
		<%}%>
	}

	function reSize() {
		document.getElementById("main").style.height = Math.max(document.body.clientHeight - document.getElementById("main").offsetTop, 0) + "px";
	}

	function set_main_class(str) {
		jQuery('.header_menu  li').removeClass('on');
		jQuery('#home_' + str).addClass('on');
	}


	function feed() {
		title = '反馈'
		url = "http://123.125.148.3:888/tcenter/feedback.jsp";
		var dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle(title);
		dialog.show();
	};
</script>
<style>
	#chindex1 svg:not(:root){
		overflow: visible;
	}
</style>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init();" scroll="no">

	<div class="br-logo">
		<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
		   <img class="ht-100p" src="img/2019/<%=system_logo%>">
		</a>
	</div>

	<div class="br-sideleft overflow-y-auto">
		<label class="sidebar-label pd-x-15 mg-t-20"></label>
			<div class="br-sideleft-menu">
				<%if(userinfo_session.getRole()==1 || userinfo_session.getRole()==4){%>
				<a href="cms_main.jsp" class="br-menu-link active menu-home">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-home tx-22"></i>
						<span class="menu-item-label">主页</span>
					</div>
					<!-- menu-item -->
				</a>
				<%if(cms_explore==1&&userinfo_session.hasPermission("ManageFile")){%>
				<a href="explorer/index2018.jsp" class="br-menu-link menu-explorer">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-folder tx-20"></i>
						<span class="menu-item-label">文件管理</span>
					</div>
				</a>
				<%}%>
				<%if(cms_channel==1&&userinfo_session.hasPermission("ManageChannel")){%>
				<a href="channel/index2018.jsp" class="br-menu-link menu-channel">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-sitemap tx-20"></i>
						<span class="menu-item-label">结构管理</span>
					</div>
				</a>
				<%}%>
				<!-- br-menu-link -->
				<a href="source/index2018.jsp" class="br-menu-link menu-source">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-database tx-20"></i>
						<span class="menu-item-label">资源中心</span>
					</div>
					<!-- menu-item -->
				</a>
									
				<a href="lib/appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app" hidden="hidden">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-tablet tx-26"></i>
						<span class="menu-item-label">APP管理</span>
					</div>
				</a>
				<a href="lib/appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage" hidden="hidden">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-user tx-26"></i>
						<span class="menu-item-label">用户管理</span>
					</div>
				</a>
			    <a href="lib/appIndex2018.jsp?childGroup=3" class="br-menu-link menu-interactive" id="menu-interactive" hidden="hidden">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-comments-o tx-20"></i>
						<span class="menu-item-label">互动管理</span>
					</div>                                     
				</a>    
				<a href="lib/webIndex.jsp" class="br-menu-link menu-standard" id="menu-standard">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-desktop tx-18"></i>
						<span class="menu-item-label">内容管理</span>
					</div>
				</a>
				<%if(cms_site==1&&userinfo_session.hasPermission("ManageSystem")){%>
				<a href="#" class="br-menu-link">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-gear tx-20"></i>
						<span class="menu-item-label">系统管理</span>
						<i class="menu-item-arrow fa fa-angle-down"></i>
					</div>
				</a>
				<!-- br-menu-link -->
				<ul class="br-menu-sub nav flex-column">
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item">
						<a href="system/index2018.jsp" class="nav-link br-menu-item">站点配置</a>
					</li><%}%>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="system/index_2018.jsp?id=1" class="nav-link">许可证</a></li><%}%>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="system/index_2018.jsp?id=2" class="nav-link">系统参数</a></li><%}%>
					<li class="nav-item"><a href="system/index_2018.jsp?id=11" class="nav-link">工作流管理</a></li>
					<li class="nav-item"><a href="system/index_2018.jsp?id=3" class="nav-link">操作日志</a></li>
					<li class="nav-item"><a href="system/index_2018.jsp?id=4" class="nav-link">登录日志</a></li>
					<li class="nav-item"><a href="system/index_2018.jsp?id=5" class="nav-link">错误日志</a></li>
					<li class="nav-item"><a href="system/index_2018.jsp?id=6" class="nav-link">系统日志</a></li>
					<li class="nav-item"><a href="system/index_2018.jsp?id=7" class="nav-link">备份中心</a></li>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="system/index_2018.jsp?id=8" class="nav-link">系统监控</a></li><%}%>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="system/index_2018.jsp?id=9" class="nav-link">调度管理</a></li><%}%>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="system/index_2018.jsp?id=10" class="nav-link">图片尺寸</a></li><%}%>
					<li class="nav-item"><a href="system/index_2018.jsp?id=12" class="nav-link">水印设置</a></li>
					<li class="nav-item"><a href="template/index2018.jsp" class="nav-link">模板管理</a></li>
					<li class="nav-item"><a href="user/index2018.jsp" class="nav-link">用户管理</a></li>
					<li class="nav-item"><a href="publish/index2018.jsp" class="nav-link">发布进程管理</a></li>
					<li class="nav-item"><a href="report/index2018.jsp" class="nav-link">工作量统计</a></li>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="spider/index2018.jsp" class="nav-link">采集系统</a></li><%}%>
				</ul>
				<%}%>
			<%}else if(userinfo_session.getRole()==2||userinfo_session.getRole()==3){%>
				<a href="cms_main.jsp" class="br-menu-link active  menu-home">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-home tx-20"></i>
						<span class="menu-item-label">主页</span>
					</div>
					<!-- menu-item -->
				</a>
				<!-- br-menu-link -->
				<a href="source/index2018.jsp" class="br-menu-link menu-source">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-database tx-20"></i>
						<span class="menu-item-label">资源中心</span>
					</div>
					<!-- menu-item -->
				</a>
				<a href="lib/appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app" hidden="hidden">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-tablet tx-26"></i>
						<span class="menu-item-label">APP管理</span>
					</div>
				</a>
                                  
				<a href="lib/appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage" hidden="hidden">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-user tx-26"></i>
						<span class="menu-item-label">用户管理</span>
					</div>
				</a>
				<a href="lib/appIndex2018.jsp?childGroup=4" class="br-menu-link menu-interactive" id="menu-interactive" hidden="hidden">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-comments-o tx-20"></i>
						<span class="menu-item-label">互动管理</span>
					</div>                                     
				</a>    
				<a href="lib/webIndex.jsp" class="br-menu-link menu-standard" id="menu-standard">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-desktop tx-18"></i>
						<span class="menu-item-label">内容管理</span>
					</div>
				</a>
			<%}else if(userinfo_session.getRole()==4){%>
				<a href="content/index2018.jsp" class="br-menu-link menu-content">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-desktop tx-20"></i>
						<span class="menu-item-label">界面管理</span>
					</div>
					<!-- menu-item -->
				</a>
				<!-- br-menu-link -->
			<%}%>
			</div>
			<!-- br-sideleft-menu -->
		</div>
        <!-- br-sideleft -->

		<div class="br-header">
			<div class="br-header-left">
				<div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
				<div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
				<div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i>内容汇聚发布</a></div>
			</div>
			<!-- br-header-left -->
			<script language=javascript>var navi_menu = "多端发布";</script>
			<%@include file="include/header_navigate.jsp"%><!--静态包含-->
			<!-- br-header-right -->
		</div>
		<!-- br-header -->

        

		<%if(Flag==2){%>
		<!--许可证到期-->
		<div class="br-mainpanel with-first-nav">
			<iframe src="system/license_edit.jsp?flag=1" style="width: 100%;height: 100%;" id="content_frame" scrolling="no" frameborder="0" onload="changeFrameHeight(this)"></iframe>
		</div>
		<!-- br-mainpanel -->
		<%}else{%>
		<!-- ########## START: MAIN PANEL ########## -->
		<div class="br-mainpanel with-first-nav">
			<div class="pd-30">
				<h4 class="tx-gray-800 mg-b-5">概览</h4>
				<p class="mg-b-0" id="main_num">本系统下目前管理0个站点、0个子节点内容</p>
			</div>
			<!-- d-flex -->

			<div class="br-pagebody mg-t-5 pd-x-30">
				<div class="row row-sm">
					<div class="col-sm-6 col-xl-3">
						<div class="bg-teal rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-database tx-60 lh-0 tx-white op-7"></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">资源总数</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1" id="main_count">0</p>
									<span class="tx-11 tx-roboto tx-white-6" id="main_count1">已发0，草稿0</span>
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-sm-t-0">
						<div class="bg-danger rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-file tx-60 lh-0 tx-white op-7"></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">今日新增数据</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1" id="main_td">0</p>
									<span class="tx-11 tx-roboto tx-white-6" id="main_dc">最近7天增加 0 条</span>
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-xl-t-0">
						<div class="bg-br-primary rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-tachometer tx-60 lh-0 tx-white op-7"></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">当前用户发稿量</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1" id="main_uc">0</p>
									<span class="tx-11 tx-roboto tx-white-6" id="main_uc1">近24小时发稿量 0</span>
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-xl-t-0">
						<div class="bg-primary rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-line-chart tx-60 lh-0 tx-white op-7"></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">用户浏览量</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1" id="main_pv1">0</p>
									<span class="tx-11 tx-roboto tx-white-6" id="main_pv2">最近7天PV 0</span>
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
				</div>
				<!-- row -->

				<div class="row row-sm mg-t-20">
					<div class="col-8">
						<div class="card pd-0 bd-0 shadow-base">
							<div class="pd-x-30 pd-t-30 pd-b-15">
								<div class="d-flex align-items-center justify-content-between">
									<div>
										<h6 class="tx-13 tx-uppercase tx-inverse tx-semibold tx-spacing-1">用户访问数据统计</h6>
										<p class="mg-b-0">最近7天数据浏览</p>
									</div>
									<div class="tx-13">
										<p class="mg-b-0"><span class="square-8 rounded-circle bg-purple bg-pv mg-r-10"></span> PV 浏览数量</p>
										<!--<p class="mg-b-0"><span class="square-8 rounded-circle bg-pink bg-uv mg-r-10"></span> UV 独立用户数量</p>-->
									</div>
								</div>
								<!-- d-flex -->
							</div>
							<div class="pd-x-30 pd-b-15 pd-l-40">
								<div id="chindex1" class="br-chartist br-chartist-2 ht-200 ht-sm-300"></div>
							</div>
						</div>
						<!-- card -->



					</div>
					<!-- col-9 -->
					<div class="col-4">


						<div class="card bd-0 shadow-base pd-30">
							<h6 class="tx-13 tx-uppercase tx-inverse tx-semibold tx-spacing-1">系统服务资源</h6>

							<label class="tx-12 tx-gray-600 mg-b-10">服务器已安全运行：<span id="main_time"></span></label>

							<label class="tx-12 tx-gray-600 mg-b-10">CPU使用情况 <span id="main_cpu"></span></label>
							<div class="progress ht-5 mg-b-10">
								<div class="progress-bar" id="main_cpu_wd" role="progressbar" aria-valuenow="25" aria-valuemin="0" aria-valuemax="100"></div>
							</div>

							<label class="tx-12 tx-gray-600 mg-b-10">内存使用情况 <span id="main_free"></span></label>
							<div class="progress ht-5 mg-b-10">
								<div class="progress-bar bg-teal" id="main_free_wd" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"></div>
							</div>

							<label class="tx-12 tx-gray-600 mg-b-10">存储使用情况 <span id="main_Filesystem"></span></label>
							<div class="progress ht-5 mg-b-10">
								<div class="progress-bar bg-danger" id="main_Filesystem_wd"  role="progressbar" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100"></div>
							</div>

							<label class="tx-12 tx-gray-600 mg-b-10">数据库连接数使用情况 <span id="main_connection"></span></label>
							<div class="progress ht-5 mg-b-10">
								<div class="progress-bar bg-warning" id="main_connection_wd" role="progressbar" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"></div>
							</div>

							<label class="tx-12 tx-gray-600 mg-b-10">模板发布线程使用情况 <span id="main_template"></span></label>
							<div class="progress ht-5 mg-b-10">
								<div class="progress-bar bg-info" id="main_template_wd" role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
							</div>

							<label class="tx-12 tx-gray-600 mg-b-10">文件发布线程使用情况 <span id="main_file"></span></label>
							<div class="progress ht-5 mg-b-10">
								<div class="progress-bar bg-purple" id="main_file_wd"  role="progressbar" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
							</div>


						</div>
						<!-- card -->


					</div>
					<!-- col-3 -->
				</div>
				<!-- row -->

			</div>
			<!-- br-pagebody -->
			<footer class="br-footer">
				<div class="footer-left">
					<div class="mg-b-2"><%=company_info%></div>
				</div>
			</footer>
		</div>
		<!-- br-mainpanel -->
		<!-- ########## END: MAIN PANEL ########## -->
		<%}%>


<script src="lib/2018/jquery/jquery.js"></script>
<script src="lib/2018/popper.js/popper.js"></script>
<script src="lib/2018/bootstrap/bootstrap.js"></script>
<script src="lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="lib/2018/moment/moment.js"></script>
<script src="lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>

<script src="lib/2018/peity/jquery.peity.js"></script>
<script src="lib/2018/chartist/chartist.js"></script>
<script src="common/2018/TideDialog2018.js"></script>
<script src="common/2018/bracket.js"></script>
<script src="common/2018/ResizeSensor.js"></script>

<script>
	window.onresize = function() {
		if (document.getElementById("content_frame")) {
			document.getElementById("content_frame").style.height = Math.max(document.documentElement.clientHeight - 70, 0) + "px";
		}
	}

	function changeFrameHeight(_this) {
		$(_this).css("height", document.documentElement.clientHeight - 70);
	}


$(function() {
	'use strict'

	$(window).resize(function() {
		minimizeMenu();
	});

	minimizeMenu();

	function minimizeMenu() {
		if (window.matchMedia('(min-width: 992px)').matches && window.matchMedia('(max-width: 1299px)').matches) {
			// show only the icons and hide left menu label by default
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

$(function(){

    $.ajax({
        type:"get",
        dataType:"json",
        url:"report/main_data.jsp",
        success:function(data){
            var arr = new Array() ;
            arr.push(data.pv);

            chIndex1 = new Chartist.Line('#chindex1', {
                labels: data.xaxis,
                series: arr
            }, {
                //high: ,
                low: 0,
                axisY: {
                    onlyInteger: true
                },
                showArea: true,
                fullWidth: true,
                chartPadding: {
                    bottom: 0,
                    left: 0
                }
            });
        }
    });

	//服务器信息
	systemManager();

    //用户浏览
    displayData();
});	

//服务器信息
function systemManager(){
	$.ajax({
		type: "get",
		dataType:"json",
		url: "main_data.jsp",
		success: function(msg){
			var main_connection = msg.connection_now + "/" + msg.connection_max ;
			var main_template = msg.template_now + "/" + msg.template_max ;
			var main_file = msg.file_now + "/" + msg.file_max ;

			var main_connection_wd = GetPercent(msg.connection_now,msg.connection_max); 
			var main_template_wd = GetPercent(msg.template_now,msg.template_max); 
			var main_file_wd = GetPercent(msg.file_now,msg.file_max); 

			$("#main_time").html(msg.time);
			$("#main_cpu").html(msg.cpu);
			$("#main_free").html(msg.free);
			$("#main_Filesystem").html(msg.Filesystem);
			$("#main_connection").html(main_connection);
			$("#main_template").html(main_template);
			$("#main_file").html(main_file);

			$("#main_cpu_wd").css("width",msg.cpu);
			$("#main_free_wd").css("width",msg.free);
			$("#main_Filesystem_wd").css("width",msg.Filesystem);			
			$("#main_connection_wd").css("width",main_connection_wd);
			$("#main_template_wd").css("width",main_template_wd);
			$("#main_file_wd").css("width",main_file_wd);

			window.setTimeout(systemManager,3000);
		} 
	});
}

//用户浏览量
function displayData()
{
	
	$.ajax({
		url:'report/main_data.jsp',
		type:'get',
		dataType:'json',
		success:function(data){

            $("#main_num").html("本系统下目前管理"+data.sitenum+"个站点、"+data.channelnum+"个子节点内容");
            $("#main_count").html(data.count);
            $("#main_count1").html("已发"+data.PublishCount+",草稿"+data.UnPublishCount);
            $("#main_td").html(data.TodayCount);
            $("#main_dc").html("最近7天增加 "+data.DaysCount);
            $("#main_uc").html(data.UserCount);
            $("#main_uc1").html("近24小时发稿量 "+data.UserCount1);
			$("#main_pv1").html(data.pv1);
			$("#main_pv2").html("最近7天PV "+data.pv2);
		}
	});
}

function GetPercent(num, total) {
	num = parseFloat(num);
	total = parseFloat(total);
	if (isNaN(num) || isNaN(total)) {
	  return "-";
	}
	return total <= 0 ? "0" : (Math.round(num / total * 10000) / 100.00 + "%");
} 
</script>
</body>

</html>
