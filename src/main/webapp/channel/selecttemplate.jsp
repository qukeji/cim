<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%String contextPath=request.getContextPath();%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/index.js"></script>
<style>body{background:none;}</style>
</head>
<body>

<div class="column_nav" id="leftTd">

<iframe frameborder="0" src="../template/select_template_tree.jsp" style="width:100%;height:99%;" name="ifm_left" id="ifm_left"></iframe></div>
<div class="column_toggle" id="centerTd">
<div id="div001"><a id="split" class="menu_resize"></a><a class="menu_chick" onclick="toggle_left();"></a><a  id="split2" class="menu_resize"></a></div></div>
<div class="column_viewer" id="rightTd"><iframe frameborder="0" src="../template/select_template_list.jsp" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></div>

</body>
</html>