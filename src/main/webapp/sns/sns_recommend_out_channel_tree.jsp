<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
//System.out.println(ChannelID+"---");
Tree tree = new Tree();

String channel_tree_string = "";

channel_tree_string = tree.listTreeByChannelRecommendOut(userinfo_session,ChannelID);
//System.out.println("cid"+ChannelID+"  tree_String:"+channel_tree_string);
%>
<html>

<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>

<script language=javascript>

function init()
{
}
</script>

<body topmargin="0" leftmargin="0" onload="init();" >
<div style="position: absolute; top: 0px; left: 0px; height: 100%; padding: 5px; overflow: no;">
<script language="javascript">
function show(id)
{

}

function getChannelID()
{
	return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("ChannelID");
}

function getChannelType()
{
	return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("ChannelType");
}
//function init()
//{
if (document.getElementById) {
//	var tree = new WebFXTree('网站首页','javascript:show(-1)\" ChannelID=\"0');
//	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);
<%=channel_tree_string%>
	tree.setType('noroot2');
	document.write(tree);
}
//}
</script>
</div>
</body>
</html>
