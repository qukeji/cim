<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		ParentID	= getIntParameter(request,"ParentID");
String Action		= getParameter(request,"Action");
Tree tree		= new Tree();

String channel_tree_string = "";

channel_tree_string = tree.listChannel_JS(userinfo_session);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/dialog.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript">
var channel_tree_id_path = getCookie("channel_path");
var node = null;

function init()
{
	
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
</head>
<body  onload="init();">
<form name="form" action="newfile.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
<tr>
    <td  valign="middle">
	<script language="javascript">
var myObject = new Object();
function show(id)
{
	if (tree.getSelected())
	{
		var name=tree.getSelected().text;
		top.TideDialogClose({suffix:'_2',recall:true,returnValue:{Name:name,ChannelID:id}});
	}
	
}

function expandParent(node)
{
	if(node.parentNode)
	{
		node.parentNode.expand();
		expandParent(node.parentNode);
	}
}

//if (document.getElementById) {
	//var tree = new WebFXTree('网站','javascript:show(-1)\" ChannelID=\"0');
	//tree.setBehavior('classic');
	<%=channel_tree_string%>
	//tree.setType('noroot');
	document.write(tree);
	//alert(tree);
	try{
	<%if(ParentID!=0 && ParentID!=-1){%>if(lsh_<%=ParentID%>)	expandParent(lsh_<%=ParentID%>);lsh_<%=ParentID%>.expand();<%}%>
	}catch(e){}
//}

function getChannelID()
{
	return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("ChannelID");
}

function getChannelType()
{
	return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("ChannelType");
}
</script>
	
	</td>
    <td valign="middle"></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>