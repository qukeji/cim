<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int		id		= getIntParameter(request,"id");
int		From	= getIntParameter(request,"From");
String	Action	= getParameter(request,"Action");
if(Action.equals("Delete")&&id!=0)
{
	Channel channel = CmsCache.getChannel(id);

	int parent = channel.getParent();

	if(channel.getType()==Channel.Site_Type)
	{
		Site site = channel.getSite();
		site.Delete(site.getId());
	}
	else
	{
		channel.setActionUser(userinfo_session.getId());
		channel.Delete(id);
	}
	String success= "{\"status\":1,\"message\":2}";
	
	if(From==1){
	 	response.sendRedirect("index.jsp");
	} else{
		out.println(success);		
	}
     return;
}
%>
