<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int ChannelID = getIntParameter(request,"ChannelID");
String ItemID = getParameter(request,"ItemID");

int CategoryID = getIntParameter(request,"CategoryID");
int currPage = getIntParameter(request,"currPage");
int rowsPerPage = getIntParameter(request,"rowsPerPage");

if(ChannelID!=0 && !ItemID.equals(""))
{
	ChannelPrivilege cp = new ChannelPrivilege();
	if(cp.hasRight(userinfo_session,CategoryID>0?CategoryID:ChannelID,3))
	{
		Document document = new Document();
		document.setUser(userinfo_session.getId());
		document.Approve(ItemID,ChannelID);
	}

	String url = "";
	if(CategoryID==0)
		url = "content.jsp?id="+ChannelID;
	else
		url = "content.jsp?id="+CategoryID;
	
	url += "&currPage="+currPage+"&rowsPerPage="+rowsPerPage;

	response.sendRedirect(url);
}
%>
