package tidemedia.cms.util;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.apache.http.HttpHost;
import org.elasticsearch.action.admin.indices.create.CreateIndexRequest;
import org.elasticsearch.action.admin.indices.create.CreateIndexResponse;
import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.action.update.UpdateRequest;
import org.elasticsearch.client.*;
import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.common.xcontent.XContentType;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

/*
 *ES初始化，ES查询数据
 */
public class ESUtil2019 {

	static private ESUtil2019 instance = null;
	static private RestHighLevelClient client = null;
	public static int hasshow = 0;//是否显示过信息
	private static ObjectMapper mapper = new ObjectMapper();
	static synchronized public ESUtil2019 getInstance()  {
		if (instance == null) {
			instance = new ESUtil2019();
		}
		return instance;
	}

	private ESUtil2019()
	{
		if (client != null) {
			try {
				client.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		client = null;
		client = getClient();//初始化话ES链接
	}

	//初始化client
	public void newClient(){
		if (client != null) {
			try {
				client.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		client = null;
		client = getClient();//初始化话ES链接
	}

	//根据默认系统默认配置初始化库,如果已经有连接则使用该连接
	private RestHighLevelClient getClient(){
		TideJson ES_json = null;
		try {
			ES_json = CmsCache.getParameter("ES_Config").getJson();
		} catch (MessageException e) {
			e.printStackTrace();
			ErrorLog.SaveErrorLog("其他错误.","ES系统参数错误",0,e);
			return null;
		} catch (SQLException e) {
			e.printStackTrace();
			ErrorLog.SaveErrorLog("其他错误.","ES系统参数错误",0,e);
			return null;
		}

		String HOST = ES_json.getString("host");
		int PORT = ES_json.getInt("port");
		int status = ES_json.getInt("status");//是否开启ES

		if(status==0 || HOST.equals("")){//host为空，es连接关闭,返回null
			if(hasshow==0)
			{
				hasshow = 1;
				System.out.println(Util.getCurrentDateTime()+" ES初始化失败：HOST不能为空");
				ErrorLog.SaveErrorLog("ES","ES没有配置",0,new MessageException());
			}
			return null;
		}

		if (client != null) {//es连接对象已存在，返回client
			return client;
		}

		client = newClient(HOST,PORT);//初始化es连接

		return client;
	}
	//初始化
	@SuppressWarnings("resource")
	public RestHighLevelClient newClient(String HOST,int PORT){
		long time1 = System.currentTimeMillis();

		client = new RestHighLevelClient(RestClient.builder(new HttpHost(HOST, PORT, "http")));

		System.out.println("ES初始化用时：" + (System.currentTimeMillis() - time1) + "ms");

		return client ;
	}

	//判断索引是否存在
	public boolean indexExists(String index){
		if(client!=null){
			Request request = new Request("HEAD", index);
			try {
				Response response = client.getLowLevelClient().performRequest(request);
				return response.getStatusLine().getReasonPhrase().equals("OK");
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return false;
	}

	//创建ES索引库
	public void createIndex(String index,String type,Map<String,Object> properties){
		if(client!=null) {
			//索引名称
			CreateIndexRequest request = new CreateIndexRequest(index);
			//分片副本
			request.settings(Settings.builder().put("index.number_of_shards", 5).put("index.number_of_replicas", 1));

			Map<String, Object> mapping = new HashMap<>();
			mapping.put("properties", properties);
			request.mapping(type, mapping);
			try {
				CreateIndexResponse response = client.indices().create(request, RequestOptions.DEFAULT);
				//System.out.println(response.toString());
			} catch (IOException e) {
				e.printStackTrace();
				ErrorLog.SaveErrorLog("其他错误.", "ES创建索引错误：", 0, e);
			}
		}
	}

	//添加ES文档
	public void addDocument(String index, String type, String id, Map<String, Object> object){
		if(client!=null) {
			IndexRequest indexRequest = new IndexRequest(index, type, id);
			try {
				indexRequest.source(object, XContentType.JSON);
				client.index(indexRequest, RequestOptions.DEFAULT);//IndexResponse indexResponse =
			} catch (IOException e) {
				ErrorLog.SaveErrorLog("其他错误.", "ES入库错误:" + id, 0, e);
				e.printStackTrace(System.out);
			}
		}
	}

	//修改文档
	public void updateDocument(String index, String id, Map<String, Object> object) throws IOException {
		if(client!=null) {
			UpdateRequest updateRequest = new UpdateRequest(index,id);
			try {
				updateRequest.doc(object,XContentType.JSON);
				client.update(updateRequest,RequestOptions.DEFAULT);
			} catch (IOException e) {
				ErrorLog.SaveErrorLog("其他错误.", "ES修改错误:" + id, 0, e);
				e.printStackTrace(System.out);
			}
		}
	}

	//删除文档
	public void delDocument(String index, String type, String id){
		if(client!=null) {
			DeleteRequest deleteRequest = new DeleteRequest(index,type,id);
			try {
				client.delete(deleteRequest,RequestOptions.DEFAULT);
			} catch (IOException e) {
				ErrorLog.SaveErrorLog("其他错误.", "ES删除错误:" + id, 0, e);
				e.printStackTrace(System.out);
			}
		}
	}

	//ES查询
	public SearchResponse searchDocument(String index, String type, SearchSourceBuilder searchSourceBuilder ){
		SearchResponse searchResponse = null;
		if(client!=null) {
			SearchRequest searchRequest = new SearchRequest(index);
			//searchRequest.types(type);
			searchRequest.source(searchSourceBuilder);
			try {
				searchResponse = client.search(searchRequest, RequestOptions.DEFAULT);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return searchResponse ;

	}

	//判断ES是否运行
	public boolean isRun(){
		if(client==null){
			return false;
		}
    	return true;
	}
	//关闭ES连接
	public void close() {
		if(client!=null){
			try {
				client.close();
				client=null;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}


}