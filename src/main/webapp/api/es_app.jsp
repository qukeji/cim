<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.elasticsearch.action.search.SearchResponse,
				org.elasticsearch.client.transport.TransportClient,
				org.elasticsearch.index.query.QueryBuilders,
				org.elasticsearch.index.query.BoolQueryBuilder,
				org.elasticsearch.index.query.QueryBuilders,
				org.elasticsearch.action.search.SearchRequestBuilder,
				org.elasticsearch.search.SearchHit,
				org.elasticsearch.search.SearchHits,
				org.elasticsearch.search.sort.SortOrder,
				java.io.*,
				java.sql.*,
				java.text.*,
				java.util.*,
				org.json.*"%>
<%@ page import="org.elasticsearch.search.builder.SearchSourceBuilder" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	//初始化
	public static ESUtil2019 init1() {
		ESUtil2019 eu = ESUtil2019.getInstance();
		return eu;
	}
	//查询
	public static JSONObject query(String keyword,int currPage,int listnum,int site,ESUtil2019 eu) throws IOException, ParseException,SQLException,MessageException,JSONException {
		
		JSONObject jsonObject = new JSONObject();		
		
		BoolQueryBuilder boolQuery = QueryBuilders.boolQuery();
		
		if(!keyword.equals("")){
			boolQuery.must(QueryBuilders.wildcardQuery("title.keyword", "*"+keyword+"*"));
		}
		if(site!=0){
			boolQuery.must(QueryBuilders.termQuery("siteid", site));
		}

		SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
		searchSourceBuilder.query(boolQuery);
		searchSourceBuilder.from((currPage - 1) * listnum);
		searchSourceBuilder.size(listnum);
		searchSourceBuilder.sort("id", SortOrder.DESC);

		SearchResponse response = eu.searchDocument("tidemedia_app", "document", searchSourceBuilder);
							
		SearchHits hits = response.getHits();
		SearchHit[] searhits = hits.getHits();		
		int count = (int) hits.getTotalHits().value;//ES查询总数
		System.out.println("count:"+count);
		
		JSONArray arr = new JSONArray();
		for (SearchHit hit : searhits) {
			
			Map map = hit.getSourceAsMap();
			String dateline = map.get("dateline").toString();
			if(!dateline.equals("")){
				dateline = Util.FormatDate("MM-dd HH:mm",dateline);
			}
			
			JSONObject json = new JSONObject();
			json.put("title",map.get("title"));
			json.put("date",dateline);
			json.put("allowcomment",map.get("allowcomment"));
			json.put("channelcode",map.get("channelcode"));
			json.put("channelid",map.get("channelid"));
			json.put("docfrom",map.get("docfrom"));
			json.put("doctype",map.get("doctype"));
			json.put("frame",map.get("frame"));
			json.put("url",map.get("href"));
			json.put("contentUrl",map.get("hrefapp"));
			json.put("id",map.get("id"));
			json.put("isphotonews",map.get("isphotonews"));
			json.put("itemtype",map.get("itemtype"));
			json.put("jumptype",map.get("jumptype"));
			json.put("photo",map.get("photo"));
			json.put("photo2",map.get("photo2"));
			json.put("photo3",map.get("photo3"));
			json.put("secondcategory",map.get("secondcategory"));
			json.put("showcollect",map.get("showcollect"));
			json.put("showcomment",map.get("showcomment"));
			json.put("showtime",map.get("showtime"));
			json.put("showtype",map.get("showtype"));
			json.put("summary",map.get("summary"));
			json.put("videoid",map.get("videoid"));
			
			arr.put(json);
		}
		
		jsonObject.put("total",count);
		jsonObject.put("page",currPage);
		jsonObject.put("list",arr);
		
		return jsonObject ;
	}

	public HashMap<String, Object> getList(String keyword,int currPage,int listnum,int site){

		HashMap<String, Object> map = new HashMap<String, Object>() ;

		try{
			JSONObject json = new JSONObject();
			ESUtil2019 eu = init1();
			json = query(keyword,currPage,listnum,site,eu);

			map.put("result",json);
			map.put("status",1);
			map.put("message","成功");

		}catch(Exception e){
			map.put("status",0);
			map.put("message","程序异常");
			System.out.println(e.getMessage());
		} 

		return map ;
	
	}

%>
<%
String keyword 	= getParameter(request,"keyword");//关键词
int currPage  	= getIntParameter(request,"page");//页码
int listnum  	= getIntParameter(request,"per_num");//每页显示数量
int site 		= getIntParameter(request,"site");//客户端来源

if(currPage==0){
	currPage = 1 ;
}
if(listnum==0){
	listnum = 10 ;
}
%>
<%
JSONObject json = new JSONObject();
long begin_time = System.currentTimeMillis();
HashMap<String, Object> map = getList(keyword,currPage,listnum,site);
json = new JSONObject(map);
out.println(json);
%>
