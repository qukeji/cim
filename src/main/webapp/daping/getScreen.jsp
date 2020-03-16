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
		Integer pglobalid = getIntParameter(request,"pglobalid");
		TideJson daping_config = CmsCache.getParameter("daping").getJson();
		Channel screenChannel = CmsCache.getChannel(daping_config.getInt("screenchannelid"));
		TableUtil tu  = new TableUtil();
		String sql = "select * from " + screenChannel.getTableName()+"  where screenplanid="+pglobalid+" and Active =1 order by PublishDate asc";
		ResultSet rs = tu.executeQuery(sql);
        JSONArray array = new JSONArray();
        int i = 0;
		while(rs.next()){
			JSONObject screenData =new JSONObject();
			Integer globalid = rs.getInt("globalid");
			String Title = rs.getString("Title");
			Integer user = rs.getInt("User");
			screenData.put("globalid",globalid);
			screenData.put("xplace",rs.getString("xplace"));
			screenData.put("yplace",rs.getString("yplace"));
			screenData.put("width",rs.getString("width"));
			screenData.put("height",rs.getString("height"));
			screenData.put("screenpro",rs.getString("screen_pro"));
			screenData.put("sourceid",rs.getString("sourceid"));
			screenData.put("number",i+=1);
			screenData.put("Title",Title);
			array.put(screenData);
		}
		jsonObject.put("code",200);
        jsonObject.put("message","获取成功");
		jsonObject.put("data",array);
		out.println(jsonObject.toString());
    }catch(Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","jsp文件异常："+e.toString());
        out.println(jsonObject.toString());
    }
%>
