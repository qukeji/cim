<%@ page language="java" import="java.util.*,
tidemedia.cms.system.CmsCache,
tidemedia.cms.system.Channel,
java.text.DateFormat,
java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@page import="tidemedia.cms.base.TableUtil"%>
<%@page import="java.sql.ResultSet"%>
<%@ include file="/config1.jsp"%>
  
  <%!
  //日期转成时间戳
  	public  long getTimestamp(String datestr) throws Exception{
		   Date date  = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(datestr);
		   return  date.getTime();  
		}
   %>
<%
  /**
   *  创建者		创建时间		说明		
   *   王海龙		20130917		参数 id：直播流编号 字符型
   *                                返回值json字符串
   *										id:直播流编号
   *										list：节目单列表
   *											daytime:当天00:00:00的毫秒值
   *											programme：节目单
   *													s:节目开始播出时间到当天00:00:00的毫秒值
   *													t:节目名
   *
   **/

	
	String liveid= getParameter(request,"id");
	//String time = getParameter(request,"time");
	//String day = getParameter(request,"day");
	//String callback = getParameter(request,"callbakc");
   // System.out.println("liveid------------"+liveid);	
	int days = 6;
	DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	Calendar ca = Calendar.getInstance();
  	String date =(format.format(ca.getTime()).split(" "))[0];//获取当前日期
  	
	 String stime = date+" 23:59:59";//start_time最大限制
	 long temp = getTimestamp(date+" 00:00:00")-days*24*3600*1000;//接口中返回的当前日期（含当天）往前推六天的数据（即七天的数据）
	 String etime = format.format(new Date(temp));//
	System.out.println("------------"+3);	
	int channelid_jiemudan = 5696;//节目单频道ID
	//int channelid_jiemudan = CmsCache.getParameter("sys_channelid_jiemudan").getIntValue();//系统参数sys_channelid_jiemudan
	Channel channel = CmsCache.getChannel(channelid_jiemudan);
	String tableName = channel.getTableName();
	System.out.println("------------"+tableName);	
	TableUtil tu = new TableUtil();
	 
	//String sql ="select start_time,Title from "+ tableName+ w;
	String sql ="select start_time,Title from "+ tableName+ " where liveid= '"+liveid+"' and start_time between '"+etime+ "' and '" +stime+"'";
	System.out.println(sql);
 	ResultSet set = tu.executeQuery(sql);
 	String json = "{\"id\":\""+liveid+"\",list:[";
 	 
 	while(set.next()){
 		 String start_time = set.getString("start_time");
 		 String daytime = (start_time.split(" "))[0]+" 00:00:00";
 		 String mathDaytime = "\"daytime\":\""+getTimestamp(daytime)+"\"";
 		 String title = set.getString("Title");
 		 long s = getTimestamp(start_time)-getTimestamp(daytime);
 		 if(!json.contains(mathDaytime)){
			 if(json.endsWith(",")){
 		 	json = json.substring(0,json.length()-1);
 		 	json = json+"]},";
 		 }  
 		 	 json+="{\"daytime\":\""+getTimestamp(daytime)+"\",programme:[{\"s\":\""+s+"\",\"t\":\""+title+"\"},";
 		 	  
 		 }else{
 		 	json += "{\"s\":\""+s+"\",\"t\":\""+title+"\"},";
 		 }
 		 
 		 	   
 	}
 	if(json.endsWith(",")){
 		 	json = json.substring(0,json.length()-1);
 		   json = json+"]}]}";
 		 	
 		 	}else if(json.endsWith("[")){
 		 	json +="]}";
 		 	}	 
 		 	 
    tu.closeRs(set);
	out.println(json);
 %>

 
