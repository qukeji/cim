<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=gb2312" %>
<%@ include file="../config.jsp"%>
<%
String Action = getParameter(request,"Action");
//System.out.print("Title:"+Title);
if(!Action.equals(""))
{
	int		ChannelID		= getIntParameter(request,"ChannelID");
	int		OrderNumber		= getIntParameter(request,"OrderNumber");
	int		ItemID			= getIntParameter(request,"ItemID");
	int NoCloseWindow		= getIntParameter(request,"NoCloseWindow");

	Document document = new Document();

	int newid = document.getPrevItemID(OrderNumber,ChannelID,Action);
	if(newid==0) newid = ItemID;

	response.sendRedirect("document.jsp?ItemID=" + newid + "&ChannelID="+ChannelID+"&NoCloseWindow="+NoCloseWindow);
}
%>
