<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(! userinfo_session.isAdministrator())
{
	response.sendRedirect("../noperm.jsp");
	return;
}

int Parent  = getIntParameter(request,"Parent");
int itemid_  = getIntParameter(request,"itemid");
String Title = request.getParameter("Title");
Title=java.net.URLDecoder.decode(Title,"UTF-8");;


TableUtil tu_ = new TableUtil("user");

String sql = "select * from navigation where  Title='"+tu_.SQLQuote(Title)+"' and Parent="+Parent + " and id!="+itemid_;
ResultSet rs_ = tu_.executeQuery(sql);
if(rs_.next())
{
	//返回信息1
	out.println("1");
}
else
{
	//返回信息0
	out.println("0");
}

tu_.closeRs(rs_);
%>
