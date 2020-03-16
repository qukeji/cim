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

String sql = "select GlobalID,ItemID,ChannelID from item_snap where OrderNumber>10000000";
ResultSet rsrs = tu3.executeQuery(sql);
while(rsrs.next())
{
	Channel ch  = CmsCache.getChannel(rsrs.getInt("ChannelID"));
	int itemid = rsrs.getInt("ItemID");
	int gid = rsrs.getInt("GlobalID");

	sql = "select OrderNumber from " + ch.getTableName() + " where id=" + itemid;
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		int n = rs.getInt("OrderNumber");
		tu2.executeUpdate("update item_snap set OrderNumber="+n + " where GlobalID=" + gid);
	}
	tu.closeRs(rs);
}
tu3.closeRs(rsrs);
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!