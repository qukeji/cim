<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!(new UserPerm().canManageUser(userinfo_session)))
{response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");

UserGroup group = new UserGroup();

String tree_string = "";

tree_string = group.listGroup_JS(userinfo_session);
%>
<html>

<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/ContextMenu.js"></script>
<script type="text/javascript" src="../common/ieemu.js"></script>

<script language=javascript>
function init()
{
	//ContextMenu.intializeContextMenu();
}
</script>

<body topmargin="0" leftmargin="0" onload="init();">
<div style="position: absolute; top: 0px; left: 0px; height: 100%; padding: 5px; overflow: auto;">
<script language="javascript">
function show(id)
{
	if(parent.parent.frames["main"])
	{
		parent.parent.frames["main"].location = "channel_privilege_user_list.jsp?GroupID=" + id;
	}
}

//function init()
//{
if (document.getElementById) {
	var tree = new WebFXTree('用户组','javascript:show(-1)\" ChannelID=\"0');
	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);
<%=tree_string%>
	document.write(tree);
}
//}


</script>
</div>

</body>
</html>
