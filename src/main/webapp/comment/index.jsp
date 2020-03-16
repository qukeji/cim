<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(userinfo_session.getRole()==4){ response.sendRedirect("../noperm.jsp");return;}
Channel channel = new Channel();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/index.js"></script>
<script> 
	function toggle_left(){
		$("#leftTd").toggle();
	}
 
</script>
</head>
<body>
<table width="100%" border="0" height="100%">
  <tr height="100%">
    <td width="194" valign="top" id="leftTd"><iframe frameborder="0" src="channel_tree.jsp" style="width:100%;height:100%;" name="ifm_left" id="ifm_left"></iframe></td>
<td width="14" align="center" valign="middle"><a onmousedown="did('split')" id="split" style="cursor:e-resize" class="menu_resize"></a><a class="menu_chick" onclick="toggle_left();"></a><a  onmousedown="did('split2')" id="split2" class="menu_resize"></a></td>
    <td valign="top" id="rightTd"><iframe frameborder="0" src="content.jsp" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></td>
  </tr>
</table>
</body>
</html>
