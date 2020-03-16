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

	response.sendRedirect("document.jsp?ItemID=0&ChannelID=" + ct.getChannelID());
}
%>
