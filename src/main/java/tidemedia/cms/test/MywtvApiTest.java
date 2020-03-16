package tidemedia.cms.test;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.MalformedURLException;
import java.net.URL;

import org.json.JSONException;
import org.json.JSONObject;

public class MywtvApiTest {

	/**
	 * @param args
	 * @throws JSONException 
	 */
	public static void main(String[] args) throws JSONException {
		// TODO Auto-generated method stub

		String api = "http://api.video.mywtv.cn/login";
		String data = "email=cms%40mywtv.cn&passwd=" + ("mywtv.cn");
		System.out.println("data:"+data);
		String content = postHttpUrl(api, data,"");
		JSONObject json = new JSONObject(content);
		String token = (json.getString("token"));
		
		api = "http://api.video.mywtv.cn/public/video";
		data = "videoId=87934948354293762&publishId=81701169738547200";
		content = postHttpUrl(api, data,token);
		System.out.println(content);
	}

	public static String postHttpUrl(String httpurl,String data,String token)
	{
		String content = "";
		URL url;
		try {
			url = new URL(httpurl);
			java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
			connection.setDoOutput(true);  
			connection.setUseCaches(false);
			if(token.length()>0)
				connection.addRequestProperty("Authorization", "Token " + token);
			connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");  
			connection.setRequestMethod("POST");
			connection.connect();
			OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());
			
			out.write(data);
			out.flush();
			
			String sCurrentLine = "";
			
			java.io.InputStream l_urlStream = connection.getInputStream(); 
			java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream)); 
			while ((sCurrentLine = l_reader.readLine()) != null) 
			{
				content+=sCurrentLine; 
			}		

			//System.out.println(content);
			out.close();
			out = null;
			connection.disconnect();
			connection = null;
		} catch (MalformedURLException e) {
			System.out.println(e.getMessage());
		} catch (IOException e) {
			System.out.println(e.getMessage());
		} 
		
		return content;
	}
}
