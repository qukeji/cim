<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int		PageID			= getIntParameter(request,"PageID");
int		ModuleID		= getIntParameter(request,"ModuleID");
int		Index			= getIntParameter(request,"Index");

String	Action	= getParameter(request,"Action");
if(PageID>0)
{
	Page p = new Page(PageID);

	p.CopyModuleCode(ModuleID,Index);
	
	response.sendRedirect("page.jsp?id=" + PageID);
}
%>
