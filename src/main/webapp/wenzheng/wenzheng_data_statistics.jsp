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
//获取资源数
public int getNum(String sql){

	int num = 0 ;
	try{
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(sql);
		if(Rs.next()) {
			num = Rs.getInt("num");
		}
		tu.closeRs(Rs);
	}catch(Exception e) {
		e.printStackTrace();			
	}
	return num ;

} 

%>

<%

    TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
    int channelid = politics.getInt("politicsid");//问政编号信息
    Channel channel = CmsCache.getChannel(channelid);
    //今日新增
    Calendar calendar = Calendar.getInstance();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); 
    String nowDate = sdf.format(calendar.getTime());
   
    long nowTime=Util.getFromTime(nowDate,"");
    
    //问政总数
    int count=0;
    int count1=0;
    int count2=0;
    int count3=0;
    int count4=0;
    String whereSql = " where Active=1";
    //zi资源总数
    String sql = "select * ,count(1) as num from " + channel.getTableName() + whereSql+" order by id desc";
    count=getNum(sql);
    //待办理
    sql = "select * ,count(1) as num from " + channel.getTableName() + whereSql+" and Status2=0 order by id desc";
    count1 = getNum(sql);
    //已办理
    sql = "select * ,count(1) as num from " + channel.getTableName() + whereSql+" and Status2=2 order by id desc";
    count2 = getNum(sql);
      //办理中
    sql = "select * ,count(1) as num from " + channel.getTableName() + whereSql+" and Status2=1 order by id desc";
    count4 = getNum(sql);
    //已发布
     sql = "select * ,count(1) as num from " + channel.getTableName() + whereSql+" and Status=1 order by id desc";
    count3 = getNum(sql);
	String callback=getParameter(request,"callback");

    JSONObject json = new JSONObject();    
  
     JSONArray array = new JSONArray();
     
     json.put("count",count);
     json.put("count1",count1);
    json.put("count2",count2);
     json.put("count3",count3);
    json.put("count4",count4);
    out.println(json.toString());

%>
