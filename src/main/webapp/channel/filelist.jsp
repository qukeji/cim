<%@ page import="tidemedia.cms.system.*,
				java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

String TemplateFolder = defaultSite.getTemplateFolder();
String Path = getParameter(request,"Path");
String RealPath = (TemplateFolder + "/" + Path);
File file = new File(RealPath);
File[] files = file.listFiles();
%>
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<title></title>

<Script language="javascript">
var curName="";
var curFileID=-1;
var curPath = "<%=Path%>";

function OpenFolder(folderName){
	//alert(curPath);
	parent.OpenFolder(curPath+"/" + folderName);
}
function selectFile(fileitem,curfile){
	var allFile = document.body.all;
	for (var i=0;i<allFile.length;i++)
		if (allFile[i].className == "fileitem")
			allFile[i].className = "";
			
	var cuEl=eval("item"+fileitem);
	cuEl.className="fileitem";
	var fileName = cuEl.fileName;
	
	curFileID = fileitem;
	var typeEl = eval("type" + fileitem);
	if (typeEl.innerText!="文件夹"){
		curName = parent.document.all.folderList.value + fileName;
		parent.document.all.url.value=curName;
		}
	else{curName="";}
}
function OpenFile(){
	parent.closeWindow();
}

</Script>

</head>

<body topmargin="0" leftmargin="0" oncontextmenu="return false">
<script>
var el;

function doPreview(){
	if (curName!=null && curName!=""){
		window.open(curName);
 	}
}
</script>


<table width="100%" cellspacing="0" cellpadding="0" class="fileCur" id="a">
<tr><td class="titlebar">名称</td><td class="titlebar">标题</td><td class="titlebar">类型
</td></tr>
<%
if(files!=null)
{
	int j = 0;
	for(int i = 0;i<files.length;i++)
	{
		if(files[i].isDirectory())
		{
		j++;
%>
<tr onmouseup="selectFile(<%=j%>)" ondblclick="OpenFolder('<%=files[i].getName()%>');"
	class="a" id="item<%=j%>"><td><img src="../images/tree/foldericon.png"><%=files[i].getName()%></td>
	<td>&nbsp;</td><td id="type<%=j%>">文件夹</td></tr>
<%
		}
	}
	for(int i = 0;i<files.length;i++)
	{
		if(!files[i].isDirectory())
		{
		j++;
%>
<tr onmouseup="selectFile(<%=j%>);"
	ondblclick="OpenFile();"
	class="a" id="item<%=j%>" fileName="<%=files[i].getName()%>"><td><%=files[i].getName()%></td><td></td>
	<td id="type<%=j%>"></td></tr>
<%
		}
	}
}
else
{
%>
<tr class="a"><td>
找不到模板目录.
</td>
</tr>
<%
}
%>
</table>
</body>

</html>
