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
<%@ include file="../config.jsp"%>

<%!
//获取资源数
public int getNum(String sql){

	int num = 0 ;
	try{
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(sql);
		if(Rs.next()) {
			num = Rs.getInt("num");
		}
		tu.closeRs(Rs);
	}catch(Exception e) {
		e.printStackTrace();			
	}
	return num ;

} 

%>
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
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
if(CmsCache.hasValidLicense()) diff = 1000000;

//查询站点总数
int sitenum = 0 ;
String sql= "select * from site";
TableUtil tu = new TableUtil();
ResultSet Rs = tu.executeQuery(sql);
while(Rs.next()) {
	if(Rs.getInt("id")==1){
		continue;
	}
	sitenum++; //= Rs.getInt("rowCount");
}
tu.closeRs(Rs);

//查询频道总数
sql = "select count(*) as num from channel";
int channelnum = getNum(sql);

//查询资源总数
//sql = "select count(*) as num from item_snap";
int count = tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,0,"","");//getNum(sql);
int countAudited = tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,2,"","");//getNum(sql);
int countUnaudited = tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,1,"","");//getNum(sql);

//今日新增
Calendar calendar = Calendar.getInstance();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
String nowDate = sdf.format(calendar.getTime());
//calendar.add(Calendar.DATE, +1);
//String  date1 = sdf.format(calendar.getTime());
long nowTime=Util.getFromTime(nowDate,"");
sql = "select count(*) as num from item_snap where Active=1 and CreateDate>="+nowTime+" and CreateDate<"+(nowTime+86400);
int count1 = getNum(sql);//tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,0,nowDate,date1);//

//7天数据
calendar.add(Calendar.DATE, -6);
String  date2= sdf.format(calendar.getTime());
long time2 = Util.getFromTime(date2,"");
sql = "select count(*) as num from item_snap where Active=1 and CreateDate>="+time2+" and CreateDate<"+(nowTime+86400);
int count2 = getNum(sql);//tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,0,date2,date1);//

//用户发稿量
sql = "select count(*) as num from item_snap where Active=1 and Status=1 and User="+userinfo_session.getId();
int count3 = getNum(sql);
//近24小时发稿量
int time1 = (int)(System.currentTimeMillis()/1000);
sql = "select count(*) as num from item_snap where Active=1 and Status=1 and User="+userinfo_session.getId()+" and PublishDate>="+(time1-86400)+" and PublishDate<"+time1;
int count4 = getNum(sql);
%>
<!DOCTYPE html>
<html  id="appManage">

<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="favicon.ico">
<title>TideCMS 9.0
	<%=CmsCache.getCompany()%>
</title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/rickshaw/rickshaw.min.css" rel="stylesheet">
<link href="../lib/2018/chartist/chartist.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">

<link rel="stylesheet" href="../style/2018/tcenter.css">
<link rel="stylesheet" href="../style/2018/theme.css">

<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<!--<script type="text/javascript" src="common/ui.core.js"></script>
<script type="text/javascript" src="common/ui.draggable.js"></script>
<script type="text/javascript" src="common/TideDialog.js"></script>-->

<script language=javascript>
/*
$(function(){			
	var popTimer = null ;
	var updateTimer = null ;
	function updateManagerDate(){
		$.ajax({
			type: "get",
			url: "/cms/system/manager_data.jsp?flag=6",
			success: function(msg){
			   $(".pop-text").html(msg);
			   var th = $(".pop-text").find("th:[scope=col]")
					th.parent("tr").remove();
			} 
		});
	}
	$(".frame_tool_c").mouseenter(function(){
		clearTimeout(updateTimer);
		clearTimeout(popTimer);		
		if( $(".pop-box").is(":hidden") ){
			updateManagerDate();
		}		
		updateTimer = setInterval(function(){
		   updateManagerDate();
		   console.log(11)
		},3000)		
		$(".pop-box").fadeIn(100);
	}).mouseleave(function(){
		clearTimeout(updateTimer);
		popTimer = setTimeout(function(){
			$(".pop-box").fadeOut(100);
			clearTimeout(popTimer);			
		},200)   		
	})	    		
 })*/

	function init() {
		window.status = "当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
		//	window.onresize=reSize;
		//	reSize();

		//	if (jQuery.browser.msie) {
		//		var version=parseInt(jQuery.browser.version);
		//		if(version==6){
		//			alert("你当前使用的浏览器是IE6,请升级你的浏览器!");
		//		}
		//	}

		set_main_class("index");
		<%if(diff<10*24*3600){%>
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
		url = "http://123.125.148.3:888/cms/feedback.jsp";
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
		<a href="<%=base%>/tcenter/main.jsp"><img src="../images/2018/system-logo.png"></a>
		</a>
	</div>

	<div class="br-sideleft overflow-y-auto">
		<label class="sidebar-label pd-x-15 mg-t-20"></label>
			<div class="br-sideleft-menu">
				<%if(userinfo_session.getRole()==1 || userinfo_session.getRole()==4){%>
				<a href="main.jsp" class="br-menu-link active menu-home">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-home tx-22"></i>
						<span class="menu-item-label">主页</span>
					</div>
					<!-- menu-item -->
				</a>
				<%if(userinfo_session.hasPermission("ManageFile")){%>
				<a href="explorer_index2018.jsp" class="br-menu-link menu-explorer">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-folder tx-20"></i>
						<span class="menu-item-label">文件管理</span>
					</div>
				</a>
				<%}%>
				<%if(userinfo_session.hasPermission("ManageChannel")){%>
				<a href="channel_index2018.jsp" class="br-menu-link menu-channel">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-sitemap tx-20"></i>
						<span class="menu-item-label">结构管理</span>
					</div>
				</a>
				<%}%>
				<!-- br-menu-link -->
				
					<a href="source_index2018.jsp" class="br-menu-link menu-channel">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-database tx-20"></i>
						<span class="menu-item-label">资源中心</span>
					</div>
				</a>
				
			
				<%if(userinfo_session.hasPermission("ManageSystem")){%>
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
					<li class="nav-item"><a href="system_index_2018.jsp?id=11" class="nav-link">审核管理</a></li>
					<li class="nav-item"><a href="system_index_2018.jsp?id=3" class="nav-link">操作日志</a></li>
					<li class="nav-item"><a href="system_index_2018.jsp?id=4" class="nav-link">登录日志</a></li>
					<li class="nav-item"><a href="system_index_2018.jsp?id=5" class="nav-link">错误日志</a></li>
					<li class="nav-item"><a href="system_index_2018.jsp?id=6" class="nav-link">系统日志</a></li>
					<li class="nav-item"><a href="system_index_2018.jsp?id=7" class="nav-link">备份中心</a></li>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="system_index_2018.jsp?id=8" class="nav-link">系统监控</a></li><%}%>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="system_index_2018.jsp?id=9" class="nav-link">调度管理</a></li><%}%>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="system_index_2018.jsp?id=10" class="nav-link">图片尺寸</a></li><%}%>
					<li class="nav-item"><a href="template_index2018.jsp" class="nav-link">模板管理</a></li>
					<li class="nav-item"><a href="user_index2018.jsp" class="nav-link">用户管理</a></li>
					<li class="nav-item"><a href="publish_index2018.jsp" class="nav-link">发布进程管理</a></li>
					<li class="nav-item"><a href="report_index2018.jsp" class="nav-link">工作量统计</a></li>
					<%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="spider_index2018.jsp" class="nav-link">采集系统</a></li><%}%>
				</ul>
				<%}%>

			<%}else if(userinfo_session.getRole()==2||userinfo_session.getRole()==3){%>
				<a href="main.jsp" class="br-menu-link active  menu-home">
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
				<a href="lib/appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-tablet tx-26"></i>
						<span class="menu-item-label">APP管理</span>
					</div>
				</a>
                                  
				<a href="lib/appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-user tx-26"></i>
						<span class="menu-item-label">用户管理</span>
					</div>
				</a>
				<a href="lib/appIndex2018.jsp?childGroup=4" class="br-menu-link menu-interactive" id="menu-interactive">
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
			<div class="br-header-right">
				<nav class="nav">
					<div class="dropdown">
						<a href="" class="nav-link nav-link-profile" data-toggle="dropdown">
							<span class="logged-name hidden-md-down"><%=userinfo_session.getName()%></span>
							<img src="images/2018/img1.jpg" class="wd-32 rounded-circle" alt="">
							<span class="square-10 bg-success"></span>
						</a>
						<div class="dropdown-menu dropdown-menu-header wd-200">
							<ul class="list-unstyled user-profile-nav">
								<li><a href="person/index2018.jsp"><i class="icon ion-ios-person"></i> 个人信息</a></li>
								<li><a href="logout.jsp"><i class="icon ion-power"></i> 退出</a></li>
							</ul>
						</div>
						<!-- dropdown-menu -->
					</div>
					<!-- dropdown -->
				</nav>
			</div>
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
		
			<iframe src="main_content.jsp" name="content_frame" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>     
			
		</div>
			<!-- br-pagebody -->
			<footer class="br-footer">
				<div class="footer-left">
					<div class="mg-b-2">软件版权所有 © 泰德网聚.</div>
				</div>
			</footer>
		</div>
		<!-- br-mainpanel -->
		<!-- ########## END: MAIN PANEL ########## -->
		<%}%>


<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>

<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/chartist/chartist.js"></script>
<script src="../lib/jquery.sparkline.bower/jquery.sparkline.min.js"></script>
<script src="../lib/d3/d3.js"></script>
<script src="../lib/rickshaw/rickshaw.min.js"></script>

<script src="../common/2018/bracket.js"></script>
<script src="../common/2018/ResizeSensor.js"></script>
<!--<script src="common/2018/dashboard.js"></script>-->
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
	var chIndex1 = null ;
/*	chIndex1 = new Chartist.Line('#chindex1', {
				labels: [1,2,3,4,5,6,7],
				series: [[5,9,7,8,5,3,5],[10,15,10,17,8,11,16]]
			  }, {
				high: 30,
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
*/
	
	
	$.ajax({
		type:"get",
		url:"content/api_visiter_chart.jsp?id=15894",
		success:function(data1){                                            		
			var data = JSON.parse(data1)
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
	

//	resize chart when container changest it's width
//	new ResizeSensor($('.br-mainpanel'), function(){
//		chIndex1.update();											   
//	});
});

$(function(){
	
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
		url:'content/api_web_vister.jsp?id=15894',
		data:'id=1',
		type:'post',
		dataType:'json',
		success:function(data){
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
