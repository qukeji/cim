<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	Util.getIntParameter(request,"ChannelID");
String		ItemID	=	Util.getParameter(request,"ItemID");
String		Action	=	Util.getParameter(request,"Action"); 	


if(ChannelID!=0 && !ItemID.equals(""))
{
	ChannelPrivilege cp = new ChannelPrivilege();
	Document document = new Document();
	document.setUser(userinfo_session.getId());
		if(Action.equals("Approved")){
			if(cp.hasRight(userinfo_session,ChannelID,3)){
				document.Approve(ItemID,ChannelID);
				out.println("Refresh");
			}
		}else	if(Action.equals("Delete")){
			if(cp.hasRight(userinfo_session,ChannelID,4)){
				document.Delete(ItemID,ChannelID);
				out.println("Refresh");
			}
		}else	if(Action.equals("Delete2")){
			document.Delete2(ItemID,ChannelID);
			out.println("Refresh");
		}else	if(Action.equals("Publish")){
			document.Publish(ItemID,ChannelID);
			out.println("Publish");
		}else	if(Action.equals("Order")){
			int		Direction		=	getIntParameter(request,"Direction");
			int		OrderNumber		=	getIntParameter(request,"Number");
			int includesubchannel	=	getIntParameter(request,"includesubchannel");
			boolean includesubchannel_ = false;
			if(includesubchannel==1)
				includesubchannel_ = true;
			document.Order(Integer.parseInt(ItemID),ChannelID,Direction,OrderNumber,includesubchannel_);
			//document.Order(Integer.parseInt(ItemID),ChannelID,Direction,OrderNumber);
			out.println("Refresh");
		}
}else{
	out.println("error");
}
%>
