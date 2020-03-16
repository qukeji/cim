<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.user.*,
                 tidemedia.cms.util.*,
                 java.sql.*,
                 org.json.*,
                 java.util.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>

<%
    //右侧我的审核提醒列表
%>
<%
    int pagenum = getIntParameter(request, "pagenum");
    int pagesize = getIntParameter(request, "pagesize");
    int status = getIntParameter(request, "status");
    String application1 = getParameter(request, "application");
    JSONObject json = new JSONObject();
    int userid = userinfo_session.getId();
    ApproveDocument approveDocument = new ApproveDocument();
    JSONObject jsonObject = approveDocument.getMyApprove("", userid, status, request, application1, pagenum, pagesize, "", "", "");
    JSONArray arr = jsonObject.getJSONArray("list");
    json.put("result", arr);
    out.println(json);
%>
