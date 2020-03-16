<%@ page import="tidemedia.cms.util.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>


<%
    JSONObject jo = ReportUtil2.mainData(userinfo_session.getId());
    out.println(jo.toString());
%>