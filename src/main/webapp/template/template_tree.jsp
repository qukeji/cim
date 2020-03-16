<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");

TemplateGroup group = new TemplateGroup();

String tree_string = "";

tree_string = group.listGroup_JS();
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<link href="../style/9/contextMenu.css" type="text/css" rel="stylesheet" />
<style>
html{*padding:69px 0 4px;}
.menu_top{height:14px;}
.menu_main{top:14px;*top:0;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">
function getCheckbox(){
	var obj={length:500,id:'id'};
	return obj;
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script language=javascript>
var tree_id_path = getCookie("template_path");
var node = null;

function init()
{
	//tidecms.log("tree_id_path:"+tree_id_path);
	if(tree_id_path)
	{
		node = tree;
		var array = tree_id_path.split(",");
		parent.frames["ifm_right"].location = "template_list.jsp?GroupID=" + array[array.length-1];
		doExpandByCookie();
	}
}

function doExpandByCookie()
{//alert(channel_tree_id_path + ":" + node.src);
	if(!tree_id_path || tree_id_path=="") return;
	var array = tree_id_path.split(",");
	for(var i = 0; i < array.length; i++)
	{//alert(node.text + ":" + node.src+":"+array.length);
		var id = array[i];
		
		if(id==0) continue;

		if(id=="") return;

		if(node && node.src!="" && node.src!=undefined)
		{
			var s = "";
			for(j=i;j<array.length;j++)
			{
				if(j==i) 
					s = array[j];
				else
					s += "," + array[j];
			}
			tree_id_path = s;
			break;
		}
		else
		{
			node = getNodeByID(node,id);
			if(i==0&&!node) node = tree;
			//tidecms.log("node:"+node+","+id);
			if(array.length-1 != i && node) node.expand();
		}

		if(array.length-1 == i && node) 	{tree_id_path="";node.select();}
	}
}

function getNodeByID(node,id)
{//alert(channel_tree_id_path);
	if(id==0) return tree;
	if(node==null || node.childNodes==null) return null;
	for (var i = 0; i < node.childNodes.length; i++) {
		var o = $("#"+node.childNodes[i].id+"-anchor");
		//tidecms.log("getnode:"+o.attr("groupid")+","+id);
		if(o.attr("groupid")==id)
			return node.childNodes[i];
	}
	return null;
}

function show(id)
{
	if(parent.frames["ifm_right"])
	{
	 var tree_id_path = getNodePath("",tree.getSelected()) + id;
	 //tidecms.log("tree_id_path:"+tree_id_path);
	 tidecms.setCookie("template_path",tree_id_path);
	 parent.frames["ifm_right"].location = "template_list.jsp?GroupID=" + id;
	}
}

function getNodePath(path,node)
{
	//alert(path);
	var parentnode = node.parentNode;
	if(parentnode)
	{
		var thisid = document.getElementById(parentnode.id+"-anchor").getAttribute("groupid") + "," + path;//alert(thisid);
		return getNodePath(thisid,parentnode);
	}
	else
	{
		return path;
	}
}

function getGroupID()
{
	return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("GroupID");
}

function newGroup()
{
	var GroupID="";
	if (tree.getSelected()){ 
		GroupID = getGroupID();
	}else{
		GroupID = 0;
	}
	var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(180);
		dialog.setUrl("template/group_add.jsp?GroupID="+GroupID);
		dialog.setTitle("新建组");
		dialog.show();	
}

function deleteGroup()
{
	var node = tree.getSelected();
	if (node) 
		{ 
		var GroupID = getGroupID();
		var GroupName = node.text;
		if(GroupID==0)
		{
			alert("\"" + GroupName + "\"不能删除!");
			return false;
		}
		if(confirm("确实要删除\"" + GroupName + "\"吗?\r\n")) 
		{
			//清空cookie
			var node2 = null;
			if(n = node.getNext()) {node2 = n;}
			var tree_id_path = "";
			if(node2) 
			{
				var gid = document.getElementById(node2.id + '-anchor').getAttribute("GroupID");
				tree_id_path = getNodePath("",node2) + gid;
			}
			//alert(tree_id_path);
			tidecms.setCookie("template_path",tree_id_path);
			this.location = "group_delete.jsp?Action=Delete&id="+GroupID;
		}

	}else{
		return false;
	}
}

function editGroup()
{
	if (tree.getSelected()){ 
		var	GroupID = getGroupID();

		var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(220);
		dialog.setUrl("template/group_edit.jsp?GroupID="+GroupID);
		dialog.setTitle("编辑组");
		dialog.show();	
	}
}

function Order(action)
{
	if (tree.getSelected()) 
		{ 
		var GroupID = getGroupID();
		var GroupName = tree.getSelected().text;
		if(GroupID==0)
		{
			return false;
		}
		 
		var url= "template/group_order.jsp?GroupID="+GroupID;
	    var	dialog = new top.TideDialog();
		dialog.setWidth(250);
		dialog.setHeight(162);
		dialog.setUrl(url);
		dialog.setTitle("排序");
		dialog.show();

	}else{
		return false;
	}
}

</script>
</head>

<body onload="init();">
<div class="menu_top">
<div class="menu_top_main"><div class="left"></div><div class="right"></div></div>
</div>
<div class="menu_main" id="div1">
<script language="javascript">
if (document.getElementById) {
	var tree = new WebFXTree('模板组','javascript:show(-1)\" GroupID=\"-1');
	tree.setBehavior('classic');
<%=tree_string%>
	document.write(tree);
}
</script>
</div>
<div class="menu_bottom"><div class="left"></div><div class="right"></div></div>
<script type="text/javascript">
jQuery(document).ready(function(){
var beforeShowFunc = function() {}
var menu = [
  {'<img src="../images/inner_menu_edit.gif" title="新建"/>新建':function(menuItem,menu){newGroup();}},
  {'<img src="../images/inner_menu_edit.gif" title="编辑"/>编辑':function(menuItem,menu) {editGroup();}},
  {'<img src="../images/inner_menu_edit.gif" title="排序"/>排序':function(menuItem,menu) {Order();}},
  //{'<img src="../images/inner_menu_edit.gif" title="排序下降"/>排序下降':function(menuItem,menu) {Order(0);}},
  {'<img src="../images/inner_menu_cache.gif" title="刷新"/>刷新':function(menuItem,menu) {window.location.reload();}},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteGroup();}}
];
 jQuery('body').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
</script>
</body>
</html>