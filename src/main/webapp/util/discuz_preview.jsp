<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ItemID		=	getIntParameter(request,"ItemID");

	String Href = "";

	TableUtil tu = new TableUtil("bbs");
	String sql = "select * from cdb_threads where tid="+ItemID;
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		Href = "http://forum.vodone.com/viewthread.php?tid="+ItemID;
	}

	tu.closeRs(rs);

	response.sendRedirect(Href);
%>