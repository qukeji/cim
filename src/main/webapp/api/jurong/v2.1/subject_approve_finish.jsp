<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.net.*,java.sql.*,tidemedia.cms.base.*,org.json.JSONArray,org.json.JSONObject,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%
int gid = getIntParameter(request,"globalid");
System.out.println("选题gid"+gid);
Document document = new Document(gid);
document.Approve(document.getId()+"",document.getChannelID());
TableUtil tu = new TableUtil();
String sql = "UPDATE "+document.getChannel().getTableName()+" SET rwzt = 3 WHERE id = "+document.getId();
int rs = tu.executeUpdate(sql);
JSONObject json_session=new JSONObject();
//小米推送
    TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
    String push_url = jurong.getString("push_url");
    if(!push_url.equals("")){
        push_url = push_url+"?type=3&id="+gid;
        push_url = Util.ClearPath(push_url);
        Util.connectHttpUrl(push_url);
    }
if(rs==1){
    json_session.put("status",200);
    json_session.put("message","成功");
}else{
    json_session.put("status",500);
    json_session.put("message","失败");  
}

out.println(json_session);
%>
