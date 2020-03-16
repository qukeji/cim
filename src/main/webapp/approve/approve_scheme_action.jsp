<%@ page import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

int id = getIntParameter(request,"id");
String Action = getParameter(request,"Action");

ApproveScheme as = new ApproveScheme(id);
as.setUserId(userinfo_session.getId());

//开启
if(Action.equals("Enable"))
{
	as.Enable();
}
//关闭
if(Action.equals("Disable"))
{
	as.Disable();
}

response.sendRedirect("approve_scheme.jsp");

%>
