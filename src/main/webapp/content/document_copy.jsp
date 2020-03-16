<%@page import="org.json.JSONObject"%>
<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String		ItemID		=	getParameter(request,"ItemID");
int	ChannelID_Source	=	getIntParameter(request,"SourceChannel");
int	ChannelID_Dest		=	getIntParameter(request,"DestChannel");
int Type				=	getIntParameter(request,"Type");
int		CategoryID	=	getIntParameter(request,"CategoryID");
int		currPage	=	getIntParameter(request,"currPage");
int		rowsPerPage =	getIntParameter(request,"rowsPerPage");
		JSONObject json = new JSONObject();

if(ChannelID_Source!=0 && ChannelID_Dest!=0 && !ItemID.equals(""))
{	
	String items[] = ItemID.split(",");
	for(int i=0;i<items.length;i++){
		Document doc = new Document(Integer.parseInt(items[i]),ChannelID_Source);
		int categoryID = doc.getCategoryID();
		if(ChannelID_Source!=categoryID&&categoryID!=0){
			ChannelID_Source=categoryID;
		}
		if(ChannelID_Dest==categoryID||ChannelID_Source==ChannelID_Dest){
			json.put("msg", "false");
			out.println(json.toString());
			return;
		}
	}
	Document document = new Document();
	document.setUser(userinfo_session.getId());
	document.CopyDocuments(ItemID,ChannelID_Source,ChannelID_Dest,Type);
	json.put("msg", "true");
	out.println(json.toString());
	

}
%>
