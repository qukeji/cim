<%@ page import="tidemedia.cms.system.*,
				 tidemedia.cms.base.*,
				 tidemedia.cms.util.*,
				 tidemedia.cms.user.*,
				 org.json.*,
				 java.util.*,
				 java.sql.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%@ include file="../approve/approve_config.jsp" %>
<%
    JSONObject json = new JSONObject();
    JSONArray arr = null;
    int status = getIntParameter(request, "status");
    int UserId = getIntParameter(request, "userid");
    int currPage = getIntParameter(request, "currPage");
    int rowsPerPage = getIntParameter(request, "rowsPerPage");
    if (currPage < 1)
        currPage = 1;

    if (rowsPerPage == 0)
        rowsPerPage = Util.parseInt(Util.getCookieValue("rowsPerPage_new", request.getCookies()));

    if (rowsPerPage <= 0)
        rowsPerPage = 20;

    if (UserId == 0) {
        UserId = userinfo_session.getId();
    }
    ApproveDocument approveDocument = new ApproveDocument();
    arr = approveDocument.getMyApprove("", UserId, status, request, "", currPage, rowsPerPage, "", "", "").getJSONArray("list");
    JSONArray jsonArray = new JSONArray();
    int count = approveDocument.getNumber(UserId, 0);//总数
    int count2 = approveDocument.getNumber(UserId, 2);//未审核
    int count3 = approveDocument.getNumber(UserId, 3);//审核通过
    int count4 = approveDocument.getNumber(UserId, 4);//审核未通过
    JSONObject jsonObject1 = new JSONObject();
    JSONObject jsonObject2 = new JSONObject();
    JSONObject jsonObject3 = new JSONObject();
    JSONObject jsonObject4 = new JSONObject();

    jsonObject1.put("lable", "全部");
    jsonObject1.put("data", count);
    jsonObject2.put("lable", "未审核");
    jsonObject2.put("data", count2);
    jsonObject3.put("lable", "审核通过");
    jsonObject3.put("data", count3);
    jsonObject4.put("lable", "审核未通过");
    jsonObject4.put("data", count4);


    jsonArray.put(jsonObject1);
    jsonArray.put(jsonObject2);
    jsonArray.put(jsonObject3);
    jsonArray.put(jsonObject4);

    json.put("status", 200);
    json.put("message", "成功");
    json.put("moduleType", 5);
    json.put("moduleIcon", "<i class='fa fa-calendar-check-o mg-r-10 tx-22'></i>");
    json.put("moduleName", "我的审核");
    json.put("name", "我的审核");
    json.put("addJs", "siderightNewContent()");
    json.put("tablist", jsonArray);
    json.put("result", arr);

    out.println(json);

%>
<%!
    public static ArrayList repeatListWayTwo(ArrayList<Integer> list) {
        HashSet set = new HashSet(list);
        list.clear();
        list.addAll(set);
        return list;
    }
%>
