<%@ page import="tidemedia.cms.util.*,tidemedia.cms.base.*,
				tidemedia.cms.system.*,org.json.*,
				java.io.File"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/**
	 *
	 *@author wanghailong
	 *@action add
	 *@date 2014/01/11
	 *@info 选择视频树形结构
	 *
	 */
 int channelid = getIntParameter(request,"channelid");
 TideJson tj = CmsCache.getParameter("sys_video").getJson();
 JSONArray array = new JSONArray(tj.getString("select_folder"));
%>
 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style>
html{*padding:69px 0 4px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script language=javascript>
 
function ListFile(str){
	var str =  getFolderName();	   
	var number = getNumber();
	if(parent.frames["ifm_right"])
	{
		if(str && str!="\\")
			parent.frames["ifm_right"].location = "file_list_choose.jsp?number="+number+"&FolderName=" + encodeURI(str)+"&channelid=<%=channelid%>";
		else
			parent.frames["ifm_right"].location = "file_list_choose.jsp?number="+number+"&FolderName=/&channelid=<%=channelid%>";
	}

} 

function getFolderName()
{
	if(tree.getSelected())
		return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("FolderName");
	else
		return "";
}
function getNumber(){
	if(tree.getSelected())
		return document.getElementById(tree.getSelected().id + '-anchor').getAttribute("Number");
	else
		return "";
}
</script>
</head>

<body >
  
<div class="menu_main_2012" id="div1" style="margin-top:-33px">
<script language="javascript">

//var curPath=top.ReadValue("curPath");
if (document.getElementById) {
	var tree = new WebFXTree('','javascript:ListFile()');
	tree.setBehavior('classic');
	<%
	for(int i =0;i<array.length();i++)
	{ 
		JSONObject oo = array.getJSONObject(i);
		String name = oo.getString("name");
		String value = oo.getString("value");
		String copy = oo.getString("copy");
		String desc ="";
		if(copy.equals("1"))
			desc="复制文件";
		if(copy.equals("2"))
			desc="不复制文件";
	%>
		var varName=new WebFXLoadTreeItem("<%=name%>(<%=desc%>)","folder_xml.jsp?number=<%=i%>&Path=/","javascript:ListFile();\" copy=<%=copy%> Number=<%=i%> FolderName=/ ","","../images/tree/16_channel_site_icon.png","../images/tree/16_channel_site_icon.png");
		tree.add(varName);
		
	<%if(i==0){//右侧默认显示第一个目录视频%>
		parent.frames["ifm_right"].location = "file_list_choose.jsp?number=<%=i%>&FolderName=/&channelid=<%=channelid%>"; 
	<%}}%>
    
	tree.setType('noroot');
	document.write(tree);	 
    tree.expandChildren();
}
</script>
</div>
</body>
</html>