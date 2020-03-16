<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
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
	UserGroup parentGroup = new UserGroup(id);
	
	try{
		UserGroup group = new UserGroup();
		group.Delete(id);

		result = "{\"group\":"+id+",\"SuperGroup\":"+parentGroup.getParent()+",\"msg\":\"\"}";
	}catch(MessageException e){
		result = "{\"group\":"+id+",\"SuperGroup\":"+parentGroup.getParent()+",\"msg\":\""+e.getMessage()+"\"}";
	}	
}

out.println(result);
%>
