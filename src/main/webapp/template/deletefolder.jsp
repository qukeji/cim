<%@ page import="java.io.File,
				tidemedia.cms.util.FileUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Action = getParameter(request,"Action");
if(Action.equals("Delete"))
{
	String	FolderName		= getParameter(request,"FolderName");
	if(!FolderName.equals(""))
	{
		String TemplateFolder = defaultSite.getTemplateFolder();

		String  Path			= TemplateFolder + "/" + FolderName;

		String RealPath = (Path);
	//	System.out.println("realpath:"+RealPath);
		File file = new File(RealPath);
		FileUtil fileutil = new FileUtil();
		fileutil.DeleteFolder(file);
	}
	response.sendRedirect("template_tree.jsp");
}
%>
