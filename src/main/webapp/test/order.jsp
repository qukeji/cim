<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				org.apache.axis.client.*,
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
		
TableUtil tu = new TableUtil();
TableUtil tu2 = new TableUtil();
TableUtil tu3 = new TableUtil();

String sql = "select id from channel where Type=0";
ResultSet rsrs = tu3.executeQuery(sql);
while(rsrs.next())
{
	Channel ch  = CmsCache.getChannel(rsrs.getInt("id"));
	int max_order = 0;
	sql = "select max(OrderNumber) from " + ch.getTableName()+" where OrderNumber<10000000";
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		max_order = rs.getInt(1);
	}
	tu.closeRs(rs);

	if(max_order>0)
	{
		boolean need = false;
		sql = "select id,OrderNumber from " + ch.getTableName()+" where OrderNumber>10000000 order by OrderNumber asc";
		rs = tu.executeQuery(sql);
		while(rs.next())
		{
			need = true;
			int id = rs.getInt("id");
			max_order = max_order + 20;
			sql = "update " + ch.getTableName() + " set OrderNumber=" + max_order + " where id=" + id;
			tu2.executeUpdate(sql);
		}
		tu.closeRs(rs);

		if(need) out.println(ch.getName()+"("+ch.getId()+")<br>");
	}
}
tu3.closeRs(rsrs);
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!