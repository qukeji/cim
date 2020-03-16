package tidemedia.cms.util;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.io.OutputStreamWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import org.im4java.core.ConvertCmd;
import org.im4java.core.IM4JavaException;
import org.im4java.core.IMOperation;
import org.im4java.core.IdentifyCmd;

import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Parameter;

import magick.ImageInfo;
import magick.MagickException;
import magick.MagickImage;

public class Test {

	public void test() throws MagickException
	{

	}
	
	 public static void main(String args[]) throws IOException
	 {
		 String tsStr = "2015-07-18 20:37:00";  
	     
		 Timestamp    ts = Timestamp.valueOf(tsStr);  
		System.out.println(ts.getTime());
		
		java.util.Date d = new java.util.Date();
		System.out.println(d);
	 }
	 
		public static String postHttpUrl(String httpurl,String data,String charset)
		{
			String content = "";
			URL url;
			try {
				url = new URL(httpurl);
				java.net.HttpURLConnection connection = (java.net.HttpURLConnection) url.openConnection();
				connection.setDoOutput(true);  
				connection.setUseCaches(false);
				connection.setRequestProperty("Content-Type","application/x-www-form-urlencoded");  
				connection.setRequestMethod("POST");
				connection.connect();
				OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());
				
				out.write(data);
				out.flush();
				
				String sCurrentLine = "";
				
				java.io.InputStream l_urlStream = connection.getInputStream(); 
				java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream,charset)); 
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
