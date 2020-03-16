<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
int 	id			=Util.getIntParameter(request,"id");
String	content		= "";

TableUtil tu = new TableUtil();
	String sql="select * from template_files where id="+id;
	ResultSet Rs=tu.executeQuery(sql);
	response.setContentType("application/x-msdownload;");
	if(Rs.next()){
		content=tu.convertNull(Rs.getString("Content"));
	}
	tu.closeRs(Rs);
out.println(content);%>