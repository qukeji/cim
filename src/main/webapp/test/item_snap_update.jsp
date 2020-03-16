<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.publish.*,
				org.apache.commons.net.ftp.*,
				tidemedia.cms.video.*,
				java.io.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	int channelid = 4533;
	TableUtil tu = new TableUtil();
	TableUtil tu2 = new TableUtil();
	Channel ch = new Channel(channelid);
	String Sql = "SELECT * FROM " + ch.getTableName() + "";
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		int itemid = Rs.getInt("id");
		int gid = Rs.getInt("GlobalID");
		int category = Rs.getInt("Category");
		int channelid_ = channelid;
		if(category>0) channelid_ = category;
		Document document = new Document(itemid,channelid_);
		if(gid==0)
		{
			new tidemedia.cms.system.ItemSnap().Add(document);//加入全局库			
		}
		else
		{
			tu2.executeUpdate("delete from item_snap where GlobalID="+gid);
			tu2.executeUpdate("update "+ch.getTableName()+" set GlobalID=0 where id="+itemid);
			new tidemedia.cms.system.ItemSnap().Add(document);//加入全局库	
		}
		out.println(document.getTitle()+","+gid+"<br>");
	}
	tu.closeRs(Rs);
%>