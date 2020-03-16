<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID		=	getIntParameter(request,"id");

String js = "";
//System.out.println(SChannelID);
if(ChannelID!=0)
{//System.out.println(SChannelID);
	Channel channel = CmsCache.getChannel(ChannelID);

	js += "document.form.ChannelName.value='"+Util.JSQuote(channel.getName())+"';";
	js += "document.form.ChannelID.value = " + ChannelID + ";";
}
%><%=js%>