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
    int Channelid  = getIntParameter(request,"Channelid ");//频道ID
    String sql = "select id,FieldName,Description from field_desc where ChannelID = "+Channelid;
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    JSONArray jsonArray = new JSONArray();
    while (rs.next()){
        int id = rs.getInt("id");
        String title = rs.getString("FieldName");
        String Description = rs.getString("Description");
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("id",id);
        jsonObject.put("title",title);
        jsonObject.put("Description",Description);
        jsonArray.put(jsonObject);
    }
    tu.closeRs(rs);
    JSONObject jsonObject = new JSONObject();
    jsonObject.put("status",200);
    jsonObject.put("message","删除成功!");
    jsonObject.put("list",jsonArray);
    out.println(jsonObject);
%>