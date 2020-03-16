<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.util.Date,
				tidemedia.cms.user.*"%>
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
	int id = getIntParameter(request,"id");
	String loc = "";
	String active_style="";
	String active_style2="system-menu";
	String active_li="";
	 if(id==1){
		loc = "operate_log2018.jsp";
		active_style="menu-log";
		active_style2="system-manager-menu";
		active_li="system-menu-operate";
		
	}else if(id==2){
		loc = "login_log2018.jsp";
	    active_style="menu-log";
		active_style2="system-manager-menu";
		active_li="system-menu-login";
	}else if(id==3){
		loc = "error_log2018.jsp";
		active_style="menu-log";
		active_style2="system-manager-menu";
		active_li="system-menu-error";

	}else if(id==4){
		loc = "system_log2018.jsp";
		active_style="menu-log";
		active_style2="system-manager-menu";
		active_li="system-menu-system";
    }
%>

<!DOCTYPE html>
<html id="green">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<link rel="Shortcut Icon" href="../<%=ico%>">
	<title><%=title_%></title>

	<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
	<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
	<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
	<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
	<link href="../lib/2018/rickshaw/rickshaw.min.css" rel="stylesheet">
	<link rel="stylesheet" href="../style/2018/bracket.css">
	<link rel="stylesheet" href="../style/2018/common.css">
	<link rel="stylesheet" href="../style/2018/theme.css">

	<script src="../lib/2018/jquery/jquery.js"></script>
	<script src="../common/2018/common2018.js"></script>
	<script src="../common/2018/TideDialog2018.js"></script>

	<script language=javascript>
		function init()
		{
			window.status="当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
//	window.onresize=reSize;
//	reSize();

			/*	if (jQuery.browser.msie) {
                    var version=parseInt(jQuery.browser.version);
                    if(version==6){
                        alert("你当前使用的浏览器是IE6,请升级你的浏览器!");
                    }
                }*/

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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init();" id="" scroll="no" class="">

<div class="br-logo">
	<a class="d-flex align-items-center tx-center ht-100p wd-100p"  href="<%=base%>/tcenter/main.jsp">
		<img class="ht-100p" src="../img/2019/<%=system_logo%>">
	</a>
</div>
<%@include file="../operate/include/tree.jsp"%><!--静态包含-->

<%@include file="../operate/include/header.jsp"%><!--静态包含-->

<!-- ########## START: MAIN PANEL ########## -->
<div class="br-mainpanel with-first-nav">
	<iframe src="<%=loc%>" style="width: 100%;height: 100%;" id="content_frame" frameborder="0" onload="changeFrameHeight(this)"></iframe>
</div><!-- br-mainpanel -->

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../lib/2018/popper.js/popper.js"></script>
<script src="../lib/2018/bootstrap/bootstrap.js"></script>
<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
<script src="../lib/2018/moment/moment.js"></script>
<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>
<script src="../common/2018/bracket.js"></script>

<script>
	var id = <%=id%> ;
	$(function(){
//			$("#system-menu").css("display","block");

		$(".<%=active_style%>").addClass("active");
		$("#<%=active_style2%>").addClass("active");
		$("#<%=active_li%>").addClass("active");
		$("#<%=active_style2%>").css("display","block");
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
					$("#<%=active_style2%>").css("display","block");
				} else {
					$('body').removeClass('expand-menu');

					// hide current shown menu
					$('.show-sub + .br-menu-sub').slideUp();

					var menuText = $('.menu-item-label,.menu-item-arrow');
					menuText.addClass('op-lg-0-force');
					menuText.addClass('d-lg-none');

					$("#<%=active_style2%>").css("display","none");
				}
			}
		});
	});

	function show(id){

		$(".nav-link").removeClass("active");
		$(".system-menu"+id).addClass("active");

		var loc = "";
		 if(id==1)
            loc = "operate_log2018.jsp";
        else if(id==2)
            loc = "login_log2018.jsp";
        else if(id==3)
            loc = "error_log2018.jsp";
        else if(id==4)
            loc = "system_log2018.jsp";
		changeFrameSrc( window.frames["content_frame"] , loc )

	}

	$(function(){
		'use strict'

		$(window).resize(function(){
			minimizeMenu();
		});

		minimizeMenu();

		function minimizeMenu() {
			if(window.matchMedia('(min-width: 992px)').matches && window.matchMedia('(max-width: 1299px)').matches) {
				// show only the icons and hide left menu label by default
				$('.menu-item-label,.menu-item-arrow').addClass('op-lg-0-force d-lg-none');
				$('body').addClass('collapsed-menu');
				$('.show-sub + .br-menu-sub').slideUp();
			} else if(window.matchMedia('(min-width: 1300px)').matches && !$('body').hasClass('collapsed-menu')) {
				$('.menu-item-label,.menu-item-arrow').removeClass('op-lg-0-force d-lg-none');
				$('body').removeClass('collapsed-menu');
				$('.show-sub + .br-menu-sub').slideDown();
				$("#system-menu").show();
			}
		}
	});
</script>
</body>
</html>
