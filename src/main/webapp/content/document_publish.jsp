<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
String	ItemID		=	getParameter(request,"ItemID");

int		currPage	=	getIntParameter(request,"currPage");
int		rowsPerPage =	getIntParameter(request,"rowsPerPage");

if(ChannelID!=0)
{
	Document document = new Document();
	document.setUser(userinfo_session.getId());
	document.Publish(ItemID,ChannelID);

	//String url = "";
	//url = "content.jsp?id="+ChannelID;
	
	//url += "&currPage="+currPage+"&rowsPerPage="+rowsPerPage;

	//response.sendRedirect(url);
}
%>
