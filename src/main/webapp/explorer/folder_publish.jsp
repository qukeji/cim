<%@ page import="java.io.File,tidemedia.cms.util.Util,
				tidemedia.cms.util.FileUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
int SiteId = Util.getIntParameter(request,"SiteId");
if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

String s = "";

String Action = getParameter(request,"Action");
if(Action.equals("Publish"))
{
	String	FolderName		= getParameter(request,"FolderName");
	
	Site site=CmsCache.getSite(SiteId);
    String SiteFolder=site.getSiteFolder();
	if(!FolderName.equals(""))
	{
		String  Path			= SiteFolder + "/" + FolderName;

		String InsertFolderName = "";

		File file = new File(Path);
		FileUtil fileutil = new FileUtil();
		fileutil.PublishFolder(file,SiteFolder,userinfo_session.getId(),site);

		String parentFolder = FolderName.substring(0,FolderName.lastIndexOf("/"));
		s = "{\"foldername\":\""+FolderName+"\",\"parentFolder\":\""+parentFolder+"\",\"siteid\":"+SiteId+",\"type\":2,\"site\":false}";
	}
}
out.println(s);
%>
