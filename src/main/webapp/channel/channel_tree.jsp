<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
 *		修改人		日期		备注
 *		王海龙		20131112	修改排序功能 添加Sort方法
 *
 */
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
<title>无标题文档</title>
<link href="../style/menu.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<link href="../style/contextMenu.css" type="text/css" rel="stylesheet" />
<style>
html{*padding:69px 0 4px;}
</style>
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
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

var channel_tree_id_path = getCookie("channel_path");
var node = null;

function init()
{
	if(channel_tree_id_path)
	{
		node = tree;
		var array = channel_tree_id_path.split(",");
		parent.frames["ifm_right"].location = "channel.jsp?id=" + array[array.length-1];
		doExpandByCookie();
	}
}

function doExpandByCookie()
{//alert(channel_tree_id_path + ":" + node.src);
	if(!channel_tree_id_path || channel_tree_id_path=="") return;
	var array = channel_tree_id_path.split(",");
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
			channel_tree_id_path = s;
			break;
		}
		else
		{
			node = getNodeByChannelID(node,id);
			if(array.length-1 != i && node) node.expand();
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

		if(array.length-1 == i && node){if(tree.getSelected()) tree.getSelected().deSelect();channel_tree_id_path=""; node.select();}
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
</head>

<body  onload="init();">
<div class="menu_top">
<div class="manage">
	<div class="manage_box">
		<div class="manage_boxr">
			<div class="manage_boxm">
				<div class="manage_boxm_title"><img src="../images/structure.png" />结构管理 <span id="notify"></span></div>
			</div>
		</div>
	</div>
</div>
<div class="menu_top_main"><div class="left"></div><div class="right"></div></div>
</div>
<div class="menu_main" id="div1">
		<script language="javascript">
var myObject = new Object();
function show(id)
{
	var o = tree.getSelected();
	if (o)
	{
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		var channel_tree_id_path = getNodePath("",tree.getSelected()) + id;
		//var expires = new Date();
		//expires.setTime(expires.getTime() + 100 * 24 * 60 * 60 * 1000);
		//document.cookie = "channel_path=" + channel_tree_id_path + ";path=/;expires=" + expires.toGMTString();
		tidecms.setCookie("channel_path",channel_tree_id_path);

		var type = getChannelType(o);
		if(type==5)
		{
			o.toggle();
		}
	}
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = "../channel/channel.jsp?id=" + id;
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
	tree.setType('noroot');
	document.write(tree);
	//alert(tree);
	try{
	<%if(ParentID!=0 && ParentID!=-1){%>if(lsh_<%=ParentID%>)	expandParent(lsh_<%=ParentID%>);lsh_<%=ParentID%>.expand();<%}%>
	}catch(e){}
//}

function getChannelID(node)
{
	if(node==null) node = tree.getSelected();
	return $("#" + node.id + '-anchor').attr("ChannelID");
}

function getChannelType(node)
{
	if(node==null) node = tree.getSelected();
	return $("#"+node.id + '-anchor').attr("channeltype");
}

function newChannel()
{
    myObject.title = "新建频道";
	myObject.Type = 0;
	if (tree.getSelected()) 
		{ 
		myObject.ChannelID = getChannelID();
		myObject.Type = getChannelType();
		myObject.ChannelName = tree.getSelected().text;
	}else{
		myObject.ChannelID = 0;
		myObject.ChannelName = "网站首页";
		myObject.Type=-1;
	}
	var url='channel/channel_add_pre.jsp?ChannelID='+myObject.ChannelID+'&Type='+myObject.Type;
	url+='&ChannelName='+encodeURI(myObject.ChannelName);
	var	dialog = new top.TideDialog();
		dialog.setWidth(400);
		dialog.setHeight(200);
		dialog.setUrl(url);
		dialog.setTitle("新建频道");
		dialog.show();
}


function newCategory()
{
	//var myObject = new Object();
    myObject.title = "新建分类";
	if (tree.getSelected()) 
		{ 
		//alert(tree.getSelected().id); 
		//alert(document.getElementById(tree.getSelected().id + '-anchor').ChannelID);
		myObject.ChannelID = getChannelID();
		myObject.ChannelName = tree.getSelected().text;
	}else{
		myObject.ChannelID = 0;
		myObject.ChannelName = "网站首页";
	}
 	var Feature = "dialogWidth:32em; dialogHeight:20em;center:yes;status:no;help:no";
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=channel/category_add.jsp",myObject,Feature);
	if(retu!=null)
		window.location.reload();
}


function deleteChannel()
{
	if (tree.getSelected()) 
		{ 
		$.contextMenu.hide2();
		var notify = $("#notify");
		var node = tree.getSelected();
		var node2 = null;
		if(n = node.getNext()) {node2 = n;}
		else if(node.getPreviousSibling()) node2 = node.getPreviousSibling();
		else if(node.parentNode) node2 = node.parentNode;
		var ChannelID = getChannelID(node);
		var ChannelName = node.text;
		if(ChannelID==0)
		{
			alert("\"" + ChannelName + "\"不能删除!");
			return false;
		}else{
			var url='channel/channel_deletechannel.jsp?ChannelID='+ChannelID;
			//var notify1 ='<div class="tidecms_common_tips" id="tidecms_notify" style="margin:-2px 0 0 6px;float:right;line-height:24px;display:block;"><div class="tn_top"></div><div class="tct"></div><div class="tn_main"></div><div class="tn_bot"></div></div>';
			var	dialog = new top.TideDialog();
			dialog.setWidth(400);
			dialog.setHeight(145);
			dialog.setUrl(url);
			dialog.setTitle("删除频道");
			dialog.show();
		}
		/*
		if(confirm("确实要删除\"" + ChannelName + "\"吗?\r\n注意：频道被删除后不能恢复，而且其下面的子频道将一并删除!")) 
		{
			//alert(node.getNextSibling().select());return;
			var url = "channel_delete.jsp?Action=Delete&id=" + ChannelID;
			notify.html("<font color=red>正在删除...</font>");
			  $.ajax({type: "GET",url: url,success: function(msg){				  
				  if(node2) {node2.select();show(getChannelID(node2));}				  
				  node._remove2();$("#" + node.id).remove();
				  notify.html("<font color=red>删除成功</font>");
				  notify[0].timerId = setTimeout(function (){notify.html("");}, 500);				  
			  }}); 
			//this.location = "channel_delete.jsp?Action=Delete&id="+ChannelID;
		}
*/
	}else{
		return false;
	}
}

function editChannel()
{
    myObject.title = "编辑频道";
	myObject.Type = 0;
	if (tree.getSelected()) 
		{ 
		myObject.ChannelID = getChannelID();
		myObject.ChannelName = tree.getSelected().text;
		myObject.Type = getChannelType();
		if(myObject.Type==1)
			myObject.title = "编辑分类";
		else if(myObject.Type==2)
			myObject.title = "编辑页面";
	}else{
		myObject.ChannelID = 0;
		myObject.ChannelName = "网站首页";
	}

	var url;
	var width=500;
	var height=500;
	if(myObject.Type==2){
		 url='page/page_edit2.jsp?ChannelID='+myObject.ChannelID;
		 width=400;
		 height=300;	
	}else{
		url='channel/channel_edit.jsp?ChannelID='+myObject.ChannelID;
	}

	var	dialog = new top.TideDialog();
		dialog.setWidth(width);
		dialog.setHeight(height);
		dialog.setUrl(url);
		dialog.setTitle(myObject.title);
		dialog.show();
}
function Sort(action){
	myObject.title="排序";
	if(tree.getSelected()){
		myObject.ChannelID = getChannelID();
		myObject.ChannelName = tree.getSelected().text;		
	}
	var url= "channel/channel_order.jsp?Action=" + action + "&ChannelID="+myObject.ChannelID;
	var	dialog = new top.TideDialog();
		dialog.setWidth(250);
		dialog.setHeight(162);
		dialog.setUrl(url);
		dialog.setTitle(myObject.title);
		dialog.show();

}
function Order(action)
{
	if (tree.getSelected()) 
		{ 
		var ChannelID = getChannelID();
		var ChannelName = tree.getSelected().text;
		if(ChannelID==0)
		{
			//alert("\"" + ChannelName + "\"不能删除!");
			return false;
		}
		url = this.location+"../../../content/document_order.jsp?Action=" + action + "&ChannelID="+ChannelID;
		var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(200);
		dialog.setUrl(url);
		dialog.setTitle("排序");
		dialog.show();

	}else{
		return false;
	}
}

function viewSource()
{
	location='view-source:'+location;
}

function action(o)
{
	if(!o) return;

	//修改频道
	if(o.action==1)
	{
		var oo = $("a[channelid="+o.id+"]");
		if(oo.size()==1)
		{
			var id = oo.attr("id");
			$("a[channelid="+o.id+"]").html(o.name);
			if(o.icon!="")
			{
				$("#"+id.replace("-anchor","-icon")).attr("src","../images/channel_icon/"+o.icon);
			}
			show(o.id);
		}
	}

	//添加频道
	if(o.action==2)
	{
		var oo = tree.getSelected();
		var src = oo.src;
		if(src==""){ 
			var id = $("#"+oo.id+"-anchor").attr("channelid");
			src = "../channel/channel_xml.jsp?id=" + id;
		}
		oo.reload2(src,true);
	}

	//删除频道
	if(o.action==3)
	{
		var node = tree.getSelected();
		tidecms.log("current node:"+node.id+","+node.text);
		if(o.id==$("#" + node.id + '-anchor').attr("channelid"))
		{
			var node2 = null;
			if(n = node.getNext()) {node2 = n;}
			else if(node.getPreviousSibling()) node2 = node.getPreviousSibling();
			else if(node.parentNode) node2 = node.parentNode;
			if(node2) {
				tidecms.log("current node2:"+node2.id+","+node2.text);
				node2.select();show(getChannelID(node2));}
			node._remove2();
			//$("#" + node.id).remove();
		}
	}
}
</script>
</div>
<div class="menu_bottom"><div class="left"></div><div class="right"></div></div>
<script type="text/javascript">
jQuery(document).ready(function(){
var beforeShowFunc = function() {}
var menu = [
  {'<img src="../images/inner_menu_edit.gif" title="新建"/>新建':function(menuItem,menu){newChannel();}},
  {'<img src="../images/inner_menu_edit.gif" title="编辑"/>编辑':function(menuItem,menu) {editChannel();}},
<%if((new UserPerm().canDeleteChannel(userinfo_session))){%>
{'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteChannel();}},
<%}%>
  {'<img src="../images/inner_menu_edit.gif" title="排序"/>排序':function(menuItem,menu) {Sort();}},
  {'<img src="../images/inner_menu_cache.gif" title="刷新"/>刷新':function(menuItem,menu) {window.location.reload();}}
];
 jQuery('body').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
</script>
</body>
</html>