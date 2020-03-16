<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String Action = getParameter(request,"Action");
String menu = Parameter.getParameterValue("sys_person_menu",userinfo_session);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script language=javascript>
function init()
{
}
</script>

<body topmargin="0" leftmargin="0" onload="init();">
<div class="menu_top_2012">
	<div class="m_t_main">
		<div class="m_t_title"><img src="../images/person.png" />个人设置</div>
	</div>
</div>
<div class="menu_main_2012" id="div1">
<script language="javascript">
function show(url)
{
	if(parent.frames["ifm_right"])
	{
		parent.frames["ifm_right"].location = url;
	}
}

//function init()
//{
if (document.getElementById) {
<%if(menu.length()>0){out.println(menu);}else{%>
	var tree = new WebFXTree('个人设置','');
	tree.setBehavior('classic');
	var a = new WebFXTreeItem('我的信息',"javascript:show('my_info.jsp')");
	tree.add(a);
	var e = new WebFXTreeItem('修改密码',"javascript:show('update_pass.jsp')");
	tree.add(e);
	var b = new WebFXTreeItem('我的快捷方式',"javascript:show('shortcut.jsp')");
	tree.add(b);
	var c = new WebFXTreeItem('我的工作任务',"javascript:show('task.jsp')");
	tree.add(c);
	var f = new WebFXTreeItem('工作量统计',"javascript:show('../report/myreport.jsp')");
	tree.add(f);
	var d = new WebFXTreeItem('TideCMS工具栏',"javascript:show('tools.jsp')");
	tree.add(d);
	var d = new WebFXTreeItem('Tide一键转载',"javascript:show('transfer_tools.jsp')");
	tree.add(d);
	//var e = new WebFXTreeItem('我的采集设置',"javascript:show('my_spider.jsp')");
	//tree.add(e);
	document.write(tree);
<%}%>
}
//}

</script>
</div>
</body>
</html>
