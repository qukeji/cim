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
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
   
%>
<%
    JSONObject jsonObject =new JSONObject();
    try{
        Integer globalid = getIntParameter(request,"globalid");
		TideJson daping_config = CmsCache.getParameter("daping").getJson();
		Integer channelid = daping_config.getInt("screenchannelid");
		String sourceid = getParameter(request,"sourceid");

        Integer userId = userinfo_session.getId();
        HashMap<String,String> map = new HashMap<String,String>();
		ItemUtil its = new ItemUtil();
		map.put("sourceid",sourceid);
		its.updateItemByGid(channelid, map,globalid,userId);//根据频道id入库微博数据 
		jsonObject.put("code",200);
		jsonObject.put("message","修改成功");
		out.println(jsonObject.toString());
    }catch(Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","jsp文件异常："+e.toString());
        out.println(jsonObject.toString());
    }
%>
