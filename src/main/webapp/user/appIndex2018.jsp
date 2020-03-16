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
    int count = ReportUtil2.getEsNum(0,0,userinfo_session.getId(),false,0,"","");//tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,0,"","");//getNum(sql);
    int countAudited = ReportUtil2.getEsNum(0,0,userinfo_session.getId(),false,2,"","");//tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,2,"","");//getNum(sql);
    int countUnaudited = ReportUtil2.getEsNum(0,0,userinfo_session.getId(),false,1,"","");//tidemedia.cms.util.ESUtil.searchESDocument(0,0,false,1,"","");//getNum(sql);
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

    <script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" scroll="no">

<div class="br-logo">
	<a class="d-flex align-items-center"  href="<%=base%>/tcenter/main.jsp">
	   <img class="wd-30 ht-30 mg-l-20" src="../img/2018/tidemedia_logo.svg">
	   <span class="tx-16-force tx-bold-force tx-black-foce">Tcenter 20</span>
	</a>
</div>

<div class="br-sideleft overflow-y-auto">
    	<%@include file="user_tree.jsp"%><!--静态包含-->
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
     <iframe src="content2018.jsp?id=14263" id="content_frame" style="width: 100%;height: 100%;"  frameborder="0" onload="changeFrameHeight(this)"></iframe>
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
