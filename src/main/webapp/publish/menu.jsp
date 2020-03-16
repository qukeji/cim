<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}
String Action = getParameter(request,"Action");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<style>
html{*padding:69px 0 4px;}
.menu_top{height:14px;}
.menu_main{top:14px;*top:0;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script language=javascript>
function init()
{

}
</script>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"  scrolling="auto"  onload="init();" >
<div class="menu_top">
<div class="menu_top_main"><div class="left"></div><div class="right"></div></div>
</div>
<div class="menu_main" id="div1">
<script language="javascript">
function show(id)
{
	if(parent.frames["ifm_right"])
	{
		if(id==1)
			parent.frames["ifm_right"].location = "setup.jsp";
		else if(id==2)
			parent.frames["ifm_right"].location = "to_be_published.jsp";
		else if(id==3)
			parent.frames["ifm_right"].location = "published.jsp";
	}
}

function showSite(id)
{
}

function showItem(SiteId,type){
switch(type){
case 1:parent.frames["ifm_right"].location = "setup.jsp?SiteId="+SiteId;break;
case 2:parent.frames["ifm_right"].location = "to_be_published.jsp?SiteId="+SiteId;break;
case 3:parent.frames["ifm_right"].location = "published.jsp?SiteId="+SiteId;break;
}
}
if (document.getElementById) {
	var tree = new WebFXTree('站点发布','');
	tree.setBehavior('classic');
	<%=new Site().getPublishSiteTree("tree")%>

	var lsh__1 = new WebFXTreeItem('其它','javascript:showSite(-1);\" SiteID=0 ChannelType=\"3','','../images/tree/16_channel_site_icon.png','../images/tree/16_channel_site_icon.png');
	var b = new WebFXTreeItem('发布设置','javascript:showItem(-1,1)');
	var c = new WebFXTreeItem('待发布任务','javascript:showItem(-1,2)');
	var d = new WebFXTreeItem('已发布任务','javascript:showItem(-1,3)');
	lsh__1.add(b)
	lsh__1.add(c)
	lsh__1.add(d)
	tree.add(lsh__1);

	document.write(tree);
	tree.expandAll();
}

</script>
</div>
<div class="menu_bottom"><div class="left"></div><div class="right"></div></div>
</body>
</html>