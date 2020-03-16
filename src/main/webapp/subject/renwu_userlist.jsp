<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				org.json.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    String content = getParameter(request,"content");
    int SubjectId = getIntParameter(request,"SubjectId");
    String table="";
    if (SubjectId!=0){
        Document document=CmsCache.getDocument(SubjectId);
        Channel channel=document.getChannel();
        table=channel.getTableName();
    }else {
        JSONObject jsonObject=new JSONObject();
        jsonObject.put("message","选题id为空");
        out.println(jsonObject);
        return;
    }
    String sql="select id, users_id, users from "+table+" where GlobalID="+SubjectId;
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    String users="";
    String id="";
    String users_id="";

    JSONObject jsonObject2=new JSONObject();
    JSONArray arr=new JSONArray();
    if(rs.next()){

        id=rs.getString("id");
        users=rs.getString("users");
        users_id=rs.getString("users_id");
        String user[]=users.split(",");
        String userid[]=users_id.split(",");
        JSONArray arr2=new JSONArray();

        for(int a=0;a<user.length;a++){
            JSONObject jsonObject=new JSONObject();
            jsonObject.put("name",user[a]);
            jsonObject.put("id",userid[a]);
            
            arr2.put(jsonObject);
        }

        jsonObject2.put("result",arr2);
        jsonObject2.put("id",id);
              jsonObject2.put("users_id",users_id);
        jsonObject2.put("message","成功");
        jsonObject2.put("page",2);
        jsonObject2.put("code",200);

    }
    out.println(jsonObject2);
%>
