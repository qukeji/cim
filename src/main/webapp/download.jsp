<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="config.jsp"%><%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String	Type		= getParameter(request,"Type");
String	FileName	= getParameter(request,"FileName");
String	FolderName	= getParameter(request,"FolderName");
String	Charset		= getParameter(request,"Charset");

int SiteId=Util.getIntParameter(request,"SiteId");

String SiteFolder="";

if(Charset.equals(""))
	Charset = "GB2312";

String	Template		= getParameter(request,"Template");

if(Template.equals("True"))
{
	SiteFolder = CmsCache.getDefaultSite().getTemplateFolder();
}
else if(Template.equals("backup")){
SiteFolder = CmsCache.getDefaultSite().getBackupFolder();
}else
{
	Site site=CmsCache.getSite(SiteId);
	if(SiteId!=0){
	 SiteFolder=site.getSiteFolder();
	}
}

String  Path			= SiteFolder + "/" + FolderName;

FileUtil fileutil = new FileUtil();
fileutil.setActionuser(userinfo_session.getId());

//System.out.println(Path);
if(Type.equals("File"))
{
	if(!FileName.equals(""))
	{
		String[] files = Util.StringToArray(FileName,",");//System.out.println(Path + "/" + files[0]);
		if(files!=null && files.length>0)
		{
			fileutil.downloadFile(request,response,FolderName + "/" + files[0],"csv/downloadable",files[0],SiteId);
		}
	}
}
else if(Type.equals("Folder"))//обтьд©б╪
{
	if(!FolderName.equals(""))
	{
		fileutil.downloadFolder(request,response,FolderName,SiteId);
	}
}
%>