<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,org.json.*,
				java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
String	id	=	getParameter(request,"id");

JSONArray jj = new JSONArray();
if(id.length()>0)
{
	TableUtil tu = new TableUtil();
	String sql = "select id,progress from channel_transcode where id in (" + id + ")";
	ResultSet rs = tu.executeQuery(sql);
	while(rs.next())
	{
		JSONObject j = new JSONObject();
		j.put("id",rs.getInt("id"));
		j.put("progress",rs.getInt("progress"));
		jj.put(j);
	}
	tu.closeRs(rs);
}
out.println(jj.toString());
%>