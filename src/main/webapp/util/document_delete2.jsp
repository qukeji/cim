<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
String		ItemID	=	getParameter(request,"ItemID");

String videoid = getParameter(request,"videoid");

int		CategoryID	=	getIntParameter(request,"CategoryID");
int		currPage	=	getIntParameter(request,"currPage");
int		rowsPerPage =	getIntParameter(request,"rowsPerPage");

if(ChannelID!=0 && !ItemID.equals(""))
{
	ChannelPrivilege cp = new ChannelPrivilege();
	if(cp.hasRight(userinfo_session,CategoryID>0?CategoryID:ChannelID,4))
	{
		Document document = new Document();
		document.setUser(userinfo_session.getId());
		document.Delete2(ItemID,ChannelID);
	}
String []ids=videoid.split(",");
for(int c=0;c<ids.length;c++){
	String httpUrl="http://club.vodone.com/api/api_fileclient.php?videoid="+ids[c]+"&audit=2";
	Util.connectHttpUrl(httpUrl,true);
}
	String url = "";
	if(CategoryID==0)
		url = "club_content.jsp?id="+ChannelID;
	else
		url = "club_content.jsp?id="+CategoryID;
	
	url += "&currPage="+currPage+"&rowsPerPage="+rowsPerPage;

	response.sendRedirect(url);
}
%>