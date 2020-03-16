<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String result = "{}";

int		id		= getIntParameter(request,"id");
String	Action	= getParameter(request,"Action");
if(Action.equals("Delete")&&id!=0)
{
	TemplateGroup parentGroup = new TemplateGroup(id);

	TemplateGroup group = new TemplateGroup();
	group.Delete(id);
	
	result = "{\"group\":"+id+",\"SuperGroup\":"+parentGroup.getParent()+"}";
	//response.sendRedirect("template_tree.jsp?Action=Delete");
}
out.println(result);
%>