<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,				
				java.text.SimpleDateFormat,
				org.json.JSONObject,
				java.text.ParseException,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
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
	public static List<String> getDate(String start,String end,List<Integer> pvs) throws ParseException {
		
		List<String> xaxis= new ArrayList<String>();

		java.util.Date d1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(start);
		java.util.Date d2 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").parse(end);//定义结束日期

		Calendar dd = Calendar.getInstance();//定义日期实例

		dd.setTime(d1);//设置日期起始时间

		while(dd.getTime().before(d2)){//判断是否到结束日期

			SimpleDateFormat sdf = new SimpleDateFormat("dd");

			String str = sdf.format(dd.getTime());
//			str = Integer.parseInt(str)+"";

			xaxis.add(str);
			pvs.add(0);
		

			dd.add(Calendar.DATE, 1);//进行当前日期加1
		}

		return xaxis;
	}

	//获取时间段内数据量
	public static void setNum(int id,String begintime,String endtime,List<String> xaxis,List<Integer> list,int type) throws ParseException,SQLException,MessageException {
		
		TableUtil tu = new TableUtil();
		String tableName = CmsCache.getChannel(id).getTableName();
		String sql = "select from_unixtime(CreateDate,'%Y-%m-%d') as CreateDate,count(*) as num";

		if(type==1){//文件
			if(id==8800){//音视频媒资
				sql += " ,sum(video_source_size) as filesize";
			}else{
				sql += " ,sum(filesize) as filesize";
			}
		}

		sql += " from "+tableName+" where Active=1 and from_unixtime(CreateDate,'%Y-%m-%d %H-%m-%s') >= '"+begintime+"' and from_unixtime(CreateDate,'%Y-%m-%d %H-%m-%s')<'"+endtime +"' group by from_unixtime(CreateDate,'%Y-%m-%d')";

		System.out.println(sql);
		
		ResultSet rs1 = tu.executeQuery(sql);
		while(rs1.next())
		{
			int num = rs1.getInt("num");    
			String date_ = rs1.getTimestamp("CreateDate").toString();
			String day = date_.substring(8,10);
			int i = xaxis.indexOf(day);
			list.set(i,num);

			if(type==1){//文件大小
				int filesize = rs1.getInt("filesize");
				filesize = (int)Math.round(filesize/1024+0.5);

				list.set(i,(int)Math.round(filesize/1024+0.5));
			}				
		}
		tu.closeRs(rs1);

	}

%>
<% 
    int id = 14263;
	


	int date_type = getIntParameter(request,"date_type");//date_type=0 7天  date_type=1 30天
	int type = getIntParameter(request,"type");//type=0 数量 type=1 文件

	long current = System.currentTimeMillis();	 
	java.util.Date date = new java.util.Date();
	String begintime = getZeroDate(date,7);
	if(date_type==1){
		begintime = getZeroDate(date,30);
	}
	String endtime = getZeroDate(date,0);
	
	List<Integer> week = new ArrayList<Integer>();

	List<String> xaxis= new ArrayList<String>();
	xaxis = getDate(begintime,endtime,week) ;//横坐标	

	Map<String,List> res = new HashMap<String,List>();
	res.put("xaxis",xaxis);
	
	setNum(id,begintime,endtime,xaxis,week,type);//设置视频数量
	res.put("week",week);


	JSONObject jo = new JSONObject(res);
	out.println(jo.toString());

%>

