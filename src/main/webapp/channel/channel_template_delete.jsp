<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		id			= getIntParameter(request,"id");
int		ChannelID	= getIntParameter(request,"ChannelID");
String	Action	= getParameter(request,"Action");
if(Action.equals("Delete")&&id!=0)
{
	ChannelTemplate ct = new ChannelTemplate(id);
	//ct.setRootPath(application.getRealPath(RootPath));
	ct.Delete(id);

	response.sendRedirect("channel.jsp?id="+ChannelID);
}
%>
