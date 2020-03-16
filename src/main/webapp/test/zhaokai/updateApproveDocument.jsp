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
<%@ page import="tidemedia.cms.base.MessageException" %>
<%@ page import="tidemedia.cms.system.*" %>
<%@ page import="java.util.HashMap" %>

<%@ page contentType="text/html;charset=utf-8" %>

<%
    ArrayList<Integer> list = new ArrayList<>();
    ArrayList<Integer> list2 = new ArrayList<>();
	String sql = "select max(id) id from approve_document where Action>-1 group by GlobalID order by id desc ";
    TableUtil tu = new TableUtil();
    ResultSet rs = tu.executeQuery(sql);
    while (rs.next()) {
        int id = rs.getInt("id");
        list.add(id);
    }

    for (int i = 0; i < list.size(); i++) {
        int appdocid = list.get(i);
        ApproveDocument appDoc = new ApproveDocument(appdocid);
        int gid = appDoc.getGlobalID();
        int channelid  = appDoc.getChannelID();
        int action = appDoc.getAction();
        int ApproveItemId = appDoc.getApproveItemId();
        ApproveItems ai = new ApproveItems(ApproveItemId);
        int step = ai.getStep();
        int type = ai.getType();
        int ApproveStatus = 0;
        if(type==1){
            int t_action = -1;
            int flag = 0;
            sql="select id from approve_document where GlobalID="+gid+" and ApproveItemId="+ApproveItemId;
            rs = tu.executeQuery(sql);
            while (rs.next()){
                int aid = rs.getInt("id");
                ApproveDocument appDoc1 = new ApproveDocument(aid);
                t_action=appDoc1.getAction();
                if(t_action==0){
                    flag=1;
                    break;
                }else if(t_action==2){
                    flag=2;
                    break;
                }
            }
            if(flag==0){
                ApproveStatus=100;
            }else if(flag==1){
                ApproveStatus=step;
            }
        }else{
            if(action==0){
                ApproveStatus=step;
            }else if(action==1){
                ApproveStatus=100;
            }
        }
        HashMap map = new HashMap();
        map.put("ApproveStatus",ApproveStatus+"");
        ItemUtil.updateItemByGid(channelid,map,gid,1);
    }
    tu.closeRs(rs);
    out.print("处理完成");


%>

