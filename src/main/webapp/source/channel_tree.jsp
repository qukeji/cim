<%@ page import="tidemedia.cms.system.Tree"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
String Action = getParameter(request,"Action");

Tree tree = new Tree();

String channel_tree_string = "";

channel_tree_string = tree.listSource_JS(userinfo_session);

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>

<script language=javascript>

var channel_tree_id_path = getCookie("source_channel_path");
var node = null;

function init()
{
	//ContextMenu.intializeContextMenu()
	//try{
	//alert(channel_tree_id_path);
	if(channel_tree_id_path!="")
	{
		node = tree;
		var array = channel_tree_id_path.split(",");
		parent.frames["ifm_right"].location = "../source/source_content.jsp?id=" + array[array.length-1];
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
		<div class="m_t_title"><img src="../images/source.png" />资源中心</div>
	</div>
</div>
<div class="menu_main_2012" id="div1">
<script language="javascript">
function show(id)
{
	try{
	if (tree.getSelected())
	{
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		var channel_tree_id_path = getNodePath("",tree.getSelected()) + id;
		var expires = new Date();
		expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
		document.cookie = "source_channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

	if(id<0)
		return;

	parent.frames["ifm_right"].location = "content.jsp?id=" + id;
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
		document.cookie = "source_channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

	if(id<0)
		return;

	parent.frames["ifm_right"].location = "source_content.jsp?id=" + id;
}

function getNodePath(path,node)
{
	//alert(path);
	var parentnode = node.parentNode;
	if(parentnode)
	{//alert(document.getElementById(parentnode.id+"-anchor").getAttribute("ChannelID"));
		var thisid = document.getElementById(parentnode.id+"-anchor").getAttribute("ChannelID") + "," + path;//alert(thisid);
		return getNodePath(thisid,parentnode);
	}
	else
	{
		return path;
	}
}

function show2(cata,id)
{
	try{
	if (tree.getSelected())
	{
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		var channel_tree_id_path = getNodePath("",tree.getSelected()) + id;//alert(channel_tree_id_path);
		var expires = new Date();
		expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
		document.cookie = "source_channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

	parent.frames["ifm_right"].location = "../vodone/spider_list.jsp?cata=" + cata;
}

//function init()
//{
if (document.getElementById) {
//	var tree = new WebFXTree('网站首页','javascript:show(-1)\" ChannelID=\"0');
//	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);
<%=channel_tree_string%>
	var e = new WebFXTreeItem('我的采集','javascript:show(-2);\" ChannelID=-2 ChannelType=\"0','','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png');
<%/*tidemedia.cms.vodone.VodoneUserInfo vu = new tidemedia.cms.vodone.VodoneUserInfo(userinfo_session.getId());
String[] s = tidemedia.cms.util.Util.StringToArray(vu.getSpiderCata(),"}");
for(int i = 0;i<s.length;i++)
	{
		String s1 = s[i];
		//out.println("****"+s1+"*****");
		String[] ss = tidemedia.cms.util.Util.StringToArray(s1,"(");
		if(ss.length==2)
		{
			//System.out.println("****"+ss[0]+"*****"+ss[1]);
			String ss1 = "";
			if(ss[0].length()>1) ss1 = ss[0].substring((i>0?2:1),ss[0].length()-1);
			String ss2 = "";
			if(ss[1].length()>2) ss2 = ss[1].substring(0,ss[1].length()-2);
			int nid = 50001+i;
%>e.add(new WebFXTreeItem('<%=ss1%>','javascript:show2(\'<%=ss2%>\',<%=nid%>);\" ChannelID=<%=nid%> ChannelType=\"0','','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png'));<%
		}
	}
*/
%>
	tree.add(e);
	document.write(tree);
}
//}

</script>
</div>
<div style="display:none"><iframe id="CopyDocuments" style="display:none;width: 0; height: 0;" src="about:blank"></iframe></div>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
