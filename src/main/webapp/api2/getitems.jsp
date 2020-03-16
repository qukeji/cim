 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				tidemedia.cms.util.*,
				java.sql.SQLException,
				java.sql.Timestamp,
				java.text.ParseException,
				java.text.SimpleDateFormat,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
//判断日期类型是否合法
	public  boolean isValidDate(String str) {
		boolean convertSuccess = true;
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		try {
			format.setLenient(false);
			format.parse(str);
		} catch (ParseException e) {
			// e.printStackTrace();

			convertSuccess = false;
		}
		return convertSuccess;
	}
//将时间日期转化为10位时间戳
	public  Integer StringToTimestamp(String time) {

		int times = 0;
		try {
			times = (int) ((Timestamp.valueOf(time + " 00:00:00").getTime()) / 1000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (times == 0) {
			System.out.println("String转10位时间戳失败");
		}
		return times;

	}
//获取当天23点的时间戳
	public  int Today_endtime(String time) {

		int times = 0;
		try {
			times = (int) ((Timestamp.valueOf(time + " 23:59:59").getTime()) / 1000);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (times == 0) {
			System.out.println("String转10位时间戳失败");
		}
		return times;

	}
	//判断参数输入是否合法
	public boolean JudgeRequest(String str){
		Pattern pattern = Pattern.compile("[0-9]{10}");
		boolean flag_valid=pattern.matches("[0-9]{1,10}", str);
		return flag_valid;
	}
	//获取文章总数
	public int getTotal(int id,int starttime,int endtime)throws Exception{
                Channel channel=CmsCache.getChannel(id);
                int type=channel.getType();

		TableUtil tu=new TableUtil();
		String sql="select count(*) as count from "+CmsCache.getChannel(id).getTableName()+"  where  active=1 and Category="+id+"  and status=1";
                if(type==0){
                   sql="select count(*) as count from "+CmsCache.getChannel(id).getTableName()+"  where  active=1   and status=1";
                }
		if(starttime>0&&endtime>0){
			sql+=" and publishdate>"+starttime+" and publishdate<"+endtime+"";
		}else if(starttime>0&&endtime==0){
			sql+=" and publishdate>"+starttime+" ";
		}else if(starttime==0&&endtime>0){
			sql+=" and publishdate<"+endtime+" ";
		}
		ResultSet rs=tu.executeQuery(sql);
		int count=0;
		while(rs.next()){
			count=rs.getInt("count");
		}
		tu.closeRs(rs);
		return count;
	} 
%>
<%
	JSONObject oo = new JSONObject();

	try{
	int id = getIntParameter(request,"id");
	int pages = getIntParameter(request,"page");
	int pagesize = getIntParameter(request,"pagesize");
	/*int id =  Util.parseInt(ids);
	int pages =  Util.parseInt(pages_);
	int pagesize =  Util.parseInt(pagesize_);
	*/
	/*boolean id_flag=JudgeRequest(ids);
	boolean page_flag=JudgeRequest(pages_);
	boolean pagesize_flag=JudgeRequest(pagesize_);
	*/
	//out.println(id_flag+"----"+page_flag+"-----"+pagesize_flag);
	Channel channel = CmsCache.getChannel(id);//判断频道是否存在
	 if(pages==0||pages<0){
		if(pages==0){
			oo.put("status",0);
			oo.put("message","所传页数不符合要求");
		}
	 }else if(pagesize==0||pagesize<0){
        if(pagesize==0){
			oo.put("status",0);
			oo.put("message","所传每页数量不符合要求");
		}
	 }else if(id==0){
		    oo.put("status",0);
			oo.put("message","频道参数不符合要求");
	 }else if(channel==null){
			oo.put("status",0);
			oo.put("message","该频道编号不存在");
	 }else if(pagesize>=500){
			oo.put("status",0);
			oo.put("message","所传每页数量不符合要求");
	 }else{
	
	
	
	
		String starttime =getParameter(request,"starttime");
		String endtime =getParameter(request,"endtime");
	
	//	String starttime = "2015-08-31";
	//	String endtime = "2015-08-08";
		int starttime_int = 0;
		int endtime_int = 0;
		boolean flag_Start = isValidDate(starttime);
		if (flag_Start) {
			starttime_int = StringToTimestamp(starttime);
		}
		boolean flag_End = isValidDate(endtime);
		if (flag_End) {
			endtime_int = Today_endtime(endtime);
		}
		
		
		String whereSql ="";
		int count=0;
		if (starttime_int == 0 && endtime_int == 0) {
			// 查询所有
			whereSql ="";
			count=getTotal(id,0,0);
		} else if (starttime_int > 0 && endtime_int == 0) {
			int endtime_today=Today_endtime(starttime);//当天24点的时间戳
			whereSql=" PublishDate > "+starttime_int+"  ";
			count=getTotal(id,starttime_int,0);
			// 有开始时间 没结束时间 查询当天的
		}else if(starttime_int > 0 && endtime_int > 0){
			//有开始时间 有结束时间 查询这个时间段 的数据
			whereSql=" PublishDate > "+starttime_int+" and PublishDate< "+endtime_int+" ";
			count=getTotal(id,starttime_int,endtime_int);
		}else if(starttime_int == 0 && endtime_int > 0){
			//没开始时间的话，有结束时间的话也是查询结束时间之前
			whereSql=" PublishDate< "+endtime_int+" ";
			count=getTotal(id,0,endtime_int);
		}

	String orderSql = "order by ordernumber desc";

	
	

	if(pages<=0) pages = 1;
	if(pagesize<=0 || pagesize>500) pagesize = 50;

	PageControl p = new PageControl();
	p.setCurrentPage(pages);
	p.setRowsPerPage(pagesize);
	
	boolean flag_out=true;
	if(pages>count/pagesize+1){
			flag_out=false;
			oo.put("status",0);
			oo.put("message","获取内容数量超过内容总数！");
	}
	

	//Channel channel = CmsCache.getChannel(id);
	if(flag_out){
		ArrayList<Document> items = channel.listItems(p,"",whereSql,orderSql);


		JSONArray jsonArray = new JSONArray();  
		for(int i = 0;i < items.size();i++)
		{
			Document item = items.get(i);
			JSONObject o = new JSONObject();
			o.put("id",item.getId());
			o.put("Title",item.getTitle());
			o.put("Href",item.getFullHref());

			jsonArray.put(o);
		}
		oo.put("documents",jsonArray);
		oo.put("total",count);
		oo.put("message","获取成功！");
		oo.put("status",1);
	}
	
  }
	}catch(Exception e){
			oo.put("message","接口调用失败，请检查传值参数");
			oo.put("status",0);
	}
	 
	out.println(oo.toString());
%>



