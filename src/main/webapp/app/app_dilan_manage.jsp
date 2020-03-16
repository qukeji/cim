<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				 org.json.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    Channel channel = CmsCache.getChannel("s53_appbot");
    String sql="select * from "+channel.getTableName();
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    int  id=0;
     JSONArray jsonArr = new JSONArray();
    while(rs.next()){
    JSONObject json = new JSONObject();
    id = rs.getInt("id");
    String title=rs.getString("Title");
    Document doc = CmsCache.getDocument(id,channel.getId());
   
    String   company1=doc.getValue("company");
    boolean company=false;
    if(company1.equals("1")){
    company=true;
    }
   
    json.put("Title", doc.getTitle());
    json.put("channelID", doc.getValue("column_id"));
    json.put("listUrl", doc.getValue("column_href"));
     json.put("company", company);
  
      jsonArr.put(json);
    }
  String callback=getParameter(request,"callback");    
 out.println(callback+"("+jsonArr.toString()+")");

%>
