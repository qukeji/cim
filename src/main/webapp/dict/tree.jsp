<%@ page import="tidemedia.cms.system.*,tidemedia.cms.dict.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");

DictGroup group = new DictGroup();

String tree_string = "";

tree_string = group.listGroup_JS();
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link href="../style/menu.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
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
function init()
{
<%if(Action.equals("Delete")){%>
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = "user_list.jsp";
	}
<%}%>

}

function show(id)
{
	if(parent.frames["ifm_right"])
	{
	 parent.frames["ifm_right"].location = "list.jsp?GroupID=" + id;
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
		dialog.setUrl("dict/group_add.jsp?GroupID="+GroupID);
		dialog.setTitle("新建组");
		dialog.show();	
}

function deleteGroup()
{
	if (tree.getSelected()) 
		{ 
		var GroupID = getGroupID();
		var GroupName = tree.getSelected().text;
		if(GroupID==0)
		{
			alert("\"" + GroupName + "\"不能删除!");
			return false;
		}
		if(confirm("确实要删除\"" + GroupName + "\"吗?\r\n")) 
		{
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
		dialog.setHeight(180);
		dialog.setUrl("dict/group_edit.jsp?GroupID="+GroupID);
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
		this.location = "group_order.jsp?Action=" + action + "&GroupID="+GroupID;

	}else{
		return false;
	}
}

</script>
</head>

<body>
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
  {'<img src="../images/inner_menu_cache.gif" title="刷新"/>刷新':function(menuItem,menu) {window.location.reload();}},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteGroup();}}
];
 jQuery('body').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
</script>
</body>
</html>