<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.text.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
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

var node = null;

function init()
{

}

function doExpandByCookie()
{//alert(channel_tree_id_path + ":" + node.text + ":" + node.src);

}

function doExpandXmlNodeByCookie()
{//alert(channel_tree_id_path + ":" + node.src);

}

function getNodeByChannelID(node,id)
{//alert(channel_tree_id_path);
	if(id==0) return tree;
	if(node==null || node.childNodes==null) return null;
	for (var i = 0; i < node.childNodes.length; i++) {
		if(document.getElementById(node.childNodes[i].id+"-anchor").getAttribute("ChannelID")==id)
			return node.childNodes[i];
	}
	return null;
}

</script>
<head>

<body onload="init();">
<div class="menu_top">
<div class="manage">
	<div class="manage_box">
		<div class="manage_boxr">
			<div class="manage_boxm">
				<div class="manage_boxm_title"><img src="../images/manage_user.gif" />评论系统</div>
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
	try{
	if (tree.getSelected())
	{
	}
	}catch(e){}

	parent.frames["ifm_right"].location = "content.jsp?id=" + id;
}


if (document.getElementById) {
	var tree = new WebFXTree('网站','javascript:show(-1)" ChannelID="0');
	tree.setBehavior('classic');
	//tree.setType('noroot');
<%
TableUtil tu = new TableUtil("comment");

String sql = "SELECT * FROM comment_channel where parentid=-1";
ResultSet rs = tu.executeQuery(sql);
while(rs.next())
{
	String name = tu.convertNull(rs.getString("name"));
	int channelid = rs.getInt("channelid");
	String s = "channel_"+channelid;
%>
var <%=s%> = new WebFXLoadTreeItem('<%=name%>','channel_xml.jsp?channelid=<%=channelid%>','javascript:show(<%=channelid%>);\" ChannelID=\"channel_<%=channelid%>','','','');
tree.add(<%=s%>);

<%
	}
tu.closeRs(rs);
%>
	document.write(tree);
	if(tree.childNodes.length==1)
		tree.childNodes[0].expand();
}
</script>
</div>
<div class="menu_bottom"><div class="left"></div><div class="right"></div></div>
<div style="display:none"><iframe id="CopyDocuments" style="display:none;width: 0; height: 0;" src="about:blank"></iframe></div>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
