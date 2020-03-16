<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.util.ArrayList,
				redis.clients.jedis.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%

Jedis jedis = new Jedis("localhost");
/*
jedis.set("foo", "bar");
String value = jedis.get("foo");
out.println(value);
*/


//out.println("<br>"+doc2.getTitle());

long publishbegin = System.currentTimeMillis();
for(int i = 4000;i<7000;i++)
{
	Document doc1 = CmsCache.getDocument(i,3);
	//out.println(i+","+doc1.getTitle()+"<br>");
}
long publishend = System.currentTimeMillis();
long time1 = publishend-publishbegin;

TableUtil tu = new TableUtil();
ResultSet rs = tu.executeQuery("select id from channel");
publishbegin = System.currentTimeMillis();
while(rs.next())
{
	int id = rs.getInt("id");
	try{
	Channel ch = CmsCache.getChannel(id);
	//out.println(id+","+ch.getName()+"<br>");
	}catch(Exception e){}
}
publishend = System.currentTimeMillis();
out.println(time1 + ","+(publishend-publishbegin));
tu.closeRs(rs);
%>