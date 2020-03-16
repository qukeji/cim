<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
Cookie cookie = new Cookie("Role",userinfo_session.getRole()+"");
cookie.setMaxAge(60*60*24*365);
response.addCookie(cookie);

int Flag = getIntParameter(request,"Flag");
String Username ="";
String Username2=userinfo_session.getUsername2();
Cookie[] cookies = request.getCookies();
if(cookies!=null)
{
	for(int i=0;i<cookies.length;i++)
	{
		if(cookies[i].getName().equals("Username"))
			Username = cookies[i].getValue();	
	}
}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>音视频收录剪辑_tidemedia center</title>
<link rel="Shortcut Icon" href="favicon.ico">
<link href="style/9/tidecms.css" rel="stylesheet" />
<link href="style/tidemedia_center.css" rel="stylesheet" />
<script type="text/javascript" src="common/jquery.js"></script>
<script type="text/javascript" src="common/common.js"></script>
<script type="text/javascript" src="common/TideDialog.js"></script>
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
		$('.header_menu').attr('id','live_clip2');
		main.location="blank_chaitiao.jsp";
	}else if(str=="LiveClips"){
	    setClass(str);
		$('.header_menu').attr('id','live_clip1');
		main.location="chaitiao/main_chaitiao.jsp?type=2";
	}else if(str=="ClipsManager"){
	  setClass(str);
	  $('.header_menu').attr('id','live_clip2');
	  main.location="http://cms.tidedemo.com/vms/other/index.jsp?id=15089&Username2=<%=Username2%>&Username=<%=Username%>";
	}else if(str=="MyClips"){
	  setClass(str);
	  $('.header_menu').attr('id','live_clip2');
	  main.location="http://cms.tidedemo.com/vms/other/index2.jsp?id=15081&Username2=<%=Username2%>&Username=<%=Username%>";
	}else if(str=="EpgManage"){
	  setClass(str);
	  $('.header_menu').attr('id','live_clip2');
	  main.location="other/index.jsp?id=5696";
	}else if(str=="AutoRecod"){
	  setClass(str);
	  $('.header_menu').attr('id','live_clip2');
	  //main.location="other/index.jsp?id=17572";
	  main.location="http://cms.tidedemo.com/vms/other/index.jsp?id=15090&Username2=<%=Username2%>&Username=<%=Username%>";
	}else if(str=="SysConfig"){
	 setClass(str);
		$('.header_menu').attr('id','live_clip1');
		main.location="chaitiao/main_chaitiao.jsp?type=1";
	}else{
	setClass(str);
		var href = $("#home_"+str).attr("href");
		if(href) main.location = href;
	} 
	
}
function reSize() {
	document.getElementById("frame_main").style.height = Math.max(document.documentElement.clientHeight - 75, 0) + "px";
	//alert(document.body.clientHeight);
	document.getElementById("main").style.height = Math.max(document.documentElement.clientHeight - 75, 0) + "px";
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
        	<div class="frame_logo"><a href="main.jsp">tidemedia center</a></div><span class="frame_tool_arr">></span><div class="frame_product_name">音视频收录剪辑</div>
        </div>
        <div class="frame_tool_r">
        	<div class="frame_login_in"><%=userinfo_session.getName()%> 你好！<a href="logout.jsp">退出</a></div>
            <div class="frame_tool_set"><a href="#">设置</a></div>
        </div>
    </div>
</div>
<div class="header_menu" id="live_clip2"><!-- 拆条菜单1，颜色为深黑色；live_clip2为拆条菜单2，颜色为红色 -->
	<ul>
    	<li id="home_index"><a href="javascript:menu('index');">主页</a></li>
        <li id="home_LiveClips"><a href="javascript:menu('LiveClips');">实时剪辑</a></li>
        <li id="home_ClipsManager"><a href="javascript:menu('ClipsManager');">剪辑内容管理</a></li>
        <li id="home_MyClips"><a href="javascript:menu('MyClips');">我的剪辑内容</a></li>
        <li id="home_EpgManage"><a href="javascript:menu('EpgManage');">节目单管理</a></li>
        <li id="home_AutoRecod"><a href="javascript:menu('AutoRecod');">自动录制剪辑</a></li>
        <li id="home_SysConfig"><a href="javascript:menu('SysConfig');">系统配置</a></li>
    </ul>
</div>
<div class="frame_main" name="frame_main" id="frame_main"  frameborder="no"  border="0"><!--  name="frame_main" id="frame_main" frame_main层的高度需要js算出来，高度=浏览器高度-73px，iframe的高度也一样 -->
	<!-- iframe内容 -->
	<iframe id="main" name="main" frameborder="0" scrolling="yes" border="0" style="width:100%;" src="blank_chaitiao.jsp"></iframe>

</div>
</body>
</html>
