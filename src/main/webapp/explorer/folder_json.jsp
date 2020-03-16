<%@ page import="tidemedia.cms.system.*,org.json.*,java.sql.*,tidemedia.cms.base.*,java.io.*,tidemedia.cms.util.*,java.util.*,java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int SiteId = Util.getIntParameter(request,"SiteId");
if(!(userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator())){ 
	out.println("[]");
	return;
}

if(userinfo_session.isSiteAdministrator())
{
	if(!userinfo_session.getSite().equals(SiteId+""))
	{
		out.println("[]");
		return;
	}
}
long begin_time = System.currentTimeMillis();
String Path = getParameter(request,"Path");

Site site=CmsCache.getSite(SiteId);
String SiteFolder	=	site.getSiteFolder();

JSONArray array = new JSONArray();

if (SiteFolder.equals("")){
	out.println(array);
	return;
}else{

	String RealPath = SiteFolder + "/" + Path;
	File file = new File(RealPath);
	if(file==null) {
		out.println(array);return;
	}
	File[] files = file.listFiles(new FilenameFilter()
                {
                    public boolean accept(File file,String name)
                    {
                      return file.isDirectory();
                    }                     
                });
	if(files==null) {
		out.println(array);return;
	}
	Arrays.sort(files);

	for(int i = 0;files!=null && i<files.length;i++){

		JSONObject o = new JSONObject();

		if(files[i].isDirectory() && !(files[i].getName().equalsIgnoreCase("WEB-INF"))){

			String FolderName = files[i].getName();

			File file2 = new File(RealPath+"/"+FolderName);

			File[] files2 = file2.listFiles(new FileFilter()
                {
                    public boolean accept(File file)
                    {
                      return file.isDirectory();
                    }                     
                });			

			if(files2.length>0){
				o.put("load",1);
			}else{
				o.put("load",0);
			}

			o.put("name",FolderName);
			o.put("folderName",Path + "/" + FolderName);
			o.put("icon","");
			o.put("siteId",SiteId);
			
			array.put(o);
		}
	}
}
out.println(array);	

%>