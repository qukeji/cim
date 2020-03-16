<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ItemID		=	getIntParameter(request,"ItemID");
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		SChannelID	=	getIntParameter(request,"sourceChannelID");
System.out.println("ok");
String js = "";
//System.out.println(SChannelID);
if((SChannelID!=0) && ItemID!=0)
{//System.out.println(SChannelID);
	Channel ch = CmsCache.getChannel(ChannelID);

	String s = "";
	String TableName = "";

	TableName = ch.getTableName();
	//System.out.println(TableName);
		
	if(SChannelID>0)
	{
		Channel channel = CmsCache.getChannel(ChannelID);
		s = channel.getRecommendOutRelation();
	}

	String Title = "";
	String Href = "";

	TableUtil tu = new TableUtil("bbs");
	String sql = "select * from cdb_threads where tid="+ItemID;
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		Title = convertNull(rs.getString("subject"));
		Href = "http://forum.vodone.com/viewthread.php?tid="+ItemID;
	}

	tu.closeRs(rs);

	String[] options = Util.StringToArray(s, "\n");
	for (int i = 0; i < options.length; i++) {
		String o = options[i].replace("\r", "");
		int index = o.lastIndexOf("=");
		if(index!=-1)
		{
			String a = o.substring(0,index);
			String b = o.substring(index+1);
			
			if(b.startsWith("getHref()"))
			{
				js += "setValue('"+a+"','"+Util.JSQuote(Href)+"');";
			}
			else if(b.startsWith("Title"))
			{
				js += "setValue('"+a+"','"+Util.JSQuote(Title)+"');";
			}
		}
	}
	js += "setValue('RecommendGlobalID','" + 0 + "');";
	js += "setValue('RecommendChannelID','" + ChannelID + "');";
	js += "setValue('RecommendItemID','" + ItemID + "');";
	js += "setValue('RecommendType','0');";

}
//System.out.println(js);
%><%=js%>