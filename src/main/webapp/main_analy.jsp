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
<title>访问数据统计服务_tidemedia center</title>
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
	if(str=="index")
	{
		setClass(str);
		main.location="blank_analy.jsp";
	}
	else
	{
		setClass(str);
		var href = $("#home_"+str).attr("href");
		if(href) main.location = href;
	}
}


function reSize()
{
	document.getElementById("frame_main").style.height = Math.max(document.body.clientHeight - 75, 0) + "px";
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - 75, 0) + "px";
}
function setClass(id)
{
	jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+id).addClass('on');
 
}
</script>

<body onLoad="init();">
<div class="frame">
	<div class="frame_tool">
    	<div class="frame_tool_l">
        	<div class="frame_logo"><a href="main.jsp">tidemedia center</a></div><span class="frame_tool_arr">></span><div class="frame_product_name">访问数据统计服务</div>
        </div>
        <div class="frame_tool_r">
        	<div class="frame_login_in"><%=userinfo_session.getName()%> 你好！<a href="logout.jsp">退出</a></div> 
            <div class="frame_tool_set"><a href="#">设置</a></div>
        </div>
    </div>
</div>
<div class="header_menu" id="analy">
	<ul>
	    <li id="home_index"><a href="javascript:menu('index');">主页</a></li>
	    <li id="home_web_analy" href="analy/analy_web_index.jsp"><a href="javascript:menu('web_analy');">网站统计</a></li>
		<li id="home_video_analy" href="analy/analy_video_index.jsp"><a href="javascript:menu('video_analy');">视频统计</a></li>
    	<li id="home_live_analy" href="analy/analy_live_index.jsp"><a href="javascript:menu('live_analy');">直播统计</a></li>
        <li id="home_app_analy" href="analy/analy_app_index.jsp"><a href="javascript:menu('app_analy');">APP统计</a></li>
		<li id="home_ad_analy" href="analy/analy_ad_index.jsp"><a href="javascript:menu('ad_analy');">广告统计</a></li>
        <li id="home_sys_statistic" href="analy/analy_system_index.jsp"><a href="javascript:menu('sys_statistic');">系统统计</a></li> 
		<li id="home_work_statistic" href="analy/analy_work_index.jsp"><a href="javascript:menu('work_statistic');">工作量统计</a></li>
        <li id="home_sys_config" href="other/index.jsp?id=17564"><a href="javascript:menu('sys_config');">系统配置</a></li>
    </ul>
</div>
<div class="frame_main" name="frame_main" id="frame_main"  frameborder="no"  border="0"><!-- frame_main层的高度需要js算出来，高度=浏览器高度-73px，iframe的高度也一样 -->
	<!-- iframe内容 -->
	<iframe id="main" name="main" frameborder="0" scrolling="no" border="0" style="width:100%;" src="blank_analy.jsp"></iframe>
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
