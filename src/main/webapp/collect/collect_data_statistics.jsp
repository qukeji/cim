<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
    //概览页面数据统计
%>

<%!
    public  int gettotal(int channelid) throws MessageException, SQLException{
        int num = 0;
        Channel channel = CmsCache.getChannel(channelid);
        String whereSql = " where Active=1";
        String sql = "select * ,count(1) as total from " + channel.getTableName() + whereSql+" order by id desc";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next())
            num = rs.getInt("total");
        tu.closeRs(rs);
        return num;
    }
%>


<%

	String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();    
    JSONArray array = new JSONArray();
     
     
    TideJson collect = CmsCache.getParameter("collect").getJson();
    int parent = collect.getInt("collect");//
    int collect_could = collect.getInt("collect_could");//
    int collect_paihang = collect.getInt("collect_paihang");// 
    int collect_local = collect.getInt("collect_local");// 
    //16317云资源频道ID，16408热度排行频道id，13097本地采集频道id
    int channelid[]={collect_could,collect_paihang,collect_local};
    int count3=0;
    int count1=0;
     int count=0;
    for(int i=0;i<channelid.length;i++){
        if(channelid[i]==collect_could){
            count = gettotal(channelid[i]);
           
        }else if(channelid[i]==collect_paihang){
             count1 = gettotal(channelid[i]);
              
        }
        else if(channelid[i]==collect_local){
             count3 = gettotal(channelid[i]);
             
        }
        
    }
    
    int count2=count+count1;
    
    json.put("count2",count2);
     json.put("count3",count3);
    out.println(json.toString());
%>
