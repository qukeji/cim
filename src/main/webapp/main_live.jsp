<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);
 
%>

<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>音视频直播管理与发布_tidemedia center</title>
<link rel="Shortcut Icon" href="favicon.ico">
<link href="style/9/tidecms.css" rel="stylesheet" />
<link href="style/tidemedia_center.css" rel="stylesheet">

<style type="text/css">
html,body {
	margin:0;
	height:100%;
}
</style>
</head>

<script type="text/javascript" src="common/jquery.js"></script>
<script type="text/javascript" src="common/common.js"></script>
<script type="text/javascript" src="common/ui.core.js"></script>
<script type="text/javascript" src="common/ui.draggable.js"></script>
<script type="text/javascript" src="common/TideDialog.js"></script>

<script language=javascript>
function init()
{
	
	window.onresize=reSize;
	reSize();
	setClass("index");

}
function menu(str)
{
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "myhome=" + str + ";expires=" + expires.toGMTString();
	if(str=="index"){
		setClass(str);
		main.location="blank_live.jsp";
	}
	else
	{
		setClass(str);
		var href = $("#home_"+str).attr("href");
		if(href) main.location = href;
	}
}


function reSize() {
	document.getElementById("frame_main").style.height = Math.max(document.body.clientHeight - 75, 0) + "px";
	//alert(document.body.clientHeight);
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - 75, 0) + "px";
	//alert(document.body.clientHeight);
	//alert(document.getElementById("main").offsetTop);
	//document.getElementById("t_menu").style.display = "";
}
function setClass(id){
 jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+id).addClass('on');
 
}
</script>

<body onLoad="init();">
<div class="frame">
	<div class="frame_tool">
    	<div class="frame_tool_l">
        	<div class="frame_logo"><a href="main.jsp">tidemedia center</a></div><span class="frame_tool_arr">></span><div class="frame_product_name">音视频直播管理与发布</div>
        </div>
        <div class="frame_tool_r">
        	<div class="frame_login_in"><%=userinfo_session.getName()%> 你好！<a href="logout.jsp">退出</a></div> 
            <div class="frame_tool_set"><a href="#">设置</a></div>
        </div>
    </div>
</div>
<div class="header_menu" id="live">
	<ul>
	    <li id="home_index"><a href="javascript:menu('index');">主页</a></li>
	    <li id="home_timeshift" href="live/live_index.jsp?id=14272"><a href="javascript:menu('timeshift');">时移直播</a></li>
		<li id="home_templive" href="live/live_index.jsp?id=18093"><a href="javascript:menu('templive');">服务器管理</a></li>
    	<li id="home_broadcast" href="live/live_index.jsp?id=14276"><a href="javascript:menu('broadcast');">播控管理</a></li>
        <li id="home_virlive" href="live/live_index.jsp?id=14277"><a href="javascript:menu('virlive');">虚拟直播</a></li>
        <li id="home_epg" href="live/live_index.jsp?id=14275"><a href="javascript:menu('epg');">节目单管理</a></li> 
		<li id="home_lu" href="live/live_index.jsp?id=14274"><a href="javascript:menu('lu');">流桥管理</a></li>
        <li id="home_collect" href="live/live_index.jsp?id=14279"><a href="javascript:menu('collect');">频道管理</a></li>
        <li id="home_syscon" href="live/index.jsp?id=17564"><a href="javascript:menu('syscon');">系统配置</a></li>
    </ul>
</div>
<div class="frame_main" name="frame_main" id="frame_main"  frameborder="no"  border="0"><!-- frame_main层的高度需要js算出来，高度=浏览器高度-73px，iframe的高度也一样 -->
	<!-- iframe内容 -->
	<iframe id="main" name="main" frameborder="0" scrolling="no" border="0" style="width:100%;" src="blank_live.jsp"></iframe>
</div>

<div class="openwin tidedialog" id="TideDialog_1" style="display:none;">
	<div class="openwin_bg"></div>
	<div class="openwin_main" id="popmain">
    	<div class="openwin_nav" id="openwin_nav_id">
        	<div class="nav" id="TideDialogTitle"></div>
            <div class="close" style="background:url(images/openwin_close.png) no-repeat 0 0;"><a href="" title="关闭" id="TideDialogClose"></a></div>
        </div>
        <div class="openwin_iframe" id="popDiviframe" name="popDiviframe">
		 <iframe frameborder="0" src="about:blank" id="popiframe_1" name="popiframe_1" style="width:100%;height:100%;" scrolling="no" allowTransparency="true">
	     </div>
	</div>
</div>

</body>
</html>
