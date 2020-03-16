<%@page import="java.util.*"%>
<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.publish.PublishManager,
				java.sql.*"%>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="javax.print.Doc" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//轮播图排序接口
TableUtil tu = new TableUtil();
int user = userinfo_session.getId();
String sql = "";
String  itemids = getParameter(request,"itemids");
int  ChannelID = getIntParameter(request,"ChannelID");
String TableName = CmsCache.getChannel(ChannelID).getTableName();
String itemid[] = itemids.split(",");
ArrayList<Long> list = new ArrayList<Long>();
HashMap<String,String> map = new HashMap<String,String>();
for(int i=0;i<itemid.length;i++){
	int id =Integer.parseInt(itemid[i]) ;
	Document doc=new Document(id,ChannelID);
	list.add(doc.getOrderNumber());
}
Collections.sort(list);
Collections.reverse(list);
for(int i=0;i<itemid.length;i++){
	int id =Integer.parseInt(itemid[i]) ;
	Document doc1=new Document(id,ChannelID);
	int globalID = doc1.getGlobalID();
	sql = "update " + TableName + " set OrderNumber="
			+ list.get(i) + " where id=" + id;
	tu.executeUpdate(sql);
	sql = "update item_snap set OrderNumber=" + list.get(i)
			+ " where GlobalID=" + globalID;
	tu.executeUpdate(sql);
	
}
PublishManager publishmanager = PublishManager.getInstance();
publishmanager.DocumentPublish(ChannelID, user);
out.println("Refresh");



%>
