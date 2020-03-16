<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 tidemedia.cms.user.*,
                 java.util.*,
                 java.sql.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="javax.lang.model.element.NestingKind" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp" %>
<%
    int Channelid = getIntParameter(request, "Channelid");
    String sql = "select a.id,a.Title,a.Status,b.ViewType,c.Other from channel_list_header a,channel b,field_desc c where a.Channelid = b.id = c.ChannelID and a.Channelid = " + Channelid;
    TableUtil tu = new TableUtil();
    JSONArray jsonArray = new JSONArray();
    JSONObject o = new JSONObject();
    ResultSet rs = null;
    try {
        rs = tu.executeQuery(sql);
    }catch (Exception e){
        o.put("status", 500);
        o.put("message", e.getMessage());
        o.put("ViewType", -1);
        o.put("Other", "");
        o.put("list", jsonArray);
        return;
    }
    String Other = "";
    int ViewType = 0;
    while (rs.next()) {
        int id = rs.getInt("id");//列表项目ID
        int Status = rs.getInt("Status");//使用状态
        ViewType = rs.getInt("ViewType");//使用状态
        String Title = rs.getString("Title");//项目名称
        Other = rs.getString("Other");//字符串
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("id", id);
        jsonObject.put("Status", Status);
        jsonObject.put("Title", Title);
        jsonArray.put(jsonObject);
    }
    tu.closeRs(rs);
    o.put("status", 200);
    o.put("message", "success!");
    o.put("ViewType", ViewType);
    o.put("Other", Other);
    o.put("list", jsonArray);
%>