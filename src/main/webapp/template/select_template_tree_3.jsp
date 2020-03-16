<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");
String SerialNo = getParameter(request,"SerialNo");

TemplateGroup group = new TemplateGroup();

String tree_string = "";

tree_string = group.listGroup_JS(SerialNo);

String Desc = "";
if(SerialNo.equals("page_frame_template"))
	Desc = "框架模板";
else if(SerialNo.equals("page_sub_system"))
	Desc = "子系统模板";
else
	Desc = "模块模板";

String cookie_name = "template_path";
if(SerialNo.length()>0) cookie_name = SerialNo+"_" + cookie_name;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>无标题文档</title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script language=javascript>
var cookie_name = "<%=cookie_name%>";
var tree_id_path = getCookie(cookie_name);
var node = null;

function init()
{
	if(tree_id_path)
	{
		node = tree;
		//tidecms.log("init tree_id_path:"+tree_id_path);
		var array = tree_id_path.split(",");
		parent.frames["ifm_right"].location = "select_template_list_3.jsp?SerialNo=<%=SerialNo%>&GroupID=" + array[array.length-1];
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


function getCheckbox(){
	var obj={length:500,id:'id'};
	return obj;
}

function show(id)
{
	if(parent.frames["ifm_right"])
	{
		var tree_id_path = getNodePath("",tree.getSelected()) + id;
		//tidecms.log("tree_id_path:"+tree_id_path);
		tidecms.setCookie(cookie_name,tree_id_path);
		parent.frames["ifm_right"].location = "select_template_list_3.jsp?SerialNo=<%=SerialNo%>&GroupID=" + id;
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
</script>

<style>
html{*padding:69px 0 4px;}
</style>
</head>

<body onload="init();">
<div class="menu_top">
<div class="manage">
	<div class="manage_box">
		<div class="manage_boxr">
			<div class="manage_boxm">
				<div class="manage_boxm_title"><img src="../images/manage_user.gif" /><%=Desc%></div>
			</div>
		</div>
	</div>
</div>
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
</body>
</html>