<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}
String Action = getParameter(request,"Action");
%>
<html>

<link type="text/css" rel="stylesheet" href="../common/xtree.css" />
<script type="text/javascript" src="../common/xtree.js"></script>
<script language=javascript>
function init()
{
}
</script>

<body topmargin="0" leftmargin="0" onload="init();">
<div style="position: absolute; top: 0px; left: 0px; height: 100%; padding: 5px; overflow: auto;">
<script language="javascript">
function show(id)
{
	if(parent.parent.frames["main"])
	{
		if(id==1)
			parent.parent.frames["main"].location = "list.jsp";
		else if(id==2)
			parent.parent.frames["main"].location = "config.jsp";
		else if(id==3)
			parent.parent.frames["main"].location = "about:blank";
		else if(id==4)
			parent.parent.frames["main"].location = "email_list.jsp";
	}
}

//function init()
//{
if (document.getElementById) {
	var tree = new WebFXTree('邮件列表','');
	tree.setBehavior('classic');
	var a = new WebFXTreeItem('发送文件夹','javascript:show(1)');
	tree.add(a);
	var d = new WebFXTreeItem('邮件地址列表','javascript:show(4)');
	tree.add(d);
	var b = new WebFXTreeItem('邮件发送配置','javascript:show(2)');
	tree.add(b);
	var c = new WebFXTreeItem('邮件发送统计','javascript:show(3)');
	tree.add(c);
	document.write(tree);
}
//}

</script>
</div>

</body>
</html>
