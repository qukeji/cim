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

    //问政总数
    public  int gettotal(int id,int task_status) throws MessageException, SQLException{
        int num = 0;
        
        Channel channel = CmsCache.getChannel(id);
        String whereSql = " where Active=1 and task_status= " + task_status;
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
    
    
    TideJson xuanti = CmsCache.getParameter("xuanti").getJson();
    int channelid = xuanti.getInt("xuantiid");
	String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();    
    JSONArray array = new JSONArray();
     
    
    int task_status[]={0,1,2,3};
    int count3=0;
    int count4=0;
    for(int i=0;i<task_status.length;i++){
        if(task_status[i]==0){
            int count = gettotal(channelid,task_status[i]);
             json.put("count",count);
        }else if(task_status[i]==1){
             count3 = gettotal(channelid,task_status[i]);
              
        }
        else if(task_status[i]==2){
             count4 = gettotal(channelid,task_status[i]);
             
        }
        else if(task_status[i]==3){
            int count2 = gettotal(channelid,task_status[i]);
             json.put("count2",count2);
        }
    }
    
    int count1=count3+count4;
     json.put("count1",count1);
   
     
    out.println(json.toString());
    

%>
