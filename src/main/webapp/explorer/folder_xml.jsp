<%@ page import="tidemedia.cms.util.Util,tidemedia.cms.system.*,java.io.*,java.util.Arrays"%><%@ page contentType="text/html;charset=utf-8" %><%response.setContentType("text/xml");%><%response.setHeader("Pragma","No-cache"); response.setHeader("Cache-Control","no-cache"); response.setDateHeader("Expires", 0);%><?xml version="1.0"  encoding="utf-8"?>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
String Path = getParameter(request,"Path");
int SiteId = Util.getIntParameter(request,"SiteId");
if(!CheckExplorerSite(userinfo_session,SiteId))
{ response.sendRedirect("../noperm.jsp");return;}
//String RealPath = application.getRealPath(RootPath + "/" + Path);
Site site=CmsCache.getSite(SiteId);
String SiteFolder	=	site.getSiteFolder();
if (SiteFolder.equals("")){
%>
<tree></tree>
<%
}else{
String RealPath = SiteFolder + "/" + Path;
File file = new File(RealPath);
if(file==null) {out.println("<tree></tree>");return;}
File[] files = file.listFiles(new FilenameFilter()
                {
                    public boolean accept(File file,String name)
                    {
                      return file.isDirectory();
                    }                     
                });
//out.println("<!--list1:"+(System.currentTimeMillis()-begin_time)+"ms-->");
if(files==null) {out.println("<tree></tree>");return;}
Arrays.sort(files);//按文件名排序
//out.println("<!--list2:"+(System.currentTimeMillis()-begin_time)+"ms-->");

%>
<tree>
	<%
	//For each newNode in Root.SubFolders
	for(int i = 0;files!=null && i<files.length;i++)
	{
		if(files[i].isDirectory() && !(files[i].getName().equalsIgnoreCase("WEB-INF")))
		{
			String FolderName = files[i].getName();

			File file2 = new File(RealPath+"/"+FolderName);
			File[] files2 = file2.listFiles(new FilenameFilter()
                {
                    public boolean accept(File file,String name)
                    {
                      return file.isDirectory();
                    }                     
                });			
			if(files2.length>0)
			{
				//out.println("<!--list2:"+(System.currentTimeMillis()-begin_time)+"ms-->");
	%>
	<tree text="<%=FolderName%>" src="folder_xml.jsp?Path=<%=java.net.URLEncoder.encode(Path + "/" + FolderName,"utf-8")%>&amp;SiteId=<%=SiteId%>" action="javascript:ListFile()&quot; FolderName=&quot;<%=Path + "/" + FolderName%>&quot;SiteId=&quot;<%=SiteId%>"/>
	<%
			}
			else
			{
	%>
	<tree text="<%=FolderName%>" action="javascript:ListFile()&quot; FolderName=&quot;<%=Path + "/" + FolderName%>&quot;SiteId=&quot;<%=SiteId%>" />
	<%
			}
		}
	}
	%>
</tree>
<%}%>
<!--<%=(System.currentTimeMillis()-begin_time)%>ms-->