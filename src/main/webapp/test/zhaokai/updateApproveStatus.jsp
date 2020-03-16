<%@ page import="org.apache.http.HttpResponse,
				org.apache.http.HttpStatus,
				org.apache.http.client.methods.HttpPost"
%>
<%@ page import="org.apache.http.entity.StringEntity" %>
<%@ page import="org.apache.http.impl.client.CloseableHttpClient" %>

<%@ page import="org.apache.http.impl.client.HttpClients" %>
<%@ page import="org.apache.http.message.BasicHeader" %>
<%@ page import="org.apache.http.protocol.HTTP" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="tidemedia.cms.util.Util" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStream" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.File" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.mysql.fabric.xmlrpc.base.Array" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="tidemedia.cms.system.Channel" %>
<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page import="tidemedia.cms.system.FieldGroup" %>
<%@ page import="tidemedia.cms.base.MessageException" %>

<%@ page contentType="text/html;charset=utf-8" %>

<%
    ArrayList<Integer> list = new ArrayList<>();
	String sql = "select * from channel where type in (0)";
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    while (rs.next()) {
        int channelid = rs.getInt("id");
        list.add(channelid);
    }
   for (int i = 0; i <list.size() ; i++) {
        int id = list.get(i);
        Channel channel = CmsCache.getChannel(id);
        sql = "alter table " + channel.getTableName() +" add ApproveStatus int(11) default 0";
        try{
            tu.executeUpdate(sql);
        }catch (Exception e){

           if(e.getMessage().indexOf("Duplicate column")!=-1){
               sql = "alter table " + channel.getTableName() +" alter ApproveStatus set default 0";
               tu.executeUpdate(sql);
            }
        }
        ArrayList<FieldGroup> FieldGroupInfo = channel.getFieldGroupInfo();
        for (int j = 0; j < FieldGroupInfo.size(); j++) {
            FieldGroup fg = FieldGroupInfo.get(j);
            String fgName = fg.getName();
            if("内容编辑".equals(fgName)){
                int fgId = fg.getId();
                sql = "delete from field_desc where FieldName='ApproveStatus' and ChannelID="+id;
                tu.executeUpdate(sql);
                sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
                sql += id + ",'ApproveStatus','" + tu.SQLQuote("审核状态") + "','number',1,1)";
                int fieldid = tu.executeUpdate_InsertID(sql);
                tu.executeUpdate("update field_desc set GroupID=" + fgId + " where id=" + fieldid);
                sql = "update field_desc set OrderNumber=id*100 where OrderNumber=0";
                tu.executeUpdate(sql);
                break;
            }
        }
       // System.out.println("sql======="+sql);
    }
    tu.closeRs(rs);
    out.print("处理完成");


%>

