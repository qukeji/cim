<%@ page import="tidemedia.cms.system.*,
                java.util.*,tidemedia.cms.util.*,
                java.sql.*,tidemedia.cms.base.*,
                tidemedia.cms.scheduler.*,
                java.net.URL,
                java.net.HttpURLConnection,
                org.json.JSONObject,
                org.json.JSONArray,
                java.net.URL,
                java.net.HttpURLConnection,
                java.io.OutputStreamWriter,
                java.io.BufferedReader,
                java.io.IOException,
                java.io.InputStreamReader,
                tidemedia.cms.publish.*"%>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public JSONObject pushWeixin(String  ids,int channelid,String weixin_id,int userId,String url) throws Exception{
        JSONObject jsonObject =new JSONObject();
        try{
            Channel channel = CmsCache.getChannel(channelid);
            String tableName = channel.getTableName();
            String sql  = "select * from "+tableName+" where id in("+ids+")";
            TableUtil tu = new TableUtil();
            ResultSet rs = tu.executeQuery(sql);
            JSONArray array = new JSONArray();
            String[] gloArray = weixin_id.split(",");
            if(gloArray.length>8){
                jsonObject.put("code",500);
                jsonObject.put("message","最大文章数不得超过8");
                return jsonObject;
            }
            while(rs.next()){
                JSONObject jsonObject1 =new JSONObject();
                jsonObject1.put("globalid",rs.getInt("globalid"));
                jsonObject1.put("title",rs.getString("Title"));
                jsonObject1.put("author",rs.getString("globalid"));
                String content = rs.getString("Content");
                jsonObject1.put("content",content);
                jsonObject1.put("description",rs.getString("Summary"));
                String imagepath = rs.getString("Photo");
                jsonObject1.put("imagepath",imagepath);
                array.put(jsonObject1);
            }
            for(String weixinid :gloArray){
                JSONObject requestJson = new JSONObject();
                requestJson.put("article",array);
                requestJson.put("weixin_id",weixinid);
                jsonObject=httpRequest(url+"/weixin/cmspush.do?news",requestJson.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
        return jsonObject;
    }

    public JSONObject httpRequest(String requestUrl, String outputStr)  throws  Exception{
   
        JSONObject jsonObject =new JSONObject();
        jsonObject.put("code",500);
        jsonObject.put("message","连接异常");
        String result = null;
        try {
            // 创建连接
            URL url = new URL(requestUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setDoOutput(true);
            connection.setDoInput(true);
            connection.setUseCaches(false);
            connection.setInstanceFollowRedirects(true);
            // 设置请求方式
            connection.setRequestMethod("POST");
            // 设置接收数据的格式
            connection.setRequestProperty("Accept", "text/html");
            // 设置发送数据的格式
            connection.setRequestProperty("Content-Type", "application/json");
            // utf-8编码
            connection.connect();
            OutputStreamWriter out = new OutputStreamWriter(connection.getOutputStream(), "UTF-8");
            out.append(outputStr);
            out.flush();
            out.close();
            // 读取响应
            StringBuffer buffer = new StringBuffer();
            BufferedReader reader = null;
            try {
                // 定义BufferedReader输入流来读取URL的响应
                reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
                String line = null;
                String code = new Integer(connection.getResponseCode()).toString();
                System.out.println("Code:"+code);
                while ((line = reader.readLine()) != null) {
                    buffer.append(line);
                }
                if(result==null){
                    result = buffer.toString();
                    jsonObject = new JSONObject(result);
                }
            } catch (IOException e) {
                e.printStackTrace();
                throw new IOException("数据读取异常");
            } finally {
                if(reader!=null){
                    reader.close();
                }
            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
            return jsonObject;
        }catch (Exception e){
            e.printStackTrace();
            return jsonObject;
        }
        // 自定义错误信息
        return jsonObject;
    }
%>
<%
    JSONObject jsonObject =new JSONObject();
    try{
    
        String path = request.getContextPath();  
        String url = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();  
    
        Integer channelid = getIntParameter(request,"channelid");
        String  ids = getParameter(request,"ids");
        Integer userId = userinfo_session.getId();
        String weixin_id = getParameter(request,"weixin_id");
        jsonObject = pushWeixin(ids,channelid,weixin_id,userId,url);
        out.println(jsonObject.toString());
       // out.println("channelid:"+channelid+"  ids:"+ids+"  userId:"+userId+"  weixin_id:" weixin_id);
    }catch(Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","本jsp文件异常："+e.toString());
        out.println(jsonObject.toString());
    }
%>
