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
    public  int gettotal(int id) throws MessageException, SQLException{
        int num = 0;
        
        Channel channel = CmsCache.getChannel(id);
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

    TideJson hudong_guanli = CmsCache.getParameter("hudong_guanli").getJson();
    int channelid = hudong_guanli.getInt("shequ");
    int channelid1 = hudong_guanli.getInt("pingjia");
    int channelid2 = hudong_guanli.getInt("yijian");
    int channelid3 = hudong_guanli.getInt("baoliao");
    
	String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();    
    JSONArray array = new JSONArray();
    int count=0;
    int count2=0;
    int count3=0;
    int count4=0;
    count = gettotal(channelid);
    count2 = gettotal(channelid1);
    count3 = gettotal(channelid2);
    count4 = gettotal(channelid3);
     

     json.put("count",count);
     json.put("count2",count2);
     json.put("count3",count3);
     json.put("count4",count4);
     
    out.println(json.toString());
    

%>
