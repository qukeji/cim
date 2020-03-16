<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    String sql = "select id,Title from channel_jixiao_scheme where active = 1";
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    ResultSet rs1 = null;
    JSONArray schemeArray = new JSONArray();
    while(rs.next()){
        int id = rs.getInt("id");
        String name = rs.getString("Title");
        String sql1 = "select id,report_name reportName from channel_jixiao_report where jixiao_id = "+id+" order by TongjiDate desc";
        rs1 = tu.executeQuery(sql1);
        JSONArray schemeArray1 = new JSONArray();
        while(rs1.next()){
            int reportId = rs1.getInt("id");
            String reportName = rs1.getString("reportName");
            JSONObject jsonObject1 = new JSONObject();
            jsonObject1.put("reportId",reportId);
            jsonObject1.put("reportName",reportName);
            schemeArray1.put(jsonObject1);
        }
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("id",id);
        jsonObject.put("name",name);
        jsonObject.put("arr",schemeArray1);
        schemeArray.put(jsonObject);
    }
    tu.closeRs(rs);
    tu.closeRs(rs1);
    out.println(schemeArray.toString());

%>