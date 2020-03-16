<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.elasticsearch.common.settings.Settings,
				org.elasticsearch.common.xcontent.XContentType,
				org.elasticsearch.action.bulk.BulkResponse,
				java.io.*,
				java.sql.*,
				java.util.*"%>
<%@ page import="org.apache.http.HttpHost" %>
<%@ page import="org.elasticsearch.client.*" %>
<%@ page import="org.elasticsearch.action.admin.indices.create.CreateIndexRequest" %>
<%@ page import="org.elasticsearch.action.admin.indices.create.CreateIndexResponse" %>
<%@ page import="org.elasticsearch.action.bulk.BulkRequest" %>
<%@ page import="org.elasticsearch.action.index.IndexRequest" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	public static String HOST = "127.0.0.1";//"192.168.70.56";//
    public static int PORT = 9200;//http请求的端口是9200，客户端是9300
	public static String database = "tidemedia_content";
	public static String es_table = "document";
	public static RestHighLevelClient client = null;
	private static ObjectMapper mapper = new ObjectMapper();

    //初始化
    public static void init1(){

		client = new RestHighLevelClient(RestClient.builder(new HttpHost(HOST, PORT, "http")));

    }

	//判断索引是否存在
	public static boolean indexExists(String index){
		Request request = new Request("HEAD", index);
		try {
			Response response = client.getLowLevelClient().performRequest(request);
			return response.getStatusLine().getReasonPhrase().equals("OK");
		} catch (IOException e) {
			e.printStackTrace(System.out);
		}
		return false;
	}

	//创建索引
    public static void createIndex1(String index){
		Map <String,Object> properties = new HashMap <>();

		Map<String,Object> id = new HashMap<>();
        id.put("type","integer");
        properties.put("id",id);
        Map<String,Object> channelid = new HashMap<>();
        channelid.put("type","integer");
        properties.put("channelid",channelid);
        Map<String,Object> SiteId = new HashMap<>();
        SiteId.put("type","integer");
        properties.put("SiteId",SiteId);
        Map<String,Object> channelcode = new HashMap<>();
        channelcode.put("type","keyword");
        properties.put("channelcode",channelcode);
        Map<String,Object> Title = new HashMap<>();
        Title.put("type","keyword");
        properties.put("Title",Title);
        Map<String,Object> Summary = new HashMap<>();
        Summary.put("type","text");
        Summary.put("store",true);//参数需要研究是什么意思
        Summary.put("index",true);//参数需要研究是什么意思
        Summary.put("analyzer", "standard");//参数需要研究是什么意思
        properties.put("Summary",Summary);
        Map<String,Object> Content = new HashMap<>();
        Content.put("type","text");
        Content.put("store",true);
        Content.put("index",true);
        Content.put("analyzer", "standard");
        properties.put("Content",Content);
        Map<String,Object> Photo = new HashMap<>();
        Photo.put("type","keyword");
        properties.put("Photo",Photo);
        Map<String,Object> href = new HashMap<>();
        href.put("type","keyword");
        properties.put("href",href);
        Map<String,Object> Keyword = new HashMap<>();
        Keyword.put("type","keyword");
        properties.put("Keyword",Keyword);
        Map<String,Object> Tag = new HashMap<>();
        Tag.put("type","keyword");
        properties.put("Tag",Tag);
        Map<String,Object> dateline = new HashMap<>();
        dateline.put("type","keyword");
        properties.put("dateline",dateline);
        Map<String,Object> PublishDate = new HashMap<>();
        PublishDate.put("type","date");
        PublishDate.put("format","yyy-MM-dd HH:mm:ss");
        properties.put("PublishDate",PublishDate);
        Map<String,Object> CreateDate = new HashMap<>();
        CreateDate.put("type","date");
        CreateDate.put("format","yyy-MM-dd HH:mm:ss");
        properties.put("CreateDate",CreateDate);
        Map<String,Object> Status = new HashMap<>();
        Status.put("type","integer");
        properties.put("Status",Status);
        Map<String,Object> Active = new HashMap<>();
        Active.put("type","integer");
        properties.put("Active",Active);
        Map<String,Object> User = new HashMap<>();
        User.put("type","integer");
        properties.put("User",User);
        Map<String,Object> VirtualPV = new HashMap<>();
        VirtualPV.put("type","integer");
        properties.put("VirtualPV",VirtualPV);
        Map<String,Object> PV = new HashMap<>();
        PV.put("type","integer");
        properties.put("PV",PV);

		//索引名称
		CreateIndexRequest request = new CreateIndexRequest(index);
		//分片副本
		request.settings(Settings.builder().put("index.number_of_shards", 5).put("index.number_of_replicas", 1));

		Map<String, Object> mapping = new HashMap<>();
		mapping.put("properties", properties);
		request.mapping("document", mapping);

		try {
			CreateIndexResponse response = client.indices().create(request, RequestOptions.DEFAULT);
		} catch (IOException e) {
			e.printStackTrace();
			ErrorLog.SaveErrorLog("其他错误.", "ES创建索引错误：", 0, e);
		}
    }
%>
<%
int limit = getIntParameter(request,"limit");

out.println("开始导入");

%>
<%

try{

	long begin_time = System.currentTimeMillis();
	init1();
	out.println("ES初始化用时：" + (System.currentTimeMillis() - begin_time) + "毫秒<br>");

	int documentCount=0;
	for(int i=0;i<10;i++){

		int start = limit*1000 ;
		limit++;

		String sql = "select * from item_snap where PublishDate<1573612874 order by GlobalID desc limit "+start+",1000";//where PublishDate<1553097600 
		out.println("sql:"+sql+"<br>");
		System.out.println("sql:"+sql+"<br>");
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(sql);

		BulkRequest bulkRequest = new BulkRequest();

		String s = "";
		while (Rs.next()){

			documentCount++;
			String index = database ;

			if(!indexExists(index)){//索引不存在则先创建索引
				out.println("创建索引："+index+"<br>");
				createIndex1(index);
			}

			int globalid = Rs.getInt("GlobalID");//文章编号
            Document doc = CmsCache.getDocument(globalid);
			s = doc.getPublishDate() ;
			if(s.equals("")){
				continue;
			}

			Map<String, Object> jsonObject = new HashMap<String, Object>();
			jsonObject.put("id", globalid);
			jsonObject.put("channelid", Rs.getInt("ChannelID"));
			jsonObject.put("SiteId", Rs.getInt("SiteId"));
			jsonObject.put("channelcode", Rs.getString("ChannelCode"));
			jsonObject.put("Title", Rs.getString("Title"));
			jsonObject.put("Status", Rs.getInt("Status"));
			jsonObject.put("Active", Rs.getInt("Active"));
			jsonObject.put("User", Rs.getInt("User"));
			jsonObject.put("Summary", Util.XMLQuote(doc.getSummary()));
			jsonObject.put("Content", Util.XMLQuote(doc.getContent()));
			jsonObject.put("Photo", doc.getValue("Photo"));
			jsonObject.put("href", doc.getHttpHref());
			jsonObject.put("Keyword", Util.XMLQuote(doc.getValue("Keyword")).replaceAll(";", " "));
			jsonObject.put("Tag", Util.XMLQuote(doc.getValue("Tag")));
			jsonObject.put("dateline", doc.getPublishDate());
			jsonObject.put("PublishDate", doc.getPublishDate());
			jsonObject.put("CreateDate", doc.getCreateDate());
			jsonObject.put("VirtualPV", doc.getIntValue("pv_virtual"));
			jsonObject.put("PV", doc.getIntValue("pv"));

			IndexRequest indexRequest = new IndexRequest(index, "_doc", Rs.getInt("GlobalID")+"");
			try {
				indexRequest.source(jsonObject, XContentType.JSON);
				client.index(indexRequest, RequestOptions.DEFAULT);
			} catch (IOException e) {
				ErrorLog.SaveErrorLog("其他错误.", "ES入库错误:" + Rs.getInt("GlobalID"), 0, e);
				e.printStackTrace(System.out);
			}

			//添加到builder中
			bulkRequest.add(indexRequest);
		}
		BulkResponse bulkResponse = client.bulk(bulkRequest, RequestOptions.DEFAULT);
		if (bulkResponse.hasFailures()) {
			out.println("批量增加："+bulkResponse.buildFailureMessage()+"<br>");
		}
		tu.closeRs(Rs);
		
	}

	out.println("数据量："+documentCount);
	if(documentCount>0){
	%>
		<meta http-equiv="refresh" content="1;url=itemsnap_to_ES.jsp?limit=<%=limit%>" />
	<%}else{%>
		<script>
			alert('数据导入结束');
			javascript:self.close();
		</script>
	<%}

}catch (Exception e) {
	System.out.println(e.getMessage());
}finally {
	client.close();//关闭客户端
}

%>