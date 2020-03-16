<%@ page import="tidemedia.cms.system.*,
				org.json.*,
				tidemedia.cms.util.TideJson,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

Tree tree		= new Tree();
String channel_tree_string = "";
TideJson tj= CmsCache.getParameter("sys_vote_channel").getJson();
if(tj==null){out.println("error:插入投票参数未配置，请联系系统管理员。");return;}
int channelid =tj.getInt("subject_channelid");
channel_tree_string = tree.listChannel_content_JS(channelid, "tree", userinfo_session,20);
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
var channelid=<%=channelid%>;
function show(id)
{
	if(parent.frames["right"])
	{
		if(id==0){
			id=channelid;
		}
		parent.frames["right"].location = "editor_vote_content.jsp?id=" + id;
	}
}
</script>
</head>

<body>
<div class="dialog_menu_top"><div class="left"></div><div class="right"></div></div>

<div class="dialog_menu_main" id="div1">
<script language="javascript">
var tree = new WebFXTree('投票','javascript:show(<%=channelid%>)" ChannelID="0');
tree.setBehavior('classic');
<%=channel_tree_string%>
//tree.setType('noroot');
document.write(tree);
</script>
</div>
<div class="dialog_menu_bottom"><div class="left"></div><div class="right"></div></div>
</body>
</html>
