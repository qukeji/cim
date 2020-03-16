<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.base.*,
                tidemedia.cms.util.*,
                tidemedia.cms.user.*,
                java.util.Date,
                java.text.DecimalFormat,
                java.text.SimpleDateFormat,
                java.util.*,
                java.sql.*,
                org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
    cookie.setMaxAge(60*60*24*365);
    response.addCookie(cookie);

    int Flag = getIntParameter(request,"Flag");
    String time = CmsCache.getExpiresDateStr();
    int userId = userinfo_session.getId();
    long current = System.currentTimeMillis();
    time  = time.replaceAll("-","/");
    Date date = new Date(time);
    long ExpiresDate = date.getTime();
    long diff = (ExpiresDate - current)/1000; //秒
    String url = request.getRequestURL()+"";
    String base = url.replace(request.getRequestURI(),"");
    if(CmsCache.hasValidLicense()) diff = 1000000;
    String system_logo = CmsCache.getParameter("system_logo").getContent();
    int   userinfo_sessionid=userinfo_session.getId();
    TideJson  tidejson = CmsCache.getParameter("personal_workbench").getJson();
    JSONArray jsonarr = tidejson.getJSONArray("urlarr");
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

    <link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
    <link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
    <link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
    <link href="../lib/2018/highlightjs/github.css" rel="stylesheet">
    <link rel="stylesheet" href="../style/2018/bracket.css">
    <link rel="stylesheet" href="../style/2018/common.css">
    <!-- workstate -->
    <link rel="stylesheet" href="../style/2018/workstate.css">
    <script type="text/javascript" src="../lib/2018/jquery/jquery.js"></script>
    <script type="text/javascript" src="../common/2018/common2018.js"></script>
    <script type="text/javascript" src="../common/2018/content.js"></script>
	
    <script>
        var  jsonarr = <%=jsonarr%>;
        var  userinfo_sessionid=<%=userinfo_sessionid%>;
        var  listType="";
    </script>

    <script language=javascript>
        function init() {
            window.status = "当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
            set_main_class("index");
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
   
</head>
<body onLoad="init();" class="collapsed-menu email" id="js-source">

<!-- ########## START: MAIN PANEL ########## -->
<div class="br-mainpanel with-first-nav pd-b-30 mg-l-0-force mg-t-0-force">
    <div class="pd-t-20 pd-x-30 pd-media pd-b-5">
        <h4 class="tx-gray-800 mg-b-15 tx-20">常用工具</h4>
        <div class="usual-tool-box">
            <ul class="tool">
                
            </ul>
        </div>
    </div>
    <!-- d-flex -->
    <div class="br-pagebody mg-t-5 pd-x-30">
        
    </div>
</div>
<!-- br-mainpanel -->
<!-- ########## END: MAIN PANEL ########## -->

<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../lib/2018/peity/jquery.peity.js"></script>
<!-- flot.js -->
<!-- <script src="../lib/2018/Flot/jquery.flot.js"></script>
<script src="../lib/2018/Flot/jquery.flot.pie.js"></script>
<script src="../lib/2018/Flot/jquery.flot.resize.js"></script> -->
<script src="../lib/2018/chart.js/Chart.js"></script>

<script src="../lib/2018/highlightjs/highlight.pack.js"></script>
<script src="../common/2018/TideDialog2018.js"></script>
<script src="../common/2018/bracket.js"></script>
<!-- workstate -->
<script>
    var usualToolUrl = "tool.jsp" ;  //常用工具接口
    var baseUrl = "<%=base%>" ;
    var aiticleUrl = "myarticles_info.jsp"; //我的稿件接口
    var xuantiUrl = "mytask_info.jsp"; //我的稿件接口
    var videoUrl = "../vms/video/myvideo/myshiping_info.jsp"; //我的视频接口
    //var shenheUrl = "work/MyApproveDocument.jsp?Action=0"; //审核接口
    var shenheUrl = "my_approve.jsp"; //审核接口
    var xiansuoUrl = "../collect/getitems.jsp?type=0&pagesize=15"; //线索接口
    var userId = <%=userId%>;
</script>
<script src="../common/2018/workstate.js"></script>
<script>

    $(function() {
        'use strict'
        $('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
    
        $(document).on('mouseover', function(e){
          e.stopPropagation();
          if($('body').hasClass('collapsed-menu')) {
            var targ = $(e.target).closest('.br-sideleft').length;
            if(targ) {
              $('body').addClass('expand-menu');
              // show current shown sub menu that was hidden from collapsed
              $('.show-sub + .br-menu-sub').slideDown();
              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.removeClass('d-lg-none');
              menuText.removeClass('op-lg-0-force');
              menuText.css({
                  "display":"block",
                  "opacity":"1"
              })
            } else {
              $('body').removeClass('expand-menu');
              // hide current shown menu
              $('.show-sub + .br-menu-sub').slideUp();
              var menuText = $('.menu-item-label,.menu-item-arrow');
              menuText.addClass('op-lg-0-force');
              menuText.addClass('d-lg-none');
            }
          }
        });
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
    })

</script>

</body>

</html>
