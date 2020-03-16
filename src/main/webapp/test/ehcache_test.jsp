<%@ page import="org.apache.axis.client.*,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.system.*,com.danga.MemCached.*,net.sf.ehcache.*"%>
<%
TableUtil tu = new TableUtil();
int cid = 9893;//彩视界
int i = 0;
Channel channel = CmsCache.getChannel(cid);
String sql = "select id from "+channel.getTableName()+" where Active=1";
ResultSet rs = tu.executeQuery(sql);
while(rs.next())
{
	i++;
	int itemid = rs.getInt("id");
	Document doc = new Document(itemid,cid);
	CacheUtil.put("document_"+cid+"_"+itemid,doc);
}
tu.closeRs(rs);

out.println("保持了"+i+"个文档对象到缓存");
%>