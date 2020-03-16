<%@ page
import="java.sql.*,java.net.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.user.*,java.util.*,java.sql.*"
%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(! userinfo_session.isAdministrator())
{
	response.sendRedirect("../noperm.jsp");
	return;
}

int itemid_  = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");
String cityname = request.getParameter("cityname");
cityname=new String(cityname.getBytes("ISO-8859-1"),"utf-8" );
Channel channel = CmsCache.getChannel(channelid);
String channel_name = channel.getTableName();

TableUtil tu_ = new TableUtil();

String sql = "select * from "+channel_name+" where  Title='"+cityname+"' and Parent="+itemid_;

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
