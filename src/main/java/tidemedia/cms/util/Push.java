/**
 * author hailong	
 * created on 2015-9-16下午10:28:05
 * 极光消息推送
 */
package tidemedia.cms.util;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

import javax.swing.text.html.Option;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.methods.PostMethod;
import org.apache.commons.httpclient.methods.StringRequestEntity;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.ItemUtil;


public class Push 
{
	
	
	 
	//推送对象
    public static JSONObject audience(HashMap<String, String> map)
	 	throws JSONException
	 {
		 JSONObject object = new JSONObject();
		 String type = map.get("audience_type");
		
		 String values = map.get("audience");
		 String[] value = values.split(",");
		 JSONArray array = new JSONArray();
		 for(String temp : value)
		 {
			 array.put(temp);
		 }
		 
		 if(type.equals("tag"))//每一个 tag 的长度限制为 40 字节
			 object.put("tag", array);//一次最多推送20个
		 else  if(type.equals("alias"))//用别名来标识一个用户。一个设备只能绑定一个别名，但多个设备可以绑定同一个别名。一次推送最多 1000 个。
			 object.put("alias", array);
		 else if(type.equals("registration"))//设备标识 一次推送最多 1000 个
			 object.put("registration_id", array);
		 
		return object;
	 }
    
	//推送消息
	public static JSONObject message(HashMap<String, String> map)
		throws JSONException
	{
		JSONObject result = new JSONObject();
		result.put("msg_content", map.get("content"));
		result.put("content_type", "text");
		result.put("title", map.get("title"));
		
		JSONObject extras = new JSONObject();
		extras.put("id", map.get("id"));
		extras.put("url", map.get("url"));
		extras.put("title", map.get("title"));
		
		result.put("extras", extras);
		
		return result;
	}
	//通知
	public static JSONObject notification(String platform,HashMap<String, String> map) 
		throws JSONException
	{
		JSONObject result = new JSONObject();
		
		JSONObject object = new JSONObject();
		//通知内容	;这里指定了，则会覆盖上级统一指定的 alert 信息；内容可以为空字符串，则表示不展示到通知栏。
		object.put("alert", map.get("alert"));
		//附加信息，约定传给客户端三个值文章的globalid，title，url
		JSONObject extras = new JSONObject();
		extras.put("id", map.get("id"));
		extras.put("url", map.get("url"));
		extras.put("title", map.get("title"));
		object.put("extras", extras);
		
		if(platform.equalsIgnoreCase("android"))
		{
			object.put("title", map.get("title"));
			result.put("android", object);
		}
		else if(platform.equalsIgnoreCase("ios"))
		{
			object.put("sound", "default");
			result.put("ios", object);
		}
		else
		{
			object.put("title", map.get("title"));
			result.put("android", object);
			object.put("sound", "default");
			result.put("ios", object);
		}
		
		return result;
	}
	
	//type=1是通知，type=2是消息
	//globalid推送的globalid
	public static boolean send(HashMap<String,String> map,int type,int globalid) 
		throws HttpException, IOException, JSONException, SQLException, MessageException
	{
		 boolean result_ = true;
		 
		 
		 
		 TideJson json = CmsCache.getParameter("sys_push").getJson();
		 
		 String appkey = json.getString("appkey");
		 String masterkey = json.getString("masterkey");
		/*
		 * { "platform" : "all" }
		指定特定推送平台：

		{ "platform" : ["android", "ios"] }
		 */
		JSONObject object = new JSONObject();
		String platform = map.get("platform");
		//"android", "ios", "winphone"
		if(platform.contains(","))
			object.put("platform", "["+platform+"]");
		else
		object.put("platform", platform);
		 
		if(map.get("audience_type").equals("all"))
			object.put("audience", "all");
		else 
			object.put("audience", audience(map));
		
		//判断推送的是通知还是消息
		if(type==1)
			object.put("notification", notification(platform, map));
		else 
			object.put("message", message(map));
		
		HttpClient client = new HttpClient();
		PostMethod post = new PostMethod("https://api.jpush.cn/v3/push");
		//测试接口，只测试不发送
		//PostMethod post = new PostMethod("https://api.jpush.cn/v3/push/validate");
		post.addRequestHeader("Authorization","Basic "+ Util.base64(appkey+":"+masterkey));
		post.setRequestHeader("Content-Type","application/json");    
	    //post.setQueryString(object.toString());
		post.setRequestEntity(new StringRequestEntity(object.toString()));
		client.executeMethod(post);
		String str=new String(post.getResponseBodyAsString().getBytes("utf-8"));
	  	//推送结果处理
		Document document = new Document(globalid);
		JSONObject result = new JSONObject(str);
	    //{"error": {"message": "Missing parameter", "code": 1002}}
	    JSONObject error = result.optJSONObject("error");
	    HashMap<String, String> map_ = new HashMap<String, String>();
	    if(error!=null)
	    {
	    	map_.put("Summary", error.optString("message"));
	    	map_.put("state", "0");//推送失败
	    	result_ = false;
	    }
	    else if(result.optInt("msg_id")>0)
	    {
	    	map_.put("Summary", "推送成功");
	    	map_.put("state", "1");
	    	result_ = true;
	    }
	    ItemUtil.updateItemByGid(document.getChannelID(), map_, globalid, 1); 
	    post.releaseConnection();
		return result_;
	}
}
