package tidemedia.cms.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.system.ErrorLog;

public class QQ {
	public String Username = "908642323";
	public String Password = "tidemedia#im";
	public String To = "";//要发送信息的qq号
	public String Cookie = "";
	private int clientid = 66933334;
	private String vfwebqq = "";
	private String psessionid = "";
	private String refer = "http://web2-b.qq.com/proxy.html";
	
	public QQ()
	{
		
	}
	
	public QQ(String u,String p)
	{		
		Username = u;
		Password = p;
	}
	
	public boolean Send(String to,String message)
	{
		if(to.length()==0)
			to = To;
		if(to.length()==0)
			return false;
		
		if(psessionid.length()==0)
		{
			login();
		}
		
		if(psessionid.length()>0)
		{
			try {			
			JSONObject json = new JSONObject();
			
			json.put("to", to);
			//要发送的人
			json.put("face", 0);
			
			JSONArray msg = new JSONArray();
			msg.put(message + "\r\n由tidecms发送");
			JSONArray font = new JSONArray();
			font.put("font");
			
			JSONObject font1 = new JSONObject().put("name", "宋体").put("size", "10");
			
			JSONArray style = new JSONArray();
			style.put(0);
			style.put(0);
			style.put(0);
			font1.put("style", style);
			font1.put("color", "000000");

			font.put(font1);	 
			msg.put(font);
			
			json.put("content", msg.toString());
			json.put("msg_id", new Random().nextInt(10000000));
			json.put("clientid", clientid);
			System.out.println("psessionid:"+psessionid);
			json.put("psessionid", psessionid);//需要这个才能发送
			String sendMsgUrl = "http://d.web2.qq.com/channel/send_msg";
			String content = json.toString();
			System.out.println("content:"+content); 
			
			content = URLEncoder.encode(content,"utf-8");//他要需要编码
			content ="r="+content;
			//发送
			String res = postUrl(sendMsgUrl, content);
			//不出意外，这是返回结果：{"retcode":0,"result":"ok"}
			System.out.println(res);
			JSONObject rh = new JSONObject(res);
			if("0".equals(rh.getString("retcode"))){
				return true;
			}
			else
			{
				res = postUrl(sendMsgUrl, content);
				System.out.println("sec:"+res);
				rh = new JSONObject(res);
				if("0".equals(rh.getString("retcode"))){
					return true;
				}
				else
					return false;
			}
			
			} catch (JSONException e) {
				e.printStackTrace();
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}	
			return false;
		}
		else
			return false;
	}
	
	public boolean login()
	{
		if(Username.length()<=0 && Password.length()<=0)
			return false;
		
		String checkIdUrl = "http://ptlogin2.qq.com/check?appid=1003903&uin="+Username;
		String res = getUrl(checkIdUrl);
		Pattern p = Pattern. compile("\\,\\'([!\\w]+)\\'");
		Matcher m = p. matcher(res);
		String checkType = "";
		if(m.find()){
			checkType = m.group(1); 
		}
		String check = ""; 
		if(!checkType.startsWith("!")){
			//需要输入验证码
			ErrorLog.Log("QQ消息","登录时需要验证码("+Username+","+To+")","登录时需要验证码");
			return false;
		}else{
			//不需要输入验证码
			check = checkType;
		}
		String key = "";
		try {
			key = md5(md5_3(Password)+check);
		} catch (Exception e) {e.printStackTrace();}
		String loginUrl = "http://ptlogin2.qq.com/login?u="+Username+"&" +
				"p=" +key+
				"&verifycode="+check+"&remember_uin=1&aid=1003903" +
				"&u1=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html%3Fstrong%3Dtrue" +
				"&h=1&ptredirect=0&ptlang=2052&from_ui=1&pttype=1&dumy=&fp=loginerroralert";
		res = getUrl(loginUrl);
		p = Pattern.compile("登录成功！");//提取最后一个字符串，看看是不是 登录成功！
		m = p. matcher(res);
		if(m.find()){
			ErrorLog.Log("QQ消息","登录成功("+Username+","+To+")","登录成功");
		}else{
			//登陆失败
			ErrorLog.Log("QQ消息","登录失败("+Username+","+To+")","登录失败");
			return false;
		}
		String ptwebqq = "";
		String skey = "";
		p = Pattern.compile("ptwebqq=(\\w+);");
		m = p.matcher(Cookie);
		if(m.find()){
			ptwebqq = m.group(1);
		}
		p = Pattern.compile("skey=(@\\w+);");
		m = p.matcher(Cookie);
		if(m.find()){
			skey = m.group(1);
		}
		String channelLoginUrl = "http://d.web2.qq.com/channel/login2";
		String content = "{\"status\":\"\",\"ptwebqq\":\""+ptwebqq+"\",\"passwd_sig\":\"\",\"clientid\":\""+clientid+"\"}";
		content = URLEncoder.encode(content);//urlencode 
		content = "r="+content;//post的数据
		System.out.println("content:"+content);
		res = postUrl(channelLoginUrl, content);//post
		//这次登陆基本上不会发生什么问题
		//下面提取很重要的2个数据psessionid ,vwebqq，通用采用正则表达式,虽然结果是个json
		p = Pattern.compile("\"vfwebqq\":\"(\\w+)\"");
		m = p.matcher(res);
		if(m.find()){
			vfwebqq = m.group(1);
		}
		p = Pattern.compile("\"psessionid\":\"(\\w+)\"");
		m = p.matcher(res);
		if(m.find()){
			psessionid = m.group(1);
		}
		//到此，登陆就算完成了，后面可以调用发送qq信息等接口了			
		return true;
	}
	
	private  String postUrl(String url, String contents){
		try{ 
			System.out.println("post>>>"+url);
			 
			URL serverUrl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) serverUrl.openConnection(); 
	        conn.setRequestMethod("POST");//"POST" ,"GET" 
	        if(refer != null){
	        	conn.addRequestProperty("Referer", refer);
	        }
	        conn.addRequestProperty("Cookie", Cookie);
	        conn.addRequestProperty("Accept-Charset", "UTF-8;");//GB2312,
	        conn.addRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.8) Firefox/3.6.8");
	        conn.setDoOutput(true); 
	        conn.connect();
	        
	        conn.getOutputStream().write(contents.getBytes());
	        
	        if(conn.getHeaderFields().get("Set-Cookie") != null){
		        for(String s:conn.getHeaderFields().get("Set-Cookie")){
		        	Cookie += s;
		        }
	        }
	        
	        InputStream ins =  conn.getInputStream();
	        
	        String charset = "UTF-8"; 
	        InputStreamReader inr = new InputStreamReader(ins, charset);
	        BufferedReader bfr = new BufferedReader(inr);
	       
	        String line = "";
	        StringBuffer res = new StringBuffer(); 
	        do{
	    	    res.append(line);
	    	    line = bfr.readLine();
	    	   //System.out.println(line);
	        }while(line != null);
	      
	        System.out.println(">>>==="+res);
	        
	        return res.toString();
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public  String getUrl(String url){
		try{ 			 
			URL serverUrl = new URL(url);
			HttpURLConnection conn = (HttpURLConnection) serverUrl.openConnection(); 
	        conn.setRequestMethod("GET");//"POST" ,"GET"
	        if(refer != null){
	        	conn.addRequestProperty("Referer", refer);
	        }
	        conn.addRequestProperty("Cookie", Cookie);
	        conn.addRequestProperty("Accept-Charset", "UTF-8;");//GB2312,
	        conn.addRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.8) Firefox/3.6.8");
	        conn.connect();
	       
	        if(conn.getHeaderFields().get("Set-Cookie") != null){
		        for(String s:conn.getHeaderFields().get("Set-Cookie")){
		        	Cookie += s;
		        }
	        }
	        InputStream ins =  conn.getInputStream();
	        
	        String charset = "UTF-8"; 
	        InputStreamReader inr = new InputStreamReader(ins, charset);
	        BufferedReader bfr = new BufferedReader(inr);
	       
	        String line = "";
	        StringBuffer res = new StringBuffer(); 
	        do{
	    	    res.append(line);
	    	    line = bfr.readLine();
	        }while(line != null);
	        
	        return res.toString();
		}catch(Exception e){
			e.printStackTrace();
			return "";
		}
	}
	
	public static String md5_3(String s) throws Exception {
		java.security.MessageDigest md = java.security.MessageDigest
				.getInstance("MD5");
		md.update(s.getBytes("UTF-8"));
		byte tmp[] = md.digest(); // MD5 的计算结果是一个 128 位的长整数，
		md.update(tmp);
		tmp = md.digest();
		md.update(tmp);
		tmp = md.digest();
		
		char hexDigits[] = { // 用来将字节转换成 16 进制表示的字符
		'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

		char str[] = new char[16 * 2]; 
		int k = 0;  
		for (int i = 0; i < 16; i++) { 
			byte byte0 = tmp[i]; // 取第 i 个字节
			str[k++] = hexDigits[byte0 >>> 4 & 0xf]; 
			str[k++] = hexDigits[byte0 & 0xf]; // 取字节中低 4 位的数字转换
		}
		s = new String(str);
		return s;
	}	
	public static String md5(String s) throws Exception {
		java.security.MessageDigest md = java.security.MessageDigest
				.getInstance("MD5");
		md.update(s.getBytes("UTF-8"));
		byte tmp[] = md.digest(); // MD5 的计算结果是一个 128 位的长整数，
		md.update(tmp);
		
		char hexDigits[] = { // 用来将字节转换成 16 进制表示的字符
		'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

		char str[] = new char[16 * 2]; 
		int k = 0;  
		for (int i = 0; i < 16; i++) { 
			byte byte0 = tmp[i]; // 取第 i 个字节
			str[k++] = hexDigits[byte0 >>> 4 & 0xf]; 
			str[k++] = hexDigits[byte0 & 0xf]; // 取字节中低 4 位的数字转换
		}
		s = new String(str);
		return s;
	}
	
	public String getUsername() {
		return Username;
	}

	public void setUsername(String username) {
		Username = username;
	}

	public String getPassword() {
		return Password;
	}

	public void setPassword(String password) {
		Password = password;
	}
}
