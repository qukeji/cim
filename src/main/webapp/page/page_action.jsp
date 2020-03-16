<%@ page import="tidemedia.cms.system.*,tidemedia.cms.page.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int		pageID		= getIntParameter(request,"pageID");
int		frameID		= getIntParameter(request,"frameID");
int		moduleID	= getIntParameter(request,"moduleID");
String	Action		= getParameter(request,"Action");

if(pageID>0)
{
	Page p = new Page(pageID);
	p.setActionUser(userinfo_session.getId());
	
	if(Action.equals("DeleteFrame"))
	{
		if(!new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageFrameEdit))
		{
			response.sendRedirect("../noperm.jsp");return;
		}
		p.delFrame(frameID);
		//response.sendRedirect("page_edit.jsp?id="+id);return;
	}
	else if(Action.equals("MoveFrame"))
	{
		if(!new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageFrameEdit))
		{
			response.sendRedirect("../noperm.jsp");return;
		}
		int frameID2 = getIntParameter(request,"frameID2");

		p.moveFrame(frameID,frameID2);
	}
	else if(Action.equals("MoveModule"))
	{
		if(!new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageModuleEdit))
		{
			response.sendRedirect("../noperm.jsp");return;
		}
		int		moduleID2	= getIntParameter(request,"moduleID2");

		p.moveModule(moduleID,moduleID2);
		response.sendRedirect("page_edit.jsp?type=1&id="+pageID);return;
	}
	else if(Action.equals("DeleteModule"))
	{
		if(!new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageModuleEdit))
		{
			response.sendRedirect("../noperm.jsp");return;
		}
		p.delModule(moduleID);
		response.sendRedirect("page_edit.jsp?type=1&id="+pageID);return;
	}
	else if(Action.equals("DeleteModuleContent"))
	{
		if(!new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageModuleEdit))
		{
			response.sendRedirect("../noperm.jsp");return;
		}
		p.delModuleContent(moduleID);
		out.println("<script>top.TideDialogClose({refresh:'main'});</script>");return;
		//response.sendRedirect("page_edit.jsp?type=0&id="+pageID);return;
	}
	else if(Action.equals("AddModule"))
	{
		if(!new ChannelPrivilege().hasRight(userinfo_session,pageID,ChannelPrivilege.PageModuleEdit))
		{
			response.sendRedirect("../noperm.jsp");return;
		}
		p.addModule(moduleID);
		response.sendRedirect("page_edit.jsp?type=1&id="+pageID);return;
	}

	response.sendRedirect("page_edit.jsp?type=2&id="+pageID);return;
}
%>