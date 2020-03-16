<%@ page import="java.io.File,tidemedia.cms.util.Util,
				tidemedia.cms.util.*,
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
	String	FileName		= getParameter(request,"FileName");
	int SiteId=Util.getIntParameter(request,"SiteId");
	Site site=CmsCache.getDefaultSite();
    String SiteFolder=site.getBackupFolder();
	if(!FileName.equals(""))
	{
		String  Path			= SiteFolder + "/" + FolderName;

		String[] files = Util.StringToArray(FileName,",");
		if(files!=null && files.length>0)
		{
			for(int i=0;i<files.length;i++)
			{
				String RealPath = Path + "/" + files[i];
				File file = new File(RealPath);
				file.delete();

				//new Log().FileLog("删除备份文件","/" + FolderName + "/" + files[i],userinfo_session.getId(),SiteId);
				//System.out.println(file.getName());
			}
		}
	}
	//System.out.println("file_list.jsp?FolderName="+java.net.URLEncoder.encode(FolderName));
	response.sendRedirect("file_list.jsp?FolderName="+java.net.URLEncoder.encode(FolderName,"utf-8")+"&SiteId="+SiteId);
}
%>
