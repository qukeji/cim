<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ModuleID		=	getIntParameter(request,"ModuleID");

if(ModuleID>0)
{
	PageModule pm = new PageModule(ModuleID);
	ChannelTemplate ct = new ChannelTemplate(pm.getTemplate());

	int id = 0;

	id = ct.getChannelID();

	response.sendRedirect("content.jsp?id=" + id);
}
%>
