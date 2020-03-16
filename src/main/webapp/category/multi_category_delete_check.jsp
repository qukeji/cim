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

<%
	int child = 0 ;

	//删除记录
	int itemid  = getIntParameter(request,"itemid");
	int channelid = getIntParameter(request,"channelid");
	Channel channel = CmsCache.getChannel(channelid);
	String channel_name = channel.getTableName();

	String sql = "select * from "+channel_name+" where Parent="+itemid;
	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		child = 1 ;//有子频道
	}
	tu.closeRs(rs);

	out.println(child);
%>
