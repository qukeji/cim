<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%><%@ page contentType="text/html;charset=utf-8"%><%@ include file="../config.jsp"%>
<%
int		ChannelID	=	Util.getIntParameter(request,"ChannelID");
String		ItemID	=	Util.getParameter(request,"ItemID");
String		Action	=	Util.getParameter(request,"Action"); 	
if(ChannelID!=0 && !ItemID.equals(""))
{
	ChannelPrivilege cp = new ChannelPrivilege();
	Document document = new Document(Integer.parseInt(ItemID),ChannelID);;
	document.setUser(userinfo_session.getId());
	int weight=Util.getIntParameter(request,"weight");
	document.UpdateWeight(weight);
	out.println(weight);	
}%>