<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ItemID		=	getIntParameter(request,"ItemID");

	String Href = "";

	TableUtil tu = new TableUtil("supesite");
	String sql = "select * from supe_spaceitems where itemid="+ItemID;
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		int uid = rs.getInt("uid");
		Href = "http://club.vodone.com/?uid-"+uid+"-action-viewspace-itemid-"+ItemID;
	}

	tu.closeRs(rs);

	response.sendRedirect(Href);
%>