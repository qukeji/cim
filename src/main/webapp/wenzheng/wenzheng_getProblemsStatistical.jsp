 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
                java.util.Calendar,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.util.Date,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%!
//获取当天24点的时间戳
public static int getTimesnight(){ 
    Calendar cal = Calendar.getInstance(); 
    cal.set(Calendar.HOUR_OF_DAY, 24); 
    cal.set(Calendar.SECOND, 0); 
    cal.set(Calendar.MINUTE, 0); 
    cal.set(Calendar.MILLISECOND, 0); 
    return (int) (cal.getTimeInMillis()/1000); 
    } 

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
    JSONArray jsonArray = new JSONArray();  
	try{
	int returnDays = getIntParameter(request,"returnDays");

    TideJson politics = CmsCache.getParameter("politics").getJson();//问政接口信息
    int channelid = politics.getInt("politicsid");//问政编号信息
    Channel channel = CmsCache.getChannel(channelid);

    int endtime = getTimesnight();
    int starttime = endtime;

    if(returnDays!=0){
        starttime=endtime-(86400*returnDays);


    }

    int allnum = 0;
    int acceptnum = 0;
    int endnum = 0;

    String deptsql = "select * from channel where Type = 1 and channelcode like '"+ CmsCache.getChannel(channelid).getChannelCode() + "%'";
    TableUtil depttu = new TableUtil();
	ResultSet deptRs = depttu.executeQuery(deptsql);
    
    while(deptRs.next()) {
        int channerid = deptRs.getInt("id");
        String channername = deptRs.getString("Name");

        String sql = "select count(*) as num from "+CmsCache.getChannel(channerid).getTableName() +" where Category = "+channerid+" and active = 1 and CreateDate>=" + starttime +" and CreateDate<" + endtime +" and Category="+channerid;
        allnum=getNum(sql);
        acceptnum=getNum(sql+" and (probstatus = 4 or probstatus = 5 or probstatus = 6)");
        endnum=getNum(sql+" and probstatus = 7");



        JSONObject o = new JSONObject();
        o.put("name",channername);
        o.put("allnum",allnum);
        o.put("acceptnum",acceptnum);
        o.put("endnum",endnum);
        jsonArray.put(o);

    }
    depttu.closeRs(deptRs);

	}catch(Exception e){
        e.printStackTrace();
	}
	 
	out.println(jsonArray.toString());
%>



