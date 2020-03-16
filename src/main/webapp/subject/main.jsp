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
<html id="deep-blue">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>选题任务管理系统 </title>

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

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no" onLoad="init();">

<div class="br-logo">
	<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
	   <img class="ht-100p" src="../img/2019/<%=system_logo%>">
	</a>
</div>

	<div class="br-sideleft overflow-y-auto">
		<label class="sidebar-label pd-x-15 mg-t-20 pd-sm-x-10"></label>
			<div class="br-sideleft-menu">
				
						
			    <a href="main.jsp" class="br-menu-link active menu-home">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-home  tx-22"></i>
						<span class="menu-item-label">概览</span>
					</div>
					<!-- menu-item -->
				</a>				
				<a href="Index2018.jsp" class="br-menu-link menu-explorer">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-check-square-o tx-20"></i>
						<span class="menu-item-label">选题管理</span>
					</div>
				</a>
				<a href="project.jsp" class="br-menu-link menu-project">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-bars tx-20"></i>
						<span class="menu-item-label">项目管理</span>
					</div>
				</a>
				<a href="renwu.jsp" class="br-menu-link menu-renwu">
					<div class="br-menu-item">
						<i class="fa fa-list tx-20" aria-hidden="true" ></i> 

						<span class="menu-item-label">任务管理</span>
					</div>
				</a>
				
				<a href="dafeng.jsp" class="br-menu-link menu-dafeng">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-percent tx-20"></i>
						<span class="menu-item-label">打分记录</span>
					</div>
				</a>
				<a href="car.jsp" class="br-menu-link menu-car">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-car  tx-18-force"></i>
						<span class="menu-item-label">车辆管理</span>
					</div>
				</a>
				<a href="shebei.jsp" class="br-menu-link menu-shebei">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-laptop tx-20-force"></i>
						<span class="menu-item-label">设备管理</span>
					</div>
				</a>
				
			</div>
			<!-- br-sideleft-menu -->
		</div>
        <!-- br-sideleft -->

		
		<%@include file="header.jsp"%>
				
		<!-- br-header -->
		<!-- ########## START: MAIN PANEL ########## -->
		<div class="br-mainpanel with-first-nav">
		
			<div class="d-flex pd-30 ">
			<div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-check-square-o tx-36"></i></div>
			<div class="">
				<h4 class="tx-gray-800 mg-b-5">选题任务管理系统</h4>
				<p class="mg-b-0">本系统用于构建全局多租户用户管理、接入产品的管理以及用户登录日志查看。</p>
			</div>
			
		</div>				
		
		<!-- d-flex -->
		<div class="br-pagebody mg-t-5 pd-x-30 ">
			<div class="row row-sm">
				<div class="col-sm-6 col-xl-4 mg-b-20">
					<div class="theme-bg rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-external-link-square tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">未审核</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num"></p>								
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-4 mg-b-20 mg-sm-t-0">
					<div class="theme-bg-9 rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-check-square tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">执行中</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num1"></p>								
							</div>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-4 mg-b-20 mg-sm-t-0">
					<div class="theme-bg-8 rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-share-square tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">已完成</p>
								<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num2">8888</p>								
							</div>
						</div>
					</div>
				</div>				
			</div>
			<!-- row -->

			<div class="row row-sm mg-t-20">
				<div class="col-sm-12 col-xl-8">
					<div class="card pd-0 bd-0 shadow-base mg-b-20">
						<div class="pd-x-30 pd-t-30 pd-b-15">
							<div class="d-flex align-items-center justify-content-between">
								<div>
									<p class="tx-13 tx-uppercase tx-inverse tx-spacing-1 tx-18">
										<i class="fa fa-user-circle-o theme-tx-color mg-r-5"></i>选题任务用户排行
									</p>									
								</div>									
							</div>
						</div>
						<div class="pd-x-30 pd-b-40 pd-l-20" id="xt-user-range">
						    <table class="table  table-valign-middle mg-b-0">
					                <tbody class="tide_item">
					                  
					                 
					                </tbody>
					            </table>
						</div>
					</div>
					<!-- card -->
				</div>
				<!-- col-9 -->
				<div class="col-sm-12 col-xl-4">

		            <div class="card shadow-base bd-0 pd-b-20 ">			              
		              <div class="bg-white pd-x-30 pd-y-20 rounded-bottom d-flex align-items-center justify-content-between">
		                <div class="d-flex align-items-center">
		                  <i class="fa fa-pie-chart tx-20 theme-tx-color"></i>
		                  <span class="mg-l-8 tx-black tx-18">选题栏目数据统计</span>
		                </div><!-- d-flex -->		            
		              </div><!-- d-flex -->
		              <div class="pd-x-30 mg-l-15 tx-gray-700">
		              	<div id="flotPie1" class="min-h-250">
		              		
		              	</div>
		              </div>			              
		            </div>
		            <div class="card bd-0  mg-t-20" >			              
		             <iframe  src="include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)" ></iframe>	
		              			              
		            </div>
				</div>
				<!-- col-3 -->
			</div>
			<!-- row -->
		</div>     
			
		</div>
		<!-- br-mainpanel -->
		<!-- ########## END: MAIN PANEL ########## -->
		

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
	
	
	

});


</script>

<script type="text/javascript">
    $(function()
    {
        var url="task_data_statistics.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(res){
                console.log(res);
                 console.log(res.count);
                  console.log(res.count1);
                   console.log(res.count2);
                $('.num').html(res.count);
                $('.num1').html(res.count1);
                $('.num2').html(res.count2);
                
                  
            var piedata = [
			  { label: "未审核", data: [[1,res.count]], color: '#85C441'},
			  { label: "执行中", data: [[1,res.count1]], color: '#F89D44'},
			  { label: "已完成", data: [[1,res.count2]], color: '#36B3E3'},
			
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
			        threshold: 0
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
			

            }
        });
    });
    
    
    
       $(function()
    {
       	var url="task_ranking.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(res){
               console.log(res);
              
                var html="";
                
                for(var i in res){
                
                    html+='<tr>';
                    html+='<td class="pd-l-0-force wd-5p">'+
                          '<img src="../img/2018/logo_mob.png" class="wd-40 rounded-circle" alt="">'+
                          '</td>';
                    
                    html+=  '<td>'+
                            '<h6 class="tx-inverse tx-14 mg-b-0">'+res[i].UserName+
                            '</h6>'+
                            ' <span class="tx-12">'+res[i].phone+
                            '</span>'+
                            '</td>';
                    html+=  '<td>'+
                            '<span class="xt-num ">'+
                            '选题：'+res[i].num+
                            '</span>'+
                            
                            '</td>';
                    html+=  '<td>'+
                            '最近登录时间: '+res[i].loginDate+
                            '</td>'
                    html+='</tr>';
                }
                var oContent = $('.tide_item');
                oContent.html(html);
                
              

            }
        });
    });


</script>
</body>

</html>
