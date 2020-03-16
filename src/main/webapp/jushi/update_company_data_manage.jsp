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
    String sql = "select * from "+CmsCache.getChannel("company_s"+siteid+"_manager").getTableName()+" where active=1";
    ResultSet rs = tu.executeQuery(sql);
    String siteurl = CmsCache.getChannel("").getSite().getExternalUrl();
    System.out.println("siteurl=========="+siteurl);
    JSONArray array_manager = new JSONArray();
    while(rs.next()){
        int id = rs.getInt("id");
        /*int company_id = rs.getInt("company_id");
        int juxian_userid = rs.getInt("juxian_userid");*/
        Document doc = CmsCache.getDocument(id,CmsCache.getChannel("company_s"+siteid+"_manager").getId());
        String targetName = doc.getValue("listurl");
        System.out.println("targetName========"+targetName);

        if("".equals(targetName)){
            continue;
        }
        if(targetName.indexOf("http")==-1){
            targetName = siteurl+targetName;
        }
        String json = Util.connectHttpUrl(targetName,"");
        JSONObject jsonObject = new JSONObject(json);
        int jushi_channelid = jsonObject.getInt("list_id");
        System.out.println("jushi_channelid==========="+jushi_channelid);
        JSONObject js = new JSONObject();
        js.put("id",id);
        js.put("jushi_channelid",jushi_channelid);
        array_manager.put(js);
    }
    for (int i = 0; i <array_manager.length() ; i++) {
        JSONObject json = (JSONObject)array_manager.get(i);
        int id = json.getInt("id");
        int jushi_channelid = json.getInt("jushi_channelid");
        tu.executeUpdate("update "+CmsCache.getChannel("company_s"+siteid+"_manager").getTableName()+" set jushi_channelid="+jushi_channelid+" where id="+id);
    }
    tu.closeRs(rs);
    out.println("更新完成");

%>
