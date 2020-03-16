<%@ page import="tidemedia.cms.util.Util,java.io.File,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%response.setContentType("text/xml");%><%response.setHeader("Pragma","No-cache"); response.setHeader("Cache-Control","no-cache"); response.setDateHeader("Expires", 0);%><?xml version="1.0"  encoding="utf-8"?>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String TemplateFolder =CmsCache.getDefaultSite().getTemplateFolder();

String Path = getParameter(request,"Path");
String RealPath = (TemplateFolder + "/" + Path);
File file = new File(RealPath);
File[] files = file.listFiles();
//System.out.println("load11");
%>
<tree>
	<%
	//For each newNode in Root.SubFolders
	for(int i = 0;i<files.length;i++)
	{
		if(files[i].isDirectory())
		{
			String FolderName = files[i].getName();
			if(Util.isHasSubFolder(RealPath+"/"+FolderName))
			{
	%>
	<tree text="<%=FolderName%>" src="folder_xml.jsp?Path=<%=java.net.URLEncoder.encode(Path + "/" + FolderName,"utf-8")%>" action="javascript:ListFile()&quot; FolderName=&quot;<%=Path + "/" + FolderName%>"/>
	<%
			}
			else
			{
	%>
	<tree text="<%=FolderName%>" action="javascript:ListFile()&quot; FolderName=&quot;<%=Path + "/" + FolderName%>" />
	<%
			}
		}
	
	}
	%>
</tree>
