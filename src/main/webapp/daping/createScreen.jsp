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
		Integer pglobalid = getIntParameter(request,"pglobalid");
		TideJson daping_config = CmsCache.getParameter("daping").getJson();
		Integer channelid = daping_config.getInt("screenchannelid");
		String Title = getParameter(request,"Title");
		String x = getParameter(request,"x");
		String y = getParameter(request,"y");
		String width = getParameter(request,"width");
		String height = getParameter(request,"height");
		String screen_pro = getParameter(request,"screen_pro");
		String sourceid = getParameter(request,"sourceid");

        Integer userId = userinfo_session.getId();
        HashMap<String,String> map = new HashMap<String,String>();
		ItemUtil its = new ItemUtil();
		if(globalid==0){
			map.put("Title",Title);
			map.put("screenplanid",pglobalid+"");
			map.put("xplace",x);
			map.put("yplace",y);
			map.put("width",width);
			map.put("height",height);
			map.put("screen_pro",screen_pro);
			map.put("User",userId+"");
			its.addItemGetGlobalID(channelid, map);//根据频道id入库微博数据 
			jsonObject.put("code",200);
			jsonObject.put("message","新建成功");
		}else{
			map.put("Title",Title);
			map.put("xplace",x);
			map.put("yplace",y);
			map.put("width",width);
			map.put("height",height);
			map.put("screen_pro",screen_pro);
			map.put("User",userId+"");
			its.updateItemByGid(channelid, map,globalid,userId);//根据频道id入库微博数据 
			jsonObject.put("code",200);
			jsonObject.put("message","修改成功");
		}
		out.println(jsonObject.toString());
    }catch(Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","jsp文件异常："+e.toString());
        out.println(jsonObject.toString());
    }
%>
