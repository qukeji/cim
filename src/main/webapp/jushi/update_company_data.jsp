<%@ page import="tidemedia.cms.system.*,
				 java.sql.*" %>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="tidemedia.cms.util.EsSeach" %>
<%@ page import="org.json.JSONArray" %>
<%@ page import="com.google.gson.JsonObject" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp" %>

<%
    String siteid = getParameter(request, "siteid");
    JSONObject result = new JSONObject();
    if ("".equals(siteid.trim())) {
        result.put("status", 500);
        result.put("messsage", "参数缺失");
        out.print(result.toString());
        return;
    }
    ArrayList<Document> doclist = new ArrayList<>();
    TableUtil tu = new TableUtil();
    String sql = "select * from "+CmsCache.getChannel("company_s"+siteid+"_info").getTableName()+" where active=1 and status1=1";
    ResultSet rs = tu.executeQuery(sql);
    while(rs.next()){
        int id = rs.getInt("id");
        /*int company_id = rs.getInt("company_id");
        int juxian_userid = rs.getInt("juxian_userid");*/
        Document doc = CmsCache.getDocument(id,CmsCache.getChannel("company_s"+siteid+"_info").getId());
        doclist.add(doc);
    }
    JSONArray array_source = new JSONArray();
    for (Document d:doclist) {
        int company_id = d.getIntValue("company_id");
        int juxian_userid= d.getIntValue("juxian_userid");
        sql = "select * from channel where parent = "+CmsCache.getChannel("company_s"+siteid+"_source").getId();
        rs  = tu.executeQuery(sql);
        while (rs.next()){
            int id = rs.getInt("id");
            Channel c = CmsCache.getChannel(id);
            if(!c.getExtra2().startsWith("{")){
                continue;
            }
            JSONObject json = new JSONObject();
            JSONObject jsonEx = new JSONObject(c.getExtra2());//频道扩展属性
            if(jsonEx.has("user")){//说明是个人媒体号
                if(jsonEx.getInt("user")==juxian_userid){
                    System.out.println("Extra2================="+c.getExtra2());
                    System.out.println("title================="+d.getTitle());
                    json.put("id",d.getId());
                    json.put("jushi_channelid",id);
                    array_source.put(json);
                    //tu.executeUpdate("update "+CmsCache.getChannel("company_s"+siteid+"_info").getTableName()+" set jushi_channelid="+id+" where id="+d.getId());
                    //tu.executeUpdate("update "+CmsCache.getChannel("company_s"+siteid+"_manager").getTableName()+" set jushi_channelid="+id+" where juxian_userid="+juxian_userid);
                    continue;
                }
            }else if(jsonEx.has("company")){//说明是企业媒体号
                if(jsonEx.getInt("company")==company_id){
                    System.out.println("Extra2================="+c.getExtra2());
                    System.out.println("title================="+d.getTitle());
                    json.put("id",d.getId());
                    json.put("jushi_channelid",id);
                    array_source.put(json);
                    //tu.executeUpdate("update "+CmsCache.getChannel("company_s"+siteid+"_info").getTableName()+" set jushi_channelid="+id+" where id="+d.getId());
                    //tu.executeUpdate("update "+CmsCache.getChannel("company_s"+siteid+"_manager").getTableName()+" set jushi_channelid="+id+" where company_id="+company_id);
                    continue;
                }
            }
        }
    }
    for (int i = 0; i <array_source.length() ; i++) {
        JSONObject json = (JSONObject)array_source.get(i);
        int id = json.getInt("id");
        int jushi_channelid = json.getInt("jushi_channelid");
        tu.executeUpdate("update "+CmsCache.getChannel("company_s"+siteid+"_info").getTableName()+" set jushi_channelid="+jushi_channelid+" where id="+id);
    }






    tu.closeRs(rs);
    out.println("更新完成");

%>
