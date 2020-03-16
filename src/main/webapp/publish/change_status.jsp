<%@ page import="java.sql.*,tidemedia.cms.util.Util,
				tidemedia.cms.publish.PublishScheme,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

int id = getIntParameter(request,"id");
String Action = getParameter(request,"Action");
int SiteId=Util.getIntParameter(request,"SiteId");
//PublishScheme publishscheme = new PublishScheme(id);
PublishScheme publishscheme =CmsCache.getPublishScheme(id);
publishscheme.setUserId(userinfo_session.getId());
if(Action.equals("Enable"))
{
	
	publishscheme.Enable();
	
}

if(Action.equals("Disable"))
{
	publishscheme.Disable();
}

//  CmsCache.getSite(publishscheme.getSite()).clearPublishSchemes();
 response.sendRedirect("setup2018.jsp?SiteId="+SiteId);
%>
