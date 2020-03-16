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
<title>系统管理_tidemedia center</title>
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
<script type="text/javascript" src="common/TideDialog.js"></script>
<script type="text/javascript" src="common/jquery.tablesorter.js"></script>


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
	 
		main.location="blank_system.jsp";
	}else if(str=="userrole"){
	    setClass(str);
		main.location="other/index.jsp?id=17561";
		//main.location="main.jsp";
	}else if(str=="status"){
	  setClass(str);
      main.location="other/index.jsp?id=17562";
	 // main.location="";
	}else if(str=="log"){
	  setClass(str);
	   main.location="other/index.jsp?id=17563";
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
        	<div class="frame_logo"><a href="main.jsp">tidemedia center</a></div><span class="frame_tool_arr">></span><div class="frame_product_name">系统管理</div>
       </div>
        <div class="frame_tool_r">
        	<div class="frame_login_in"><%=userinfo_session.getName()%> 你好！<a href="logout.jsp">退出</a></div> 
            <div class="frame_tool_set"><a href="#">设置</a></div>
        </div>
    </div>
</div>
<div class="header_menu" id="system">
	<ul>
    	<li id="home_index"><a href="javascript:menu('index');">主页</a></li>
        <li id="home_userrole"><a href="javascript:menu('userrole');">用户及权限管理</a></li>
        <li id="home_status"><a href="javascript:menu('status');">产品应用状态管理</a></li>
        <li id="home_log"><a href="javascript:menu('log');">日志管理</a></li>
    </ul>
</div>
<div class="frame_main" name="frame_main" id="frame_main"  frameborder="no"  border="0"><!--  name="frame_main" id="frame_main" frame_main层的高度需要js算出来，高度=浏览器高度-73px，iframe的高度也一样 -->
	<!-- iframe内容 -->
	<iframe id="main" name="main" frameborder="0" scrolling="no" border="0" style="width:100%;" src="blank_system.jsp"></iframe>

</div>
</body>
</html>
