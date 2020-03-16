<%@ page import="org.json.JSONArray,
				 org.json.JSONObject" %>
<%@ page import="tidemedia.cms.base.TableUtil" %>
<%@ page import="tidemedia.cms.system.Channel" %>
<%@ page import="tidemedia.cms.system.CmsCache" %>
<%@ page import="tidemedia.cms.system.ErrorLog" %>
<%@ page import="tidemedia.cms.util.EsSeach" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp" %>
<%
    String callback=getParameter(request,"callback");
    int channelid_manager_child = getIntParameter(request, "channelid");//媒体号内容管理子频道id
    int jushi_userid = getIntParameter(request, "userid");//聚视用户id
    int siteid = getIntParameter(request, "siteid");
    JSONObject result = new JSONObject();
    JSONArray array = new JSONArray();
    if (channelid_manager_child==0||siteid==0) {
        result.put("status", 500);
        result.put("messsage", "参数缺失");
        out.print(result.toString());
        return;
    }
    TableUtil tu = new TableUtil();
    ResultSet rs = null;
    Channel channelid_manager = CmsCache.getChannel("company_s"+siteid+"_manager");
    String channelids = "";
    String sql = "select jushi_channelid from "+channelid_manager.getTableName()+" where status=1 and active=1 and category="+channelid_manager_child;
    rs = tu.executeQuery(sql);
    while (rs.next()){
        int jushi_channelid = rs.getInt("jushi_channelid");
        if(jushi_channelid==0){
            continue;
        }
        if(channelids.length()==0){
            channelids+=jushi_channelid;
            continue;
        }
        channelids+=","+jushi_channelid;
    }
    System.out.println("channelids==="+channelids);
    String channelcode = CmsCache.getChannel("company_s"+siteid+"_source").getChannelCode();

    try {
        array = new EsSeach().companyDocNum(channelids, channelcode);
        //System.out.println("arr=========="+array);
        for (int i = 0; i < array.length(); i++) {
            JSONObject json = (JSONObject)array.get(i);
            int channelid = json.getInt("channelid");
            sql = "select * from "+channelid_manager.getTableName()+" where category = "+channelid_manager_child+" and jushi_channelid="+channelid;
            rs = tu.executeQuery(sql);
            String title = "";
            String photo = "";
            String summary = "";
            int company_id = 0;
            int virtualconcern = 0;
            while(rs.next()){
                 title = tu.convertNull(rs.getString("Title"));
                 photo = tu.convertNull(rs.getString("Photo"));
                 summary = tu.convertNull(rs.getString("Summary"));
                 company_id = rs.getInt("company_id");
                virtualconcern = rs.getInt("virtualconcern");
                 json.put("title",title);
                 json.put("photo",photo);
                 json.put("summary",summary);
                 json.put("company_id",company_id);
                 json.put("userWatchCount",virtualconcern);
            }
            array.put(i,json);
        }
        for (int i = 0; i < array.length(); i++) {
            JSONObject json = (JSONObject)array.get(i);
            int company_id = json.getInt("company_id");
            String userWatchCountChannel = "";
            if(siteid==53){
                userWatchCountChannel="community_userwatch";
            }else{
                userWatchCountChannel = "s"+siteid+"_community_userwatch";
            }
            sql = "select count(*) count from "+CmsCache.getChannel(userWatchCountChannel).getTableName()+" where becompanyid="+company_id;
            rs = tu.executeQuery(sql);
            int userWatchCount = 0;
            if(rs.next()){
                userWatchCount = rs.getInt("count");
            }
            json.put("userWatchCount",userWatchCount+json.getInt("userWatchCount"));
            sql= "select * from "+CmsCache.getChannel(userWatchCountChannel).getTableName()+" where active=1 and becompanyid="+company_id+" and userid ="+jushi_userid;
            int isWatch = 0;
            if(jushi_userid==0){
                json.put("isWatch",isWatch);
                array.put(i,json);
                continue;
            }else{

            }
            rs = tu.executeQuery(sql);
            if(rs.next()){
                isWatch = 1;
            }
            json.put("isWatch",isWatch);
            array.put(i,json);
        }
        result.put("status", 200);
        result.put("array", array);
        tu.closeRs(rs);
    } catch (Exception e) {
        ErrorLog.SaveErrorLog("其他错误","ES查询错误",0,e);
        e.printStackTrace(System.out);
        result.put("status", 500);
        result.put("messsage", "获取数据失败");
    }
    out.println(callback+"("+result.toString()+")");

%>
