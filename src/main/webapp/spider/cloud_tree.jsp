<%@ page import="tidemedia.cms.system.Tree,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
String Action = getParameter(request,"Action");

Tree tree = new Tree();

String channel_tree_string = "";
int id = getIntParameter(request,"id");
Channel ch = CmsCache.getChannel(id);
channel_tree_string = tree.listChannel_content_JS(id,"tree",userinfo_session,100);

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style>
html{*padding:69px 0 4px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/xtree_drag.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>


<script language=javascript>

var channel_tree_id_path = getCookie("sns_channel_path_"+<%=id%>);
var node = null;

function init()
{
	//ContextMenu.intializeContextMenu()
	//try{
	
	if(channel_tree_id_path)
	{//alert(channel_tree_id_path);
		node = tree;
		var array = channel_tree_id_path.split(",");
		parent.frames["ifm_right"].location = "../content/content.jsp?id=" + array[array.length-1];
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
	var right_window = tidecms.getRightIfm();
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
			$("#"+objid).css("background","");
			return false;
	}

	return false;
}

</script>
<head>

<body onload="init();">
<div class="menu_top_2012">
	<div class="m_t_main">
		<div class="m_t_title"><img src="../images/sns.png" />当前结构</div>
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
		var channeltype = ($("#"+tree.getSelected().id + '-anchor').attr("channeltype"));
		if(channeltype==5)
		{
			tree.getSelected().toggle();
		}
		var expires = new Date();
		expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
		document.cookie = "sns_channel_path_"+<%=id%>+"=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

	parent.frames["ifm_right"].location = "../content/content.jsp?id=" + id;
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
		//document.cookie = "source_channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
	}
	}catch(e){}

	if(id<0)
		return;

	parent.frames["ifm_right"].location = "../source/source_content.jsp?id=" + id;
}

//function init()
//{
if (document.getElementById) {
	var tree = new WebFXTree('<%=ch.getName()%>','javascript:show(<%=id%>)\" ChannelID=\"0');
	var lsh_13539 = new WebFXLoadTreeItem('云资源','../source/tree_api2.jsp','javascript:show(13539);\" ChannelID=13539 ChannelType=\"0','','../images/tree/16_channel_icon.png','../images/tree/16_openchannel_icon.png');
    tree.add(lsh_13539);
	tree.setBehavior('classic');	
	document.write(tree);
	if(tree.childNodes.length==1)
		tree.childNodes[0].expand();
}
//}

</script>
</div>
<div style="display:none"><iframe id="CopyDocuments" style="display:none;width: 0; height: 0;" src="about:blank"></iframe></div>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->
</body>
</html>
