<%@ page import="org.elasticsearch.action.search.SearchResponse,
                 org.elasticsearch.client.transport.TransportClient,
                 org.elasticsearch.index.query.BoolQueryBuilder,
                 org.elasticsearch.index.query.QueryBuilders,
                 org.elasticsearch.search.SearchHit,
                 org.elasticsearch.search.SearchHits,
                 org.elasticsearch.search.sort.SortOrder" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="org.json.JSONException" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="tidemedia.cms.user.UserInfo" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="tidemedia.cms.util.ESUtil2019" %>
<%@ page import="org.elasticsearch.search.builder.SearchSourceBuilder" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
    public int[] getSiteID(UserInfo user) throws SQLException, MessageException {
        int company = user.getCompany();
        if (company != 0) {
            String sql = "select * from site where company = " + company;
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            String id = "";
            while (rs.next()) {
                if (id.length() > 0) {
                    id += "," + rs.getInt("id");
                } else {
                    id += rs.getInt("id") + "";
                }
            }
            tu.closeRs(rs);
            id += ",68";
            int[] ids = Util.StringToIntArray(id, ",");
            return ids;
        } else {
            return new int[]{};
        }
    }

    //返回租户用户的栏目管理频道channelcode
    public List<String> reChannelCode(int companyId, UserInfo user) throws JSONException, MessageException, SQLException {
        JSONArray app = ChannelUtil.getApplicationChannel("app", companyId, 1, user);
        System.out.println("app=" + app);
        List<String> channelCodes = new ArrayList<String>();
        for (int i = 0; i < app.length(); i++) {
            JSONObject json = app.getJSONObject(i);
            int siteid = (int) json.get("siteid");
            String serialNo = "s" + siteid + "_a_a";
            channelCodes.add(CmsCache.getChannel(serialNo).getChannelCode());
        }
        return channelCodes;
    }

    //查询数量;参数，频道id,问题状态，评价
    public int getNumber(int userid, int probstatus) throws MessageException, SQLException {
        int num = 0;

        String whereSql = " where Active=1 ";
        if (probstatus != 0) {
            int status3 = probstatus - 1;
            whereSql += " and Status=" + status3;
        }
        if (userid != 0) {
            whereSql += " and User=" + userid;
        }
        String sql_count = "select count(*) from item_snap " + whereSql;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql_count);
        if (rs.next())
            num = rs.getInt(1);
        tu.closeRs(rs);

        return num;
    }

    public JSONObject searchItemSnap(String title, int userid, boolean listAll, String startDate, String endDate, int status, int Active, int currPage, int listnum, String sort, UserInfo user, int type) throws JSONException, SQLException, MessageException {
        int[] siteIds = getSiteID(user);
        String globalid = "";
        int rowsCount = 0;
        TransportClient client = null;
        JSONObject jsonObject = new JSONObject();
        try {
            //获取索引
            String index = "tidemedia_content";
            BoolQueryBuilder boolQuery = QueryBuilders.boolQuery()
                    .must(QueryBuilders.termQuery("Active", Active))
                    .must(QueryBuilders.wildcardQuery("Title", "*" + title + "*"));
            int company = user.getCompany();
            List<String> channelCodes = new ArrayList<>();
            if (type != 2) {
                if (company != 0) {
                    channelCodes = reChannelCode(company, user);//获取对应租户站点下栏目管理频道channelcode
                } else {
                    Channel channel = CmsCache.getChannel("s53_a_a");
                    channelCodes.add(channel.getChannelCode());
                }
            } else {//租户管理系统
                Channel channel = ChannelUtil.getApplicationChannel("shengao");
                int id = channel.getId();
                if (user.getCompany() != 0) {//获取符合条件的租户频道,替换ch对象，后面逻辑不变
                    id = new Tree().getChannelID(id, user);
                    channel = CmsCache.getChannel(id);
                }
                String wengaoChannelCode = channel.getChannelCode();
                channelCodes.add(wengaoChannelCode);
            }
            System.out.println("channelCode=" + channelCodes);
            BoolQueryBuilder boolQuery2 = QueryBuilders.boolQuery();
            for (String channelcode : channelCodes) {
                boolQuery2 = boolQuery2.should(QueryBuilders.wildcardQuery("channelcode", channelcode + "*"));
            }
            boolQuery.must(boolQuery2);
            if (userid != 0 && type != 1 && type != 2) {
                boolQuery.must(QueryBuilders.termQuery("User", userid));
            }
            if (status != 0) {
                boolQuery.must(QueryBuilders.termQuery("Status", (status - 1)));
            }
            if (startDate != "" || endDate != "") {
                boolQuery.must(QueryBuilders.rangeQuery("CreateDate").from(startDate).to(endDate));
            }
            BoolQueryBuilder boolQuery3 = QueryBuilders.boolQuery();
            if (siteIds.length > 0) {
                for (int i = 0; i < siteIds.length; i++) {
                    int siteId = siteIds[i];
                    boolQuery3 = boolQuery3.should(QueryBuilders.termQuery("SiteId", siteId));
                }
            }
            boolQuery.must(boolQuery3);
            ESUtil2019 eu = ESUtil2019.getInstance();
            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
            searchSourceBuilder.query(boolQuery);
            searchSourceBuilder.from((currPage - 1) * listnum);
            searchSourceBuilder.size(listnum);
            searchSourceBuilder.sort(sort, SortOrder.DESC);
            SearchResponse response = eu.searchDocument(index, "document", searchSourceBuilder);
            SearchHits hits = response.getHits();
            rowsCount = (int) hits.getTotalHits().value;//ES查询总数
            SearchHit[] searhits = hits.getHits();
            for (SearchHit hit : searhits) {
                Map<String, Object> map = hit.getSourceAsMap();
                if (globalid.equals("")) {
                    globalid = map.get("id") + "";
                } else {
                    globalid += "," + map.get("id");
                }
            }
        } catch (Exception e) {
            if (client != null) ESUtil2019.getInstance().close();
            ErrorLog.SaveErrorLog("其他错误", "ES查询错误", 0, e);
            e.printStackTrace(System.out);
        }
        jsonObject.put("rowsCout", rowsCount);
        jsonObject.put("globalids", globalid);
        return jsonObject;
    }
%>
