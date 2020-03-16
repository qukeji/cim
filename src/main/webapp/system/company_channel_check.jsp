<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				org.json.*,
				java.util.concurrent.*,
				java.util.*,
				java.net.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
int company = getIntParameter(request,"company");//租户编号

JSONObject json = new JSONObject();

if(company!=0){

	String sql = "select id from channel where company="+company;
	TableUtil tu = new TableUtil();
	ResultSet rs=tu.executeQuery(sql);
	if(rs.next()){
		json.put("code",500);
		json.put("message","请先删除此租户的相关频道");
	}else{
		json.put("code",200);
		json.put("message","");
	}
	tu.closeRs(rs);

}else{
	json.put("code",500);
	json.put("message","租户不存在");
}

out.println(json.toString());

%>