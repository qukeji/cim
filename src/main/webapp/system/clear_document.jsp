<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.plugin.*,
				java.text.SimpleDateFormat,
				java.text.ParseException,
				java.io.IOException,
				java.io.BufferedReader,
				java.net.URL,
				java.net.URLConnection,
				java.net.URLEncoder,
				java.util.*,
				java.util.Date,
				java.text.*,
				java.io.InputStreamReader,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
*用处：删除稿件，每次最多删除500条
*/
%>
<%!
	
	public int startTime=0;//开始时间
	public int endTime=0;//结束时间
	public int TargetChannelID=0;//频道编号
	public static Site site ;//站点
	public int Total = 0 ;//删除总条数

	//初始化开始时间，结束时间，目标频道编号
	public void init(int channelid,String start,String end) throws MessageException, SQLException, ParseException{
		
		TargetChannelID=channelid;
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		start = start.split("\\.")[0];
		end = end.split("\\.")[0];
		if(!start.equals("")){
			java.util.Date date_start = sdf.parse(start);
			startTime=(int) (date_start.getTime()/1000);
		}else{
			startTime=0;
		}		
		if(!end.equals("")){
			java.util.Date date_end = sdf.parse(end);
			endTime=(int) (date_end.getTime()/1000);
		}else{
			endTime=0;
		}
	}

	//查询要删除的数据数量
	public ArrayList<Integer> CheckTemplate(int limit,int Status) throws MessageException, SQLException, IOException,ParseException{
		
		ArrayList<Integer> docList = new ArrayList<Integer>();//每次要删除文章的itemID集合

		TableUtil tu=new TableUtil();
		Channel TargetChannel=CmsCache.getChannel(TargetChannelID);
		String SQL="select id from "+TargetChannel.getTableName()+" where Active=1";
		
		int Category=0;
		if(TargetChannel.getType()!=0){//说明是继承频道
			Category=TargetChannelID;
			SQL+=" and Category="+Category;
		}
		
		if(startTime!=0){
			SQL+=" and ModifiedDate > "+startTime;
		}
		if(endTime!=0){
			SQL+=" and ModifiedDate < "+endTime;
		}
		if(Status==-1){
			SQL+=" and Status=0";
		}else if(Status==1){
			SQL+=" and Status="+Status;
		}
		if(limit!=0){
			SQL +=" limit "+0+","+limit;
		}
		ResultSet rs_Doc=tu.executeQuery(SQL);
		while(rs_Doc.next()){
			int id=rs_Doc.getInt("id");
			docList.add(id);
		}
		tu.closeRs(rs_Doc);
		return docList;
	}
	//删除稿件(文章id，用户id，操作类型)
	public String Delete(int id,int userid,int type) throws SQLException, MessageException{
		String result = "";
		
		boolean DelLocal = false ;//是否删除本地文件

		Document document = CmsCache.getDocument(id,TargetChannelID);

		//更改文章状态
		Channel channel = CmsCache.getChannel(TargetChannelID);
		TableUtil datasource_tu = channel.getTableUtil();
		String Sql = "update " + channel.getTableName() + " set Status=0 where id=" + id;
		if(type==1){//删除文章
			DelLocal = true ;
			Sql = "update " + channel.getTableName() + " set Active=0,Status=0 where id=" + id;
		}
		datasource_tu.executeUpdate(Sql);

		Log.SystemLog("数据清理",  " 频道："+channel.getName()+"   文章："+document.getTitle()+"   时间："+document.getModifiedDate()+"  作者："+document.getUserName()+"   频道id："+TargetChannelID);
		result=" 频道："+channel.getName()+" , 编号："+TargetChannelID +"  , 文章："+document.getTitle()+" ,  时间："+document.getModifiedDate()+" , 作者："+document.getUserName();

		if(type==1){//删除文章
			new ItemSnap().Delete(document.getGlobalID());
			new RelatedItem().Delete(document.getGlobalID());
			CmsCache.delDocument(id, TargetChannelID);
			CmsCache.delDocument(document.getGlobalID());
		}else{
			new ItemSnap().UpdateStatus(document.getGlobalID(), 0);
			new RelatedItem().UpdateStatus(document.getGlobalID(), 0);
			CmsCache.delDocument(id, TargetChannelID);
			CmsCache.delDocument(document.getGlobalID());
		}

		Log l = new Log();
		l.setTitle(document.getTitle());
		l.setUser(userid);
		l.setItem(id);
		if(type==1){
			l.setLogAction(102);
		}else{
			l.setLogAction(103);
		}
		l.setFromType("channel");
		l.setFromKey(TargetChannelID+"");
		l.Add();

		try {
			DelApi delapi = new DelApi();
			delapi.setSiteID(channel.getSiteID());
			delapi.setChannelID(TargetChannelID);
			delapi.setItemID(id);
			delapi.setDelLocal(DelLocal);
			delapi.DeleteFiles();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println(e.getMessage());
		}

		return result;
	}
	
%>
<%
	//接收参数
	int channelid		= getIntParameter(request,"channelid");//频道编号
	String channelname	= getParameter(request,"channelname");//频道名
	int Status			= getIntParameter(request,"Status");//文章状态（草稿：-1 ；已发：1）
	String start		= getParameter(request,"start");//开始时间
	String end			= getParameter(request,"end");//结束时间
	String confirm		= getParameter(request,"confirm");//是否确认删除
	int type			= getIntParameter(request,"type");//操作（删除：1 ；撤稿：2）

//	int limit			= getIntParameter(request,"limit");//每次删除数量
//	if(limit==0){limit=100;}
%>
<%
	try{
		//初始化开始时间，结束时间，目标频道编号
		init(channelid,start,end);

		//判断是否满足删除条件
		if(!confirm.equals("true")){
			Channel channel=new Channel(channelid);
			if(!channel.getName().equals(channelname)){
				out.print("该频道名字与频道id不符");
				return ;
			}
			//查询要删除的数据数量
			ArrayList<Integer> list = CheckTemplate(0,Status);
			Total = list.size() ;
			if(type==1){
				out.print(channel.getName()+"频道"+(start.equals("")?"从创建频道":"从"+start+"时间开始")+(end.equals("")?"至今":"到"+end+"时间")+"，符合删除条件的记录有"+list.size()+"条(包含继承频道)，删除后无法恢复，请问是否确定删除。");
				return ;
			}else{
				out.print(channel.getName()+"频道"+(start.equals("")?"从创建频道":"从"+start+"时间开始")+(end.equals("")?"至今":"到"+end+"时间")+"，符合撤稿条件的记录有"+list.size()+"条(包含继承频道)，请问是否确定撤稿。");
				return ;
			}
		}

		//确认删除稿件
		site = CmsCache.getChannel(TargetChannelID).getSite();
		long Time = System.currentTimeMillis();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		//====>遍历文章
		int documentCount=0;
		ArrayList<Integer> docList = CheckTemplate(500,Status);
		for(int id:docList){
			documentCount++;
			String result = Delete(id,userinfo_session.getId(),type);
			out.println(result+"<br>");
		}
		long Time2 = System.currentTimeMillis();
		if(documentCount>0){
			Log.SystemLog("数据清理",  "清理文章数:"+documentCount+",site："+site.getName()+"   清理文章区间  从："+(startTime>0?(sdf.format(new Date(Long.valueOf(startTime+"000")))):0)+"  到："+(endTime>0?(sdf.format(new Date(Long.valueOf(endTime+"000")))):0)+"  清理所用的时长"+(Time2-Time)+"毫秒");

			out.println("文章清理中请勿关闭页面<br>");

			int Tatal1 = Total-CheckTemplate(0,Status).size();
			NumberFormat numberFormat = NumberFormat.getInstance(); 
			numberFormat.setMaximumFractionDigits(2);
			String result = numberFormat.format((float) Tatal1 / (float) Total * 100); 

			out.println("进度："+ result + "% ("+Tatal1+"/"+Total+")");
		%>
			<meta http-equiv="refresh" content="3" />
		<%}else{%>
			<script>
			alert('文章清理结束');
			javascript:self.close();
			</script>
		<%
			Log.SystemLog("数据清理",  "文章清理结束");
		  }
	} catch (Exception e){
		e.printStackTrace();
		System.out.println(e.getMessage());
		out.println("删除文章失败");
		return ;
	}
%>