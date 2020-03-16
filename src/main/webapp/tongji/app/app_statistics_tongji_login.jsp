<%@ page import="org.elasticsearch.action.search.SearchResponse,
                 org.elasticsearch.index.query.BoolQueryBuilder,
                 org.elasticsearch.index.query.QueryBuilders,
                 org.elasticsearch.search.SearchHit,
                 org.elasticsearch.search.SearchHits,
                 org.elasticsearch.search.builder.SearchSourceBuilder,
                 org.json.JSONArray,
                 org.json.JSONException,
                 org.json.JSONObject,
                 tidemedia.cms.system.AppTongji,
                 tidemedia.cms.util.ESUtil2019,
                 java.text.ParseException,
                 java.text.SimpleDateFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.HashMap" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="/tcenter/config.jsp" %>
<!--
作用：app统计数据入ES
-->
<%!
    //将yyyy-MM-dd变为yyyy-MM-dd HH:mm:ss格式
    public static String formatDate(String time){
        if(time!=null && time != ""){
            time = time.replace("\"","");
            time +=" 00:00:00";
            return time;
        }
        else return  "";
    }
%>
<%
    String serial = getParameter(request, "serial");
    String os = getParameter(request, "os");
    String phone = getParameter(request, "phone");
    String resolution = getParameter(request, "resolution");
    String ditch = getParameter(request, "ditch");
    String app_version = getParameter(request, "appversion");
    String service_provider = getParameter(request, "serviceProvider");
    String network = getParameter(request, "network");
    String area = getParameter(request, "area");
    String start = getParameter(request, "start");
    start = formatDate(start);
    String ip = AppTongji.getIpAddress(request);
    JSONObject json = new JSONObject();

    //原php程序逻辑，现因测试，暂时注释
    /*if (serial == "" || os == "" || phone == "" || resolution == "" || app_version == "" || service_provider == "" || network == "" || start == "") {
        json.put("status", 0);
        json.put("message", "请仔细审核您的参数。");
        return;
    }*/

    ESUtil2019 eu = ESUtil2019.getInstance();
    int count = 0;
    BoolQueryBuilder boolQuery = QueryBuilders.boolQuery()
            .must(QueryBuilders.termQuery("serial", serial));

    SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
    searchSourceBuilder.query(boolQuery);

    AppTongji appTongji = new AppTongji(serial, phone, os, start, resolution, ditch, 0, app_version, service_provider, network, start, start, area, ip);
    if (!eu.indexExists("tongji")) {//索引不存在，先创建索引
        appTongji.createIndex("tongji","app");
    }
    SearchResponse searchResponse = eu.searchDocument("tongji","app",searchSourceBuilder);
    SearchHits hits = searchResponse.getHits();
    count = (int) hits.getTotalHits().value;//ES查询总数
    SearchHit[] searhits = hits.getHits();
    for (SearchHit hit : searhits) {
        Map<String, Object> map = hit.getSourceAsMap();
        serial = map.get("serial")+"";
    }
    if (count == 0) {
        appTongji.addEs();
    } else {
        appTongji.updateEs();
    }
%>
