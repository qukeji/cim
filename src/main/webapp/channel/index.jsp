<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
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
</script>
</head>

<body onLoad="init()">
<div class="column_nav" id="leftTd"><iframe frameborder="0" src="channel_tree.jsp" style="width:100%;height:100%;" name="ifm_left" id="ifm_left"></iframe></div>
<div class="column_toggle" id="centerTd"><div id="div001"><a id="split" class="menu_resize"></a><a class="menu_chick" onclick="toggle_left();"></a><a  id="split2" class="menu_resize"></a></div></div>
<div class="column_viewer" id="rightTd"><iframe frameborder="0" src="channel.jsp" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></div>

</body>
</html>