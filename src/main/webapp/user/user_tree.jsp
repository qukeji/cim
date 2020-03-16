<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
*	修改人	修改时间	备注
*	金毅鹏  20130609    修改显示全部用户功能(if(id==0){id=-1})
*/

if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");

UserGroup group = new UserGroup();

String tree_string = "";

tree_string = group.listGroup_JS(userinfo_session);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
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
<script type="text/javascript">
function getCheckbox(){
	var obj={length:500,id:'id'};
	return obj;
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script language="javascript">

function init()
{
<%if(Action.equals("Delete")){%>
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = "user_list.jsp";
	}
<%}%>

}
</script>
</head>

<body  onload="init();">
<div class="menu_top">
<div class="menu_top_main"><div class="left"></div><div class="right"></div></div>
</div>
<div class="menu_main" id="div1">
<script language="javascript">
function show(id)
{   
	if(id==0){
		id=-1;
	}
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = "user_list.jsp?GroupID=" + id;
	}
}
if (document.getElementById) {
	var tree = new WebFXTree('用户组','javascript:show(-1)\" ChannelID=\"0');
	tree.setBehavior('classic');
<%=tree_string%>
	document.write(tree);
}

function newGroup()
{
	if (tree.getSelected()) 
		{ 
		GroupID = document.getElementById(tree.getSelected().id + '-anchor').getAttribute("GroupID");
	}else{
		GroupID = 0;
	}

	 var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(200);
		dialog.setUrl("user/group_add.jsp?GroupID="+GroupID);
		dialog.setTitle("新建用户组");
		dialog.show();
}

function deleteGroup()
{
	if (tree.getSelected()) 
		{ 
		var GroupID = document.getElementById(tree.getSelected().id + '-anchor').getAttribute("GroupID");
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
		GroupID = document.getElementById(tree.getSelected().id + '-anchor').getAttribute("GroupID");
	}else{
		GroupID = 0;
	}

	 var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(200);
		dialog.setUrl("user/group_edit.jsp?GroupID="+GroupID);
		dialog.setTitle("编辑用户组");
		dialog.show();
}

function Order(action)
{
	if (tree.getSelected()) 
		{ 
		var GroupID = document.getElementById(tree.getSelected().id + '-anchor').GroupID;
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
</div>
<div class="menu_bottom"><div class="left"></div><div class="right"></div></div>
<script type="text/javascript">
jQuery(document).ready(function(){
var beforeShowFunc = function() {}
var menu = [
  {'<img src="../images/inner_menu_edit.gif" title="新建"/>新建':function(menuItem,menu){newGroup();}},
  {'<img src="../images/inner_menu_edit.gif" title="编辑"/>编辑':function(menuItem,menu) {editGroup();}},
  {'<img src="../images/inner_menu_edit.gif" title="排序上升"/>排序上升':function(menuItem,menu) {Order(1);}},
  {'<img src="../images/inner_menu_edit.gif" title="排序下降"/>排序下降':function(menuItem,menu) {Order(0);}},
  {'<img src="../images/inner_menu_cache.gif" title="刷新"/>刷新':function(menuItem,menu) {window.location.reload();}},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteGroup();}}
];
 jQuery('body').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
</script>
</body>
</html>