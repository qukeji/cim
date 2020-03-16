<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//type=2 选择视频编码视频
int		type	= getIntParameter(request,"type");
int     srcflag = getIntParameter(request,"flag");
String left="./editor_photo_select_left.jsp?flag="+srcflag+"&type="+type;
String right="./editor_photo_select_right.jsp?flag="+srcflag+"&type="+type;
//修改插入图片集功能 2013/7/17   张赫东
//String video_url = CmsCache.getParameterValue("video_url");
//Document doc = CmsCache.getDocument(GlobalID);
//String js = doc.getFullHref("js");
//out.println("doc:"+doc);
//out.println("js:"+js);

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<style>
html,body{height:100%;}
</style>
<link href="../style/menu.css" type="text/css" rel="stylesheet" />


<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/index.js"></script>
<script> 
	function toggle_left(){
		$("#leftTd").toggle();
	}

	function getRadio()
	{
		var id_ = window.frames["right"].getRadio();
		return id_;
	}
	function getCheckbox_()
	{
		var obj = window.frames["right"].getCheckbox();
	
		return obj;
	}
</script>
</head>
<body>

    <div class="column_nav" id="leftTd" style="width:134px"> 
    <iframe frameborder="0" src="<%=left%>" style="width:100%;height:100%;" name="left" id="left"></iframe></div>
<div class="column_toggle" id="centerTd" style="left:134px;">
<div id="div001"><a  id="split" style="cursor:e-resize" class="menu_resize"></a><a class="menu_chick" onclick="toggle_left();"></a><a  id="split2" class="menu_resize"></a></div></div>
<div class="column_viewer" id="rightTd" style="left:148px;"><iframe frameborder="0"   style="width:100%;height:100%;" name="right" id="right"></iframe></div>

</body>
</html>