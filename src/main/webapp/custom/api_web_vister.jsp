<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*,
				java.io.*,
				java.text.SimpleDateFormat,
				org.json.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.*,
				java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	public static String getCurrentDate(java.util.Date date)
	{
	 	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
	    Calendar calendar = Calendar.getInstance();     
	    calendar.setTime(date);  
	    return df.format(calendar.getTime());
	}
	
	public static String getZeroDate(java.util.Date date,int days)
	{
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
	    Calendar calendar = Calendar.getInstance();     
	    calendar.setTime(date); 
	    calendar.set(Calendar.HOUR_OF_DAY, 0);
	    calendar.set(Calendar.MINUTE, 0);
	    calendar.set(Calendar.SECOND, 0);
		calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR) - days); 
	    return df.format(calendar.getTime());
	}

	public static int getPV(int id,int number) throws SQLException,MessageException{

		int visiter = 0 ;

		long current = System.currentTimeMillis();	 
		java.util.Date date = new java.util.Date();
		String begintime = "";
		String endtime = "";
		switch (number)
		{
			case 2:
				begintime = getZeroDate(date,7); 
				endtime = getZeroDate(date,0);
				break;
			default :
				begintime = getZeroDate(date,0); 
				endtime = getCurrentDate(date);
				break;			
		}

		
		TableUtil tu = new TableUtil();
		String sql = "select sum(pv) from page_distinct p where site="+id+" and date >= '"+begintime+"' and date<'"+endtime+"'";		
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next()){
			visiter = rs.getInt(1);
		}
		tu.closeRs(rs);

		return visiter ;

	}
%>
<%
//long begintime1 = System.currentTimeMillis() ;

int id = getIntParameter(request,"id");
String tableName = CmsCache.getChannel(id).getTableName();

JSONObject o = new JSONObject();
int pv1 = 0;//getPV(id,1);
int pv2 = 0;//getPV(id,2);

long current = System.currentTimeMillis();	 
java.util.Date date = new java.util.Date();
String begintime = getZeroDate(date,7);
String endtime = getCurrentDate(date);
String nowdate = endtime.substring(0,10);

TableUtil tu = new TableUtil();
String sql = "select sum(pv_virtual+pv),from_unixtime(PublishDate,'%Y-%m-%d') as PublishDate from "+tableName+" where status=1 and from_unixtime(PublishDate,'%Y-%m-%d %H-%m-%s') >= '"+begintime+"' and from_unixtime(PublishDate,'%Y-%m-%d %H-%m-%s')<'"+endtime +"' group by from_unixtime(PublishDate,'%Y-%m-%d')";
ResultSet rs1 = tu.executeQuery(sql);
while(rs1.next())
{
	String date_ = rs1.getTimestamp("PublishDate").toString();
	date_ = date_.substring(0,10);

	if(date_.equals(nowdate)){//今日pv

		pv1 = rs1.getInt(1);

	}else{ //近7日PV(今日之前7天)

		pv2 += rs1.getInt(1);
	}	 
}
tu.closeRs(rs1);


o.put("pv1", pv1);
o.put("pv2", pv2);

//System.out.println("用时："+(System.currentTimeMillis()-begintime1));

out.println(o);
%>