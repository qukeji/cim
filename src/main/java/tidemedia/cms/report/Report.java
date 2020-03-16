package tidemedia.cms.report;

import java.util.ArrayList;
import java.util.Calendar;
import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.user.UserGroup;

public class Report extends Table {
	private String channelID = "";
	private String year = "";
	private String current = "";
	private int groupID;
	private String userName = "";
	private String startDate = "";
	private String endDate = "";
	private String startTime = "";
	private String endTime = "";
	private int total;
	private int countToday;
	private int countYesterday;
	private int countWeek;
	private int countMonth;
	private int countYear;
	
	public ArrayList listByMonth(Calendar nowDate) throws SQLException, MessageException{
		ArrayList list=new ArrayList();
		TableUtil tu = new TableUtil("user");
		String ListSql = "select * from userinfo";
		String CountSql = "select count(*) from userinfo";
		if(!userName.equals("")){
			ListSql += " where Name like '%"+userName+"%'";
			CountSql += " where Name like '%"+userName+"%'";	
		}else if(groupID!=0){
			ListSql += " where GroupID=" + groupID;
			CountSql +=" where GroupID=" + groupID;
		}
		ListSql +=" order by Role,id";
		ResultSet Rs=tu.List(ListSql,CountSql,1,1000);
		
		int maxDay=nowDate.getActualMaximum(Calendar.DAY_OF_MONTH);
		while(Rs.next())
		{
			String Name = convertNull(Rs.getString("Name"));
			int userId = Rs.getInt("id");
			ReportList reportList=new ReportList();
			ArrayList dayCounts=new ArrayList();
			int t=0;
			for(int day=1;day<=maxDay;day++){
				int dayCount=0;
				for(String c:channelID.split(",")){
					dayCount+=getDayCount(userId,Integer.parseInt(c),nowDate,day);
					t+=dayCount;
				}
				dayCounts.add(dayCount);
			}
			reportList.setTotal(t);
			reportList.setDayCounts((ArrayList)dayCounts.clone());
			reportList.setUserName(Name);
			list.add(reportList);
		}
		
		tu.closeRs(Rs);

		return list;
	}
	
	public int getDayCount(int userId,int channelId,Calendar nowDate,int day) throws MessageException, SQLException{
		int num=0;
		String sql="SELECT count(*) as count FROM item_snap where  Active=1 and Status=1 ";
		sql+="and ChannelCode like '%"+channelId+"%' and user="+userId;
		sql+=" and CreateDate>="+getFromToday((Calendar)nowDate.clone(),day);
		sql+=" and CreateDate<"+getToToday((Calendar)nowDate.clone(),day);
		TableUtil tu = new TableUtil();
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		return num;
	}
	
	public ArrayList listByGroup() throws SQLException, MessageException{
		ArrayList list=new ArrayList();
		TableUtil tu = new TableUtil("user");
		String ListSql = "select * from userinfo";
		String CountSql = "select count(*) from userinfo";
		String gName="";
		if(groupID!=0){
			ListSql += " where GroupID=" + groupID;
			CountSql +=" where GroupID=" + groupID;
			UserGroup userGroup=new UserGroup(groupID);
			gName=userGroup.getName();
		}
		
		ListSql +=" order by Role,id";
		ResultSet Rs=tu.List(ListSql,CountSql,1,1000);
		int t=0;
		int tToday=0;
		int tYesterday=0;
		int tWeek=0;
		int tMonth=0;
		int tYear=0;
		while(Rs.next())
		{
			String Name = convertNull(Rs.getString("Name"));
			int userId = Rs.getInt("id");
			ReportList reportList=new ReportList();
			for(String c:channelID.split(",")){
				Channel channel = CmsCache.getChannel(Integer.parseInt(c));
				String channelName=channel.getParentChannel().getName();
				int num=0;
				//发稿量
				num=getTotal(channel, userId);
				reportList.setTotal(reportList.getTotal()+num);
				t+= num;
				//今日发稿量
				num=getToday(channel, userId);
				reportList.setCountToday(reportList.getCountToday()+num);
				tToday+= num;
				//昨日发稿量
				num=getYesterday(channel, userId);
				reportList.setCountYesterday(reportList.getCountYesterday()+num);
				tYesterday+= num;
				//本周
				num=getWeek(channel, userId);
				reportList.setCountWeek(reportList.getCountWeek()+num);
				tWeek+=num;
				//本月
				num=getMonth(channel, userId);
				reportList.setCountMonth(reportList.getCountMonth()+num);
				tMonth+= num;
				//本年	
				num=getYear(channel, userId);
				reportList.setCountYear(reportList.getCountYear()+num);
				tYear+=num;
			}
			reportList.setGroupId(groupID);
			reportList.setGroupName(gName);
			reportList.setUserName(Name);
			reportList.setUserId(userId);
			list.add(reportList);
		}
		
		tu.closeRs(Rs);
		this.total=t;
		this.countToday=tToday;
		this.countYesterday=tYesterday;
		this.countWeek=tWeek;
		this.countMonth=tMonth;
		this.countYear=tYear;

		return list;
	}
	
	public ArrayList listByUserName() throws SQLException, MessageException{
		return listByUserName(0);
	}
	
	public ArrayList listByUserName(int type) throws SQLException, MessageException{
		ArrayList list=new ArrayList();
		TableUtil tu = new TableUtil("user");
		String ListSql = "select * from userinfo";
		String CountSql = "select count(*) from userinfo";
		if(!userName.equals("")){
			ListSql += " where Name like '%"+userName+"%'";
			CountSql += " where Name like '%"+userName+"%'";	
		}
		ListSql +=" order by Role,id";
		ResultSet Rs=tu.List(ListSql,CountSql,1,1000);
		int t=0;
		int tToday=0;
		int tYesterday=0;
		int tWeek=0;
		int tMonth=0;
		int tYear=0;
		while(Rs.next())
		{
			String Name = convertNull(Rs.getString("Name"));
			int userId = Rs.getInt("id");
			for(String c:channelID.split(",")){
				TableUtil tu2= new TableUtil();
				ReportList reportList=new ReportList();
				Channel channel = CmsCache.getChannel(Integer.parseInt(c));
				String channelName=channel.getParentChannel().getName();
				int num=0;
				//发稿量
				if(type==1 || type==0)
				{
				num=getTotal(channel, userId);
				reportList.setTotal(num);
				t+= num;
				}
				//今日发稿量
				if(type==2 || type==0)
				{
				num=getToday(channel, userId);
				reportList.setCountToday(num);
				tToday+= num;
				}
				//昨日发稿量
				if(type==3 || type==0)
				{
				num=getYesterday(channel, userId);
				reportList.setCountYesterday(num);
				tYesterday+= num;
				}
				//本周
				if(type==4 || type==0)
				{
				num=getWeek(channel, userId);
				reportList.setCountWeek(num);
				tWeek+=num;
				}
				//本月
				if(type==5 || type==0)
				{
				num=getMonth(channel, userId);
				reportList.setCountMonth(num);
				tMonth+= num;
				}
				//本年	
				if(type==6 || type==0)
				{
				num=getYear(channel, userId);
				reportList.setCountYear(num);
				tYear+=num;
				}
				
				reportList.setUserName(Name);
				reportList.setUserId(userId);
				reportList.setChannelName(channelName);
				reportList.setChannelId(Integer.parseInt(c));
		
				list.add(reportList);
			}
		}
		
		tu.closeRs(Rs);
		this.total=t;
		this.countToday=tToday;
		this.countYesterday=tYesterday;
		this.countWeek=tWeek;
		this.countMonth=tMonth;
		this.countYear=tYear;

		return list;
	}
	/**得到本年发稿量**/
	public int getYear_(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from " + channel.getTableName() + " where User=" + userId ;
		sql+=" and CreateDate>="+getFromYear();
		sql+=" and CreateDate<"+getToYear();
		sql+=" and Active=1 and Status=1";
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		ArrayList<Channel> arrays = channel.listSubChannels(Channel.Channel_Type);
		for(int i = 0;i<arrays.size();i++)
		{
			Channel ch = (Channel)arrays.get(i);
			if(ch.isTableChannel()) num += getYear(ch,userId);
		}
		
		return num;
	}
	
	/**得到本年发稿量**/
	public int getYear(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from item_snap where User=" + userId ;
		sql+=" and CreateDate>="+getFromYear();
		sql+=" and CreateDate<"+getToYear();
		sql+=" and Status=1 and ChannelCode like '" + channel.getChannelCode() + "%'";
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		return num;
	}
	
	/**得到本月发稿量，修改成从item_snap表读取，2015/04/04**/
	public int getMonth(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from item_snap where User=" + userId ;
		sql+=" and CreateDate>="+getFromMonth();
		sql+=" and CreateDate<"+getToMonth();
		sql+=" and Status=1 and ChannelCode like '" + channel.getChannelCode() + "%'";
		
		//System.out.println(sql);
		
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		return num;
	}
	
	/**得到本月发稿量**/
	public int getMonth_(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from " + channel.getTableName() + " where User=" + userId ;
		sql+=" and CreateDate>="+getFromMonth();
		sql+=" and CreateDate<"+getToMonth();
		sql+=" and Active=1 and Status=1";
		
		//System.out.println(sql);
		
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		ArrayList<Channel> arrays = channel.listSubChannels(Channel.Channel_Type);
		for(int i = 0;i<arrays.size();i++)
		{
			Channel ch = (Channel)arrays.get(i);
			if(ch.isTableChannel()) num += getMonth(ch,userId);
		}
		
		return num;
	}
	
	/**得到本周发稿量**/
	public int getWeek_(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from " + channel.getTableName() + " where User=" + userId ;
		sql+=" and CreateDate>="+getFromWeek();
		sql+=" and CreateDate<"+getToWeek();
		sql+=" and Active=1 and Status=1";
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		ArrayList<Channel> arrays = channel.listSubChannels(Channel.Channel_Type);
		for(int i = 0;i<arrays.size();i++)
		{
			Channel ch = (Channel)arrays.get(i);
			if(ch.isTableChannel()) num += getWeek(ch,userId);
		}
		
		return num;
	}
	
	/**得到本周发稿量**/
	public int getWeek(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from item_snap where User=" + userId ;
		sql+=" and CreateDate>="+getFromWeek();
		sql+=" and CreateDate<"+getToWeek();
		sql+=" and Status=1 and ChannelCode like '" + channel.getChannelCode() + "%'";
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		return num;
	}
	
	/**得到昨日发稿量**/
	public int getYesterday(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from item_snap where User=" + userId ;
		sql+=" and CreateDate>="+getFromYesterday();
		sql+=" and CreateDate<"+getToYesterday();
		sql+=" and Status=1 and ChannelCode like '" + channel.getChannelCode() + "%'";
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		return num;
	}
	
	/**得到今天发稿量**/
	public int getToday(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from item_snap where User=" + userId ;
		sql+=" and CreateDate>="+getFromToday();
		sql+=" and CreateDate<"+getToToday();
		sql+=" and Status=1 and ChannelCode like '" + channel.getChannelCode() + "%'";
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		return num;
	}
	
	/**得到昨日发稿量**/
	public int getYesterday_(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from " + channel.getTableName() + " where User=" + userId ;
		sql+=" and CreateDate>="+getFromYesterday();
		sql+=" and CreateDate<"+getToYesterday();
		sql+=" and Active=1 and Status=1";
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		ArrayList<Channel> arrays = channel.listSubChannels(Channel.Channel_Type);
		for(int i = 0;i<arrays.size();i++)
		{
			Channel ch = (Channel)arrays.get(i);
			if(ch.isTableChannel()) num += getYesterday(ch,userId);
		}
		
		return num;
	}
	/**得到今天发稿量**/
	public int getToday_(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from " + channel.getTableName() + " where User=" + userId ;
		sql+=" and CreateDate>="+getFromToday();
		sql+=" and CreateDate<"+getToToday();
		sql+=" and Active=1 and Status=1";
		ResultSet rs =tu.executeQuery(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		ArrayList<Channel> arrays = channel.listSubChannels(Channel.Channel_Type);
		for(int i = 0;i<arrays.size();i++)
		{
			Channel ch = (Channel)arrays.get(i);
			if(ch.isTableChannel()) num += getToday(ch,userId);
		}
		
		return num;
	}
	
	/**得到发稿量**/
	public int getTotal(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from item_snap where User=" + userId;
		
		if(!startDate.equals("")){
			sql+=" and CreateDate>="+getFromTime();
		}
		if(!endDate.equals("")){
			sql+=" and CreateDate<"+getToTime();
		}
		sql+=" and Status=1 and ChannelCode like '" + channel.getChannelCode() + "%'";
		ResultSet rs =tu.executeQuery(sql);
		//System.out.println(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		return num;
	}
	
	
	/**得到发稿量**/
	public int getTotal_(Channel channel,int userId) throws SQLException, MessageException{
		int num=0;
		TableUtil tu= new TableUtil();
		String sql = "select count(*) from " + channel.getTableName() + " where User=" + userId;
		
		if(!startDate.equals("")){
			sql+=" and CreateDate>="+getFromTime();
		}
		if(!endDate.equals("")){
			sql+=" and CreateDate<"+getToTime();
		}
		sql+=" and Active=1 and Status=1";
		ResultSet rs =tu.executeQuery(sql);
		//System.out.println(sql);
		if(rs.next())
		{
			num=rs.getInt(1);
		}
		tu.closeRs(rs);
		
		ArrayList<Channel> arrays = channel.listSubChannels(Channel.Channel_Type);
		for(int i = 0;i<arrays.size();i++)
		{
			Channel ch = (Channel)arrays.get(i);
			//System.out.println(ch.getId()+"_"+ch.getName());
			if(ch.isTableChannel()) num += getTotal(ch,userId);
		}
		
		return num;
	}
	
	public long getFromYear(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		nowDate.set(Calendar.DAY_OF_MONTH,1);
		nowDate.set(Calendar.MONTH,0);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public long getToYear(){
		Calendar nowDate= new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		nowDate.set(Calendar.DAY_OF_MONTH,1);
		nowDate.set(Calendar.MONTH,12);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public long getFromMonth(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		nowDate.set(Calendar.DAY_OF_MONTH,1);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public long getToMonth(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		nowDate.set(Calendar.DAY_OF_MONTH,1);
		nowDate.add(Calendar.MONTH,1);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	
	public long getFromWeek(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		nowDate.set(Calendar.DAY_OF_WEEK,Calendar.MONDAY);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public long getToWeek(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		nowDate.set(Calendar.DAY_OF_WEEK,Calendar.MONDAY);
		nowDate.add(Calendar.WEEK_OF_MONTH,1);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public long getFromYesterday(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		nowDate.add(Calendar.DAY_OF_MONTH,-1);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public long getToYesterday(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public long getFromToday(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public long getToToday(){
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		nowDate.add(Calendar.DAY_OF_MONTH,1);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public static long getFromToday(Calendar nowDate,int day){
		nowDate.set(Calendar.DAY_OF_MONTH,day);
		return  nowDate.getTimeInMillis()/1000;
	}
	
	public static long getToToday(Calendar nowDate,int day){
			nowDate.set(Calendar.DAY_OF_MONTH,day);
			nowDate.add(Calendar.DAY_OF_MONTH,1);
			return  nowDate.getTimeInMillis()/1000;
	}
		
	
	public long getFromTime(){
		Calendar nowDate = new java.util.GregorianCalendar();
		long fromtime=0;
		if(!startDate.equals("")){
			String []s=startDate.split("-");
			nowDate = new java.util.GregorianCalendar();
			nowDate.set(Calendar.DAY_OF_MONTH,Integer.parseInt(s[2]));
			nowDate.set(Calendar.MONTH,Integer.parseInt(s[1])-1);
			nowDate.set(Calendar.YEAR,Integer.parseInt(s[0]));
			
			String []t=startTime.split(":");
			nowDate.set(Calendar.HOUR_OF_DAY,Integer.parseInt(t[0]));
			nowDate.set(Calendar.MINUTE,Integer.parseInt(t[1]));
			nowDate.set(Calendar.SECOND,0);
			fromtime = nowDate.getTimeInMillis()/1000;
		}
		return fromtime;
	}
	
	public long getToTime(){
		Calendar nowDate = new java.util.GregorianCalendar();
		long totime=0;
		if(!endDate.equals("")){
			String []s=endDate.split("-");
			nowDate = new java.util.GregorianCalendar();
			nowDate.set(Calendar.DAY_OF_MONTH,Integer.parseInt(s[2]));
			nowDate.set(Calendar.MONTH,Integer.parseInt(s[1])-1);
			nowDate.set(Calendar.YEAR,Integer.parseInt(s[0]));
			
			String []t=endTime.split(":");
			nowDate.set(Calendar.HOUR_OF_DAY,Integer.parseInt(t[0]));
			nowDate.set(Calendar.MINUTE,Integer.parseInt(t[1]));
			nowDate.set(Calendar.SECOND,0);
			totime = nowDate.getTimeInMillis()/1000;
		}
		return totime;
	}
	public String getChannelID() {
		return channelID;
	}

	public void setChannelID(String channelID) {
		this.channelID = channelID;
	}

	public String getYear() {
		return year;
	}

	public void setYear(String year) {
		this.year = year;
	}

	public String getCurrent() {
		return current;
	}

	public void setCurrent(String current) {
		this.current = current;
	}

	public int getGroupID() {
		return groupID;
	}

	public void setGroupID(int groupID) {
		this.groupID = groupID;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getStartDate() {
		return startDate;
	}

	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public Report() throws MessageException, SQLException {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public void Add() throws SQLException, MessageException {
		// TODO Auto-generated method stub

	}

	@Override
	public void Delete(int id) throws SQLException, MessageException {
		// TODO Auto-generated method stub

	}

	@Override
	public void Update() throws SQLException, MessageException {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean canAdd() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canDelete() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canUpdate() {
		// TODO Auto-generated method stub
		return false;
	}

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}

	public int getCountToday() {
		return countToday;
	}

	public void setCountToday(int countToday) {
		this.countToday = countToday;
	}

	public int getCountYesterday() {
		return countYesterday;
	}

	public void setCountYesterday(int countYesterday) {
		this.countYesterday = countYesterday;
	}

	public int getCountWeek() {
		return countWeek;
	}

	public void setCountWeek(int countWeek) {
		this.countWeek = countWeek;
	}

	public int getCountMonth() {
		return countMonth;
	}

	public void setCountMonth(int countMonth) {
		this.countMonth = countMonth;
	}

	public int getCountYear() {
		return countYear;
	}

	public void setCountYear(int countYear) {
		this.countYear = countYear;
	}

}
