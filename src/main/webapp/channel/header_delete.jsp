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
    int id = getIntParameter(request,"id");//项目ID
    ChannelListHeader channelListHeader = new ChannelListHeader();
    JSONObject jsonObject = new JSONObject();
    try {
        channelListHeader.Delete(id);
    }catch (Exception e){
        jsonObject.put("status",500);
        jsonObject.put("message","删除失败!");
        out.println(jsonObject);
        return;
    }
    jsonObject.put("status",200);
    jsonObject.put("message","删除成功!");
    out.println(jsonObject);
%>