<%@ page import="java.io.File,tidemedia.cms.util.Util,
				tidemedia.cms.util.FileUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int SiteId=Util.getIntParameter(request,"SiteId");
if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

String s = "";

String Action = getParameter(request,"Action");
if(Action.equals("Delete"))
{
	String	FolderName		= getParameter(request,"FolderName");
	
	Site site=CmsCache.getSite(SiteId);
    String SiteFolder=site.getSiteFolder();
	if(!FolderName.equals(""))
	{
	
	
		String  Path			= SiteFolder + "/" + FolderName;

		//String RealPath = application.getRealPath(Path);
		String RealPath = Path;
	//	System.out.println("realpath:"+RealPath);
		File file = new File(RealPath);
		FileUtil fileutil = new FileUtil();
		fileutil.DeleteFolder(file);

		new Log().FileLog(LogAction.folder_delete,"/" + FolderName,userinfo_session.getId(),SiteId);

		String parentFolder = FolderName.substring(0,FolderName.lastIndexOf("/"));

		File parentFile = new File(SiteFolder + parentFolder);  
		File[] listFiles = parentFile.listFiles();  
		if(listFiles==null || listFiles.length == 0){  
			parentFolder = parentFolder.substring(0,parentFolder.lastIndexOf("/"));
		}

		s = "{\"foldername\":\""+FolderName+"\",\"parentFolder\":\""+parentFolder+"\",\"siteid\":"+SiteId+",\"type\":2,\"site\":false}";
	}
}

out.println(s);
%>
