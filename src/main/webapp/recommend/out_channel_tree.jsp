<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");

Tree tree = new Tree();

String channel_tree_string = "";

channel_tree_string = tree.listTreeByChannelRecommendOut(userinfo_session,ChannelID);
%>
<html>

<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>

<script language=javascript>
var channel_tree_id_path = getCookie("recommend_channel_path");
var node = null;
function init()
{
	if(channel_tree_id_path)
	{//alert(channel_tree_id_path);
		node = tree;
		var array = channel_tree_id_path.split(",");
		//parent.frames["ifm_right"].location = "../content/content.jsp?id=" + array[array.length-1];
		doExpandByCookie();

	}
}

function doExpandByCookie()
{//alert(channel_tree_id_path + ":" + node.text + ":" + node.src);
	if(!channel_tree_id_path || channel_tree_id_path=="") return;
	var array = channel_tree_id_path.split(",");
	for(var i = 0; i < array.length; i++)
	{//alert(node.text + ":" + node.src+":"+array.length);
		var id = array[i];
		if(node && node.src!="")
		{
			var s = "";
			for(j=i;j<array.length;j++)
			{
				if(j==i) 
					s = array[j];
				else
					s += "," + array[j];
			}
			channel_tree_id_path = s;
			break;
		}
		else
		{
			node = getNodeByChannelID(node,id);
			if(id>0 && i!=array.length-1) node.expand();
		}

		if(array.length-1 == i && node) 	{channel_tree_id_path="";node.select();}
	}
}

function doExpandXmlNodeByCookie()
{//alert(channel_tree_id_path + ":" + node.src);
	if(!channel_tree_id_path || channel_tree_id_path=="") return;
	var array = channel_tree_id_path.split(",");
	for(var i = 0; i < 1; i++)
	{//alert(i + ":" + node.src);
		var id = array[i];
		var s = "";
		for(j=1;j<array.length;j++)
		{
			if(j==1) 
				s = array[j];
			else
				s += "," + array[j];
		}
		channel_tree_id_path = s;//node.expand();//alert(node);
		node = getNodeByChannelID(node,id);
		if(array.length-1 == i && node) 	{channel_tree_id_path=""; node.select();}
		else{node.expand();}
	}
}

function getNodeByChannelID(node,id)
{//alert(channel_tree_id_path);
	if(id==0) return tree;
	if(node==null || node.childNodes==null) return null;
	for (var i = 0; i < node.childNodes.length; i++) {
		if(document.getElementById(node.childNodes[i].id+"-anchor").getAttribute("ChannelID")==id)
		{
			return node.childNodes[i];
		}
	}
	return null;
}

</script>

<body topmargin="0" leftmargin="0" onload="init();" >
<div style="position: absolute; top: 0px; left: 0px; height: 100%; padding: 5px; overflow: no;">
<script language="javascript">
function show(id)
{
		try{
	if (tree.getSelected())
	{
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		var channel_tree_id_path = getNodePath("",tree.getSelected()) + id;
		var channeltype = ($("#"+tree.getSelected().id + '-anchor').attr("ChannelType"));
		if(channeltype==5)
		{
			tree.getSelected().toggle();
		}
		var expires = new Date();
		expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
		document.cookie = "recommend_channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

}

function getSelectedChannel()
{
	var channelid = "";
	//alert($('.tree_check:checked').size());
	$('.tree_check:checked').each(function(){ 
		var id = this.value;
		id = id.replace("-checkbox", "-anchor");
		if(channelid=="")
			channelid += $("#"+id).attr("ChannelID");
		else
			channelid += ","+$("#"+id).attr("ChannelID");
		//alert(channelid);
	});
	//alert(channelid);
	return channelid;
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
	tree.setCheckbox(1);
	document.write(tree);
}
//}
</script>
</div>
</body>
</html>
