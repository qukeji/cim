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
<%@ include file="../../config.jsp"%>
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
<html id="userdataManage">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>用户数据管理系统 </title>

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
<style>
	.height{
        height:200px !important;
        width:100% !important;
    }
</style>
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
				
			 <a href="main.jsp" class="br-menu-link  active menu-home">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-home tx-22"></i>
                <span class="menu-item-label">概览</span>
            </div>
            <!-- menu-item -->
        </a>
        <a href="appIndex2018.jsp" class="br-menu-link menu-explorer">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-tablet tx-22-force tx-center"></i>
                <span class="menu-item-label">APP注册用户</span>
            </div>
        </a>
       
			</div>
			<!-- br-sideleft-menu -->
		</div>
        <!-- br-sideleft -->

		<div class="br-header">
		
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
				<div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-users tx-36"></i></div>
				<div class="">
                    <h4 class="tx-gray-800 mg-b-5">用户数据管理系统</h4>
					<p class="mg-b-0">本系统用于汇总终端用户进行查看及管理</p>	
					</div>
				
			</div>				
			
			<!-- d-flex -->
			<div class="br-pagebody mg-t-5 pd-x-30">
				<div class="row row-sm">
					<div class="col-sm-6 col-xl-3">
						<div class="theme-bg rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-users tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">APP总注册用户数</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num">
								
									</p>
									
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
				
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-sm-t-0">
						<div class="theme-bg-1 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-calendar-plus-o tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">最近一个月注册用户</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num2">
										
									</p>
									
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-xl-t-0">
						<div class="theme-bg-2 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-address-card-o tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">最近一周注册用户</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num3"></p>
									
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
					<div class="col-sm-6 col-xl-3 mg-t-20 mg-xl-t-0">
						<div class="theme-bg-3 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-address-book-o tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">今日新增用户</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num4" id="main_pv1">0</p>
									
								</div>
							</div>
						</div>
					</div>
					<!-- col-3 -->
				</div>
				<!-- row -->

				<div class="row row-sm mg-t-20">
					<div class="col-8">
						<div class="card pd-0 bd-0 shadow-base mg-t-20">
							<div class="pd-x-30 pd-t-30 pd-b-15">
								<div class="d-flex align-items-center justify-content-between">
									<div>
										<p class="tx-13 tx-uppercase tx-inverse tx-spacing-1 tx-18">
											<i class="fa fa-line-chart theme-tx-color mg-r-5"></i>APP用户数据统计
										</p>										
									</div>									
								</div>
							</div>
							<div class="pd-x-30 pd-b-15 pd-l-40">
								<div id="chindex1" class="br-chartist br-chartist-2 ht-200 ht-sm-300 wd-100p">
								    
								</div>
							</div>
						</div>
						<!-- card -->
					</div>
					<!-- col-9 -->
					<div class="col-4">

						
			            
			
			            <div class="  bd-0 mg-t-20">			              
    			             <iframe  src="include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)" ></iframe>		              
			            </div>
					</div>
					<!-- col-3 -->
				</div>
				<!-- row -->
			</div>
			
		</div>
		


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
<script src="../lib/2018/raphael/raphael.min.js"></script>
<script src="../lib/2018/morris.js/morris.js"></script>
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
	
	var total="";
	var xaxis="";
    var url="user_main_chart.jsp";
	 $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(data){
                console.log(data);
                
			    xaxis=data.xaxis; 
			     total=data.appuser;
                 var dataArray = new Array();
                 
                 for(var i=0; i<xaxis.length;i++){
                    
                    dataArray.push({y:xaxis[i], a: total[i]});
                     }
                     
              	    new Morris.Line({
            	    element: 'chindex1',
            	    data: dataArray,
            	    xkey: 'y',
            	    ykeys: ['a'],
            	    labels: ['APP新增用户数'],
            	    lineColors: ['#14A0C1'],
            	    lineWidth: 1,
            	    ymax: 'auto 100',
            	    gridTextSize: 11,
            	    hideHover: 'auto',
            	    resize: true
                	});
                	
                	//本月数量
                	if(i=xaxis.length-1){
                       $('.num2').html(total[xaxis.length-1]);
                          console.log(total[xaxis.length-1]);
                    }
              
                	
        }
     });       

});
 $(function()
    {
        var url="http://183.166.129.70:888/cms/webuser/user_img_api.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"jsonp",
            success: function(res){
                console.log(res);
               

            }
        });
    });

</script>


<script type="text/javascript">
    $(function()
    {
        var url="user_data_statistics.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(res){
                console.log(res);
                 $('.num').html(res.count);
                  $('.num3').html(res.count1);
                   $('.num4').html(res.count2);

            }
        });
    });

</script>


</body>


