<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,
				java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
int		ChannelID	=	getIntParameter(request,"id");

int globalid = 0;
int itemid = 0;
//System.out.println("channelid:"+ChannelID);
if(ChannelID!=0)
{
	Document doc  = ItemUtil.getNewDocument(ChannelID,userinfo_session.getId());

	if(doc!=null)
	{
		globalid = doc.getGlobalID();
		itemid = doc.getId();

		Channel ch = CmsCache.getChannel(ChannelID);
		if(ch.getType()==Channel.Category_Type)
		{
			TableUtil tu = ch.getTableUtil();
			tu.executeUpdate("update " + ch.getTableName() + " set Category=" + ChannelID + " where id=" + itemid);
		}
	}
}
//System.out.println("globalid:"+globalid);
%><%=globalid%>,<%=itemid%>