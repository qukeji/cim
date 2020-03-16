<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    int channelid = 16664;
    Channel channel = CmsCache.getChannel(channelid);
    String whereSql = " where Active=1";
    String sql = "select *  from " + channel.getTableName() + whereSql;
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    JSONArray array = new JSONArray();
    while(rs.next()){
        JSONObject json = new JSONObject();
        int id =rs.getInt("id");
        int gid=rs.getInt("GlobalID");
        Document doc=CmsCache.getDocument(gid);
        int chhinnelid1=doc.getChannelID();
        String lat=rs.getString("lat");//维度
        String lng=rs.getString("lng");//维度
        
        String title=rs.getString("Title");
        json.put("id",id);
        json.put("channelid",chhinnelid1);
        json.put("lat",lat);
        json.put("lng",lng);
        json.put("gid",gid);
        
        json.put("title",title);
        
        
       
       String path=doc.getHttpHref();
        json.put("address",path);
        array.put(json);
    }
    
    String callback=getParameter(request,"callback");
     out.println(callback+"("+array+")");
     //out.println(array);
   
%>
