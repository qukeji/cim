<%@ page import="tidemedia.cms.util.*,
				java.io.File,
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
    String Url=site.getUrl();
//System.out.println(FolderName+":"+FileName);

	//windows系统不做编码，直接返回汉字 2011-11-09
	if(System.getProperty("os.name").toUpperCase().indexOf("WINDOWS")==-1)
	{
		FileName = java.net.URLEncoder.encode(FileName,"utf-8");
	}
	else
	{
		//windows系统也编码，否则会出错，2013-1-17
		FileName = java.net.URLEncoder.encode(FileName,"utf-8");
	}
	//out.println("FileName:"+FileName);
	FolderName = java.net.URLEncoder.encode(FolderName,"utf-8");
	FolderName = FolderName.replace("%2F","/");
   
	if(Url.endsWith("/"))
		Url += FolderName;
	else
		Url += "/" + FolderName;

	if(Url.endsWith("/"))
		Url += FileName;
	else
		Url += "/" + FileName;

	response.sendRedirect(Util.ClearPath(Url));
%>
