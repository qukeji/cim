<%@ page import="java.io.*,tidemedia.cms.util.Util,
				tidemedia.cms.util.FileUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%><%
String	FileName	= getParameter(request,"FileName");
String	FolderName	= getParameter(request,"FolderName");
String	Charset		= getParameter(request,"Charset");

int	SiteId		= Util.getIntParameter(request,"SiteId");
if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}

String exts = CmsCache.getParameterValue("explorer_edit_file_ext");
String ext = Util.getFileExt(FileName);
if(!(exts+",").contains(ext+","))
{
	out.println("文件类型不符合要求.");return;
}

Site site=CmsCache.getSite(SiteId);

String SiteFolder=site.getSiteFolder();

if(!FileName.equals(""))
{
	if(Charset.equals(""))
		Charset = "GB2312";

	String	filecontent = getParameter(request,"filecontent");

	String  RealPath			= Util.ClearPath(SiteFolder + "/" + FolderName + "/" + FileName);
	//String RealPath = application.getRealPath(Path);

	BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(RealPath,false),Charset));

	ot.write(filecontent,0,filecontent.length());
	ot.close();

	new Log().FileLog(LogAction.file_edit,"/" + FolderName + "/" + FileName,userinfo_session.getId(),SiteId);

	//发布
	FileUtil fileutil = new FileUtil();
	fileutil.PublishFile("/" + FolderName + "/" + FileName,SiteFolder,userinfo_session.getId(),site);
}
%>