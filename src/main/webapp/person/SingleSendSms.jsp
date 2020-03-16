<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				org.json.*,
				java.net.HttpURLConnection,
				java.net.MalformedURLException,
				java.net.URL,
				java.io.OutputStreamWriter,
                java.io.InputStreamReader,
				java.io.IOException,
				java.io.BufferedReader,
				java.io.InputStream,
				java.io.UnsupportedEncodingException"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!  
public static String postHttpUrl(String httpurl, String data, String charset)
  {
    String content = "";
    try
    {
      URL url = new URL(httpurl);
      HttpURLConnection connection = (HttpURLConnection)url.openConnection();
      connection.setDoOutput(true);
      connection.setUseCaches(false);
      connection.setRequestProperty("Content-Type", "application/json");
      connection.setRequestMethod("POST");
      connection.connect();
      OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream());

      out.write(data);
      out.flush();

      String sCurrentLine = "";

      InputStream l_urlStream = connection.getInputStream();
      BufferedReader l_reader = new BufferedReader(new InputStreamReader(l_urlStream, charset));
      while ((sCurrentLine = l_reader.readLine()) != null)
      {
        content = content + sCurrentLine;
      }
      System.out.println("content:"+content);
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
%>

<%  

	JSONObject json_result = new JSONObject();

    String phone = getParameter(request,"phone");//手机号

	//用户信息
	try {
		TideJson jsonUser = CmsCache.getParameter("user_sms").getJson();
		String TemplateCode = jsonUser.getString("TemplateCode");
		//短信内容
		Random r = new Random();
		String sources = "0123456789";
		StringBuffer sb = new StringBuffer() ;
		for (int i = 0; i < 6; i++) {
			sb.append(sources.charAt(r.nextInt(9)) + "");
		}
		String content = "{\"name\":\"\", \"code\":\""+sb.toString()+"\"}";

		JSONObject json_content = new JSONObject();
	    json_content.put("code",sb.toString());
	    JSONObject json = new JSONObject();
	    json.put("token","产品");
	    json.put("phone",phone);//手机号，多个逗号分割
	    json.put("template",TemplateCode);//模板编号
	    json.put("content",json_content);//短信内容  
	    json.put("identify","");//标识
	    json.put("project","产品");//项目名
		//发送短信
	    String result = postHttpUrl("http://115.29.150.217:888/cms_cloud/api/send_sms.jsp", json.toString(), "utf-8");		
		json_result = new JSONObject(result);
		if(json_result.getInt("state")==1){
			
			//验证码入库
			TableUtil tu_user = new TableUtil("user");
			String sql = "insert into validation (Code,Phone,ExpireDate,CreateDate) values('"+tu_user.SQLQuote(sb.toString())+"','"+tu_user.SQLQuote(phone)+"',date_add(now(), interval 10 minute),now())";
			tu_user.executeUpdate_InsertID(sql);
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	}	
	
	out.println(json_result);
%>