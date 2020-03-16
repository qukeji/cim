<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
int gid = getIntParameter(request,"GlobalID");

if(gid>0)
{
	Document doc = new Document(gid);

	TableUtil tu_comment = new TableUtil("comment");

	boolean isexist = false;
	String Sql = "select * from comment_item where itemid="+gid;
	ResultSet rs = tu_comment.executeQuery(Sql);
	if(rs.next())
	{
		isexist = true;
	}
	tu_comment.closeRs(rs);

	if(isexist)
	{
		Sql = "update comment_item set title='" + tu_comment.SQLQuote(doc.getTitle()) + "',channelid=" + doc.getChannelID() + " where itemid=" + gid;
	}
	else
	{
		Sql = "insert into comment_item(title,channelid,itemid) values('" + tu_comment.SQLQuote(doc.getTitle()) + "'," + doc.getChannelID() + "," + gid + ")";
	}
	tu_comment.executeUpdate(Sql);

	System.out.println("update comment item:"+doc.getTitle());
}
%>