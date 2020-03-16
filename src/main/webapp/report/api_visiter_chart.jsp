<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,				
				java.text.SimpleDateFormat,
				org.json.*,
				java.text.ParseException,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
	public static String getCurrentDate(java.util.Date date){
	 	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
	    Calendar calendar = Calendar.getInstance();     
	    calendar.setTime(date);  
	    return df.format(calendar.getTime());
	}
	
	public static String getZeroDate(java.util.Date date,int days){
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
	    Calendar calendar = Calendar.getInstance();     
	    calendar.setTime(date); 
	    calendar.set(Calendar.HOUR_OF_DAY, 0);
	    calendar.set(Calendar.MINUTE, 0);
	    calendar.set(Calendar.SECOND, 0);
	    calendar.set(Calendar.DAY_OF_YEAR,calendar.get(Calendar.DAY_OF_YEAR) - days);  
	    return df.format(calendar.getTime());
	}
	//获取时间段内索引
	public static List<String> getDate(String start,String end,List<Integer> pvs ) throws ParseException {
		
		List<String> xaxis= new ArrayList<String>();

		java.util.Date d1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(start);
		java.util.Date d2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(end);//定义结束日期

		Calendar dd = Calendar.getInstance();//定义日期实例

		dd.setTime(d1);//设置日期起始时间

		while(dd.getTime().before(d2)){//判断是否到结束日期

			SimpleDateFormat sdf = new SimpleDateFormat("dd");

			String str = sdf.format(dd.getTime());
			str = Integer.parseInt(str)+"";

			xaxis.add(str);
			pvs.add(0);

			dd.add(Calendar.DATE, 1);//进行当前日期加1
		}

		return xaxis;
	}
%>
<% 
long current = System.currentTimeMillis();	 
java.util.Date date = new java.util.Date();
String begintime = getZeroDate(date,6);//开始时间
String endtime = getCurrentDate(date);//结束时间


//用户租户
int companyid = userinfo_session.getCompany();
JSONArray arr = ChannelUtil.getApplicationChannel("app",companyid,1,userinfo_session);//所有APP管理

Map<String,List> res = new HashMap<String,List>();
List<Integer> pvs = new ArrayList<Integer>();//纵坐标
List<String> xaxis= new ArrayList<String>();//横坐标
xaxis = getDate(begintime,endtime,pvs) ;

//获取APP站点下的栏目管理id
for(int i=0;i<arr.length();i++){
	JSONObject job = arr.getJSONObject(i);
	int siteid = job.getInt("siteid");
	final String code = "s"+siteid+"_a_a";//栏目管理频道标识
	Channel channel = CmsCache.getChannel(code);
	int id = channel.getId();

	String tableName = CmsCache.getChannel(id).getTableName();
	TableUtil tu = new TableUtil();
	String sql = "select sum(pv_virtual+pv),from_unixtime(PublishDate,'%Y-%m-%d') as PublishDate from "+tableName+" where status=1 and from_unixtime(PublishDate,'%Y-%m-%d %H-%m-%s') >= '"+begintime+"' and from_unixtime(PublishDate,'%Y-%m-%d %H-%m-%s')<'"+endtime +"' group by from_unixtime(PublishDate,'%Y-%m-%d')";
	ResultSet rs1 = tu.executeQuery(sql);
	while(rs1.next())
	{
		int pv = rs1.getInt(1);    
		String date_ = rs1.getTimestamp("PublishDate").toString();
		String day = date_.substring(8,10);
		if(!day.equals("")){
			day = Integer.parseInt(day)+"";
		}
		int j = xaxis.indexOf(day);
		pv = pv + pvs.get(j);
		pvs.set(j,pv);
	}
	tu.closeRs(rs1);
	
}	
res.put("pv",pvs);
res.put("xaxis",xaxis);
JSONObject jo = new JSONObject(res);
out.println(jo.toString());

%>

