<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		FieldID		=	getIntParameter(request,"FieldID");
int		ItemID		=	getIntParameter(request,"ItemID");
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		SChannelID	=	getIntParameter(request,"sourceChannelID");
Recommend r = new Recommend();
String js = r.RecommendIn(FieldID,ItemID,ChannelID,SChannelID);
out.println(js);
%>