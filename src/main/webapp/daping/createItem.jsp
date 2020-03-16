<%@ page import="tidemedia.cms.system.*,
                java.util.*,tidemedia.cms.util.*,
                java.sql.*,tidemedia.cms.base.*,
                org.json.JSONObject,
                org.json.JSONArray"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
   
%>
<%
    JSONObject jsonObject =new JSONObject();
    try{
        Integer channelid = getIntParameter(request,"channelid");
        String  Title = "未命名";
        Integer userId = userinfo_session.getId();
        HashMap<String,String> map = new HashMap<String,String>();
		map.put("Title",Title);
		map.put("User",userId+"");
		ItemUtil its = new ItemUtil();
        Integer globalid = its.addItemGetGlobalID(channelid, map);//根据频道id入库微博数据 
		jsonObject.put("code",200);
        jsonObject.put("message","新建成功");
        jsonObject.put("parentGlobalid",globalid);
        Document Doc = new Document(globalid);
        jsonObject.put("itemId",Doc.getId());
		out.println(jsonObject.toString());
       // out.println("channelid:"+channelid+"  ids:"+ids+"  userId:"+userId+"  weixin_id:" weixin_id);
    }catch(Exception e){
        jsonObject.put("code",500);
        jsonObject.put("message","jsp文件异常："+e.toString());
        e.printStackTrace();
        out.println(jsonObject.toString());
    }
%>
