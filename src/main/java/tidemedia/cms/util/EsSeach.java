package tidemedia.cms.util;

import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.index.query.BoolQueryBuilder;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHits;
import org.elasticsearch.search.aggregations.AggregationBuilder;
import org.elasticsearch.search.aggregations.AggregationBuilders;
import org.elasticsearch.search.aggregations.bucket.histogram.DateHistogramInterval;
import org.elasticsearch.search.aggregations.bucket.histogram.Histogram;
import org.elasticsearch.search.aggregations.bucket.terms.Terms;
import org.elasticsearch.search.aggregations.metrics.ParsedSum;
import org.elasticsearch.search.aggregations.metrics.Sum;
import org.elasticsearch.search.aggregations.metrics.SumAggregationBuilder;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;

/*
 *ES初始化，ES查询数据
 */
public class EsSeach {
    private String siteIds = "";//站点id
    private int channelId = 0;//频道id
    private int userid = 0;//用户id
    private boolean listAll = false;//包含子频道
    private int status = 0;//状态
    private String startDate = "";//开始时间
    private String endDate = "";//结束时间
    public static ESUtil2019 eu = null;

    public EsSeach() {
        super();
        eu = ESUtil2019.getInstance();
    }

    //tcenter首页数据统计
    public int ReportData() {
        int count = 0;

        try {
            if (!eu.isRun()) {//es服务关闭
                return count;
            }

            BoolQueryBuilder boolQuery = QueryBuilders.boolQuery().must(QueryBuilders.termQuery("Active", 1));

            if (!siteIds.equals("")) {//查站点数据
                String[] arr = siteIds.split(",");
                Integer[] sitearr = new Integer[arr.length];
                for (int i = 0; i < arr.length; i++) {
                    sitearr[i] = Integer.parseInt(arr[i]);
                }
                boolQuery.must(QueryBuilders.termsQuery("SiteId", sitearr));
            } else if (channelId != 0) {//查频道
                if (listAll) {//包含子频道
                    String channelcode = CmsCache.getChannel(channelId).getChannelCode();
                    boolQuery.must(QueryBuilders.wildcardQuery("channelcode", channelcode + "*"));
                } else {
                    boolQuery.must(QueryBuilders.termQuery("channelid", channelId));
                }
            }

            if (userid != 0) {
                boolQuery.must(QueryBuilders.termQuery("User", userid));
            }
            if (status != 0) {
                boolQuery.must(QueryBuilders.termQuery("Status", (status - 1)));
            }

            if (!startDate.equals("") && !endDate.equals("")) {
                if (userid != 0) {//取发布时间
                    boolQuery.must(QueryBuilders.rangeQuery("PublishDate").from(startDate).to(endDate));
                } else {
                    boolQuery.must(QueryBuilders.rangeQuery("CreateDate").from(startDate).to(endDate));
                }
            }

            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
            searchSourceBuilder.query(boolQuery);

            SearchResponse response = eu.searchDocument("tidemedia_content", "document", searchSourceBuilder);
            SearchHits hits = response.getHits();
            count = (int) hits.getTotalHits().value;//ES查询总数

        } catch (MessageException e) {
            ErrorLog.SaveErrorLog("其他错误", "ES查询错误", 0, e);
            e.printStackTrace(System.out);
        }
        return count;
    }

    //tcenter系统首页PV数据
    public JSONObject ReportPvData() {

        JSONObject json = new JSONObject();
        try {
            if (!eu.isRun()) {//es服务关闭
                json.put("count", 0);
                return json;
            }

            BoolQueryBuilder boolQuery = QueryBuilders.boolQuery().must(QueryBuilders.termQuery("Status", 1));
            String channelcode = CmsCache.getChannel(channelId).getChannelCode();
            boolQuery.must(QueryBuilders.wildcardQuery("channelcode", channelcode + "*"));

            SumAggregationBuilder sab = AggregationBuilders.sum("PV").field("PV");
            SumAggregationBuilder sab1 = AggregationBuilders.sum("VirtualPV").field("VirtualPV");

            SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
            searchSourceBuilder.query(boolQuery);


            if (!startDate.equals("") && !endDate.equals("")) {
                boolQuery.must(QueryBuilders.rangeQuery("PublishDate").from(startDate).to(endDate));
                //需要给聚合内容一个别名
                //AggregationBuilder aggregation = AggregationBuilders.dateHistogram("timeAgg").field("PublishDate")
                //        .dateHistogramInterval(DateHistogramInterval.DAY).format("yyyy-MM-dd");
                AggregationBuilder aggregation = AggregationBuilders.dateHistogram("timeAgg").field("PublishDate")
                        .fixedInterval(DateHistogramInterval.DAY).format("yyyy-MM-dd");
                aggregation.subAggregation(sab);
                aggregation.subAggregation(sab1);

                searchSourceBuilder.aggregation(aggregation);

                SearchResponse response = eu.searchDocument("tidemedia_content", "document", searchSourceBuilder);
                Histogram timeAgg = response.getAggregations().get("timeAgg");
                for (Histogram.Bucket entry : timeAgg.getBuckets()) {
                    Sum sum = entry.getAggregations().get("VirtualPV");
                    Sum sum1 = entry.getAggregations().get("PV");
                    long VirtualPV = (long) sum.getValue();
                    long PV = (long) sum1.getValue();
                    long count = PV + VirtualPV;

                    String date_ = entry.getKey().toString();
                    String day = date_.substring(8, 10);
                    if (!day.equals("")) {
                        day = Integer.parseInt(day) + "";
                    }
                    json.put(day, count);
                }

            } else {
                searchSourceBuilder.aggregation(sab);
                searchSourceBuilder.aggregation(sab1);

                SearchResponse response = eu.searchDocument("tidemedia_content", "document", searchSourceBuilder);
                //根据别名获取聚合对象，不同聚合会返回不同的聚合对象
                ParsedSum ivc = response.getAggregations().get("PV");
                ParsedSum ivc1 = response.getAggregations().get("VirtualPV");
                long VirtualPV = (long) ivc1.getValue();
                long PV = (long) ivc.getValue();
                long count = VirtualPV + PV;
                json.put("count", count);
            }
        } catch (Exception e) {
            ErrorLog.SaveErrorLog("其他错误", "ES查询错误", 0, e);
            e.printStackTrace(System.out);
        }
        return json;
    }

    //媒体号稿件量查询
    public JSONArray companyDocNum(String channelids, String channelcode) throws JSONException {

        JSONArray array = new JSONArray();
        if (!eu.isRun()) {//es服务关闭
            return array;
        }
        String[] arr = channelids.split(",");
        Integer[] channelarr = new Integer[arr.length];
        for (int i = 0; i < arr.length; i++) {
            channelarr[i] = Integer.parseInt(arr[i]);
        }
        BoolQueryBuilder boolQuery = QueryBuilders.boolQuery().must(QueryBuilders.termQuery("Active", 1));
        boolQuery.must(QueryBuilders.wildcardQuery("channelcode", channelcode + "*"));
        boolQuery.must(QueryBuilders.termsQuery("channelid", channelarr));
        AggregationBuilder aggregation = AggregationBuilders.terms("agg").field("channelid");
        SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
        searchSourceBuilder.query(boolQuery);
        searchSourceBuilder.aggregation(aggregation).size(0);
        SearchResponse response = eu.searchDocument("tidemedia_content", "document", searchSourceBuilder);
        Terms genders = response.getAggregations().get("agg");
        for (Terms.Bucket entry : genders.getBuckets()) {
            String key = entry.getKeyAsString();      // Term
            long docCount = entry.getDocCount(); // Doc count
            JSONObject object = new JSONObject();
            object.put("channelid", key);
            object.put("Count", docCount);
            array.put(object);
        }
        return array;
    }

    public String getSiteIds() {
        return siteIds;
    }

    public void setSiteIds(String siteIds) {
        this.siteIds = siteIds;
    }

    public int getChannelId() {
        return channelId;
    }

    public void setChannelId(int channelId) {
        this.channelId = channelId;
    }

    public int getUserid() {
        return userid;
    }

    public void setUserid(int userid) {
        this.userid = userid;
    }

    public boolean isListAll() {
        return listAll;
    }

    public void setListAll(boolean listAll) {
        this.listAll = listAll;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }
}
