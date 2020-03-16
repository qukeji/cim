<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Action = getParameter(request,"Action");
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		LinkChannelID	=	getIntParameter(request,"LinkChannelID");
int		GlobalID	=	getIntParameter(request,"GlobalID");
int		fieldgroup	=	getIntParameter(request,"fieldgroup");

Tree tree = new Tree();

String channel_tree_string = "";

channel_tree_string = tree.listChannel_JS(LinkChannelID,"tree",userinfo_session,20);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<style>
html{*padding:69px 0 4px;}
</style>
<script type="text/javascript" src="../common/xtree_drag.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>

<script language=javascript>

function init()
{
}
</script>

<body onload="init();" >
<div class="menu_top">
<div class="manage">
	<div class="manage_box">
		<div class="manage_boxr">
			<div class="manage_boxm">
				<div class="manage_boxm_title"><img src="../images/manage_user.gif" />频道结构</div>
			</div>
		</div>
	</div>
</div>
<div class="menu_top_main"><div class="left"></div><div class="right"></div></div>
</div>
<div class="menu_main" id="div1">
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
	if(id>0 && parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = "select_child_content.jsp?ChannelID=<%=ChannelID%>&LinkChannelID=<%=LinkChannelID%>&LinkChannelID2="+id+"&GlobalID=<%=GlobalID%>&fieldgroup=<%=fieldgroup%>";
	}
}

//function init()
//{
if (document.getElementById) {
	var tree = new WebFXTree('网站首页','javascript:show(-1)\" ChannelID=\"0');
	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);
<%=channel_tree_string%>
	//tree.setType('noroot');
	document.write(tree);
}
//}


</script>
</div>
<div class="menu_bottom"><div class="left"></div><div class="right"></div></div>
<div style="display:none"><iframe id="CopyDocuments" style="width: 0; height: 0;" src="about:blank"></iframe></div>
</body>
</html>
