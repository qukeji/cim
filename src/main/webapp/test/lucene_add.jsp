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

int from = getIntParameter(request,"from");
int to = from + 50000;

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
long begin_time = System.currentTimeMillis();

boolean reload = false;

Sql = "select GlobalID from item_snap where GlobalID<=4000000 and GlobalID>=3500000";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	ItemSnap item = new ItemSnap(Rs.getInt("GlobalID"));
	LuceneUtil.addLucene(item,true);
}
tu.closeRs(Rs);
//writer.optimize();
//writer.close();	
//writer.commit();
//writer.optimize();
out.println(to);
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<script language="JavaScript">
function myrefresh()
{
       window.location = "lucene_add.jsp?from=<%=to%>";
}
<%if(reload){%>setTimeout('myrefresh()',1000);<%}%>
</script>
<%=(System.currentTimeMillis()-begin_time)%>ms