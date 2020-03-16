<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
String Action = getParameter(request,"Action");
String menu = CmsCache.getParameterValue("sys_system_tree_menu");
int showid = getIntParameter(request,"id");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>menu</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/xtree.js"></script>
<script language="javascript">
function init()
{
}

function show(id)
{
	if(parent.frames["ifm_right"])
	{
		var loc = "";

		if(typeof(id) == "string")
		{
			loc = id;
		}
		else
		{
		if(id==1)
			loc = "site.jsp";
		else if(id==2)
			loc = "login_log.jsp";
		else if(id==3)
			loc = "error_log.jsp";
		else if(id==4)
			loc = "../backup/file_list.jsp";
		else if(id==5)
			loc = "operate_log.jsp";
		else if(id==6)
			loc = "license.jsp";
		else if(id==7)
			loc = "parameter.jsp";
		else if(id==8)
			loc = "manager.jsp";
		else if(id==9)
			loc = "system_log.jsp";
		else if(id==10)
			loc = "content_quartz.jsp";
		else if(id==11)
			loc = "../update/upgrade.jsp";
		else if(id==12)
			loc = "../video/server_list.jsp";
                else if(id==13)
                        loc = "../photo/photo_scheme.jsp";
		else
			return;
		}
		parent.frames["ifm_right"].location = loc;
	}
}

function showSite(id)
{
	<%if(showid==0){%>
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = "site.jsp?id=" + id;
	}
	<%}%>
}
$(document).ready(function(){
	//alert("<%=showid%>");
	<%if(showid!=0){%>
		
		show(<%=showid%>);
	<%}%>
	
});
</script>
<style>.menu_main_2012{top:0;}</style>

</head>

<body>
<div class="menu_main_2012" id="div1">
<script language="javascript">
if (document.getElementById) {
	var tree = new WebFXTree('系统管理','');
	tree.setBehavior('classic');
	var a = new WebFXTreeItem('站点配置','javascript:show(1)');
	tree.add(a);
	<%=new Site().getSiteTree("a")%>
<%if(menu.length()>0){out.println(menu);}else{%>
	tree.add(new WebFXTreeItem("许可证","javascript:show(6)"));
	tree.add(new WebFXTreeItem("系统参数","javascript:show(7)"));
	tree.add(new WebFXTreeItem("操作日志","javascript:show(5)"));
	tree.add(new WebFXTreeItem("登录日志","javascript:show(2)"));
	tree.add(new WebFXTreeItem("错误日志","javascript:show(3)"));
	tree.add(new WebFXTreeItem("系统日志","javascript:show(9)"));
	tree.add(new WebFXTreeItem("备份中心","javascript:show(4)"));
	tree.add(new WebFXTreeItem("系统监控","javascript:show(8)"));
	//tree.add(new WebFXTreeItem("转码服务器","javascript:show(12)"));
	tree.add(new WebFXTreeItem("调度管理","javascript:show(10)"));
	//tree.add(new WebFXTreeItem("升级管理","javascript:show(11)"));
        tree.add(new WebFXTreeItem("图片尺寸","javascript:show(13)"));
<%}%>
	document.write(tree);
	tree.expandAll();
}
</script>
</div>
</body>
</html>
