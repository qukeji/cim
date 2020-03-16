<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.spider.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
String result = "{}";
int		id		= getIntParameter(request,"id");
String	Action	= getParameter(request,"Action");
if(Action.equals("Delete")&&id!=0)
{   SpiderGroup parentGroup = new SpiderGroup(id);
	SpiderGroup group = new SpiderGroup();
	group.Delete(id);
	
	result = "{\"group\":"+id+",\"SuperGroup\":"+parentGroup.getParent()+"}";
}
out.println(result);
%>
