<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="java.net.URLEncoder" %>
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
		//发布时推送消息推送消息
		Document doc = new Document(Integer.parseInt(ItemID) ,ChannelID);
		String Title = doc.getTitle();
		String Summary = doc.getSummary();
		int type = 5;
		int target = doc.getIntValue("target");
		String url = CmsCache.getParameter("push_message_url").getContent();
		int siteid = CmsCache.getChannel(ChannelID).getSiteID();
		if(target==0){
			Util.connectHttpUrl(url+"?siteid="+siteid+"&type="+type+"&title="+ URLEncoder.encode(Title,"utf-8")+"&summary="+URLEncoder.encode(Summary,"utf-8")+"&target=-1"+"&userid=-1","");
		}else{
			String users = doc.getValue("users");
			Util.connectHttpUrl(url+"?siteid="+siteid+"&type="+type+"&title="+URLEncoder.encode(Title,"utf-8")+"&summary="+URLEncoder.encode(Summary,"utf-8")+"&userid="+users,"");
		}
	}

	String url = "";
	if(CategoryID==0)
		url = "content_message.jsp?id="+ChannelID;
	else
		url = "content_message.jsp?id="+CategoryID;
	
	url += "&currPage="+currPage+"&rowsPerPage="+rowsPerPage;

	response.sendRedirect(url);
}
%>
