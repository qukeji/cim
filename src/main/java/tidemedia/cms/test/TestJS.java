package tidemedia.cms.test;

import java.io.IOException;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.util.Util;

public class TestJS {
	public static void main(String[] args) throws JSONException
	{
		String js = Util.connectHttpUrl("http://news.163.com/special/0001220O/news_json.js","GBK");
		System.out.println(js);
		JSONObject jo = new JSONObject(js.replace("var data=", ""));
		JSONArray ja = jo.getJSONArray("news");
		JSONArray ja1 = ja.getJSONArray(0);
		System.out.println(ja1.length());
		for(int i = 0;i<ja1.length();i++)
		{
			JSONObject item = ja1.getJSONObject(i);
			System.out.println(i+","+item.getString("t")+","+item.getString("p"));
		}
	}
}
