<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		FieldID		=	getIntParameter(request,"FieldID");
int		ItemID		=	getIntParameter(request,"ItemID");
int		ChannelID	=	getIntParameter(request,"ChannelID");

String js = "";
//System.out.println(SChannelID);
if((FieldID!=0) && ItemID!=0)
{//System.out.println(SChannelID);
	Document item = new Document(ItemID,ChannelID);
		
	if(FieldID>0)
	{
		Field field = new Field(FieldID);
		js += "setValue('"+field.getName()+"_Title','"+(item.getTitle())+"');";
		js += "setValue('"+field.getName()+"','"+(item.getGlobalID())+"');";
	}
	//System.out.println(js);
}
%><%=js%>