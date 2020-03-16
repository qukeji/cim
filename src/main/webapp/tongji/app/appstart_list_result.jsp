<%@ page import="org.elasticsearch.action.search.*,
                 org.elasticsearch.index.query.*,
                 org.elasticsearch.index.query.*,
                 org.elasticsearch.search.*,
                 org.json.*,
                 org.elasticsearch.search.sort.*,
                 org.json.JSONException,
                 tidemedia.cms.system.*,
                 java.text.SimpleDateFormat,
                 java.util.Calendar,
                 java.util.Map,
                 tidemedia.cms.util.ESUtil2019,
                 org.elasticsearch.search.builder.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="/tcenter/config.jsp" %>
<%!
    public static String getCurrentDate(java.util.Date date) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return df.format(calendar.getTime());
    }


    public static String getZeroDate(java.util.Date date, int days) {
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.DAY_OF_YEAR, calendar.get(Calendar.DAY_OF_YEAR) - days);
        return df.format(calendar.getTime());
    }

    //查询(标题，用户id，频道编号，频道路径，包含子频道，创建日期，大于，状态,Active,currPage,listnum,排序)
    public static String searchTongji(String begintime, String endtime, int currPage, int rowsPerPage, String sort, String serial,ESUtil2019 eu) throws JSONException {
        JSONArray jArray = new JSONArray();
        int TotalPageNumber = 0;
        int rowsCount = 0;
        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
        if (begintime != "" && endtime != "") {
            boolQuery.must(QueryBuilders.rangeQuery("start").from(begintime).to(endtime));
        }
        if (serial != "") {
            boolQuery.must(QueryBuilders.termQuery("serial", serial));
        }

        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
        searchSourceBuilder.query(boolQuery);
        searchSourceBuilder.from((currPage - 1) * rowsPerPage);
        searchSourceBuilder.size(rowsPerPage);
        searchSourceBuilder.sort(sort, SortOrder.DESC);

        SearchResponse response = eu.searchDocument("tongji", "app", searchSourceBuilder);

        SearchHits hits = response.getHits();
        rowsCount = (int) hits.getTotalHits().value;//ES查询总数
        TotalPageNumber = rowsCount % rowsPerPage == 0 ? rowsCount / rowsPerPage : rowsCount / rowsPerPage + 1;
        SearchHit[] searhits = hits.getHits();
        for (SearchHit hit : searhits) {
            Map<String, Object> map = hit.getSourceAsMap();
            JSONObject jo = new JSONObject();
            jo.put("serial", map.get("serial"));
            jo.put("phone", map.get("phone"));
            jo.put("operate_system", map.get("operateSystem"));
            jo.put("app_version", map.get("appVersion"));
            jo.put("service_provider", map.get("serviceProvider"));
            jo.put("network", map.get("network"));
            jo.put("start", map.get("start"));
            jo.put("end", map.get("end"));
            jArray.put(jo);
        }
        JSONObject jo = new JSONObject();
        jo.put("array", jArray);
        jo.put("pages", TotalPageNumber);
        jo.put("numbers", rowsCount);
        return jo.toString();
    }

%>
<%
    int id = getIntParameter(request, "id");
    int number = getIntParameter(request, "number");
    String channel = getParameter(request, "channel");
    int currPage = getIntParameter(request, "currPage");
    int rowsPerPage = getIntParameter(request, "rowsPerPage");
    if (rowsPerPage <= 0) {
        rowsPerPage = 20;
    }
    if (currPage <= 0)
        currPage = 1;
    long current = System.currentTimeMillis();
    java.util.Date date = new java.util.Date();
    String begintime = getParameter(request, "begin");
    String endtime = getParameter(request, "end");
    switch (number) {
        case 2:
            begintime = getZeroDate(date, 1);
            endtime = getZeroDate(date, 0);
            break;
        case 3:
            begintime = getZeroDate(date, 7);
            endtime = getZeroDate(date, 0);
            break;
        case 4:
            begintime = getZeroDate(date, 30);
            endtime = getZeroDate(date, 0);
            break;
        case 5:
            break;
        default:
            begintime = getZeroDate(date, 0);
            endtime = getZeroDate(date, -1);
            break;
    }
    ESUtil2019 eu = ESUtil2019.getInstance();
    String result = searchTongji("", "", currPage, rowsPerPage, "start","",eu);
    out.println(result);
%>

