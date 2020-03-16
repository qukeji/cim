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
	public static void setNum(int id,String begintime,String endtime,List<String> xaxis,List<Integer> list,int type) throws ParseException,SQLException,MessageException {
		
		
		TableUtil tu = new TableUtil();
		Map<String,List> res = new HashMap<String,List>();

		String tableName = CmsCache.getChannel(id).getTableName();
	        
      
		String sql = "select from_unixtime(CreateDate,'%Y-%m-%d') as CreateDate,GlobalID";
        sql += " from "+tableName+" where Active=1 and from_unixtime(CreateDate,'%Y-%m') >= '"+begintime+"' and from_unixtime(CreateDate,'%Y-%m')<'"+endtime +"'";
		System.out.println(sql);
		int num1 = 0 ;//未审核
        int num2 = 0 ;//审核中
        int num3 = 0 ;//审核通过    
		ResultSet rs1 = tu.executeQuery(sql);
		while(rs1.next())
		{
			
			int GlobalID = rs1.getInt("GlobalID"); 
			System.out.println("dddddddddddddddddddddddd"+GlobalID);
			
			
			 ApproveAction approve = new ApproveAction(GlobalID,0);
    	    int action	= approve.getAction();//是否通过
    	    int approveid = approve.getId();//审核操作id
    	    int end = approve.getEndApprove();//是否终审
    	    
    	    if(approveid==0){
    	        num1++;
    	    }else if(action==0&&end==1){
    	        num3++;
    	    }else{
    	        num2++;
    	    }
    	    
			 String CreateDate	= rs1.getString("CreateDate");
             CreateDate=Util.FormatDate("yyyy-MM-dd HH:mm",CreateDate);
			String date_ = rs1.getTimestamp("CreateDate").toString();
			
			String day = date_.substring(0,7);

			int i = xaxis.indexOf(day);
			if(type==0){
			list.set(i,num1);
			}else if(type==1){
			   	list.set(i,num2); 
			}else{
			   	list.set(i,num3); 
			}
			
			res.put("wenzheng",list);

		}
		tu.closeRs(rs1);
		System.out.println("list:list:"+list);
    
	}


%>
<% 
	Channel channel = ChannelUtil.getApplicationChannel("shengao");
	int id = channel.getId() ;

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
	


//ºá×ø±ê	
        int type[]={0,1,2};//0 代表未审核，1审核中，3审核完成
        
        for(int i=0;i<type.length;i++){
        if(type[i]==0){
        
        	List<Integer> num1 = new ArrayList<Integer>();
    		List<String> xaxis= new ArrayList<String>();
        	xaxis = getDate(begintime,endtime,num1) ; 
        	res.put("xaxis",xaxis);
        	setNum(id,begintime,endtime,xaxis,num1,type[i]);
            res.put("num1",num1);
        }else if (type[i]==1){
           
        	List<Integer> num2 = new ArrayList<Integer>();
    		List<String> xaxis= new ArrayList<String>();
        	xaxis = getDate(begintime,endtime,num2) ; 
        	res.put("xaxis",xaxis);
        	setNum(id,begintime,endtime,xaxis,num2,type[i]);
            res.put("num2",num2); 
        }else{
           
        	List<Integer> num3 = new ArrayList<Integer>();
    		List<String> xaxis= new ArrayList<String>();
        	xaxis = getDate(begintime,endtime,num3) ; 
        	res.put("xaxis",xaxis);
        	setNum(id,begintime,endtime,xaxis,num3,type[i]);
            res.put("num3",num3);    
        }
        
	}

	JSONObject jo = new JSONObject(res);
	out.println(jo.toString());

%>

