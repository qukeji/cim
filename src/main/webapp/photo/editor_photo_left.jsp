<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();

int		ParentID	= getIntParameter(request,"ParentID");
String Action		= getParameter(request,"Action");
Tree tree		= new Tree();
int		type	= getIntParameter(request,"type");
String channel_tree_string = "";
//修改插入图片集功能 2013/7/17   张赫东
//channel_tree_string = tree.listChannel_JS(userinfo_session);
channel_tree_string = tree.listChannel_content_JS(13451, "tree", userinfo_session,20);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<link href="../style/dialog_menu.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/xmlextras.js"></script>
<script type="text/javascript" src="../common/xloadtree.js"></script>
<script language=javascript>
function show(id)
{
	if(parent.frames["right"])
	{
		if(id==4347){
			id=13451;
		}//张赫东 20130527
		parent.frames["right"].location = "../photo/editor_photo_right.jsp?id=" + id+"&type=<%=type%>";
	}
}
</script>
</head>

<body>
<div class="dialog_menu_top"><div class="left"></div><div class="right"></div></div>

<div class="dialog_menu_main" id="div1">
<script language="javascript">
var tree = new WebFXTree('图片集','javascript:show(4347)" ChannelID="0');
tree.setBehavior('classic');
<%=channel_tree_string%>
//tree.setType('noroot');
document.write(tree);
</script>
</div>
<div class="dialog_menu_bottom"><div class="left"></div><div class="right"></div></div>
</body>
</html>