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
String loc = "my_info2018.jsp";

%>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="../<%=ico%>">
<title><%=title_%></title>

<link href="../lib/2018/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="../lib/2018/Ionicons/css/ionicons.css" rel="stylesheet">
<link href="../lib/2018/perfect-scrollbar/css/perfect-scrollbar.css" rel="stylesheet">
<link href="../lib/2018/jquery-switchbutton/jquery.switchButton.css" rel="stylesheet">
<!--<link href="../lib/2018/rickshaw/rickshaw.min.css" rel="stylesheet">-->
<link href="../lib/2018/chartist/chartist.css" rel="stylesheet">
<link rel="stylesheet" href="../style/2018/bracket.css">
<link rel="stylesheet" href="../style/2018/common.css">

<script src="../lib/2018/jquery/jquery.js"></script>
<script src="../common/2018/common2018.js"></script>

<script>
  window.onresize = function(){	
	  var _height = 0 
		if(document.getElementById("content_frame")){		
			if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){ 
				_height = document.getElementById("content_frame").contentWindow.document.body.scrollHeight;
			}else{
				_height = document.getElementById("content_frame").contentWindow.document.documentElement.scrollHeight;		
			}
			document.getElementById("content_frame").style.height = _height 
		}
	}
	//调整iframe的高度 
	function changeFrameHeight(_this){   
		if(navigator.userAgent.indexOf("MSIE")>0||navigator.userAgent.indexOf("rv:11")>0||navigator.userAgent.indexOf("Firefox")>0){     		
			_this.style.height = _this.contentWindow.document.body.scrollHeight ;				
		}else{		
			_this.style.height = _this.contentWindow.document.documentElement.scrollHeight ;				
		}
	}

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
		tidecms.dialog("./system/license_notify.jsp",400,200,"许可证到期提醒",2);
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

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init();"  scroll="no">

	<div class="br-logo"><a class="d-flex align-items-center"  href="<%=base%>/tcenter/main.jsp">
		    <img class="ht-100p" src="../img/2019/<%=system_logo%>">
		</a></div>

	<%@include file="../include/tree.jsp"%><!--静态包含-->

	<%@include file="../header.jsp"%><!--静态包含-->

    <!-- ########## START: MAIN PANEL ########## -->
    <div class="br-mainpanel with-first-nav mg-b-20">      
      <iframe src="<%=loc%>" style="width: 100%;height: 100%;" id="content_frame" scrolling="no" frameborder="0" onload="changeFrameHeight(this)"></iframe>  
	</div><!-- br-mainpanel -->
	
    <script src="../lib/2018/popper.js/popper.js"></script>
	<script src="../lib/2018/bootstrap/bootstrap.js"></script>
	<script src="../lib/2018/perfect-scrollbar/js/perfect-scrollbar.jquery.js"></script>
	<script src="../lib/2018/moment/moment.js"></script>
	<script src="../lib/2018/jquery-ui/jquery-ui.js"></script>
	<script src="../lib/2018/jquery-switchbutton/jquery.switchButton.js"></script>

	<script src="../common/2018/bracket.js"></script>
	<script src="../common/2018/ResizeSensor.js"></script>
	<script>
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
			  }
			}
       });
    </script>
</body>
</html>
