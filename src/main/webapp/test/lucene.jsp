<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,java.net.*,java.io.*,java.util.regex.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>
<%
int gid = getIntParameter(request,"GlobalID");
System.out.println("gid:"+gid);

String urlstr = "http://localhost:888/search/create.jsp";

 URL url = null;
    HttpURLConnection httpurlconnection = null;
    try
    {
		Document doc = new Document(gid);
		
		//String content = doc.getContent().replaceAll("\\<.*?\\>", "");

		String htmlStr = doc.getContent();
           String regEx_script = "<[\\s]*?script[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?script[\\s]*?>"; //定义script的正则表达式{或<script[^>]*?>[\\s\\S]*?<\\/script> }
           String regEx_style = "<[\\s]*?style[^>]*?>[\\s\\S]*?<[\\s]*?\\/[\\s]*?style[\\s]*?>"; //定义style的正则表达式{或<style[^>]*?>[\\s\\S]*?<\\/style> }
              String regEx_html = "<[^>]+>"; //定义HTML标签的正则表达式
         
              java.util.regex.Pattern p_script = Pattern.compile(regEx_script,Pattern.CASE_INSENSITIVE);
              java.util.regex.Matcher m_script = p_script.matcher(htmlStr);
              htmlStr = m_script.replaceAll(""); //过滤script标签

              java.util.regex.Pattern p_style = Pattern.compile(regEx_style,Pattern.CASE_INSENSITIVE);
              java.util.regex.Matcher m_style = p_style.matcher(htmlStr);
              htmlStr = m_style.replaceAll(""); //过滤style标签
         
              java.util.regex.Pattern p_html = Pattern.compile(regEx_html,Pattern.CASE_INSENSITIVE);
              java.util.regex.Matcher m_html = p_html.matcher(htmlStr);
              htmlStr = m_html.replaceAll(""); //过滤html标签 

	  //System.out.println("cid:"+doc.getContent()+"\r\n"+htmlStr);
	  if(doc.getStatus()==1 && htmlStr.length()>20)
		{
			url = new URL(urlstr);

			int doctype = 0;
			String photo = "";

			if(doc.getChannel().getChannelCode().startsWith("1_155"))
			{
				doctype = 1; 
				photo = doc.getValue("Photo");
			}
			
			if(doc.getChannel().getChannelCode().startsWith("1_154"))
			{
				doctype = 2;
				photo = doc.getValue("Photo");
			}

			httpurlconnection = (HttpURLConnection) url.openConnection(); 
			httpurlconnection.setDoOutput(true); 
			httpurlconnection.setRequestMethod("POST");
			String msg="title=" + java.net.URLEncoder.encode(doc.getTitle(),"utf-8"); 
			msg += "&content=" + java.net.URLEncoder.encode(htmlStr,"utf-8");
			String summary = doc.getSummary();
			if(summary.equals("")) summary = doc.getValue("bzz"); 
			msg += "&summary=" + java.net.URLEncoder.encode(summary,"utf-8");

			msg += "&gid="+gid; 
			msg += "&path=" + doc.getFullHref();
			msg += "&photo=" + photo;
			msg += "&doctype="+doctype; 
			msg += "&date="+doc.getPublishDate();

			OutputStream raw = httpurlconnection.getOutputStream(); 
			OutputStream buf = new BufferedOutputStream(raw); 
			OutputStreamWriter cout = new OutputStreamWriter(buf, "UTF-8"); 

			cout.write(msg); 
			cout.flush(); 
			cout.close(); 
			int code = httpurlconnection.getResponseCode();
		}
    //System.out.println("code   " + code);

    }
    catch(Exception e)
    {
      e.printStackTrace();
    }
    finally
    {
      if(httpurlconnection!=null)
        httpurlconnection.disconnect();
    }
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!