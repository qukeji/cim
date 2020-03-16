<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
 
<%
if(userinfo_session.getRole()!=1){//当前登录用户不是系统管理员
	response.sendRedirect("work/main.jsp");
	return ;
}
int role = userinfo_session.getRole();
int comopany = userinfo_session.getCompany();
if(role==1&&comopany!=0){//如果是租户管理员
	response.sendRedirect("company/main.jsp");
	return;
}
response.sendRedirect("media.jsp");
%>
