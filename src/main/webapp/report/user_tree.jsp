<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%


//if(!(new UserPerm().canManageUser(userinfo_session)))
//{response.sendRedirect("../noperm.jsp");return;}

UserGroup group = new UserGroup();

String tree_string = "";

tree_string = group.listGroup_JS(userinfo_session);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Menu</title>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<link href="../style/9/contextMenu.css" type="text/css" rel="stylesheet" />
<style>
body {
    background: #feffff !important;
}
html{*padding:69px 0 4px;}
.menu_top{height:14px;}
.menu_main{top:14px;*top:0;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.contextmenu.js"></script>
</head>

<body>
<div class="menu_top">
<div class="menu_top_main"><div class="left"></div><div class="right"></div></div>
</div>
<div class="menu_main" id="div1">
<script language="javascript">

function show(id){   
	if(id==0){
		id=-1;
	}
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = "user_list.jsp?GroupID=" + id;
	}
}

if (document.getElementById) {
	var tree = new WebFXTree('用户组','javascript:show(-1)\" ChannelID=\"0');
	tree.setBehavior('classic');
	<%=tree_string%>
	document.write(tree);
}


</script>
</div>
<div class="menu_bottom"><div class="left"></div><div class="right"></div></div>

</body>
</html>