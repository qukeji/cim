<%@ page import="java.io.File,
				tidemedia.cms.util.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
String	FolderName		= getParameter(request,"FolderName");
String	FileName		= getParameter(request,"FileName");
int SiteId = Util.getIntParameter(request,"SiteId");

if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

Site site=CmsCache.getSite(SiteId);
String SiteFolder=site.getSiteFolder();
	if(!FileName.equals(""))
	{
		FileUtil fileutil = new FileUtil();
		fileutil.PublishFiles(FileName,FolderName,SiteFolder,userinfo_session.getId(),site);
	}
	response.sendRedirect("file_list.jsp?FolderName="+FolderName+"&SiteId="+SiteId);
%>
