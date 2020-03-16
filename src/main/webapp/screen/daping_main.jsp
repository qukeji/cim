<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*,
				java.sql.*,
				tidemedia.cms.spider.*,
				java.io.*,
				org.json.*,
				tidemedia.cms.publish.*,
				java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public static String cmd1(String[] ss, boolean print) {
	String bufs = "";
	List<String> commend = new java.util.ArrayList<String>();
	ProcessBuilder builder = new ProcessBuilder();
	builder.command(commend);
	builder.redirectErrorStream(true);
	
	for (int i = 0; i < ss.length; i++) {
		commend.add(ss[i]);
	}

	String commend_desc = commend.toString().replace(", ", " ");

	try {
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream();
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while ((line2 = br2.readLine()) != null)
			buf2.append(line2);
		bufs = buf2.toString();
		br2.close();
		is2.close();
		process1.destroy();
		if (print)
			System.out.println("bufs:" + bufs);
	} catch (Exception e) {
		e.printStackTrace(System.out);
		System.out.println(e.getMessage() + "\r\n cmd:" + commend_desc);
	}	
	return bufs;
}
%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
String time_ = CmsCache.getExpiresDateStr();  
long current = System.currentTimeMillis();
time_  = time_.replaceAll("-","/");
Date date = new Date(time_);
long ExpiresDate = date.getTime();
long diff = (ExpiresDate - current)/1000; //秒
String url = request.getRequestURL()+"";
String base = url.replace(request.getRequestURI(),"");
if(CmsCache.hasValidLicense()) diff = 1000000;


String[] ss = {"/bin/sh","-c","uptime|awk '{print $1,$3}'"};
String time = cmd1(ss,false);
String[] times = time.split(" ");
String time1 = times[0].replaceFirst(":","时");
String time2 = time1.replaceFirst(":","分");
time = times[1]+" 天"+time2+"秒";
String system_logo = CmsCache.getParameter("system_logo").getContent();
%>
<!DOCTYPE html>
<html id="blue">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../favicon.ico">
<title>大数据展示管理系统 </title>

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

<script src="../lib/2018/jquery/jquery.js"></script>
<script type="text/javascript" src="../common/2018/common2018.js"></script>
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
				
				<a href="daping_main.jsp" class="br-menu-link active menu-home">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-home tx-22"></i>
						<span class="menu-item-label">概览</span>
					</div>
					<!-- menu-item -->
				</a>				
				<a href="daping_guanli.jsp" class="br-menu-link menu-explorer">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-desktop tx-20"></i>
						<span class="menu-item-label">屏幕管理</span>
					</div>
				</a>								
				<a href="daping_dataview.jsp" class="br-menu-link menu-channel">
					<div class="br-menu-item">
						<i class="menu-item-icon fa fa-line-chart tx-22"></i>
						<span class="menu-item-label">展示数据发布管理</span>
					</div>
				</a>				
															
			</div>
			<!-- br-sideleft-menu -->
		</div>
        <!-- br-sideleft -->

		<%@include file="header.jsp"%><!--静态包含-->
		<!-- br-header -->
		<!-- ########## START: MAIN PANEL ########## -->
		<div class="br-mainpanel with-first-nav">
		
			<div class="d-flex pd-30">
			<div class="td-logo theme-bg mg-r-10"><i class="tx-white fa fa-desktop tx-36"></i></div>
			<div class="">
				<h4 class="tx-gray-800 mg-b-5">大数据展示管理系统</h4>
				<p class="mg-b-0">本系统用于构建全局多租户用户管理、接入产品的管理以及用户登录日志查看。</p>
			</div>
			
		</div>				
		
		<!-- d-flex -->
		<div class="br-pagebody mg-t-5 pd-x-30">
			<div class="row row-sm">
				<div class="col-sm-12 col-xl-12">
					<div class="theme-bg rounded overflow-hidden">
						<div class="pd-25 d-flex align-items-center">
							<i class="fa fa-clock-o tx-60 lh-0 tx-white "></i>
							<div class="mg-l-20">
								<p class="tx-10 tx-spacing-1 tx-mont tx-medium tx-uppercase tx-white-8 mg-b-10">运行时间</p>
								<p class="tx-36 tx-white tx-lato tx-bold mg-b-2 lh-1 time">
								
								</p>
								
							</div>
						</div>
					</div>
				</div>
				
			</div>
			<!-- row -->

			<div class="row row-sm mg-t-20">
				<div class="col-sm-12 col-xl-8">
					<div class="card pd-0 bd-0 shadow-base">
						<div class="pd-x-30 pd-t-30 pd-b-15">
							<div class="d-flex align-items-center justify-content-between">
								<div>
									<p class="tx-13 tx-uppercase tx-inverse tx-spacing-1 tx-18">
										<i class="fa fa-th-large theme-tx-color mg-r-5"></i>大屏幕展示方案
									</p>										
								</div>									
							</div>
						</div>
						<div class="pd-x-30 pd-b-40 pd-l-20 tide_ite">
							
						</div>
					</div>
					<!-- card -->
				</div>
				<!-- col-9 -->
				<div class="col-sm-12 col-xl-4">
				 <iframe  src="include/usehelp.html" class="height"  frameborder="0" onload="changeFrameHeight(this)" ></iframe>
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

</script>
 
    <script type="text/javascript">
    $(function()
    {
       	var url="daping_channel_list.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(res){
                 res1=res.result;
                var html = "";
                html += '<ul class="screen-case">' ;
                for(var i in res1)
                {
                       html += '<li>' +
                        '<div class="screen-tl">'+
                        '<i class="tx-grey-3 fa fa-arrows-alt"></i>'+
                       res1[i].name+
                        '</div>'+
                        '<div class="screen-num">'+
                        '屏幕数量：'+
                        '<span>'+res1[i].num+
                        '</span>'+
                        "</div>"+
                        '<a href="../content/document_preview.jsp?ItemID='+res1[i].contentid+'&ChannelID='+res1[i].id+'" class="screen-scan" target="_blank">'+
                        '浏览'+
                        '</a>'+
                        '</li>'
                        
                }
                html += '</ul>';
                var oContent = $('.tide_ite');
                oContent.html(html);
                

            }
        });
    });

</script>

 <script type="text/javascript">
    $(function()
    {
       	var url="main_data.jsp";
        $.ajax({
            type:"GET",
            url: url,
            dataType:"json",
            success: function(res){
               
               console.log(res);
                 $('.time').html(res);
              

            }
        });
    });

</script>
</body>

</html>
