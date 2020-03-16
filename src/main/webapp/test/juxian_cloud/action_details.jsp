<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
    String token = getParameter(request, "token");
    String tidemedia = CmsCache.getParameter("update_token").getContent();
    if(tidemedia.equals(token)){
        JSONObject jsonObject = new JSONObject();
        int cid = getIntParameter(request,"cid");
        int ItemId = getIntParameter(request,"itemId");
        String channelName = CmsCache.getChannel(cid).getName();
        int channelId = 15812;
        String tableName = CmsCache.getChannel(channelId).getTableName();
        String sql = "select * from "+tableName+" where Status = 1";
        if(cid!=0){
            sql += " and Category = "+cid;
        }
        if(ItemId!=0){
            sql += " and id = "+ItemId;
        }
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        JSONArray jsonArray = new JSONArray();
        while(rs.next()){
            int itemId = rs.getInt("id");
            String title = convertNull(rs.getString("Title"));
            String PublishDate = convertNull(rs.getString("PublishDate"));
            int Status = rs.getInt("Status");
            String ModifiedDate = convertNull(rs.getString("ModifiedDate"));
            int userid = rs.getInt("User");
            String userName = CmsCache.getUser(userid).getName();
            String Summary = convertNull(rs.getString("Summary"));
            String Photo = convertNull(rs.getString("Photo"));
            String checkSql = convertNull(rs.getString("check_sql"));
            String executeSql = convertNull(rs.getString("execute_sql"));
            String execute_type = convertNull(rs.getString("execute_type"));
            String update_type = convertNull(rs.getString("update_type"));
            String channel_json = convertNull(rs.getString("channel_json"));
            String db = convertNull(rs.getString("db"));
            String file = convertNull(rs.getString("file"));
            int selectSite = rs.getInt("select_site");
            JSONObject o = new JSONObject();
            o.put("itemId",itemId);
            o.put("title",title);
            o.put("PublishDate",PublishDate);
            o.put("Summary",Summary);
            o.put("Photo",Photo);
            o.put("updateType",update_type);
            o.put("checkSql",checkSql);
            o.put("executeSql",executeSql);
            o.put("execute_type",execute_type);
            o.put("Status",Status);
            o.put("ModifiedDate",ModifiedDate);
            o.put("userName",userName);
            o.put("selectSite",selectSite);
            o.put("update_type",update_type);
            o.put("channel_json",channel_json);
            o.put("db",db);
            o.put("file",file);
            jsonArray.put(o);
        }
        tu.closeRs(rs);
        if(ItemId!=0){
            if(jsonArray.length()>0){
                out.println(jsonArray.get(0));
            }
        }else{
            jsonObject.put("arr",jsonArray);
            jsonObject.put("channelName",channelName);
            out.println(jsonObject);
        }
    }else{
        out.println("密码验证错误!");
    }

%>
