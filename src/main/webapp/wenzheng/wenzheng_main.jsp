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
String system_logo = CmsCache.getParameter("system_logo").getContent();

%>

<!DOCTYPE html>
<html id="pink">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>问政业务管理系统 </title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<link href="../lib/2018/rickshaw/rickshaw.min.css" rel="stylesheet">
<link href="../lib/2018/chartist/chartist.css" rel="stylesheet">
<link href="../lib/2018/morris.js/morris.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">

<link rel="stylesheet" href="../style/2018/common.css">
<link rel="stylesheet" href="../style/2018/tcenter.css">
<link rel="stylesheet" href="../style/2018/theme.css">
<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
<style>
	.nav-pills .nav-link:focus, .nav-pills .nav-link:hover{background-color:#e9ecef ;}
	.bar-tips .chart-item-color{width: 10px;height: 10px;}
	.bar-tips li:nth-child(1) .chart-item-color{background: #5058ab;}
	.bar-tips li:nth-child(2) .chart-item-color{background: #14a0c1;}
	.bar-tips li:nth-child(3) .chart-item-color{background: #01cb99;}
	.br-menu-item i {
    min-width: 21px;
    min-height: 19px;}
</style>
<style>
	.height{
        height:200px !important;
        width:100% !important;
    }
</style>
<script language=javascript>
function init()
{	
	window.status="当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
	set_main_class("index");
	<%if(diff<10*24*3600){%>
		tidecms.dialog("../system/license_notify.jsp", 500, 300, "许可证到期提醒", 2);
	<%}%>
}

function reSize() {
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - document.getElementById("main").offsetTop, 0) + "px";
}
function set_main_class(str){
	jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+str).addClass('on');
}

</script>


<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no" onLoad="init();">

	
<div class="br-logo">
	<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
	   <img class="ht-100p" src="../img/2019/<%=system_logo%>">
	</a>
</div>

	<div class="br-sideleft overflow-y-auto">
		<label class="sidebar-label pd-x-15 mg-t-20"></label>
    	<div class="br-sideleft-menu">
    				
    		<a href="wenzheng_main.jsp" class="br-menu-link  active menu-home">
                <div class="br-menu-item">
                    <i class="menu-item-icon fa fa-home tx-22"></i>
                    <span class="menu-item-label">概览</span>
                </div>
                <!-- menu-item -->
            </a>
            <a href="wenzheng_transaction.jsp?id=1" class="br-menu-link menu-source">
                <div class="br-menu-item">
                    <i class="fa fa-clock-o tx-20"></i>
                    <span class="menu-item-label">待办理</span>
                </div>
                <!-- menu-item -->
            </a>
            <a href="wenzheng_transaction.jsp?id=2" class="br-menu-link menu-source">
                <div class="br-menu-item">
                    <i class="fa fa-step-forward tx-20"></i>
                    <span class="menu-item-label">办理中</span>
                </div>
                <!-- menu-item -->
            </a>
            <a href="wenzheng_transaction.jsp?id=3" class="br-menu-link menu-source">
                <div class="br-menu-item">
                    <i class="fa fa-check-square tx-20"></i>
                    <span class="menu-item-label">已办理</span>
                </div>
                <!-- menu-item -->
            </a>
            <!-- br-menu-link -->
            <a href="wezheng_channel_statistical.jsp" class="br-menu-link menu-source">
                <div class="br-menu-item">
                    <i class="menu-item-icon fa fa-bar-chart tx-20"></i>
                    <span class="menu-item-label">各部门统计</span>
                </div>
                <!-- menu-item -->
            </a>
    	</div>
			<!-- br-sideleft-menu -->
		</div>
    <!-- br-sideleft -->

		<div class="br-header">
			<div class="br-header-left">
				<div class="navicon-left hidden-md-down"><a id="btnLeftMenu" href=""><i class="icon ion-navicon-round"></i></a></div>
				<div class="navicon-left hidden-lg-up"><a id="btnLeftMenuMobile" href=""><i class="icon ion-navicon-round"></i></a></div>
				<div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i>问政数据管理</a></div>
			</div>
			<!-- br-header-left -->
			<div class="br-header-right">
				<nav class="nav">
						<%@include file="header.jsp"%>
					<!-- dropdown -->
				</nav>
			</div>
			<!-- br-header-right -->
		</div>
		<!-- br-header -->
		<!-- ########## START: MAIN PANEL ########## -->
		<div class="br-mainpanel with-first-nav">
		
			<div class="d-flex pd-30">
				<div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-heart tx-36"></i></div>
				<div class="">
                    <h4 class="tx-gray-800 mg-b-5">问政业务管理</h4>
					<p class="mg-b-0">本系统用于将网络问政内容进行审核、分发、处理、发布。并实时发布问政排行，管理维护问政部门结构。</p>	
					</div>
				
			</div>				
			
			<!-- d-flex -->
			<div class="br-pagebody mg-t-5 pd-x-30">
				<div class="row row-sm">
					<div class="col-sm-6 col-xl-3">
						<div class="theme-bg rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-folder tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">资源总数</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num">
								
									</p>
									
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
				
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-sm-t-0">
						<div class="theme-bg-9 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-folder-open-o tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">待办理</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num2">
										
									</p>
									
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-xl-t-0">
						<div class="theme-bg-8 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-list-alt tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">办理中</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num3"></p>
									
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-xl-t-0">
						<div class="theme-bg-7 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-check tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">已办理</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num4" ></p>
									
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
				</div>
				<!-- row -->

				<div class="row row-sm mg-t-20">
					<div class="col-7">
						<div class="card pd-0 bd-0 shadow-base">
							<div class="pd-x-30 pd-t-30 pd-b-15">
								<div class="d-flex align-items-center justify-content-between">
				                    <div class="rounded d-flex align-items-center mg-r-30" >				                    
							    		<ul class="nav nav-pills flex-column flex-md-row  rounded column-charts" role="tablist">
							    			<li class="nav-item mg-r-20"><a class="nav-link bg-gray-200 pd-x-15 pd-y-8" data-toggle="tab" href="#" role="tab" aria-expanded="false">今日</a></li>	
					              			<li class="nav-item mg-r-20"><a class="nav-link bg-gray-200  pd-x-15 pd-y-8" data-toggle="tab" href="#" role="tab" aria-expanded="true">近7天</a></li>
					              			<li class="nav-item"><a class="nav-link bg-gray-200 active pd-x-15 pd-y-8" data-toggle="tab" href="#" role="tab" aria-expanded="true">近30天</a></li>					              					             
					            		</ul>
									</div><!-- pd-10 -->									
				                 </div>
							</div>							
							<div class="pd-x-30 pd-b-15 pd-l-40">
								<div id="chartBar1" class="br-chartist br-chartist-2 ht-200 ht-sm-300 wd-100p">
									
								</div>
							</div>
							<div class="bar-tips d-flex justify-content-center mg-b-20">
								<ul class="d-flex t-12">
									<li class="d-flex align-items-center mg-r-10"><div class="chart-item-color mg-r-5"></div>问题数量</li>
									<li class="d-flex align-items-center mg-r-10"><div class="chart-item-color mg-r-5"></div>受理数量</li>
									<li class="d-flex align-items-center"><div class="chart-item-color mg-r-5"></div>完结数量</li>
								</ul>
							</div>
						</div>
						<!-- card -->
					</div>
					<!-- col-9 -->
					<div class="col-5">

						<div class="card shadow-base bd-0 pd-b-20">
							 <div class="pd-x-30 pd-t-30 pd-b-15">
								<div class="d-flex align-items-center justify-content-between">
				                    <div class="rounded d-flex align-items-center mg-r-30" >				                    
							    		<ul class="nav nav-pills flex-column flex-md-row  rounded rows-charts" role="tablist">
							    			<li class="nav-item mg-r-20"><a class="nav-link bg-gray-200  pd-x-15 pd-y-8" data-toggle="tab" href="#" role="tab" aria-expanded="true">回复率</a></li>	
					              			<li class="nav-item mg-r-20"><a class="nav-link bg-gray-200  pd-x-15 pd-y-8" data-toggle="tab" href="#" role="tab" aria-expanded="true">完结率</a></li>
					              			<li class="nav-item mg-r-20"><a class="nav-link bg-gray-200 active pd-x-15 pd-y-8" data-toggle="tab" href="#" role="tab" aria-expanded="true">满意率</a></li>					              					             
					            		</ul>
									</div><!-- pd-10 -->									
				                 </div>
							</div>	
							<div class="pd-20">
								<canvas id="chartBar2" class=""></canvas>
							</div>										             
			           </div>			            			            
			           <div class="  bd-0 mg-t-20">			              
    			             <iframe  src="include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)" ></iframe>		              
			            </div>
					</div>
					<!-- col-3 -->
				</div>
				<!-- row -->
			</div>
			
		</div>
		


<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>

<script src="../lib/jquery.sparkline.bower/jquery.sparkline.min.js"></script>
<script src="../lib/2018/raphael/raphael.min.js"></script>
<script src="../lib/2018/morris.js/morris.js"></script>
<script src="../lib/2018/chartist/chartist.js"></script>
<script src="../lib/2018/chart.js/Chart.js"></script>
<script src="../lib/2018/select2/js/select2.min.js"></script>
<script type="text/javascript" src="../common/2018/TideDialog2018.js"></script>


<script src="../common/2018/bracket.js"></script>
<script src="../common/2018/ResizeSensor.js"></script>
<!--<script src="../../common/2018/chart.morris.js"></script> -->
<script>
	
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
	
	//var chIndex = null ;
	var datawz="";
	var datawz1="";
	var datawz2="";
	var xaxis="";
	var total="";
    var url="wenzheng_main_chart.jsp";
	 $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(data){
                console.log(data);
                
			    xaxis=data.xaxis; 
                 datawz=data.wenzheng;
                 datawz1=data.wenzheng1;
                 datawz2=data.wenzheng2;
			     total=data.wenzhengtotal;
                 var dataArray = new Array();
                 for(var i=0; i<xaxis.length;i++){
                    dataArray.push({y:xaxis[i], a: total[i],  b: datawz[i], c: datawz1[i], d: datawz2[i]});
                     }
              	    new Morris.Line({
            	    element: 'chindex1',
            	    data: dataArray,
            	    xkey: 'y',
            	    ykeys: ['a', 'b', 'c','d'],
            	    labels: ['总数','未处理', '待处理', '已处理'],
            	    lineColors: ['#14A0C1', '#5058AB', '#72DF00'],
            	    lineWidth: 1,
            	    ymax: 'auto 100',
            	    gridTextSize: 11,
            	    hideHover: 'auto',
            	    resize: true
                	});
        }
     });       
});


</script>
<script type="text/javascript">
    $(function()
    {
        var url="wenzheng_data_statistics.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(res){
                console.log(res);
                 $('.num').html(res.count);
                 $('.num2').html(res.count1);
                 $('.num3').html(res.count4);
                 $('.num4').html(res.count2);

            }
        });
    });

</script>



<script type="text/javascript">
   $(function() {
	
	//柱形图初始化
	//var chIndex = null ;
	//左侧柱状图数据示例

	
	var today;
	$.ajax({
					url:"../wenzheng/wenzheng_maingetnum.jsp",
					type:"GET",
					dataType:"JSON",
					cache : false,
					async : false,
					data: {returnDays:1},
					success:function(data){
					today=data;
							return data;
					}
				});
	var seven;
	$.ajax({
					url:"../wenzheng/wenzheng_maingetnum.jsp",
					type:"GET",
					dataType:"JSON",
					cache : false,
					async : false,
					data: {returnDays:7},
					success:function(data){	
					seven=data;
							return data;
					}
				});
				
	var thirty;
	$.ajax({
					url:"../wenzheng/wenzheng_maingetnum.jsp",
					type:"GET",
					dataType:"JSON",
					cache : false,
					async : false,
					data: {returnDays:30},
					success:function(data){	
					thirty=data;
							return data;
					}
				});
    
    var chartBar1 = null ;
    function updateBarChart(data){
    	$("#chartBar1").empty()
    	chartBar1 = new Morris.Bar({
		    element: 'chartBar1',
		    data: data,
		    xkey: 'name',
		    ykeys: ['allnum', 'acceptnum', 'endnum'],
		    labels: ['问题数量', '受理数量', '完结数量'],
		    barColors: ['#5058AB', '#14A0C1','#01CB99'],
		    gridTextSize: 11,
		    hideHover: 'auto',
		    resize: true
		});
    }
    updateBarChart(thirty);
    //左边柱状图切换天数
	$(".column-charts li").click(function(){
    	var _type = $(this).index() ;
    	if(_type == 0){
    		updateBarChart(today)
    	}else if(_type == 1){
    		updateBarChart(seven)
    	}else if(_type == 2){
    		updateBarChart(thirty)
    	}
    })
    
    
    //右侧柱状图数据示例
    //满意率
	var myl;
	//myl = {
	//	data : [12, 39, 30, 10, 25, 18],
	//	labels : ["交通部","公安部","财政部","统计局","税务局"]
	//}
	$.ajax({
			url:"../wenzheng/wenzheng_maingetPercent.jsp",
			type:"GET",
			dataType:"JSON",
			cache : false,
			async : false,
			data: {returnType:3},
			success:function(data){	
			myl=data;
					return data;
			}
		});
	//完结率
	var myl2;
	$.ajax({
			url:"../wenzheng/wenzheng_maingetPercent.jsp",
			type:"GET",
			dataType:"JSON",
			cache : false,
			async : false,
			data: {returnType:2},
			success:function(data){	
			myl2=data;
					return data;
			}
		});
	//myl2 = {
	//	data : [12, 39, 20, 10, 35, 18],
	//	labels : ["交通部","公安部","财政部","统计局","税务局"]
	//}
	//回复率
	var myl3;
	$.ajax({
			url:"../wenzheng/wenzheng_maingetPercent.jsp",
			type:"GET",
			dataType:"JSON",
			cache : false,
			async : false,
			data: {returnType:1},
			success:function(data){	
			myl3=data;
					return data;
			}
		});
	//myl3 = {
	//	data : [32, 39, 20, 10, 25, 18],
	//	labels : ["交通部","公安部","财政部","统计局","税务局"]
	//}
	//左边柱状图切换天数
	$(".rows-charts li").click(function(){
    	var _type = $(this).index() ;
    	if(_type == 0){
    		updateBarChart2(myl)
    	}else if(_type == 1){
    		updateBarChart2(myl2)
    	}else if(_type == 2){
    		updateBarChart2(myl3)
    	}
    })	
	var chart2 = document.getElementById('chartBar2').getContext('2d'); 
	updateBarChart2(myl3)
    function updateBarChart2(data){
    	new Chart(chart2, {
		    type: 'horizontalBar',
		    data: {
		      labels: data.labels,  //y轴
		      datasets: [{
		        label: '百分比%',
		        data: data.data,  // 
		        backgroundColor:'#29B0D0'
		      }]
		    },
		    options: {
		      legend: {
		        display: false,
		          labels: {
		            display: false
		          }
		      },
		      scales: {
		        yAxes: [{
		          ticks: {
		            beginAtZero:true,
		            fontSize: 10
		          }
		        }],
		        xAxes: [{
		          ticks: {
		            beginAtZero:true,
		            fontSize: 11,
		            max: 100
		          }
		        }]
		      }
		    }
		});
    }	
});


</script>




</body>


