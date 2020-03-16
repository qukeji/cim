<%@ page import="tidemedia.cms.util.Util,
				tidemedia.cms.system.*,
				java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript">
function getCheckbox(){
	var obj={length:500,id:'id'};
	return obj;
}
</script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
<script language=javascript>
var folder_tree_id_path = getCookie("folder_path");//如4/images/2012 4是站点编号，后面是目录

var node = null;
var num = 0;
var level = 0;
function init()
{
	
	if(folder_tree_id_path)
	{
		node = tree;
		var index = folder_tree_id_path.indexOf("/");
		var folder = encodeURI(folder_tree_id_path.substring(index));
		parent.frames["ifm_right"].location = "file_list.jsp?FolderName=" +folder+"&SiteId="+folder_tree_id_path.substring(0,index);
		doExpandByCookie();
		level = 1;
	}
}

function doExpandByCookie()
{
	var array = folder_tree_id_path.split("/");
	if(array.length>0)
	{
		var siteid = array[0];
		node = getNodeBySite(siteid);
		node.expand();
	}
}


function getNodeByFolderName(node,id)
{
	//tidecms.log("begin:"+id);
	if(id=="") return tree;
	if(node==null || node.childNodes==null) return null;
	for (var i = 0; i < node.childNodes.length; i++) {//alert(document.getElementById(node.childNodes[i].id+"-anchor").FolderName);
		var o = $("#"+node.childNodes[i].id+"-anchor");
		//tidecms.log(o.attr("FolderName")+","+id);
		if(o.attr("FolderName")==id){
			return node.childNodes[i];
		}
	}
	//tidecms.log("end:"+id);
	return null;
}

function getNodeBySite(siteid)
{
	node = tree;
	if(node==null || node.childNodes==null) return null;
	for (var i = 0; i < node.childNodes.length; i++) {
		var id = node.childNodes[i].id+"-anchor";
		var o = $("#"+id);
		if(o.attr("foldername")=="/"&&o.attr("siteid")==siteid){
			return node.childNodes[i];
		}
	}
	return null;
}

function doExpandXmlNodeByCookie()
{	//tidecms.log("doExpandXmlNodeByCookie:"+folder_tree_id_path);
	if(!folder_tree_id_path || folder_tree_id_path=="") return;
	var array = folder_tree_id_path.split("/");
	//tidecms.log("array size:"+array.length+",level:"+level);
	var path = "";
	for(var i = 1;i<=level;i++)
	{
		var p = array[i];
		path += "/" + p;
	}

	node = getNodeByFolderName(node,path);
	//tidecms.log("path:"+path);

	if(array.length-1 == level && node){if(tree.getSelected()) tree.getSelected().deSelect();folder_tree_id_path=""; node.select();}
	else{node.expand();}
	level ++;
}

function ListFile(str){
	var str;
	var SiteId;

	if (tree.getSelected()) 
		{ 
		
		str =  getFolderName();
	   SiteId =getSite();
		if(str && str!="\\"){
			document.cookie = "folder_path=" + SiteId + str; //alert(document.cookie);
			//document.cookie = "SiteId=" + SiteId;
			}
		else{
			document.cookie = "folder_path="+SiteId;
			//document.cookie = "SiteId=" + SiteId;
			}

		var channeltype = ($("#"+tree.getSelected().id + '-anchor').attr("channeltype"));
		//alert(channeltype);
		if(channeltype==5)
		{
			tree.getSelected().toggle();
		}
	}
   
	if(parent.frames["ifm_right"])
	{
		if(str && str!="\\")
			parent.frames["ifm_right"].location = "file_list.jsp?FolderName=" + encodeURI(str)+"&SiteId="+SiteId;
		else
			parent.frames["ifm_right"].location = "file_list.jsp?FolderName=&SiteId="+SiteId;
	}

}

function newFolder()
{
    var FolderName;
	var SiteId 
		FolderName = getFolderName();
		SiteId = getSite();

	if(FolderName=="")
		return;

		var	dialog = new top.TideDialog();
			dialog.setWidth(300);
			dialog.setHeight(200);
			dialog.setUrl("explorer/newfolder.jsp?SiteId="+SiteId+"&FolderName="+encodeURI(FolderName));
			dialog.setTitle("新建目录");
			dialog.show();
	
}

function getFolderName()
{
	if(tree.getSelected())
		return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("FolderName");
	else
		return "";
}

function getSite()
{
	if(tree.getSelected())
		return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("SiteId");
	else
		return 0;
}

function deleteFolder()
{
 var SiteId;
	if (tree.getSelected()) 
		{ 
		FolderName = getFolderName();
		SiteId=getSite();

		if(FolderName=="\\")
		{
			alert("\"站点根目录\"不能删除!");
			return false;
		}
		if(confirm("确实要删除\"" + FolderName + "\"吗?\r\n注意：目录被删除后不能恢复，而且其下面的文件和子目录将一并删除!")) 
		{
	    var nodeDel=getDelNode(tree.getSelected());
		var	str = document.getElementById(nodeDel.id + '-anchor').FolderName;
		 document.cookie = "folder_path=" + str;
		
			this.location = "folder_delete.jsp?Action=Delete&FolderName="+encodeURI(FolderName)+"&SiteId="+SiteId;
		}
	}else{
		return false;
	}
}


function getDelNode(selectDel){
        var nodeDel="";
		var parentDel=selectDel.parentNode;
		 if(selectDel.getPreviousSibling()&& selectDel.getPreviousSibling().parentNode==parentDel){
		   nodeDel=selectDel.getPreviousSibling();
		 }else{
		   if(selectDel.getNextSibling()&&selectDel.getNextSibling().parentNode==parentDel){
		    nodeDel=selectDel.getNextSibling();
		   }else{
		   nodeDel=parentDel;
		   }
		 } 
		 
 return nodeDel; 
    	//var	str = document.getElementById(nodeDel.id + '-anchor').FolderName;
}
function publishFolder()
{
  var SiteId;
	if (tree.getSelected()) 
		{ 
		FolderName =getFolderName();
		SiteId=getSite();

		if(confirm("确实要发布\"" + FolderName + "\"吗?\r\n提示：发布目录有可能需要较长时间!")) 
		{
			this.location = "folder_publish.jsp?Action=Publish&FolderName="+encodeURI(FolderName)+"&SiteId="+SiteId;
		}
	}else{
		return false;
	}
}

function downloadFolder()
{
   var SiteId;
	if (tree.getSelected()) 
		{ 
		FolderName =getFolderName();
        SiteId=getSite();
		window.frames["Download"].location = "../download.jsp?Type=Folder&FolderName="+encodeURI(FolderName)+"&SiteId="+SiteId;		
	}else{
		return false;
	}
}

function renameFolder()
{
  var SiteId;
	if (tree.getSelected()) 
		{ 
		FolderName = getFolderName();
		SiteId=getSite();
		if(FolderName=="\\")
		{
			alert("\"站点根目录\"不能重命名!");
			return false;
		}    
		var	dialog = new top.TideDialog();
			dialog.setWidth(300);
			dialog.setHeight(200);
			dialog.setUrl("explorer/renamefolder.jsp?SiteId="+SiteId+"&FileName="+encodeURI(FolderName));
			dialog.setTitle("重命名");
			dialog.show();	
	}else{
		return false;
	}
}

function newFile()
{
	var FolderName;
	var SiteId;
	if (tree.getSelected()){ 
		var	dialog = new top.TideDialog();
		dialog.setWidth(300);
		dialog.setHeight(200);
		dialog.setUrl("explorer/newfile.jsp?FolderName="+getFolderName()+"&SiteId="+getSite());
		dialog.setTitle("新建文件");
		dialog.show();
	}	
}

function viewSource()
{
	location='view-source:'+location;
}

</script>
</head>

<body onload="init();">
<div class="menu_top_2012">
	<div class="m_t_main">
		<div class="m_t_title"><img src="../images/explorer.png" />文件管理</div>
	</div>
</div>
<div class="menu_main_2012" id="div1">
<script language="javascript">
//var curPath=top.ReadValue("curPath");
if (document.getElementById) {
	var tree = new WebFXTree('文件管理','');
    tree.setBehavior('explorer');
   <%=new CmsFile().listFile_JS("tree")%>
    tree.setType('noroot');
	document.write(tree);
}
</script>
</div>
<div style="display:none"><iframe id="Download" name="Download" style="width: 0; height: 0;"></iframe></div>
<script type="text/javascript">
jQuery(document).ready(function(){
var beforeShowFunc = function() {}
var menu = [
  {'<img src="../images/inner_menu_edit.gif" title="新建文件"/>新建文件':function(menuItem,menu){newFile();}},
  {'<img src="../images/inner_menu_edit.gif" title="新建目录"/>新建目录':function(menuItem,menu) {newFolder();}},
  {'<img src="../images/inner_menu_edit.gif" title="发布目录"/>发布目录':function(menuItem,menu) {publishFolder();}},
  {'<img src="../images/inner_menu_edit.gif" title="下载目录"/>下载目录':function(menuItem,menu) {downloadFolder();}},
  {'<img src="../images/inner_menu_edit.gif" title="重命名"/>重命名':function(menuItem,menu) {renameFolder();}},
  {'<img src="../images/inner_menu_cache.gif" title="刷新"/>刷新':function(menuItem,menu) {window.location.reload();}},
  {'<img src="../images/inner_menu_del.gif" title="删除"/><font style="color:red;">删除</font>':function(menuItem,menu) {deleteFolder();}}
];
 jQuery('body').contextMenu(menu,{theme:'vista',beforeShow:beforeShowFunc});
});
</script>
</body>
</html>