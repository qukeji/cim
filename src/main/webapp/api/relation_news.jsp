<%@ page import="org.elasticsearch.action.search.SearchResponse,
				 org.elasticsearch.index.query.BoolQueryBuilder,
				 org.elasticsearch.index.query.QueryBuilders,
				 org.elasticsearch.search.SearchHit,
				 org.elasticsearch.search.SearchHits,
				 org.elasticsearch.search.builder.SearchSourceBuilder,
				 org.json.JSONArray,
				 org.json.JSONException,
				 org.json.JSONObject,
				 tidemedia.cms.base.MessageException,
				 tidemedia.cms.base.TableUtil,
				 tidemedia.cms.system.Document,
				 tidemedia.cms.util.ESUtil2019,
				 tidemedia.cms.util.Util,
				 java.io.IOException,
				 java.sql.ResultSet,
				 java.sql.SQLException,
				 java.text.ParseException,
				 java.util.HashMap,
				 java.util.Map" %>
<%@ page import="javax.xml.crypto.dsig.CanonicalizationMethod" %>
<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp" %>
<%!
    //初始化
    public static ESUtil2019 init1() {
        ESUtil2019 eu = ESUtil2019.getInstance();
        return eu;
    }

    //查询
    public static JSONArray query(int site, String keyword, String title,ESUtil2019 eu, int contentid) throws IOException, ParseException, SQLException, MessageException, JSONException {
        System.out.println("keyword="+keyword);
        JSONArray arr = new JSONArray();
        if (keyword.equals("")) {
            return arr;
        }

        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
        boolQuery.must(QueryBuilders.termQuery("siteid", site));
        boolQuery.mustNot(QueryBuilders.termQuery("Title", title));//去除重复标题文章

        BoolQueryBuilder builder = QueryBuilders.boolQuery();
        String[] keyWords = keyword.split(",");
        for (int i = 0; i < keyWords.length; i++) {
            String keyword_ = keyWords[i];

            builder.should(QueryBuilders.wildcardQuery("title.keyword", "*" + keyword_ + "*"));
            builder.should(QueryBuilders.wildcardQuery("summary.keyword", "*" + keyword_ + "*"));
        }

        boolQuery.must(builder);

        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
        searchSourceBuilder.query(boolQuery);
        searchSourceBuilder.from(0);
        searchSourceBuilder.size(3);
        String s = searchSourceBuilder.toString();
        System.out.println("s=="+s);
        SearchResponse response = eu.searchDocument("tidemedia_app", "document", searchSourceBuilder);
        SearchHits hits = response.getHits();
        SearchHit[] searhits = hits.getHits();
        int count = (int) hits.getTotalHits().value;//ES查询总数

        System.out.println("count="+count);
        for (SearchHit hit : searhits) {
            Map map = hit.getSourceAsMap();
            String dateline = map.get("dateline").toString();
            if (!dateline.equals("")) {
                dateline = Util.FormatDate("MM-dd HH:mm", dateline);
            }
            int gid = (int) map.get("id");
            if(gid==contentid){
                continue;
            }
            int showcomment = 0;
            int showread = 0;
            int allowcomment = 0;
            int showtime = 0;
            int showtype = 0;
            int readcount = 0;
            Document doc = new Document(gid);
            TableUtil tu = new TableUtil();
            String sql = "select showcomment,showread,allowcomment,showtime,showtype from channel_s" + doc.getChannel().getSite().getId() + "_config where active=1 ";
            ResultSet rs = tu.executeQuery(sql);
            if (rs.next()) {
                showcomment = rs.getInt("showcomment");
                showread = rs.getInt("showread");
                allowcomment = rs.getInt("allowcomment");
                showtime = rs.getInt("showtime");
                showtype = rs.getInt("showtype");
            }
            tu.closeRs(rs);

            JSONObject json = new JSONObject();
            json.put("title", map.get("title"));
            json.put("date", dateline);
            json.put("allowcomment", allowcomment);
            //json.put("readcount", showread);
            json.put("readcount", CmsCache.getDocument(gid).getIntValue("pv"));
            json.put("channelcode", readcount);
            json.put("channelid", map.get("channelid"));
            json.put("docfrom", map.get("docfrom"));
            json.put("doc_type", map.get("doctype"));
            json.put("frame", map.get("frame"));
            json.put("url", map.get("href"));
            json.put("contentUrl", map.get("hrefapp"));
            json.put("id", gid);
            json.put("isphotonews", map.get("isphotonews"));
            json.put("itemtype", map.get("itemtype"));
            json.put("jumptype", map.get("jumptype"));
            json.put("photo", map.get("photo"));
            json.put("photo2", map.get("photo2"));
            json.put("photo3", map.get("photo3"));
            json.put("secondcategory", map.get("secondcategory"));
            json.put("showcollect", 0);
            json.put("showcomment", showcomment);
            json.put("showtime", showtime);
            json.put("showtype", showtype);
            json.put("summary", map.get("summary"));
            json.put("videoid", map.get("videoid"));

            arr.put(json);
        }

//		jsonObject.put("list",arr);

        return arr;
    }

    public HashMap<String, Object> getList(int site, int contentid) {

        HashMap<String, Object> map = new HashMap<String, Object>();

        try {
            if (site == 0 || contentid == 0) {

                map.put("status", 0);
                map.put("message", "参数缺少");

            } else {
                JSONArray arr = new JSONArray();
                ESUtil2019 eu = init1();
                Document doc = new Document(contentid);
                String keyword = doc.getKeyword();
                
                String title = doc.getTitle();
                System.out.println("文章名称："+title);
                 System.out.println("关键字："+keyword);
                arr = query(site, keyword, title,eu,contentid);
                map.put("result", arr);
                map.put("status", 1);
                map.put("message", "成功");
            }
        } catch (Exception e) {
            map.put("status", 0);
            map.put("message", "程序异常");
            e.printStackTrace();
        }

        return map;

    }

%>
<%
    int site = getIntParameter(request, "site");//客户端来源
    int contentid = getIntParameter(request, "contentid");//文章编号

%>
<%
    JSONObject json = new JSONObject();
    long begin_time = System.currentTimeMillis();
    HashMap<String, Object> map = getList(site, contentid);
    json = new JSONObject(map);
    out.println(json);
%>
