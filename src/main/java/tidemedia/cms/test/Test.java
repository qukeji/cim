package tidemedia.cms.test;

import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URISyntaxException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.concurrent.atomic.AtomicInteger;

import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.util.Util;

public class Test {
	
	public static AtomicInteger num =  new AtomicInteger(0);

	public static void main(String[] args) throws IOException, JSONException
	{
		String url = "http://123.56.191.196:8888/tcenter/api/jurong/v2.0/";
        //String cookieString = "JSESSIONID=E190D35EE87702B9119D61D49B6CBD7E; domain=123.56.71.230; path=/tcenter";
        URI u = null;
        
            try {
				u = new URI(url);
				 System.out.println(u.getHost()+","+u.getPath()+","+u.getRawPath()+","+u.getFragment());
				 String s = u.getPath();
				 int num = s.indexOf("/",2);
				 if(num!=-1)
					 s = s.substring(0,num+1);
				 System.out.println("s:"+s);
			} catch (URISyntaxException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
            //cookie = "JSESSIONID="+session+"; domain="+u.getHost()+"; path=/tcenter";//+ u.getPath();
           

	}
	
    public static String getFileName(String url) {
        String filename = "";
        int lastIndexStart = url.lastIndexOf("/");
        if (lastIndexStart != -1) {
            filename = url.substring(lastIndexStart + 1);

            //去掉问号后面的
            int lastIndexStart_ = filename.lastIndexOf("?");
            if (lastIndexStart_ != -1) {
                filename = filename.substring(0, lastIndexStart_);
            }
        }

        return filename;
    }
    
	public static void main1(String[] args) throws IOException, JSONException
	{
		for(int i = 0;i<2000;i++)
		{
			num.incrementAndGet();
			TestA a = new TestA();
			new Thread(a).start();
		}
		
		TestB b = new TestB();
		new Thread(b).start();
	}
	
	synchronized  public static void done(int i)
	{
		String s = num+"";
		num.decrementAndGet();
		s = s + "," + num;
		System.out.println(s);
	}	
}
