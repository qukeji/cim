<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
int action = getIntParameter(request,"action");
if(action==1)
{

	return;
}

if(action==2)
{
	TableUtil tu = new TableUtil("user");

	out.println("清空登录日志<br>");
	tu.executeUpdate("truncate table login_log");


	return;
}
%>
<a href="init.jsp?action=1">windows初始化</a>

<br>

<a href="init.jsp?action=2">centos初始化</a>