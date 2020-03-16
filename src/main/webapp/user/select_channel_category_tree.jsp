<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
Tree tree = new Tree();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<link href="../style/9/dialog_menu.css" type="text/css" rel="stylesheet" />
<link href="../style/9/contextMenu.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script language=javascript>
function init()
{
}
</script>

<body>
<div class="dialog_menu_top"><div class="left"></div><div class="right"></div></div>
<div class="dialog_menu_main" id="div1">
<script language="javascript">
function show(id)
{
	if (tree.getSelected()) 
	{ 
		var myObject = new Object();
	    myObject.Name = tree.getSelected().text;
		myObject.ChannelID = id;
		myObject.ChannelType = getChannelType();
	   // window.returnValue=myObject;
	   // window.close();
		parent.addChannel2(myObject);
	}
}

function show1(str)
{
	window.returnValue = str;
	window.close();
}

function getChannelType()
{
	return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("ChannelType");
}

function doExpandXmlNodeByCookie()
{
}
//function init()
//{
if (document.getElementById) {
	var tree = new WebFXTree('网站首页','javascript:show(-1)\" ChannelID=\"0');
	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);
<%=tree.listChannel_JS(userinfo_session)%>
	document.write(tree);
//alert(tree);
}
//}
</script>
</div>
<div class="dialog_menu_bottom"><div class="left"></div><div class="right"></div></div>
</body>
</html>