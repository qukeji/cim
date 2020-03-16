<%@ page import="java.io.File,tidemedia.cms.util.Util,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

String	FileName		= getParameter(request,"Name");
if(!FileName.equals(""))
{
	String FolderName = request.getRealPath("/") + "images\\channel_icon\\";
	String  Path			= FolderName + "/" + FileName;

	File file = new File(Path);
	file.delete();

	//new Log().FileLog("删除图标",FileName,userinfo_session.getId(),0);
}
out.println(JsonUtil.success("删除成功."));
%>
