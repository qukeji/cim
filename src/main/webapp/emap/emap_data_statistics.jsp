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

    public  int gettotal(int id) throws MessageException, SQLException{
        int num = 0;
        
        Channel channel = CmsCache.getChannel(id);
        String whereSql = " where Active=1";
        String sql = "select * ,count(*) as total from " + channel.getTableName() + whereSql;
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next())
            num = rs.getInt("total");
        tu.closeRs(rs);
        return num;
    }
%>

<%!
    public  int gettotal1(int id) throws MessageException, SQLException{
    
        int num = 0;
        Channel channel = CmsCache.getChannel(id);
       
        String sql = "select count(*) as total  from " + channel.getTableName() +" where from_unixtime(CreateDate,'%Y-%m-%d %H-%m-%s') >= DATE_ADD(NOW(),INTERVAL -7 day) and Active=1";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql);
        if (rs.next())
            num = rs.getInt("total");
        tu.closeRs(rs);
        return num;
      
    }
    
     public  int gettotal2(int id) throws MessageException, SQLException{
        int num = 0;
        SimpleDateFormat formatter2 = new SimpleDateFormat("yyyy-MM-dd");
		String formatStr2 =formatter2.format(new Date());
        Channel channel = CmsCache.getChannel(id);
        String whereSql = " where Active=1";
        String sql2 = "select count(*) as total  from " + channel.getTableName() +" where to_days(from_unixtime(CreateDate,'%Y-%m-%d %H-%m-%s')) =to_days(now()) ";
        TableUtil tu = new TableUtil();
        ResultSet rs = tu.executeQuery(sql2);
        if (rs.next())
            num = rs.getInt("total");
        tu.closeRs(rs);
        return num;
      
    }
%>


<%

    
    int channelid = 16664;
	String callback=getParameter(request,"callback");
    JSONObject json = new JSONObject();    
    JSONArray array = new JSONArray();
    int count = gettotal(channelid);
    int count1 = gettotal1(channelid);
    int count2 = gettotal2(channelid);
     
     json.put("count",count);//总数
     json.put("count1",count1);//本周
     json.put("count2",count2);//本天
     
    out.println(json.toString());
    

%>
