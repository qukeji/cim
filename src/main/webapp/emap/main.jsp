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
<html id="electronic_map">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>电子地图管理系统 </title>

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
        <a href="Index2018.jsp" class="br-menu-link menu-explorer">
            <div class="br-menu-item">
               <i class="menu-item-icon fa fa-film tx-18-force"></i>
                <span class="menu-item-label">内容管理</span>
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
				<div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-film tx-34"></i></i></div>
				<div class="">
                    <h4 class="tx-gray-800 mg-b-5">电子地图管理系统</h4>
					<p class="mg-b-0">本系统对电子地图内容，图集，评分等相关内容进行查看、维护。</p>	
					</div>
				
			</div>				
			
			<div class="br-pagebody mg-t-5 pd-x-30 ">
			<div class="row row-sm">
				<div class="col-sm-6 col-xl-4 mg-b-20">
					<div class="theme-bg rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-external-link-square tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">数量总量</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num1"></p>								
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-4 mg-b-20 mg-sm-t-0">
					<div class="theme-bg-1 rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-check-square tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">本周新增</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num2"></p>								
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-4 mg-b-20 mg-sm-t-0">
					<div class="theme-bg-2 rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-share-square tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">今日新增</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num3"></p>								
							</div>
						</div>
					</div>
				</div>				
			</div>
				<!-- row -->

				<div class="row row-sm mg-t-20">
					<div class="col-8">
						<div class="card pd-0 bd-0 shadow-base">
							<div class="pd-x-30 pd-t-30 pd-b-15">
								<div class="d-flex align-items-center justify-content-between">
									<div>
										<p class="tx-13 tx-uppercase tx-inverse tx-spacing-1 tx-18">
											<i class="fa fa-line-chart theme-tx-color mg-r-5"></i>电子地图排行
										</p>										
									</div>									
								</div>
							</div>
								<div class="pd-x-30 pd-b-40 pd-l-20" id="BDMap" style="min-height:400px;">
							
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
		


<script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>

<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../lib/2018/Flot/jquery.flot.js"></script>
<script src="../lib/2018/Flot/jquery.flot.pie.js"></script>
<script src="../lib/2018/Flot/jquery.flot.resize.js"></script> 
<script src="../common/2018/bracket.js"></script>
<script src="../common/2018/common2018.js"></script>

<!--百度地图js-->
<script src="https://api.map.baidu.com/api?v=2.0&ak=qRmGDXGZUpzLzTmffMdhMZzrN1TQvix2"></script>
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
 


	

});


</script>


<script type="text/javascript">
    $(function()
    {
        var url="emap_data_statistics.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(res){
                console.log(res);
                 $('.num1').html(res.count);
                  $('.num2').html(res.count1);
                   $('.num3').html(res.count2);

            }
        });
    });

</script>



<script>
	//初始化饼图
	$(function(){
		
		var bdMap ;
		getMapData();
		function getMapData(){			
			$.ajax({
		        url:"mian_map_content.jsp",
		        dataType:"jsonp",		        
		        success:function(data){
		        	console.log(data)
					initMap(data);		        	
		        },
		        error:function(e){
		            console.log(e)		        	
		        }
			})
		}
        
        //地图初始化
		function initMap(data){
			bdMap = new BMap.Map("BDMap");    		             
		    bdMap.addControl(new BMap.MapTypeControl({mapTypes: [BMAP_NORMAL_MAP,BMAP_HYBRID_MAP]}));   
		    bdMap.enableScrollWheelZoom(true);		   
		    var navigationControl = new BMap.NavigationControl({			    
			    anchor: BMAP_ANCHOR_TOP_LEFT,  // 靠左上角位置 			    
			    type: BMAP_NAVIGATION_CONTROL_LARGE, // LARGE类型			    
			    enableGeolocation: true  // 启用显示定位
		    });
		    bdMap.addControl(navigationControl);
		    addMarker(data)
		}
		//创建标注点并添加到地图中
		function addMarker(points) {
		    //循环建立标注点
		    for(var i=0, pointsLen = points.length; i<pointsLen; i++) {
		        var point = new BMap.Point(points[i].lng, points[i].lat); //将标注点转化成地图上的点
		        var marker = new BMap.Marker(point); //将点转化成标注点
		        bdMap.addOverlay(marker);  //将标注点添加到地图上
		        //添加监听事件
		        (function() {
		            var thePoint = points[i];
		            marker.addEventListener("click",
		                function() {
		                showInfo(this,thePoint);
		            });
		         })();  
		    }
		    setCenterAndZoom(points);
		}
		//展示位置点相关信息
        function showInfo(thisMarker,point) {
		    //获取点的信息
//		    var sContent = 
//		    '<ul style="margin:0 0 5px 0;padding:0.2em 0">'    
//		    +'<li style="line-height: 26px;font-size: 15px;">'  
//		    +'<span style="width: 50px;display: inline-block;">名称：</span>' + point.title + '</li>'  
//		    +'<li style="line-height: 26px;font-size: 15px;"><span style="width: 50px;display: inline-block;">查看：</span><a target="_blank" href="'+point.address+'">详情</a></li>'  
//		    +'</ul>';
		    var sContent = 
		    '<ul style="margin:0 0 5px 0;padding:0.2em 0">'    		     
		    +'<li style="line-height: 26px;font-size: 15px;text-align:center;max-width:250px;">'
		    +'<a target="_blank" style="color:#666" href="'+point.address+'">'+point.title+' </a>'
		    +'</li>'
		    +'</ul>';
		    var infoWindow = new BMap.InfoWindow(sContent); //创建信息窗口对象
		    thisMarker.openInfoWindow(infoWindow); //图片加载完后重绘infoWindow
		}

		//设置地图中心点
		function setCenterAndZoom(pos){
		   	if(!pos[0]){
		   		//不存在就定位到北京
		   	    bdMap.centerAndZoom(new BMap.Point(116.4048605545,39.9134905988), 10);
		   	}else{
		   	    bdMap.centerAndZoom(new BMap.Point(pos[0].lng, pos[0].lat), 10);
		   	}
		}
		
		
		
		/*初始化饼图*/
		var piedata = [
		  { label: "Series 1", data: [[1,10]], color: '#9A3267'},
		  { label: "Series 2", data: [[1,30]], color: '#ED4151'},
		  { label: "Series 3", data: [[1,90]], color: '#F89D44'},
		  { label: "Series 4", data: [[1,70]], color: '#85C441'},
		  { label: "Series 5", data: [[1,80]], color: '#36B3E3'}
		];
		
		$.plot('#flotPie1', piedata, {
		  series: {
		    pie: {
		      show: true,
		      radius: 1,
		      label: {
		        show: true,
		        radius: 2/3,
		        formatter: labelFormatter,
		        threshold: 0.1
		      }
		    }
		  },
		  grid: {
		    hoverable: true,
		    clickable: true
		  }
		});
		
		function labelFormatter(label, series) {
			  return "<div style='font-size:8pt; text-align:center; padding:2px; color:white;'>" + label + "<br/>" + Math.round(series.percent) + "%</div>";
		}
		
		
	})
</script>

</body>


