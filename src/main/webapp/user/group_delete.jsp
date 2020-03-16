<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page import="tidemedia.cms.base.MessageException" %>
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

	UserGroup group = new UserGroup();
	try {
		group.Delete(id);
	}catch (MessageException e){//用户组下还有用户，不能删除时提示
		out.println(e.getMessage());
		return;
	}
	
	
	result = "{\"group\":"+id+",\"SuperGroup\":"+parentGroup.getParent()+"}";
//	response.sendRedirect("user_tree.jsp?Action=Delete");
}

out.println(result);
%>
