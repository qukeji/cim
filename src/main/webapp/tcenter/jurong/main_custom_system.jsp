<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);
 
String basePath = request.getScheme()+"://"+request.getServerName();
int port = request.getServerPort();
if(port>0)
	basePath +=":"+port;
basePath +="/";

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<title>线索管理 - Tide Media Center 融合媒体业务平台</title>
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
	setClass("manage");

}
function menu(str)
{
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "myhome=" + str + ";expires=" + expires.toGMTString();
	if(str=="index"){
		setClass(str);
		main.location="blank_resource.jsp";
	}else if(str=="system"){
		set_main_class(str);
		main.location="system/index.jsp";}
	else
	{
		setClass(str);
		var href = $("#home_"+str).attr("href");
		if(href) main.location = href;
	}
}
function set_main_class(str){
	jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+str).addClass('on');
}
function reSize() {
	document.getElementById("frame_main").style.height = Math.max(document.body.clientHeight - 75, 0) + "px";
	//alert(document.body.clientHeight);
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - 75, 0) + "px";
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
        	<div class="frame_logo"><a href="<%=basePath%>tcenter/main.jsp">tidemedia center</a></div><span class="frame_tool_arr">></span><div class="frame_product_name">线索管理</div>
        </div>
        <div class="frame_tool_r">
        	<div class="frame_login_in"><%=userinfo_session.getName()%> 你好！<a href="logout.jsp">退出</a></div> 
            <div class="frame_tool_set"><a href="#">设置</a></div>
        </div>
    </div>
</div>
<div class="header_menu" id="spider">
	<ul>
        <li id="home_manage" href="custom/index_interface_system.jsp"><a href="javascript:menu('manage');">线索管理</a></li>
        
    </ul>
</div>
<div class="frame_main" name="frame_main" id="frame_main"  frameborder="no"  border="0"><!--  name="frame_main" id="frame_main" frame_main层的高度需要js算出来，高度=浏览器高度-73px，iframe的高度也一样 -->
	<!-- iframe内容 -->
	<iframe id="main" name="main" frameborder="0" scrolling="no" border="0" style="width:100%;" src="./custom/index_interface_system.jsp"></iframe>

</div>
</body>
</html>
