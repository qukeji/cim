<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int ChannelID = getIntParameter(request,"ChannelID");
String ItemID = getParameter(request,"ItemID");

String videoid = getParameter(request,"videoid");

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
//System.out.println("videoid:"+videoid);
		String []ids=ItemID.split(",");
		for(int c=0;c<ids.length;c++)
		{
			int id_ = Util.parseInt(ids[c]);
			//System.out.println("video:"+id_);
			Document doc = new Document(id_,ChannelID);

			String httpUrl="http://club.vodone.com/api/api_fileclient.php?videoid="+doc.getValue("aid")+"-"+doc.getValue("itemid")+"&audit=1";
			Util.connectHttpUrl(httpUrl,false);

			if(doc.getTitle().endsWith("vod"))
			{
				//采集过来的视频
				String url = "http://122.11.50.137/api/videoreview.aspx?vid="+doc.getValue("vid")+","+doc.getValue("itemid")+"&reviewstat=1";
				Util.connectHttpUrl(url,false);
			}
		}
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
