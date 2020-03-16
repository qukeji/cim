<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONObject,
                org.json.JSONArray,
                org.jsoup.*,
 java.io.File,
 java.io.IOException,
 java.nio.charset.Charset,
 org.apache.http.HttpEntity,
 org.apache.http.HttpResponse,
 org.apache.http.client.ClientProtocolException,
 org.apache.http.client.methods.HttpPost,
 org.apache.http.entity.mime.MultipartEntity,
 org.apache.http.entity.mime.content.FileBody,
 org.apache.http.entity.mime.content.StringBody,
 org.apache.http.impl.client.CloseableHttpClient,
 org.apache.http.impl.client.HttpClients,
 org.apache.http.util.EntityUtils,
java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
    String access_token="";
    String status="";
    String fileName="";
    String content="";
    String url = "https://api.weibo.com/2/statuses/share.json";
    String jsonString = "";
    public String sendWeiboWithImg(String url,String fileName,String access_token,String status)throws
            ClientProtocolException, IOException{

        HttpPost httpPost = new HttpPost(url);

        httpPost.setHeader("User-Agent","SOHUWapRebot");

        httpPost.setHeader("Accept-Language","zh-cn,zh;q=0.5");

        httpPost.setHeader("Accept-Charset","GBK,utf-8;q=0.7,*;q=0.7");

        httpPost.setHeader("Connection","keep-alive");

        MultipartEntity mutiEntity = new MultipartEntity();

        mutiEntity.addPart("access_token",new StringBody(access_token));

        mutiEntity.addPart("status",new StringBody(status,Charset.forName("utf-8")));
        File file=null;

        if(fileName!=""){
            file = new File(fileName);
            //if(file!=null&&file.exists()){
                mutiEntity.addPart("pic", new FileBody(file));
                 mutiEntity.addPart("pic", new FileBody(file));
            //}
        }

        httpPost.setEntity(mutiEntity);

        CloseableHttpClient httpClient = HttpClients.createDefault();

        HttpResponse  httpResponse = httpClient.execute(httpPost);

        HttpEntity httpEntity =  httpResponse.getEntity();

        String content = EntityUtils.toString(httpEntity);

        return content;
    }

%>
<%
System.out.println("微博推送=========》》-=====》》》》》》》》》");
    JSONObject jsonObj = new JSONObject();
    jsonObj.put("code",200);
    jsonObj.put("message","");
    int ids = getIntParameter(request,"ids");
    int channelid = getIntParameter(request,"channelid");
    String weibo_id = getParameter(request,"weibo_id");
    Document doc = new Document(ids,channelid);
   /*int Status = doc.getStatus();
  int push= doc.getIntValue("push_status");*/
  
  //if(Status==1&&push==0){
   
 //	 String content = doc.getValue("Summary")+"http://www.baidu.com";
   content = doc.getValue("Content");
   content= (Jsoup.parse("<div>"+content+"</div>")).text();
   //Element eles = Jsoup.parse(content).getElementsByTag("p");//js_content.children();
    String href= doc.getHttpHref();
     if(content.length()>140){
        content =content.substring(0,50);
    }
    if(href!=""){
        content = content+href;
    }else{
        content = content+"http://www.baidu.com";
    }
    System.out.println("href============================"+href);
    status  =  content; // java.net.URLEncoder.encode(content,"utf-8");
    access_token = CmsCache.getParameterValue("accessToken");
    //access_token = p.getContent();
    fileName = doc.getValue("Photo");
    	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
    	int sys_channelid_image = photo_config.getInt("channelid");
		Channel channel = CmsCache.getChannel(sys_channelid_image);
	String externalUrl = channel.getSite().getSiteFolder();
    if(fileName!=""){
    
        //fileName = "/web/photo"+fileName.substring(23);
      //  fileName = "/home/pic/"+fileName;
         externalUrl = externalUrl +fileName.substring(22);
         //externalUrl = fileName ;
        for(String token:weibo_id.split(",")){
         System.out.println(token+"输出的status  为："+status  );
           jsonString = sendWeiboWithImg(url,externalUrl,token,status);
            JSONObject obj = new JSONObject(jsonString);
             System.out.println("------------------返回结果为："+obj.toString());
             System.out.println("href============================"+href);
            if(obj.has("error")){
            
                  jsonObj.put("code",500);
                  jsonObj.put("message",obj.getString("error"));
                  out.println(jsonObj.toString());
                  return ;
            }
         }
        /*String TableName = new Channel(16092).getTableName();
        TableUtil tu2 = new TableUtil();
	String sql2 = "update "+TableName +" set push_status=1 where globalid="+globalid ;
        out.println("输出的sql2 为："+sql2 );
	int i = tu2.executeUpdate(sql2);*/
    }else{
        try{
             for(String token:weibo_id.split(",")){
             String data = "access_token="+token+"&status="+status;
            System.out.println("--------------------------输出的data为："+data);
                jsonString= Util.postHttpUrl(url,data,"utf-8");
                System.out.println("------------------输出的accesstoken为："+jsonString);
                JSONObject obj = new JSONObject(jsonString);
                System.out.println("------------------返回结果为："+obj.toString());
                if(obj.has("error")){
                  jsonObj.put("code",500);
                  jsonObj.put("message",obj.getString("error"));out.println(jsonObj.toString());
                  out.println(jsonObj.toString());
                  return;
            }
        }
        /*    String TableName = new Channel(16092).getTableName();
        TableUtil tu2 = new TableUtil();
    	String sql2 = "update "+TableName +" set push_status=1 where globalid="+globalid ;
        out.println("输出的sql2 为："+sql2 );
	int i = tu2.executeUpdate(sql2);*/
        }catch(Exception e){
            System.out.println("------------------錯誤的返回自："+jsonString);
            jsonObj.put("code",500);
            jsonObj.put("message",jsonString);
            out.println(jsonObj.toString());
            return;
        }
    }
 System.out.println("href============================"+href);
    out.println(jsonObj.toString());
/*}else{
System.out.println("重复推送");
}*/

%>
