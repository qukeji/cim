<%@ page import="tidemedia.cms.util.Util,
				tidemedia.cms.system.*,
				java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String TemplateFolder =CmsCache.getDefaultSite().getTemplateFolder();

String RealPath = (TemplateFolder);
File file = new File(RealPath);
if(!file.exists())
	file.mkdir();
File[] files = file.listFiles();
%>
<html>

<script type="text/javascript" src="../common/ContextMenu.js"></script>
<script type="text/javascript" src="../common/ieemu.js"></script>
<script type="text/javascript" src="../common/common.js"></script>

<body topmargin="0" leftmargin="0" onload="ContextMenu.intializeContextMenu()" oncontextmenu="contextForBody(this)">
<div style="position: absolute; top: 0px; left: 0px; height: 100%; padding: 5px; overflow: no;">
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script language="javascript">
//var curPath=top.ReadValue("curPath");
function show(id)
{
	if(parent.parent.frames["main"])
	{
		parent.parent.frames["main"].location = "channel.jsp?id=" + id;
	}
}

if (document.getElementById) {
	var tree = new WebFXTree('模板根目录','javascript:ListFile();\" FolderName=\"\\');
	tree.setBehavior('explorer');
	
	<%
	if(files!=null)
	{
	//For each newNode in Root.SubFolders
	for(int i = 0;i<files.length;i++)
	{
		if(files[i].isDirectory())
		{
			String FolderName = files[i].getName();
			if(Util.isHasSubFolder(RealPath+"/"+FolderName))
			{
	%>
	tree.add(new WebFXLoadTreeItem("<%=FolderName%>","folder_xml.jsp?Path=<%=java.net.URLEncoder.encode(FolderName,"utf-8")%>","javascript:ListFile()\" FolderName=\"<%=FolderName%>"));
	<%
			}
			else
			{
	%>
	tree.add(new WebFXTreeItem("<%=FolderName%>","javascript:ListFile()\" FolderName=\"<%=FolderName%>"));
	<%
			}
		}
	
	}
	}
	%>
	document.write(tree);
}

function ListFile(str){
	var str;
	if (tree.getSelected()) 
		{ 
		str = document.getElementById(tree.getSelected().id + '-anchor').FolderName;
	}
	//alert(str);
	//alert(encodeURI(str));

	if(parent.parent.frames["main"])
	{
		if(str && str!="\\")
			parent.parent.frames["main"].location = "template_list.jsp?FolderName=" + encodeURI(str);
		else
			parent.parent.frames["main"].location = "template_list.jsp?FolderName=";
	}
}

function newFile()
{
	var myObject = new Object();
    myObject.title = "新建文件";
	if (tree.getSelected()) 
		{ 
		myObject.FolderName = document.getElementById(tree.getSelected().id + '-anchor').FolderName;
	}else{
		myObject.FolderName = "/";
	}

	var Feature = "dialogWidth:32em; dialogHeight:26em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=template/newfile.jsp",myObject,Feature);
	if(retu!=null)
	{
		parent.parent.frames["main"].location.reload();
	}
}

function renameFolder()
{
	if (tree.getSelected()) 
		{ 
		FolderName = document.getElementById(tree.getSelected().id + '-anchor').FolderName;
		if(FolderName=="\\")
		{
			alert("\"站点根目录\"不能重命名!");
			return false;
		}

	var myObject = new Object();
    myObject.title = "重命名";
	myObject.FolderName = FolderName;
	var Feature = "dialogWidth:32em; dialogHeight:16em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=template/renamefolder.jsp&FileName=" + encodeURI(FolderName),myObject,Feature);
	if(retu!=null)
	{
		parent.parent.frames["main"].location.reload();
		window.location.reload();
	}

	}else{
		return false;
	}
}

function newFolder()
{
	var myObject = new Object();
    myObject.title = "新建目录";
	if (tree.getSelected()) 
		{ 
		myObject.FolderName = document.getElementById(tree.getSelected().id + '-anchor').FolderName;
	}else{
		myObject.FolderName = "/";
	}
	var Feature = "dialogWidth:32em; dialogHeight:16em;center:yes;status:no;help:no";	
	var retu = window.showModalDialog
	("../modal_dialog.jsp?target=template/newfolder.jsp",myObject,Feature);
	if(retu!=null)
		window.location.reload();
}

function deleteFolder()
{
	if (tree.getSelected()) 
		{ 
		FolderName = document.getElementById(tree.getSelected().id + '-anchor').FolderName;
		if(FolderName=="\\")
		{
			alert("\"模板根目录\"不能删除!");
			return false;
		}
		if(confirm("确实要删除\"" + FolderName + "\"吗?\r\n注意：模板被删除后不能恢复，而且其下面的子模板将一并删除!")) 
		{
			this.location = "deletefolder.jsp?Action=Delete&FolderName="+encodeURI(FolderName);
		}
	}else{
		return false;
	}
}

function downloadFolder()
{
	if (tree.getSelected()) 
		{ 
		FolderName = document.getElementById(tree.getSelected().id + '-anchor').FolderName;

		window.frames["Download"].location = "../download.jsp?Template=True&Type=Folder&FolderName="+encodeURI(FolderName);
		//this.location = "folder_publish.jsp?Action=Publish&FolderName="+FolderName;
		
	}else{
		return false;
	}
}

function contextForBody(obj)
{
   var eobj,popupoptions
   popupoptions = [
   						new ContextItem("新建文件",function(){newFile();}),
   						new ContextItem("新建目录",function(){newFolder();}),
						new ContextSeperator(),
						new ContextItem("下载目录",function(){downloadFolder();}),
						new ContextSeperator(),
   						new ContextItem("删除",function(){deleteFolder();}),
						new ContextItem("重命名",function(){renameFolder();}),
						new ContextSeperator(),
   						new ContextItem("刷新",function(){window.location.reload();})
   				  ]
   ContextMenu.display(popupoptions)
}

function showText(obj)
{
	self.status=obj.innerText
}

function contextForSpan(obj)
{
   var eobj,popupoptions
   popupoptions = [
   						new ContextItem("Show Text",function(){showText(obj);})
   				  ]
   ContextMenu.display(popupoptions)
}
function hideIt(obj)
{
	obj.style.display='none'
} 

function contextForButton(obj)
{
   var eobj,popupoptions
   popupoptions = [
   						new ContextItem("<b>Hide</b>",function(){hideIt(obj);}),
   						new ContextItem("Show Text",function(){showText(obj);})
   				  ]
   ContextMenu.display(popupoptions)
}
</script>
</div>
<iframe id="Download" style="width: 0; height: 0;"></iframe>
</body>
</html>
