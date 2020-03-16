<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config1.jsp"%><%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}


String	FileName	= getParameter(request,"FileName");
String	FolderName	= getParameter(request,"FolderName");


int SiteId=31;//Util.getIntParameter(request,"SiteId");

String SiteFolder="";




	Site site=CmsCache.getSite(SiteId);
	if(SiteId!=0){
	 SiteFolder=site.getSiteFolder();
	}


String  Path			= SiteFolder + "/" + FolderName;

FileUtil fileutil = new FileUtil();
//fileutil.setActionuser(userinfo_session.getId());

//System.out.println(Path);

if(!FileName.equals(""))
	{
		String[] files = Util.StringToArray(FileName,",");//System.out.println(Path + "/" + files[0]);
		if(files!=null && files.length>0)
		{
			fileutil.downloadFile(request,response,FolderName + "/" + files[0],"csv/downloadable",files[0],SiteId);
		}
	}

%>