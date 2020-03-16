<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);


%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<title>帮助中心_tidemedia center</title>
<link rel="Shortcut Icon" href="favicon.ico">
<link href="style/9/tidecms.css" rel="stylesheet" />
<link href="style/tidemedia_center.css" rel="stylesheet" />
<script type="text/javascript" src="common/jquery.js"></script>
<script type="text/javascript" src="common/common.js"></script>
<script type="text/javascript" src="common/TideDialog.js"></script>
<style type="text/css">
html,body {
	margin:0;
	height:100%;
}
</style>
</head>
<script language=javascript>
function init()
{
	
	window.onresize=reSize;
	reSize();
	setClass("index");

}
function menu(str){
		var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "myhome=" + str + ";expires=" + expires.toGMTString();
	if(str=="index"){
		setClass(str);	 
		main.location="blank_help.jsp";
	}else{
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
        	<div class="frame_logo"><a href="main.jsp">tidemedia center</a></div><span class="frame_tool_arr">></span><div class="frame_product_name">帮助中心</div>
        </div>
        <div class="frame_tool_r">
        	<div class="frame_login_in"><%=userinfo_session.getName()%> 你好！<a href="logout.jsp">退出</a></div>
            <div class="frame_tool_set"><a href="#">设置</a></div>
        </div>
    </div>
</div>

<div class="header_menu" id="help">
    	<ul>		
		<li id="home_index"><a href="javascript:menu('index');">主页</a></li>
        <li id="home_online" href="help/index.jsp"><a href="javascript:menu('online');">在线帮助</a></li>
        <!--<li id="home_know" href="other/index.jsp?id=17558"><a href="javascript:menu('know');">知识库</a></li>-->
        <!--<li id="home_down" href="help/doc.jsp"><a href="javascript:menu('down');">文档下载</a></li>-->
		<!--<li id="home_sys" href="other/index.jsp?id=17560"><a href="javascript:menu('sys');">系统配置</a></li>-->
        </ul>
</div>
<div class="frame_main" name="frame_main" id="frame_main"  frameborder="no"  border="0">
	<!-- iframe内容 -->
	<iframe id="main" name="main" frameborder="0" scrolling="no" border="0" style="width:100%;" src="blank_help.jsp"></iframe>


</div>

</body>
</html>