<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.JSONObject,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

	Integer id =getIntParameter(request,"id");
	String versionSql = "select * from article_replica where id="+id;
    TableUtil verTu = new TableUtil();
    ResultSet verRs = verTu.executeQuery(versionSql);
    int countNumber =0 ;
	JSONObject jsonObject = new JSONObject();
    while(verRs.next()){
		jsonObject.put("Title",verRs.getString("Title"));
		jsonObject.put("Summary",verRs.getString("Summery"));
		jsonObject.put("Content",verRs.getString("Content"));
	}
	verTu.closeRs(verRs);
	out.println(jsonObject.toString());
%>
