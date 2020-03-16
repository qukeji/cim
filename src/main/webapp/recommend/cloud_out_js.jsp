<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ItemID		=	getIntParameter(request,"ItemID");
int		ChannelID	=	getIntParameter(request,"ChannelID");

String js = "";
if(ChannelID!=0 && ItemID!=0)
{
	Document doc = CmsCache.getDocument(ItemID,ChannelID);
	String title = doc.getTitle();
	String content = doc.getContent();
	String xiansuo_url = doc.getValue("SpiderUrl");

	js += "setValue('Title','"+title+"');checkTitle();";
	js += "setValue('xiansuo_id','"+ItemID+"');";
	js += "setValue('xiansuo_url','"+xiansuo_url+"');";
	js += "var RecommendContent='"+Util.JSQuote(content)+"';initRecommendContent();";

}
%>
<%=js%>
function initRecommendContent()
{
	try{
		setContent(RecommendContent,false);
	}catch(er){	
		window.setTimeout("initRecommendContent()",5);
	}
}