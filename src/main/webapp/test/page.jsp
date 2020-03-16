<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.page.*,
				magick.*,
				java.awt.*,
				tidemedia.cms.util.*,tidemedia.cms.system.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>

<%
TableUtil tu = new TableUtil();
TableUtil tu2 = new TableUtil();

String sql = "select * from page_content where id=45107 order by id desc";
String s = "";
ResultSet rs = tu.executeQuery(sql);
if(rs.next())
{
	s = rs.getString("content");
}
tu.closeRs(rs);
out.println(s);


/*
String sql = "select * from channel_s14_b";
ResultSet rs = tu.executeQuery(sql);
while(rs.next())
{
	int r = rs.getInt("Random");
	int id = rs.getInt("id");
	out.println(id+","+rs.getString("Title")+","+r+"<br>");
	int random = new java.util.Random().nextInt(999)+1;
	tu2.executeUpdate("update channel_s14_b set Random = "+random +" where id="+id);

}
tu.closeRs(rs);
*/
%>
