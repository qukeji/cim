<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				org.apache.lucene.search.*,
				org.apache.lucene.store.*,
				org.apache.lucene.util.*,
				org.apache.lucene.analysis.standard.*,
				org.apache.lucene.queryParser.*,
				org.apache.lucene.document.Field,
				org.apache.lucene.index.*,
				org.apache.lucene.document.NumericField,
				java.io.*,
				tidemedia.cms.util.*"%>
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

ItemSnap item = new ItemSnap(364856);
String title = item.getTitle();
for(int i = 0;i<10000;i++)
{	
	Util.consumeTime(1000);
	item.setGlobalID(i);
	item.setTitle(title+i);
	LuceneUtil.addLucene(item);
}
out.println(title+"<br>");
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
