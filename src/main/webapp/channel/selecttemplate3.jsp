<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String contextPath=request.getContextPath();
//页面管理中选择模板
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7  <%=CmsCache.getCompany()%></title>
<style> 
html,body{height:100%;}
</style>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
</head>

<body>
<table width="100%" border="0" height="100%">
  <tr height="100%">
    <td width="140" valign="top" id="left"><iframe frameborder="0" src="../template/select_template_tree_3.jsp" style="width:100%;height:100%;" name="ifm_left" id="ifm_left"></iframe></td>
    <td width="14" align="center" valign="middle"><a onmousedown="did('split')" id="split" style="cursor:e-resize"><img src="../images/menu_right.png" /></a></td>
    <td valign="top" id="right"><iframe frameborder="0" src="../template/select_template_list_3.jsp" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></td>
  </tr>
</table>
</body>
</html>