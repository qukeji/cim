<%@ page import="tidemedia.cms.util.Util,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.system.*"%><%@ page contentType="text/html;charset=utf-8" %><%response.setContentType("text/xml");%><%response.setHeader("Pragma","No-cache"); response.setHeader("Cache-Control","no-cache"); response.setDateHeader("Expires", 0);%><?xml version="1.0"  encoding="utf-8"?>
<%@ include file="../config.jsp"%>
<%
int id = getIntParameter(request,"channelid");
TableUtil tu = new TableUtil("comment");
TableUtil tu2 = new TableUtil("comment");
out.println("<tree>");

String sql = "SELECT * FROM comment_channel where parentid="+id;

ResultSet rs = tu.executeQuery(sql);
while(rs.next())
{
	int cid = rs.getInt("channelid");
	String name = tu.convertNull(rs.getString("name"));
	boolean haschild = false;
	sql = "SELECT * FROM comment_channel where parentid="+cid+" limit 1";
	ResultSet rsrs = tu2.executeQuery(sql);
	if(rsrs.next())
	{
		haschild = true;
	}
	tu2.closeRs(rsrs);

	String icon = " icon=\"../images/tree/16_channel_icon.png\" openIcon=\"../images/tree/16_openchannel_icon.png\"";

	if (haschild)
	{
		out.println("<tree text=\"" + Util.XMLQuote(name)
		+ "\" src=\"channel_xml.jsp?channelid="+cid+ "\" action=\"javascript:show("
		+ cid + ");&quot; ChannelID=" + cid
		+ " ChannelType=&quot;\"" + icon+ " />\r\n");
	} 
	else
	{
		out.println("<tree text=\"" + Util.XMLQuote(name)
		+ "\" action=\"javascript:show(" + cid
		+ ");&quot; ChannelID=" + cid
		+ " ChannelType=&quot;\"" + icon+ " />\r\n");
	}
}
tu.closeRs(rs);

out.println("</tree>");
%>
