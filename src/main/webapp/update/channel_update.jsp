<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="update_api.jsp"%>
<%
    int itemId = getIntParameter(request, "itemId");
    int	siteId = getIntParameter(request,"siteId");
    TideJson update_api = CmsCache.getParameter("update_api").getJson();
    String url = "";
    String token = "";
    if (update_api != null) {
        url = update_api.getString("url");
        token = update_api.getString("token");
    } else {
        url = "http://jushi.tidemedia.com/cms/update_api/";
        token = "tidemedia";
    }
    String result = "";
    if(itemId!=0){
        result = Util.connectHttpUrl(url + "action_details.jsp?token=" + token + "&itemId=" + itemId,"UTF-8");
    }
    System.out.println("result="+result);
    JSONObject jsonObject = new JSONObject(result);
    String channel_json = jsonObject.getString("channel_json");
    String db = jsonObject.getString("db");
    JSONObject jsonObject1 = new JSONObject(channel_json);
    String parent_serialno = "s"+siteId+"_"+jsonObject1.getString("parent_serialno");
    int channelId = CmsCache.getChannel(parent_serialno).getId();
    String name = jsonObject1.getString("name");
    String serialno = "s"+siteId+"_"+jsonObject1.getString("serialno");
    TableUtil tu = null;
    if(db.equals("用户库")){
        tu = new TableUtil("user");
    }else{
        tu = new TableUtil();
    }
    String Sql = "select * from channel where SerialNo='" + tu.SQLQuote(serialno)+"'";
    if (tu.isExist(Sql)) {
        out.println("频道已存在!");
        return;
    }
    createChannel(name,channelId,1,serialno,"");
    out.println("频道已创建!");
%>