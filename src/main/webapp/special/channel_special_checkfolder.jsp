<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,java.io.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
request.setCharacterEncoding("utf-8");

int	id		=	getIntParameter(request,"id");
String	Folder				= getParameter(request,"Folder");
Channel channel = CmsCache.getChannel(id);
String folder2 = channel.getSite().getSiteFolder()+"/"+channel.getFullPath() + "/" + Folder;
File f = new File(folder2);
if(f.exists())
{out.println("1");}
else{out.println("0");}%>