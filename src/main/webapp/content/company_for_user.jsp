<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%

int companyId = userinfo_session.getCompany();
JSONObject obj = new JSONObject();
int JuxianID = 0;
TableUtil tu_user = new TableUtil("user");
String sql = "select * from company where id="+companyId;
ResultSet Rs = tu_user.executeQuery(sql);
if(Rs.next())
{
	JuxianID = Rs.getInt("JuxianID");


}
obj.put("JuxianID",JuxianID);

tu_user.closeRs(Rs);
out.println(obj);
%>

