<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*,
				java.text.*,
				java.io.*,
				java.text.SimpleDateFormat,
				org.json.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.*,
				java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
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

	public static int getPV(int id,String begintime,String endtime) throws SQLException,MessageException{

		int visiter = 0 ;

		String tableName = CmsCache.getChannel(id).getTableName();
		TableUtil tu = new TableUtil();

		String sql = "select sum(pv_virtual+pv) from "+tableName+" where status=1";
		if(!begintime.equals("")){
			sql += " and from_unixtime(PublishDate,'%Y-%m-%d %H-%m-%s') >= '"+begintime+"' and from_unixtime(PublishDate,'%Y-%m-%d %H-%m-%s')<'"+endtime +"'";
		}
		
		ResultSet rs1 = tu.executeQuery(sql);
		if(rs1.next())
		{
			visiter = rs1.getInt(1);
		}
		tu.closeRs(rs1);

		return visiter ;

	}
%>
<%
//long begintime1 = System.currentTimeMillis() ;
long current = System.currentTimeMillis();	 
java.util.Date date = new java.util.Date();
String begintime = getZeroDate(date,6);//开始时间
String endtime = getCurrentDate(date);//结束时间

JSONObject o = new JSONObject();

//用户租户
int companyid = userinfo_session.getCompany();
JSONArray arr = ChannelUtil.getApplicationChannel("app",companyid,1,userinfo_session);//所有APP管理

int pv1 = 0;
int pv2 = 0;
//获取APP站点下的栏目管理id
for(int i=0;i<arr.length();i++){
	JSONObject job = arr.getJSONObject(i);
	int siteid = job.getInt("siteid");
	final String code = "s"+siteid+"_a_a";//栏目管理频道标识
	Channel channel = CmsCache.getChannel(code);
	int id = channel.getId();
	pv1 += getPV(id,"","");
	pv2 += getPV(id,begintime,endtime);
}

o.put("pv1", pv1);
o.put("pv2", pv2);

//System.out.println("用时："+(System.currentTimeMillis()-begintime1));

out.println(o);
%>