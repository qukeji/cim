<%@ page import="tidemedia.cms.system.*,
				org.apache.tools.zip.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.io.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
	public void deleteInfo(ResultSet rs, String channel_name, int Parent) throws Exception
	{

		TableUtil tu3 = new TableUtil();
		String sql3 = "delete from "+channel_name+" where id="+Parent;
		tu3.executeUpdate(sql3);

		TableUtil tu2 = new TableUtil();
		String sql2 = "select * from "+channel_name+" where Parent="+Parent;
		
		rs = tu2.executeQuery(sql2);
		while(rs.next())
		{
			int itemid = rs.getInt("id");
			deleteInfo(rs, channel_name, itemid);
		}
		
	}

%>
<%
	//删除记录
	int itemid  = getIntParameter(request,"itemid");
	int channelid = getIntParameter(request,"channelid");
	Document doc = new Document(itemid,channelid);
	Channel channel = CmsCache.getChannel(channelid);
	String channel_name = channel.getTableName();
	int Parent = Integer.parseInt(doc.getValue("Parent"));
	TableUtil tu = new TableUtil();
	ResultSet rs = null;
	//判断是否有下一级，如果有下一级则先删除下一级
	if(Parent==0)
	{
		String sql = "delete from "+channel_name+" where id="+itemid;
		tu.executeUpdate(sql);
		deleteInfo(rs, channel_name, itemid);
		tu.closeRs(rs);
	}
	else
	{
		deleteInfo(rs, channel_name, itemid);
		tu.closeRs(rs);
	}

	//检查更新删除信息后 更新父的hasNextLevel字段
	TableUtil tu_check = new TableUtil();
	String sql_check = "select * from "+channel_name+" where Status=1 and Parent="+Parent;
	
	ResultSet rs_check = tu_check.executeQuery(sql_check);
	if(!rs_check.next())
	{
		TableUtil tu_update = new TableUtil();
		String sql_update = "update "+channel_name+" set hasNextLevel=0 where status=1 and id="+Parent;
		tu_update.executeUpdate(sql_update);
	}
	tu_check.closeRs(rs_check);
%>
