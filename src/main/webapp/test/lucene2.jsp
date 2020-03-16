<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,java.net.*,java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();

Sql = "select * from item_snap use index(index_3) where Status=1 and Active=1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int gid = Rs.getInt("GlobalID");
	
	Util.connectHttpUrl("http://localhost:888/cms/test/lucene.jsp?GlobalID="+gid,false);
}
tu.closeRs(Rs);
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!