<%@ page import="com.baidu.aip.nlp.AipNlp,
         tidemedia.cms.util.*,
         tidemedia.cms.system.*,
         org.json.JSONObject,
         org.json.JSONArray,
         java.util.HashMap"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%   

           String content		= getParameter(request,"content");
           
           TideJson aiParameter = CmsCache.getParameter("doc_ai").getJson();

           String APP_ID = aiParameter.getString("app_id");
           String api_key = aiParameter.getString("api_key");
           String SECRET_KEY = aiParameter.getString("secret_key");

            // 初始化一个AipNlp
            AipNlp client = new AipNlp(APP_ID, api_key, SECRET_KEY);
            // 可选：设置网络连接参数
            client.setConnectionTimeoutInMillis(2000);
            client.setSocketTimeoutInMillis(60000);

          //  String text = "百度是一家人工只能公司";

        // 传入可选参数调用接口
            HashMap<String, Object> options = new HashMap<String, Object>();
            JSONArray jsonArray=new JSONArray();
        // 文本纠错
           // JSONObject res = client.ecnet(content, options);
            //out.println(res.toString(2));
            
            
            
       for (int i = 0; i <content.length() ; i++) {
            if(250 * i>=content.length()){
                break;
            }
            String text="";
            if(250 * (i + 1)<content.length()-1) {
                text = content.substring(250 * i, 250 * (i + 1));
            }else {
                text = content.substring(250 * i, content.length());
            }
            JSONObject res = client.ecnet(text, options);
             jsonArray.put(res);
           
        }
         out.println(jsonArray);
%>
