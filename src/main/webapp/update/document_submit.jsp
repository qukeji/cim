<%@ page import="tidemedia.cms.system.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=gb2312" %>
<%@ include file="../config.jsp"%>
<%
String Action = getParameter(request,"Action");
//System.out.print("Title:"+Title);
String filepath = getParameter(request,"filepath");
String filename = getParameter(request,"filename");
//System.out.print("Title:"+Title);
if(!filename.equals("")){
	if(!filepath.endsWith("/")){
		filepath+="/";
	}
	String site="d:/web/tidecms_update";
	File file = new File(site+filepath+filename);
	Long filesize;
	if(file.exists()){
		filesize=file.length();
		out.println(filesize);
	}
}
if(!Action.equals(""))
{
}
%>

