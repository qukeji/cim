<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				java.text.SimpleDateFormat,
				org.json.JSONObject,
				java.text.ParseException,
				java.text.DecimalFormat,
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
	 	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM");  
	    Calendar calendar = Calendar.getInstance();     
	    calendar.setTime(date); 
	    calendar.set(Calendar.HOUR_OF_DAY, 0);
	    calendar.set(Calendar.MINUTE, 0);
	    calendar.set(Calendar.SECOND, 0);
	    calendar.set(Calendar.MONTH,calendar.get(Calendar.MONTH) - days);  
	    return df.format(calendar.getTime());
	}
	
	public static List<String> getDate(String start,String end,List<Integer> pvs) throws ParseException {
		
		List<String> xaxis= new ArrayList<String>();

		java.util.Date d1 = new SimpleDateFormat("yyyy-MM").parse(start);
		java.util.Date d2 = new SimpleDateFormat("yyyy-MM").parse(end);//定义结束日期
		Calendar dd = Calendar.getInstance();//

		dd.setTime(d1);

		while(dd.getTime().before(d2)){

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM");
			String str = sdf.format(dd.getTime());
			xaxis.add(str);
			pvs.add(0);
		
			dd.add(Calendar.MONTH, 1);
		}

		return xaxis;
	}
	
	
	//
	public static void setNum(int id,String begintime,String endtime,List<String> xaxis,List<Integer> list) throws ParseException,SQLException,MessageException {
		
		
		TableUtil tu = new TableUtil();
		Map<String,List> res = new HashMap<String,List>();

		String tableName = CmsCache.getChannel(id).getTableName();
	        
      
		String sql = "select from_unixtime(CreateDate,'%Y-%m-%d') as CreateDate,count(*) as num";
        sql += " from "+tableName+" where Active=1 and from_unixtime(CreateDate,'%Y-%m') >= '"+begintime+"' and from_unixtime(CreateDate,'%Y-%m')<'"+endtime +"'";
		System.out.println(sql);
		int num1 = 0 ;//未审核
        int num2 = 0 ;//审核中
        int num3 = 0 ;//审核通过    
		ResultSet rs1 = tu.executeQuery(sql);
		while(rs1.next())
		{
			
			int num = rs1.getInt("num");  
			 String CreateDate	= rs1.getString("CreateDate");
             CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm",CreateDate);
			String date_ = rs1.getTimestamp("CreateDate").toString();
			
			String day = date_.substring(0,7);

			int i = xaxis.indexOf(day);
			list.set(i,num);
			res.put("wenzheng",list);

		}
		tu.closeRs(rs1);
		System.out.println("list:list:"+list);
    
	}


%>
<% 
	int id = 16738 ;

	long current = System.currentTimeMillis();	 
	java.util.Date date = new java.util.Date();
	String begintime = getZeroDate(date,11);
	java.util.Date date1 = new java.util.Date();
	
	Calendar cal = Calendar.getInstance();
    cal.setTime(date1);
    cal.add(Calendar.MONTH, 1);

    System.out.println("date1:"+cal.getTime());
	String endtime = getZeroDate(cal.getTime(),0);
    Map<String,List> res = new HashMap<String,List>();
	

     
	List<Integer> num1 = new ArrayList<Integer>();
	List<String> xaxis= new ArrayList<String>();
	xaxis = getDate(begintime,endtime,num1) ; 
	res.put("xaxis",xaxis);
	setNum(id,begintime,endtime,xaxis,num1);
    res.put("num1",num1);
        
	

	JSONObject jo = new JSONObject(res);
	out.println(jo.toString());

%>

