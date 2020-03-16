<%@page import="org.json.JSONObject"%>
<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String		ItemID		=	getParameter(request,"ItemID");
int	ChannelID_Source	=	getIntParameter(request,"SourceChannel");
String	ChannelID_Dest		=	getParameter(request,"DestChannel");
String chennelids[] = ChannelID_Dest.split(",");
int Type				=	getIntParameter(request,"Type");
JSONObject json = new JSONObject();
String flag = "true";
if(ChannelID_Source!=0 && ChannelID_Dest.length()>0 && !ItemID.equals(""))
{	
	String items[] = ItemID.split(",");
	for(int i=0;i<items.length;i++){
		Document doc = new Document(Integer.parseInt(items[i]),ChannelID_Source);
		int categoryID = doc.getCategoryID();
		if(ChannelID_Source!=categoryID&&categoryID!=0){
			ChannelID_Source=categoryID;
		}
		for(int j=0;j<chennelids.length;j++){
			if(Integer.parseInt(chennelids[j])==categoryID||Integer.parseInt(chennelids[j])==ChannelID_Source){
				flag = "false";
				break;
			}
		}
		if("false".equals(flag)){
			break;
		}
	}
	json.put("msg", flag);
	out.println(json.toString());
}
%>
