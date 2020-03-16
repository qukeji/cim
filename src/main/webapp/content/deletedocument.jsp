<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int ChannelID = getIntParameter(request,"ChannelID");
int ItemID = getIntParameter(request,"ItemID");

if(ChannelID!=0 && ItemID!=0)
{
	Document item = new Document();
	item.Delete(ItemID+"",ChannelID);

	response.sendRedirect("content.jsp?id="+ChannelID);
}
%>
