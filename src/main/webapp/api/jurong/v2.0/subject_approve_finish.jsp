<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.net.*,java.sql.*,tidemedia.cms.base.*,org.json.JSONArray,org.json.JSONObject,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%
int gid = getIntParameter(request,"globalid");
System.out.println("选题gid"+gid);
Document document = new Document(gid);
document.Approve(document.getId()+"",document.getChannelID());
TableUtil tu = new TableUtil();
String sql = "UPDATE "+document.getChannel().getTableName()+" SET task_status = 3 WHERE id = "+document.getId();
int rs = tu.executeUpdate(sql);
 JSONObject json_session=new JSONObject();
if(rs==1){
     
    json_session.put("status",200);
    json_session.put("message","成功");
}else{
    
    json_session.put("status",500);
    json_session.put("message","失败");  
}

out.println(json_session);
%>
