<%@ page import="tidemedia.cms.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
 
int		ChannelID		=	getIntParameter(request,"ChannelID");
String		ItemID		=	getParameter(request,"ItemID");
int		GlobalID		=	getIntParameter(request,"GlobalID");
int		LinkChannelID	=	getIntParameter(request,"LinkChannelID");

if(ChannelID!=0 && !ItemID.equals(""))
{
	ChannelPrivilege cp = new ChannelPrivilege();
	if(cp.hasRight(userinfo_session,ChannelID,4))
	{
		ItemUtil2.deleteLinkChildItems(ChannelID,LinkChannelID,GlobalID,ItemID,userinfo_session.getId());
		}
}
%>
