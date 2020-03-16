<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
String tomcatPath = request.getRealPath("/");
String	FileName	= getParameter(request,"FileName");

FileUtil fileutil = new FileUtil();
if(!FileName.equals(""))
{
	fileutil.downloadFile(request,response,tomcatPath+"/temp/"+ FileName,"csv/downloadable",FileName,0);
}
%>