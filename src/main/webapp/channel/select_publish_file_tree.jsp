<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

Tree tree = new Tree();
%>
<html>

<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script language=javascript>
function init()
{
}
</script>

<body topmargin="0" leftmargin="0" onload="init();" >
<div style="position: absolute; top: 0px; left: 0px; height: 100%; padding: 5px; overflow: no;">
<script language="javascript">
function show(obj)
{
	if (tree.getSelected()) 
	{ 
		//alert(tree.getSelected().text);
		//"<!--#Include virtual=\"" + retu + "\" -->";
	   window.returnValue="<!--#Include virtual=\"" + tree.getSelected().text + "\" -->";
	   window.close();
	}
}

function show1(str)
{
	window.returnValue = str;
	window.close();
}

//function init()
//{
if (document.getElementById) {
	var tree = new WebFXTree('网站首页','javascript:show(-1)\" ChannelID=\"0');
	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);
<%=tree.listChannel_Publish_Files_JS(userinfo_session)%>
	document.write(tree);
//alert(tree);
}
//}
</script>
</div>

</body>
</html>
