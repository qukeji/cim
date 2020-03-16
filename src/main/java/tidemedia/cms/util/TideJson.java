package tidemedia.cms.util;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.Serializable;


public class TideJson implements Serializable {
	private JSONObject json;
	
	public JSONObject getJson() {
		return json;
	}

	public void setJson(JSONObject json) {
		this.json = json;
	}

	public TideJson()
	{
		
	}
	
	public TideJson(String str)
	{
		JSONObject o;
		try {
			o = new JSONObject(str);
			this.json = o;
		} catch (JSONException e) {
			e.printStackTrace(System.out);
		}	
	}
	
	public String getString(String key)
	{
		String s;
		try {
			s = json.getString(key);
		} catch (JSONException e) {
			s = "";
		}
		if(s==null)
			s = "";
		
		return s;
	}
	
	public int getInt(String key)
	{
		int i;
		try {
			i = json.getInt(key);
		} catch (JSONException e) {
			i = 0;
		}
		
		return i;
	}
	
	public JSONArray getJSONArray(String key)
	{
		JSONArray o = new JSONArray();
		try {
			 o = json.getJSONArray(key);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return o;
	}
	
}
