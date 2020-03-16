<%@ page import="tidemedia.cms.system.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%



Tree tree = new Tree();
JSONArray arr = tree.listChannel_json(userinfo_session);
out.println(arr);
%>
