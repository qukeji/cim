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
<html id="appManage">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>APP管理 </title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
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
		<%if(userinfo_session.getRole()==1 || userinfo_session.getRole()==4){%>
		<a href="main.jsp" class="br-menu-link active menu-home" id="menu-home">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-home tx-20"></i>
			<span class="menu-item-label">主页</span>
		  </div>
		</a>
		<a href="source_index2018.jsp" class="br-menu-link menu-source" id="menu-source">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-database tx-20"></i>
			<span class="menu-item-label">资源中心</span>            
		  </div>
		</a>
		<a href="appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-tablet tx-26"></i>
				<span class="menu-item-label">APP管理</span>
			</div>
		</a>
		<a href="appIndex2018.jsp?childGroup=4" class="br-menu-link menu-app_setting" id="menu-app_setting">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-cogs tx-16"></i>
				<span class="menu-item-label">配置管理</span>
			</div>
		</a>
		<a href="appIndex2018.jsp?childGroup=5" class="br-menu-link menu-app_auto_package" id="menu-app_auto_package">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-suitcase tx-16"></i>
				<span class="menu-item-label">App打包</span>
			</div>
		</a>
                                  
		<a href="appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-user tx-26"></i>
				<span class="menu-item-label">用户管理</span>
			</div>
		   
		</a>
                                   
		<a href="appIndex2018.jsp?childGroup=3" class="br-menu-link menu-standard" id="menu-standard">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-comments-o tx-20"></i>
				<span class="menu-item-label">互动管理</span>
			</div>
		</a>
		
		<%if(userinfo_session.hasPermission("ManageSystem")){%>
		<a href="#" class="br-menu-link menu-system" id="menu-system" hidden="hidden">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-gear tx-20"></i>
			<span class="menu-item-label">系统管理</span>
			<i class="menu-item-arrow fa fa-angle-down"></i>
		  </div>
		</a>
		<ul class="br-menu-sub nav flex-column" id="system-menu"  hidden="hidden">
		 
		 
		  <li class="nav-item"><a href="system_index_2018.jsp?id=3" class="nav-link system-menu3" id="system-menu-operate">操作日志</a></li>
		  <li class="nav-item"><a href="system_index_2018.jsp?id=4" class="nav-link system-menu4" id="system-menu-login">登录日志</a></li>
		  <li class="nav-item"><a href="system_index_2018.jsp?id=5" class="nav-link system-menu5" id="system-menu-error">错误日志</a></li>
		  <li class="nav-item"><a href="system_index_2018.jsp?id=6" class="nav-link system-menu6" id="system-menu-systemlog">系统日志</a></li>
		  
		   
		  <li class="nav-item"><a href="template_index2018.jsp" class="nav-link system-menu" id="system-menu-template">模板管理</a></li>
		  <li class="nav-item"><a href="user_index2018.jsp" class="nav-link system-menu" id="system-menu-user">用户管理</a></li>
		  <li class="nav-item"><a href="report_index2018.jsp" class="nav-link system-menu" id="system-menu-report">工作量统计</a></li>
		  <%if(userinfo_session.isAdministrator()){%><li class="nav-item"><a href="spider_index2018.jsp" class="nav-link system-menu" id="system-menu-spider">采集系统</a></li><%}%>
		</ul>
		<%}%>

		<%}else if(userinfo_session.getRole()==2||userinfo_session.getRole()==3){%>
		<a href="main.jsp" class="br-menu-link menu-home" id="menu-home">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-home tx-20"></i>
			<span class="menu-item-label">主页</span>
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->
		<a href="source_index2018.jsp" class="br-menu-link menu-source" id="menu-source">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-database tx-20"></i>
			<span class="menu-item-label">资源中心</span>            
		  </div><!-- menu-item -->
		</a><!-- br-menu-link --> 
		<a href="appIndex2018.jsp?childGroup=1" class="br-menu-link menu-app" id="menu-app">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-tablet tx-20"></i>
				<span class="menu-item-label">APP管理</span>
			</div>
		</a>
		<a href="appIndex2018.jsp?childGroup=4" class="br-menu-link menu-app_setting" id="menu-app_setting">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-eye tx-16"></i>
				<span class="menu-item-label">配置管理</span>
			</div>
		</a>
		<a href="appIndex2018.jsp?childGroup=2" class="br-menu-link menu-userManage" id="menu-userManage">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-user tx-26"></i>
				<span class="menu-item-label">用户管理</span>
			</div>
		</a>
		<a href="appIndex2018.jsp?childGroup=3" class="br-menu-link menu-standard" id="menu-standard">
			<div class="br-menu-item">
				<i class="menu-item-icon fa fa-comments-o tx-20"></i>
				<span class="menu-item-label">互动管理</span>
			</div>
		</a>
	           
               								
		<%}else if(userinfo_session.getRole()==4){%>
		<a href="content_index2018.jsp" class="br-menu-link menu-content" id="menu-content">
		  <div class="br-menu-item">
			<i class="menu-item-icon fa fa-desktop tx-20"></i>
			<span class="menu-item-label">界面管理</span>            
		  </div><!-- menu-item -->
		</a><!-- br-menu-link -->   
		<%}%>
      </div><!-- br-sideleft-menu -->     
    </div><!-- br-sideleft -->
        <!-- br-sideleft -->

		<div class="br-header">
				<%@include file="header.jsp"%>
		</div>
		<!-- br-header -->
		<!-- ########## START: MAIN PANEL ########## -->
			
		<div class="br-mainpanel with-first-nav">
		
			<div class="d-flex pd-30 ">
				<div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-mobile tx-36"></i></div>
				<div class="">
					<h4 class="tx-gray-800 mg-b-5">APP管理</h4>
					<p class="mg-b-0">本系统用于构建全局多租户用户管理、接入产品的管理以及用户登录日志查看。</p>
				</div>
				
			</div>				
			
			<!-- d-flex -->
			<div class="br-pagebody mg-t-5 pd-x-30 ">
				<div class="row row-sm">
					<div class="col-sm-6 col-xl-3 mg-b-20">
						<div class="theme-bg rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-database tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">总内容数据量</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num"></p>								
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-xl-3 mg-b-20 mg-sm-t-0">
						<div class="theme-bg-9 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-file-text tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">今日新增内容</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num1"></p>								
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-xl-3 mg-b-20 mg-sm-t-0">
						<div class="theme-bg-8 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-cloud-upload tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">当前用户发稿</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 num3"></p>								
								</div>
							</div>
						</div>
					</div>
					<div class="col-sm-6 col-xl-3 mg-b-20 mg-sm-t-0">
						<div class="theme-bg-7 rounded overflow-hidden">
							<div class="pd-25 d-flex align-items-center">
								<i class="fa fa-line-chart tx-60 lh-0 tx-white "></i>
								<div class="mg-l-20">
									<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">今日浏览量</p>
									<p class="tx-24 tx-white tx-lato tx-bold mg-b-2 lh-1 " id="main_pv1"></p>								
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
											<i class="fa fa-user-circle-o theme-tx-color mg-r-5"></i>媒体号排行
										</p>									
									</div>									
								</div>
							</div>
							<div class="pd-x-30 pd-b-40 pd-l-20" id="media-range">
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

		            <div class="card shadow-base bd-0 pd-b-20">
		             	<%@include file="include/adress_daohang.html"%>
		            
		              <div class="  bd-0 mg-t-20">			              
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
		


<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>

<script src="../lib/2018/peity/jquery.peity.js"></script>
<script src="../common/2018/bracket.js"></script>

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

   $(function()
    {
    	
    	$.ajax({
    		url:'../content/api_web_vister.jsp?id=15894',
    		data:'id=1',
    		type:'post',
    		dataType:'json',
    		success:function(data){
    		    console.log(data);
    			$("#main_pv1").html(data.pv1);
    			$("#main_pv2").html("最近7天PV "+data.pv2);
    		}
    	});
   	});
   	
   	
   	 $(function()
    {
    	
    	$.ajax({
    		url:'../report/main_data.jsp',
    		data:'id=1',
    		type:'post',
    		dataType:'json',
    		success:function(data){
    		    console.log(data);
    			$(".num").html(data.count);
    			$(".num1").html(data.count1);
    			$(".num3").html(data.count3);
    		
    		
    		}
    	});
   	});
   	
    $(function()
    {
       	var url="main_rank.jsp";
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
                          '<img src="'+res[i].Photo+'" class="wd-40 rounded-circle" alt="">'+
                          '</td>';
                    
                    html+=  '<td>'+
                            '<h6 class="tx-inverse tx-14 mg-b-0">'+res[i].Title+
                            '</h6>'+
                            '</td>';
                    html+=  '<td>'+
                            '<span class="xt-video mg-r-10"><i class="fa fa-video-camera"></i>'+res[i].videocount+
                            '</span>'+
                            '<span class="xt-video mg-r-10"><i class="fa fa-picture-o"></i>'+res[i].photocount+
                            '</span>'+
                            '<span class="xt-video mg-r-10"><i class="fa fa-play-circle-o"></i>'+res[i].zhibocount+
                            '</span>'+
                            '</td>';
                    html+=  '<td><i class="fa fa-star tx-18"></i>'+
                            '关注人数:'+res[i].num+
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
