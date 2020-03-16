<%@ page import="tidemedia.cms.system.*,
                 tidemedia.cms.base.*,
                 tidemedia.cms.util.*,
                 tidemedia.cms.user.*,
                 java.util.*,
                 java.sql.*" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%
    /*String pageNum = getParameter(request, "page");
    String pageSize = getParameter(request, "num");*/
    JiXiaoUtil jiXiaoUtil = new JiXiaoUtil();
    JSONArray jsonArray = jiXiaoUtil.traverseScheme(4);
    String users = "";
    for (int i = 0; i < jsonArray.length(); i++) {
        JSONObject jsonObject = jsonArray.getJSONObject(i);
        int schemeId = jsonObject.getInt("schemeId");
        if (i == 0) {
            users += jiXiaoUtil.getUsersByJixiaoId(schemeId);
        } else {
            users += "," + jiXiaoUtil.getUsersByJixiaoId(schemeId);
        }
    }
    JSONObject jsonObject = new JSONObject();
    JSONArray jsonArray1 = new JSONArray();
    if(users.equals("")){
        jsonObject.put("status",500);
        jsonObject.put("message","参与人员为空!");
        jsonObject.put("list","");
        out.println(jsonObject);
        return;
    }
    String sql = "select gid,score from channel_jixiao_tongji where user_id in (" + users + ") order by score desc limit 10";
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    int score = 10;
    int reporter_score = 70;
    int user_score = 30;
    while (rs.next()) {
        int gid = rs.getInt("gid");
        Document document = CmsCache.getDocument(gid);
        String user = document.getUserName();
        String title = document.getTitle();
        String reporter = document.getValue("reporter");
        JSONObject o = new JSONObject();
        o.put("id",gid);
        o.put("title",title);
        o.put("reporter",reporter);
        o.put("user",user);
        o.put("score",score);
        o.put("reporter_score",reporter_score);
        o.put("user_score",user_score);
        jsonArray1.put(o);
        score--;
    }
    jsonObject.put("status",200);
    jsonObject.put("message","success!");
    jsonObject.put("list",jsonArray1);
    out.println(jsonObject);
%>