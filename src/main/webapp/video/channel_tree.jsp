<%@ page import="tidemedia.cms.system.Tree"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
String Action = getParameter(request,"Action");

Tree tree = new Tree();

String channel_tree_string = "";

channel_tree_string = tree.listVideo_JS(userinfo_session);

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<style>
html{*padding:69px 0 4px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/xtree_drag.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>


<script language=javascript>

var channel_tree_id_path = getCookie("video_channel_path");
var node = null;

function init()
{
	//ContextMenu.intializeContextMenu()
	//try{
	
	if(channel_tree_id_path)
	{//alert(channel_tree_id_path);
		node = tree;
		var array = channel_tree_id_path.split(",");
		parent.frames["ifm_right"].location = "content.jsp?id=" + array[array.length-1];
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

function OnDropTarget(event,obj)
{
	var objid = obj.id;
	var right_window = parent.right;
	if(!right_window)
		return true;

	var ChannelID_Source = 0;
	if(right_window.CategoryID>0)
		ChannelID_Source = right_window.CategoryID;
	else
		ChannelID_Source = right_window.ChannelID;

	obj = $("#"+obj.id + '-anchor');
	var ChannelID_Dest = obj.attr("ChannelID");

	if(ChannelID_Dest != ChannelID_Source)
	{
		var curr_row;
		var selectedNumber = 0;
		var selectedItem = "";
		var selectedItemTitle = "";

		var rightObj=right_window.getCheckbox();
		
		if(rightObj.length==0){
				alert("请先选择要复制的文档！");
				return false;
		}
	
	    var message;
        var type=0;
		if(event.ctrlKey || event.shiftKey){
			 message ="确实要移动这"+rightObj.length+"项到 \"" + obj.text() + "\" 吗？";
			 type=1;
		}else{
			 message ="确实要复制这"+rightObj.length+"项到 \"" + obj.text() + "\" 吗？";
			 type=0;
		}
		if(confirm(message))
			{
			  //window.frames["CopyDocuments"].location = "document_copy.jsp?ItemID=" + rightObj.id+"&SourceChannel="+ChannelID_Source+"&DestChannel="+ChannelID_Dest+"&Type="+type;
			  var url="../content/document_copy.jsp?ItemID=" + rightObj.id+"&SourceChannel="+ChannelID_Source+"&DestChannel="+ChannelID_Dest+"&Type="+type;
			  //alert(url);
			  $.ajax({
				 type: "GET",
				 url: url,
				 success: function(msg)
					 {
					 if(type==1) {alert("移动成功.");parent.right.location.reload();}
					 if(type==0) alert("复制成功.");
					 document.getElementById(objid + '-anchor').style.border = "";
					 }   
			});  
			}
			 return false;
	}

	return false;
}

</script>
<head>

<body onload="init();">
<div class="menu_top">
<div class="manage">
	<div class="manage_box">
		<div class="manage_boxr">
			<div class="manage_boxm">
				<div class="manage_boxm_title"><img src="../images/manage_user.gif" />内容中心</div>
			</div>
		</div>
	</div>
</div>
<div class="menu_top_main"><div class="left"></div><div class="right"></div></div>
</div>
<div class="menu_main" id="div1">
<script language="javascript">
function show(id)
{
	try{
	if (tree.getSelected())
	{
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		var channel_tree_id_path = getNodePath("",tree.getSelected()) + id;
		var channeltype = ($("#"+tree.getSelected().id + '-anchor').attr("channeltype"));
		if(channeltype==5)
		{
			tree.getSelected().toggle();
		}
		var expires = new Date();
		expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
		document.cookie = "video_channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

	parent.frames["ifm_right"].location = "content.jsp?id=" + id;
}

//function init()
//{
if (document.getElementById) {
//	var tree = new WebFXTree('网站首页','javascript:show(-1)\" ChannelID=\"0');
//	tree.setBehavior('classic');
//	var a = new WebFXTreeItem('1','\" ChannelID=\"100');
//	tree.add(a);
<%=channel_tree_string%>
	
	document.write(tree);
	if(tree.childNodes.length==1)
		tree.childNodes[0].expand();
}
//}

</script>
</div>
<div class="menu_bottom"><div class="left"></div><div class="right"></div></div>
<div style="display:none"><iframe id="CopyDocuments" style="display:none;width: 0; height: 0;" src="about:blank"></iframe></div>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
