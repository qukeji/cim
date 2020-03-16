<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%><%
	int id = getIntParameter(request,"id");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<style>
html,body{height:100%;}
</style>




<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/ui.core.js"></script>
<script type="text/javascript" src="../common/ui.draggable.js"></script>
<script> 
	function toggle_left(){
		$("#leftTd").toggle();
		if($("#centerTd").css("left")!="0px")
		{
			$("#centerTd").css("left",0);
			$("#rightTd").css("left",14);
		}
		else
		{
			$("#centerTd").css("left",$("#leftTd").width());
			$("#rightTd").css("left",208-(194-$("#leftTd").width()));
		}
	}
 
 var width = "";
var left;
var pleft;

function init()
{
	var o = $('#centerTd');
	left = o.offset().left;
	var top = o.offset().top;
	width = $("#leftTd").css("width").replace("px","");
	o.draggable({ axis: 'x',cursor: 'e-resize',helper: '',
		start: function(event, ui) 
		{
		},
		drag: function(event, ui) 
		{
			var p = ui.helper.offset();
			pleft = p.left;			
			$("#leftTd").css("width",(pleft));
			$("#rightTd").css("left",208-(left-pleft));
		},
		stop: function(event, ui) 
		{
			var p = ui.helper.offset();
			pleft = p.left;
			$("#leftTd").css("width",(pleft));
			$("#rightTd").css("left",208-(left-pleft));
			//if(top)	top.body.style.cursor="auto";
		},
		iframeFix: true });
}
//截图页面用 勿删
function getUrlParam(name){
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
    var r = window.location.search.substr(1).match(reg);  //匹配目标参数
    if (r != null) return decodeURI(r[2]); return null; //返回参数值
}
function parentMethod(){
    window.location.reload();
}
</script>
</head>
<body onLoad="init()">
<!--
<div class="frame">
	<div class="frame_tool">
    	<div class="frame_tool_l">
        	<div class="frame_logo"></div><span class="frame_tool_arr">></span><div class="frame_product_name">内容汇聚发布</div>
       </div>        
        <div class="frame_tool_r">
        	<div class="frame_login_in">你好！<a href="logout.jsp">退出</a></div>
            <div class="frame_tool_set"><a href="#">设置</a></div>
        </div>

    </div>
</div> -->
<div class="column_nav" id="leftTd" style="width: 352px;"><iframe frameborder="0" src="../newspaper/index.html" style="width:100%;height:100%;" name="ifm_left" id="ifm_left"></iframe></div>
<!-- <div class="column_toggle" id="centerTd" style="left: 350px;"><div id="div001"><a id="split" class="menu_resize"></a><a class="menu_chick" onclick="toggle_left();"></a><a  id="split2" class="menu_resize"></a></div></div> -->
<div class="column_toggle" id="centerTd" style="left: 352px;"><div id="div001"></div></div>
<div class="column_viewer" id="rightTd" style="left: 358px;"><iframe frameborder="0" src="content_item.jsp?globalid=<%=id%>" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></div>

</body>
</html>
