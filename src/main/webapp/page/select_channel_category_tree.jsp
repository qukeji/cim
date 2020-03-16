<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

Tree tree = new Tree();
%>
<html>

<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/ContextMenu.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>

var myObject = new Object();
var channel_tree_id_path = getCookie("channel_path");  //alert(channel_tree_id_path);
var node = null;

function init()
{
	ContextMenu.intializeContextMenu();
	if(channel_tree_id_path)
	{
		node = tree;
		var array = channel_tree_id_path.split(",");
		doExpandByCookie();
	}
}

function contextForBody(obj)
{
	if (tree.getSelected())
	{
		var channel_tree_id_path = getNodePath("",tree.getSelected());
		document.cookie = "channel_path=" + channel_tree_id_path;
	}
	else
		return false;

   var eobj,popupoptions
   popupoptions = [
						new ContextItem("新建频道",function(){newChannel();}),
						new ContextSeperator(),
   						new ContextItem("刷新",function(){window.location.reload();})
   				  ]
   ContextMenu.display(popupoptions);
   return false;
}

function newChannel()
{
    myObject.title = "新建频道";
	myObject.Type = 0;
	if (tree.getSelected()) 
		{ 
		myObject.ChannelID = document.getElementById(tree.getSelected().id + '-anchor').ChannelID;
		myObject.Type = document.getElementById(tree.getSelected().id + '-anchor').ChannelType;
		myObject.ChannelName = tree.getSelected().text;
	}else{
		myObject.ChannelID = 0;
		myObject.ChannelName = "网站首页";
	}
 	var Feature = "dialogWidth:20em; dialogHeight:15em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=channel/channel_add.jsp&Source=Page",myObject,Feature);
	if(retu!=null)
	{
		var o = new Object();
	    o.Name = retu.Name;
		o.ChannelID = retu.ChannelID;
	    window.returnValue=o;
	    window.close();
		//window.location.href="select_channel_category_tree.jsp?ParentID=" + myObject.ChannelID;
	}
}

function doExpandByCookie()
{//alert(channel_tree_id_path + ":" + node.src);
	if(!channel_tree_id_path || channel_tree_id_path=="") return;
	var array = channel_tree_id_path.split(",");
	for(var i = 0; i < array.length; i++)
	{//alert(node.text + ":" + node.src+":"+array.length);
		var id = array[i];

		if(id=="0" || id=="") return;

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
		if(document.getElementById(node.childNodes[i].id+"-anchor").ChannelID==id)
			return node.childNodes[i];
	}
	return null;
}
</script>

<body topmargin="0" leftmargin="0" onload="init();" oncontextmenu="contextForBody(this)">
<div style="position: absolute; top: 0px; left: 0px; height: 100%; padding: 5px; overflow: no;">
<script language="javascript">
function show(id)
{
	if (tree.getSelected()) 
	{ 
		var myObject = new Object();
	    myObject.Name = tree.getSelected().text;
		myObject.ChannelID = id;

//alert(window.event);
		//window.event.cancelBubble=true;

/*
try{
		top.TideDialogClose({suffix:'_2',recall:true,returnValue:{ChannelID:id}});
}catch(e){}
		return false;
	}*/
}

function show1(str)
{
	window.returnValue = str;
	window.close();
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

</body>
</html>
