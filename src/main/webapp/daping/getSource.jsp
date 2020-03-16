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
                java.text.SimpleDateFormat,
                java.util.Date,
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
		Channel sourceChannel = CmsCache.getChannel(daping_config.getInt("sourcechannelid"));
		TableUtil tu  = new TableUtil();
		String sql = "select * from " + sourceChannel.getTableName()+"  where screenplanid="+pglobalid+" and Active =1";
		ResultSet rs = tu.executeQuery(sql);
        JSONArray array = new JSONArray();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
		while(rs.next()){
			JSONObject sourceData =new JSONObject();
			Integer globalid = rs.getInt("globalid");
			String Title = rs.getString("Title");
			String sourceUrl = rs.getString("sourceUrl");
			Integer user = rs.getInt("User");
			String UserName	= CmsCache.getUser(user).getName();
			String date = rs.getString("PublishDate");
            date  = sdf.format(new Date(Long.valueOf(date)*1000));
			sourceData.put("globalid",globalid);
			sourceData.put("sourceUrl",sourceUrl);
			sourceData.put("UserName",UserName);
			sourceData.put("date",date);
			sourceData.put("Title",Title);
			array.put(sourceData);
		}
		tu.closeRs(rs);
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
