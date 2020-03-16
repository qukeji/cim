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
    String Field = getParameter(request, "Field");//字段名
    String Title = getParameter(request, "Title");//列表项目名称
    String Width = getParameter(request, "Width");//显示宽度
    String Script = getParameter(request, "Script");//列表项目脚本
    ChannelListHeader channelListHeader = new ChannelListHeader();
    channelListHeader.setId(id);
    channelListHeader.setfield(Field);
    channelListHeader.setTitle(Title);
    channelListHeader.setWidth(Width);
    channelListHeader.setScript(Script);
    JSONObject jsonObject = new JSONObject();
    try {
        channelListHeader.Update();
    }catch (Exception e){
        jsonObject.put("status",500);
        jsonObject.put("message","修改失败!");
        out.println(jsonObject);
        return;
    }
    jsonObject.put("status",200);
    jsonObject.put("message","修改成功!");
    out.println(jsonObject);
%>