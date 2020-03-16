<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
String Action = getParameter(request,"Action");

String channel_tree_string = "";
int id = getIntParameter(request,"id");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style>
html{*padding:69px 0 4px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>


<script language=javascript>

var channel_tree_id_path = "";
var node = null;

function init()
{
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = "doc.jsp";
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

		if(array.length-1 == i && node) 	{channel_tree_id_path=""; node.select();node.parentNode.deSelect();}
		else{node.expand();}
	}
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
<div class="menu_top_2012">
	<div class="m_t_main">
		<div class="m_t_title"><img src="../images/sns.png" />当前结构</div>
	</div>
</div>
<div class="menu_main_2012" id="div1">
<script language="javascript">
function show(id)
{
	if(parent.frames["ifm_right"])
	{
		var loc = "";

		if(typeof(id) == "string")
		{
			loc = id;
		}
		else
		{
		if(id==1)
			loc = "http://tidedemo.com/help/livedemo/index.html";
		else if(id==2)
			loc = "http://tidedemo.com/help/playerdemo/index.html";
		else if(id==3)
			loc = "live_test.swf";
		else if(id==4)
			loc = "chaitiao_spec.jsp";
		else if(id==0)
			loc = "doc.jsp";
		else
			return;
		}
		parent.frames["ifm_right"].location = loc;
	}
}

function showsource(id)
{
	try{
	if (tree.getSelected())
	{
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		var channel_tree_id_path = getNodePath("",tree.getSelected()) + id;
		var expires = new Date();
		expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
		//document.cookie = "source_channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

	if(id<0)
		return;

	parent.frames["ifm_right"].location = "../source/source_content.jsp?id=" + id;
}

//function init()
//{
if (document.getElementById) {
	var tree = new WebFXTree('产品帮助','javascript:show(17563)\" ChannelID=\"0');
	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);

	tree.add(new WebFXTreeItem("产品文档","javascript:show(0)"));
	tree.add(new WebFXTreeItem("直播示例","javascript:show(1)"));
	tree.add(new WebFXTreeItem("直播工具","javascript:show(3)"));
	tree.add(new WebFXTreeItem("点播示例","javascript:show(2)"));
	tree.add(new WebFXTreeItem("拆条配置规范","javascript:show(4)"));
	document.write(tree);
	tree.expandAll();
}
//}

</script>
</div>
<div style="display:none"><iframe id="CopyDocuments" style="display:none;width: 0; height: 0;" src="about:blank"></iframe></div>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
