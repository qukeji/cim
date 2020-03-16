<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String channelcode = "3625_12587_12599";
TableUtil tu = new TableUtil();
TableUtil tu_comment = new TableUtil("comment");
String Sql = "select * from channel where ChannelCode like '"+channelcode + "%'";
ResultSet Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int id_ = Rs.getInt("id");
	int parent = Rs.getInt("Parent");
	String name = tu.convertNull(Rs.getString("Name"));
	String code = tu.convertNull(Rs.getString("ChannelCode"));

	if(code.equals(channelcode))
		parent = -1;

	boolean isexist = false;
	Sql = "select * from comment_channel where channelid="+id_;
	ResultSet rs = tu_comment.executeQuery(Sql);
	if(rs.next())
	{
		isexist = true;
	}
	tu_comment.closeRs(rs);

	if(isexist)
	{
		Sql = "update comment_channel set name='" + tu_comment.SQLQuote(name) + "',parentid=" + parent + " where channelid=" + id_;
	}
	else
	{
		Sql = "insert into comment_channel(channelid,name,parentid) values("+id_+",'" + tu_comment.SQLQuote(name) + "'," + parent + ")";
	}
	tu_comment.executeUpdate(Sql);

	out.println(name+"<br>");
}
tu.closeRs(Rs);
%>