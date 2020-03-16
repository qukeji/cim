<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
int 	id			=Util.getIntParameter(request,"id");
String	Type		= Util.getParameter(request,"Type");
TableUtil tu = new TableUtil();
if(Type.equals("File")){
	String sql="select * from template_files where id="+id;
	ResultSet Rs=tu.executeQuery(sql);
	response.setContentType("application/x-msdownload;");
	if(Rs.next()){
		String  FileName=tu.convertNull(Rs.getString("FileName"));
		String Content=tu.convertNull(Rs.getString("Content"));
		String m_contentDisposition = "attachment;";
		StringBuffer buf = new StringBuffer();
		buf.append(String.valueOf(m_contentDisposition));
		buf.append(" filename=");
		buf.append(FileName);
		response.setHeader(
				"Content-Disposition",
				String.valueOf(buf));
		response.getOutputStream().write(Content.getBytes("utf-8"));
		out.clear(); 
        out = pageContext.pushBody(); 
	}
	tu.closeRs(Rs);
}
%>
