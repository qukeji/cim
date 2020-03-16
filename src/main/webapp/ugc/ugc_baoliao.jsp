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
    //爆料内容管理
%>

<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
int childGroup =  getIntParameter(request,"childGroup");
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
String dir="daping";
int childChannel = 16175 ;
%>
<!DOCTYPE html>

<html id="ugcManage">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="robots" content="noindex, nofollow">
    <link rel="Shortcut Icon" href="../favicon.ico">
    <title>UGC内容管理系统</title>

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
    <script language=javascript>

var dir = "<%=dir%>";

function init()
{	
	window.status="当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
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
		tidecms.dialog("./system/license_notify.jsp",500,300,"许可证到期提醒",2);
	<%}%>
}

function reSize() {
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - document.getElementById("main").offsetTop, 0) + "px";
}
function set_main_class(str){
	jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+str).addClass('on');
}
 

function feed()
{
	title='反馈'
	url="http://123.125.148.3:888/cms/feedback.jsp";
	var	dialog = new top.TideDialog();
		dialog.setWidth(500);
		dialog.setHeight(500);
		dialog.setUrl(url);
		dialog.setTitle(title);
		dialog.show();
};
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

        <a href="ugc_main.jsp" class="br-menu-link   menu-home">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-home tx-22"></i>
                <span class="menu-item-label">概览</span>
            </div>
            <!-- menu-item -->
        </a>
        <a href="Index2018.jsp" class="br-menu-link  menu-explorer">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-users tx-20"></i>
                <span class="menu-item-label">社区内容管理</span>
            </div>
        </a>
        <a href="ugc_pingjia.jsp" class="br-menu-link  menu-channel">
            <div class="br-menu-item">
                <i class="menu-item-icon fa  fa-comment-o tx-22"></i>
                <span class="menu-item-label">评价内容管理</span>
            </div>
        </a>
        <!-- br-menu-link -->
         <a href="ugc_baoliao.jsp" class="br-menu-link active menu-source">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-camera tx-20"></i>
                <span class="menu-item-label">爆料内容管理</span>
            </div>
            <!-- menu-item -->
        </a>	
         <a href="ugc_yijian.jsp" class="br-menu-link  menu-source">
            <div class="br-menu-item">
                <i class="menu-item-icon fa fa-file-text tx-20"></i>
                <span class="menu-item-label">意见反馈管理</span>
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
        <div class="hidden-md-down system-name"><a href="javascript:;"><i class=""></i>内容汇聚发布</a></div>
    </div>
    <!-- br-header-left -->
    <div class="br-header-right">
        <nav class="nav">
            <%@include file="header.jsp"%><!--静态包含-->
            <!-- dropdown -->
        </nav>
    </div>
    <!-- br-header-right -->
</div>
<!-- br-header -->
<!-- ########## START: MAIN PANEL ########## -->
<div class="br-mainpanel with-first-nav">
     <iframe src="../content/content2018.jsp?id=16019" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
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


        new Morris.Line({
            element: 'chindex1',
            data: [
                { y: '2006', a: 20, b: 10, c: 40 },
                { y: '2007', a: 30, b: 15, c: 45 },
                { y: '2008', a: 50, b: 40, c: 65 },
                { y: '2009', a: 40, b: 25, c: 55 },
                { y: '2010', a: 30, b: 15, c: 45 },
                { y: '2011', a: 45, b: 20, c: 65 },
                { y: '2012', a: 60, b: 40, c: 70 }
            ],
            xkey: 'y',
            ykeys: ['a', 'b', 'c'],
            labels: ['Series A', 'Series B', 'Series C'],
            lineColors: ['#14A0C1', '#5058AB', '#72DF00'],
            lineWidth: 1,
            ymax: 'auto 100',
            gridTextSize: 11,
            hideHover: 'auto',
            resize: true
        });



    });


</script>
</body>

</html>
