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
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<link href="../style/9/contextMenu.css" type="text/css" rel="stylesheet" />
<style> 
html,body{height:100%;font-size:12px;}
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
	 parent.frames["ifm_right"].location = "select_template_list_3.jsp?GroupID=" + id;
	}
}


function newGroup()
{
	var GroupID="";
	if (tree.getSelected()){ 
		GroupID = document.getElementById(tree.getSelected().id + '-anchor').GroupID;
	}else{
		GroupID = 0;
	}
	var	dialog = new top.TideDialog();
		dialog.setWidth(330);
		dialog.setHeight(250);
		dialog.setUrl("template/group_add.jsp?GroupID="+GroupID);
		dialog.setTitle("新建组");
		dialog.show();	
}

function deleteGroup()
{
	if (tree.getSelected()) 
		{ 
		var GroupID = document.getElementById(tree.getSelected().id + '-anchor').GroupID;
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
		var	GroupID = document.getElementById(tree.getSelected().id + '-anchor').GroupID;

		var	dialog = new top.TideDialog();
		dialog.setWidth(330);
		dialog.setHeight(215);
		dialog.setUrl("template/group_edit.jsp?GroupID="+GroupID);
		dialog.setTitle("编辑组");
		dialog.show();	
	}
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
</head>
 
<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"   onload="init();">
<table width="100%" class="box-gray" border="0">
  <tr>
    <td height="99%" valign="top" id="td1">
<script language="javascript">
if (document.getElementById) {
	var tree = new WebFXTree('模板组','javascript:show(-1)\" GroupID=\"-1');
	tree.setBehavior('classic');
<%=tree_string%>
	document.write(tree);
}
</script>
    </td>
  </tr>
</table>
</body>
</html>