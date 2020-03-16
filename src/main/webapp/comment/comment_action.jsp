<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String		ItemID	=	getParameter(request,"ItemID");
int			Action	=	getIntParameter(request,"Action");

if(!ItemID.equals(""))
{
	String sql = "";
	
	if(Action==1)
	{
		sql = "update comment set Status=1 where id in(" + ItemID + ")";
	}
	else if(Action==2)
	{
		sql = "update comment set Status=0 where id in(" + ItemID + ")";
	}
	else if(Action==3)
	{
		sql = "delete from comment where id in(" + ItemID + ")";
	}

	if(sql.length()>0)
	{
		TableUtil tu = new TableUtil("comment");
		tu.executeUpdate(sql);
	}
}
%>