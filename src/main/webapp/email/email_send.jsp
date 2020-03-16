<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.email.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ItemID		=	getIntParameter(request,"ItemID");


if(ItemID!=0)
{
	EmailContent ec = new EmailContent(ItemID);

	ec.setStatus(1);

	ec.UpdateStatus();

	EmailSend es = new EmailSend(ItemID);

	String url = "";
	url = "list.jsp";
	
	response.sendRedirect(url);
}
%>
