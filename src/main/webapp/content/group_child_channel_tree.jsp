<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Action = getParameter(request,"Action");
int		FieldID		=	getIntParameter(request,"FieldID");
int		ChannelID	=	getIntParameter(request,"ChannelID");

Tree tree = new Tree();

String channel_tree_string = "";


if(FieldID>0)
	channel_tree_string = tree.listTreeByGroupChildField(userinfo_session,FieldID);
%>
<html>

<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/xtree_drag.js"></script>
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
	if (tree.getSelected())
	{
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		var channel_tree_id_path = getNodePath("",tree.getSelected()) + id;
		//document.cookie = "content_path=" + channel_tree_id_path;//alert(document.cookie);
	//}catch(e){}
	}
	if(parent.parent.frames["main"])
	{
		parent.parent.frames["main"].location = "group_content.jsp?id=" + id;
	}
}

//function init()
//{
if (document.getElementById) {
//	var tree = new WebFXTree('网站首页','javascript:show(-1)\" ChannelID=\"0');
//	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);
<%=channel_tree_string%>
	tree.setType('noroot');
	document.write(tree);
}
//}


</script>
</div>
<iframe id="CopyDocuments" style="width: 0; height: 0;" src="about:blank"></iframe>
</body>
</html>
