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
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta name="robots" content="noindex, nofollow">
<link rel="Shortcut Icon" href="<%=ico%>">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>大屏管理 <%=CmsCache.getCompany()%></title>
<link href="../style/9/tidecms.css" rel="stylesheet" />
<link href="../style/tidemedia_center.css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/TideDialog.js"></script>
<script language=javascript>
function init()
{	
	window.status="当前用户：<%=userinfo_session.getName()%>  角色：<%=userinfo_session.getRoleName()%>";
	window.onresize=reSize;
	reSize();
	<%if(Flag==0){%>
	//var myhome = getCookie("myhome");
	//if(myhome!=null && myhome!="" && document.getElementById("home_"+myhome))
	//	menu(myhome);
	<%}%>

	if (jQuery.browser.msie) {
		var version=parseInt(jQuery.browser.version);
		if(version==6){
			alert("你当前使用的浏览器是IE6,请升级你的浏览器!");
		}
	}
	setClass("index");
	<%if(diff<10*24*3600){%>
		tidecms.dialog("./system/license_notify.jsp",500,300,"许可证到期提醒",2);
	<%}%>
}

function reSize() {
	document.getElementById("main").style.height = Math.max(document.body.clientHeight - document.getElementById("main").offsetTop, 0) + "px";
	//alert(document.body.clientHeight);
	//alert(document.getElementById("main").offsetTop);
	//document.getElementById("t_menu").style.display = "";
}

function menu(str){
	var expires = new Date();
	expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
	document.cookie = "myhome=" + str + ";expires=" + expires.toGMTString();
	if(str=="index"){
		setClass(str);	 
		main.location="blank.jsp";
	}
	else if(str=="file")
	{
		setClass(str);
		main.location="explorer/index.jsp";
	}
	else if(str=="user")
	{
		setClass(str);
		main.location="index.jsp?menu=webuser";
	}
	else if(str=="manage")
	{
		setClass(str);
		main.location="index.jsp?menu=manage";
	}
	else if(str=="system"){
		setClass(str);
		main.location="system/index.jsp";
	}

	else
	{
		setClass(str);
		var href = $("#home_"+str).attr("href");
		if(href) main.location = href;
	}
}

function setClass(id){
 jQuery('.header_menu  li').removeClass('on');
	jQuery('#home_'+id).addClass('on');
 
}
</script>
<style type="text/css">
html,body {
	margin:0;
	height:100%;
}
</style>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="init();"  scroll="no">
<div class="frame">
	<div class="frame_tool">
    	<div class="frame_tool_l">
        	<div class="frame_logo"><a href="<%=base%>/tcenter/main.jsp">tidemedia center</a></div><span class="frame_tool_arr">></span><div class="frame_product_name">大屏管理系统</div>
        </div>
        <div class="frame_tool_r">
        	<div class="frame_login_in"><%=userinfo_session.getName()%> 你好！<a href="logout.jsp">退出</a></div>
            <div class="frame_tool_set"><a href="#">设置</a></div>
        </div>
    </div>
</div>
<div class="header_menu" id="sns">
	<ul>
		<li id="home_index"><a href="javascript:menu('index');">主页</a></li>
		<li id="home_user" ><a href="javascript:menu('user');">大屏管理</a></li>
    </ul>
</div>
<div class="frame_main" name="frame_main" id="frame_main"  frameborder="no"  border="0"><!--  name="frame_main" id="frame_main" frame_main层的高度需要js算出来，高度=浏览器高度-73px，iframe的高度也一样 -->
	<!-- iframe内容 -->
	<iframe id="main" name="main" frameborder="0" scrolling="no" border="0" style="width:100%;" src="blank.jsp"></iframe>


</div>
</body>
</html>
