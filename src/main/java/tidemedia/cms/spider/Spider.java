/*
 * Created on 2011-3-26
 *
 */
package tidemedia.cms.spider;

import static org.quartz.JobBuilder.newJob;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

import org.apache.velocity.VelocityContext;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.TriggerKey;
import org.quartz.impl.StdSchedulerFactory;
import org.quartz.impl.triggers.SimpleTriggerImpl;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.publish.VelocityUtil;
import tidemedia.cms.system.Log;
import tidemedia.cms.system.LogAction;
import tidemedia.cms.system.Parameter;
import tidemedia.cms.util.Util;
 

/**
 * @author Administrator
 *
 */
public class Spider extends Table{

	private int		id;
	private int 	Channel;
	private int 	Status;//1允许 0禁止
	private int 	User;
	private String 	Url = "";//采集地址
	private String 	Url_First = "";//一次性采集地址
	private String 	Name = "";
	private String 	ListStart = "";
	private String 	ListEnd = "";
	private String 	ListReg = "";
	private String 	HrefReg = "";//链接的正则表达式
	private String 	Charset = "utf-8";//编码 默认utf-8
	private String 	ItemCharset = "utf-8";//文档编码
	private String 	ImageFolder = "";
	private String 	Program = "";//内容分析代理程序，返回json
	private int 	Group = 0;//组编号
	private String	TitleKeyword = "";
	private String 	Url2 = "";
	private String 	Url3 = "";
	private int		ItemStatus = 0;
	private int		IsDownloadImage = 0;
	private int		IsGlobalID = 0;//是否设置globalid
	private int     Period = 0;//采集周期 //每隔period分钟执行一次
	//private long 	RunInterval = 0;//采集间隔时间，单位是秒
	
	//一键转载
	private String transfer;//转载地址
	
	static String triggerName = "spider";
	static String triggerGroupName = "spider_group";
	static String jobName = "job_spider";
	static String jobGroupName = "job_spider_group";
	
	private ArrayList<SpiderField> Fields = new ArrayList<SpiderField>();

	public Spider() throws MessageException, SQLException {
		super();
	}

	public Spider(int id) throws SQLException, MessageException
	{
		String Sql = "select * from spider where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setChannel(Rs.getInt("Channel"));
			setStatus(Rs.getInt("Status"));
			setUser(Rs.getInt("User"));
			setName(convertNull(Rs.getString("Name")));
			setUrl(convertNull(Rs.getString("Url")).trim());
			setListStart(convertNull(Rs.getString("ListStart")).trim());
			setListEnd(convertNull(Rs.getString("ListEnd")).trim());			
			setListReg(convertNull(Rs.getString("ListReg")).trim());
			setCharset(convertNull(Rs.getString("Charset")));
			setItemCharset(convertNull(Rs.getString("ItemCharset")));
			setHrefReg(convertNull(Rs.getString("HrefReg")));
			setImageFolder(convertNull(Rs.getString("ImageFolder")));
			setUrl_First(convertNull(Rs.getString("Url_First")));
			setProgram(convertNull(Rs.getString("Program")));
			setGroup(Rs.getInt("GroupID"));
			setItemStatus(Rs.getInt("ItemStatus"));
			setIsDownloadImage(Rs.getInt("IsDownloadImage"));
			setIsGlobalID(Rs.getInt("IsGlobalID"));
			setTitleKeyword(convertNull(Rs.getString("TitleKeyword")));
			setPeriod(Rs.getInt("Period"));
			//setRunInterval(Rs.getLong("RunInterval"));
			
			setTransfer(convertNull(Rs.getString("transfer_href")));
			
			int ii = Url.replace("http://","").indexOf("/");
			if(ii!=-1)
				Url2 = "http://" + Url.replace("http://","").substring(0,ii);
			else
				Url2 = Url;
			ii = Url.replace("http://","").lastIndexOf("/");
			if(ii!=-1)
				Url3 = "http://" + Url.replace("http://","").substring(0,ii);
			else
				Url3 = Url;
			
			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("该记录不存在!");}
		
		initFields();
	}
	
	public void Add()
	{
		String Sql = "";
		
		Sql = "insert into spider (";
		
		Sql += "Channel,Status,Name,Url,Url_First,ListStart,ListEnd,ListReg,HrefReg,Charset,ItemCharset,TitleKeyword,Period";
		Sql += ",ImageFolder,Program,ItemStatus,IsDownloadImage,IsGlobalID,User,GroupID,CreateDate,transfer_href";
		Sql += ") values(";
		Sql += Channel + ",1";
		Sql += ",'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Url) + "'";
		Sql += ",'" + SQLQuote(Url_First) + "'";
		Sql += ",'" + SQLQuote(ListStart) + "'";
		Sql += ",'" + SQLQuote(ListEnd) + "'";
		Sql += ",'" + SQLQuote(ListReg) + "'";
		Sql += ",'" + SQLQuote(HrefReg) + "'";
		Sql += ",'" + SQLQuote(Charset) + "'";
		Sql += ",'" + SQLQuote(ItemCharset) + "'";
		Sql += ",'" + SQLQuote(TitleKeyword) + "'";
		Sql += "," + Period;
		//Sql += "," + RunInterval;
		Sql += ",'" + SQLQuote(ImageFolder) + "'";
		Sql += ",'" + SQLQuote(Program) + "'";
		Sql += "," + ItemStatus + "";
		Sql += "," + IsDownloadImage + "";
		Sql += "," + IsGlobalID + "";
		Sql += "," + User + "";
		Sql += "," + Group + "";
		Sql += ",now()";
		Sql += ",'"+transfer+"'";
		
		Sql += ")";
		
		
		try
		{
			int id = executeUpdate(Sql);
			startJob(id, Period);
		} 
		catch (Exception e)
	    {
			Log.SystemLog("采集添加", e.getMessage());
	    }
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "delete from spider where id="+id;
		executeUpdate(Sql);			
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		
		
		String Sql = "";
			
		Sql = "update spider set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		Sql += ",Url='" + SQLQuote(Url) + "'";
		Sql += ",Url_First='" + SQLQuote(Url_First) + "'";
		Sql += ",ListStart='" + SQLQuote(ListStart) + "'";
		Sql += ",ListEnd='" + SQLQuote(ListEnd) + "'";
		Sql += ",ListReg='" + SQLQuote(ListReg) + "'";
		Sql += ",HrefReg='" + SQLQuote(HrefReg) + "'";
		Sql += ",Charset='" + SQLQuote(Charset) + "'";
		Sql += ",ItemCharset='" + SQLQuote(ItemCharset) + "'";
		Sql += ",TitleKeyword='" + SQLQuote(TitleKeyword) + "'";
		Sql += ",Period=" + Period ;
		Sql += ",ImageFolder='" + SQLQuote(ImageFolder) + "'";
		Sql += ",Program='" + SQLQuote(Program) + "'";
		Sql += ",ItemStatus=" + ItemStatus + "";
		Sql += ",IsDownloadImage=" + IsDownloadImage + "";
		Sql += ",IsGlobalID=" + IsGlobalID + "";
		Sql += ",GroupID=" + Group + "";
		Sql += ",Channel=" + Channel + "";
		//Sql += ",RunInterval=" + RunInterval + "";
		
		Sql += ",transfer_href='"+transfer+"'";
		
		Sql += " where id="+id;

		try
		{
			executeUpdate(Sql);
			if(Status==1)
			{
				//stopJob(id);//关闭调度
				//startJob(id, Period);//开启调度
			}
		} 
		catch (Exception e)
		{
			Log.SystemLog("采集更新", e.getMessage());
		} 
	}
	//允许或禁止
	public void enable(int flag) throws SQLException, MessageException
	{	
		if(flag==1)//允许
		{
			String sql = "update spider set Status=1 where id="+getId();
			executeUpdate(sql);
		}
		else if(flag==2)//禁止
		{
			String sql = "update spider set Status=0 where id="+getId();
			executeUpdate(sql);
		}
	}
	
	//配置 status=1 开启 =2 关闭
	public void Config(int status,int t) throws SQLException, MessageException
	{
		Parameter p1 = new Parameter("sys_spider_status");
		if(p1.getId()==0)
		{
			p1.setCode("sys_spider_status");
			p1.setName("采集状态");
			p1.setType(1);
			p1.setType2(2);
			p1.setIntValue(status);
			p1.Add();
		}
		else
		{
			p1.setIntValue(status);
			p1.Update();
		}
		
		Parameter p2 = new Parameter("sys_spider_time");
		if(p2.getId()==0)
		{
			p2.setCode("sys_spider_time");
			p2.setName("采集周期");
			p2.setType(1);
			p2.setType2(2);
			p2.setIntValue(t);
			p2.Add();
		}
		else
		{
			p2.setIntValue(t);
			p2.Update();
		}
	}
	/*
	public static void addJob()
	{
		try {
			Parameter p1 = new Parameter("sys_spider_status");
			Parameter p2 = new Parameter("sys_spider_time");
			SchedulerFactory sf = new StdSchedulerFactory();
			
			Scheduler scheduler = sf.getScheduler();
			scheduler.pauseTrigger(new TriggerKey(triggerName,triggerGroupName));
			scheduler.unscheduleJob(new TriggerKey(triggerName,triggerGroupName));
			scheduler.deleteJob(new JobKey(jobName,jobGroupName));
			
			if(p1.getIntValue()==1)
			{
				JobDetail job = newJob(SpiderJob.class)  
	            .withIdentity(jobName, jobGroupName)  
	            .build();  
				//JobDetail jobDetail = new JobDetail(jobName, jobGroupName, SpiderJob.class);
				//SimpleTrigger simpleTrigger = new SimpleTrigger(triggerName,triggerGroupName);
				
				Date runTime = evenMinuteDate(new Date());
				SimpleTrigger trigger = (SimpleTrigger)newTrigger()
	            .withIdentity(triggerName,triggerGroupName)
	            .startAt(runTime)
	            .withSchedule(simpleSchedule()
                    .withIntervalInSeconds(1000)
                    .withRepeatCount(0))
	            .build();
		        
				long ctime = System.currentTimeMillis() + p2.getIntValue()*60000; 
				//System.out.println(new Date(ctime).toGMTString());
				//simpleTrigger.setStartTime(new Date(ctime));
				//simpleTrigger.setRepeatInterval(1000);
				//simpleTrigger.setRepeatCount(0);
				scheduler.scheduleJob(job, trigger);
				scheduler.start();
			}
		} catch (SchedulerException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMessage());
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
	}
	*/
	
	public void initFields() throws MessageException, SQLException
	{
		ArrayList<SpiderField> arr = new ArrayList<SpiderField>();
		String sql = "select id from spider_field where Parent=" + id;
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			SpiderField sf = new SpiderField(rs.getInt("id"));
			arr.add(sf);
		}
		tu.closeRs(rs);
		Fields = arr;
	}
	
	public String getParsed_Url_First()
	{
		String s = "";

		if(Url_First.length()>0)
		{
			VelocityContext context = new VelocityContext();
			VelocityUtil vu = new VelocityUtil();
			context.put( "util", new Util());
			s = vu.TemplateMerge(Url_First, context);
		}

		return s;
	}
	
	/*
	 * 开启调度
	 * @author wanghailong
	 * @date  2013/12/30
	 */
	public static void startJob(int id,int period) throws SchedulerException
	{
		if(period>0)
		{
			Scheduler scheduler = getScheduler();
		    JobDetail jobDetail = newJob(SpiderJob.class).withIdentity(jobName+"_"+id, jobGroupName).build(); 
		    jobDetail.getJobDataMap().put("id", id);
		    SimpleTriggerImpl trigger = new SimpleTriggerImpl(triggerName+"_"+id, triggerGroupName);
		    trigger.setStartTime(new Date(System.currentTimeMillis()));
		    trigger.setRepeatCount(trigger.REPEAT_INDEFINITELY);
		    trigger.setRepeatInterval(period*1000*60);//每隔period分钟执行一次
		    scheduler.scheduleJob(jobDetail, trigger);
	        scheduler.start();
        }
		else
        {
        	Log.SystemLog(LogAction.systemlog_spider, "没有配置采集周期");
        }
	}
	
	/*
	 * 关闭调度
	 * @author wanghailong
	 * @date  2013/12/30
	 */
	public static void stopJob(int id) throws SchedulerException
	{
		Scheduler scheduler = getScheduler();
		 
		if(scheduler.isStarted())
		{
			scheduler.pauseTrigger(TriggerKey.triggerKey(triggerName+"_"+id,triggerGroupName));//停止触发器  
			scheduler.unscheduleJob(TriggerKey.triggerKey(triggerName+"_"+id,triggerGroupName));//移除触发器  
			scheduler.deleteJob(JobKey.jobKey(jobName+"_" + id, jobGroupName));//移除任务
		}
	}
	
	public static Scheduler getScheduler() throws SchedulerException
	{
	    SchedulerFactory sf = new StdSchedulerFactory();
	    Scheduler sched = sf.getScheduler();
	    return sched;
	}
	
	//删除采集历史记录
	public void DeleteSpiderItem() throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		tu.executeUpdate("delete from spider_item where Spider="+getId());
	}
	
	public ArrayList<SpiderField> getFields()
	{
		return Fields;
	}
	
	//通过转载地址获取页面属性设置
	public Spider getSpiderByUri(String uri) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		String sql = "select id from spider where transfer_href like '%"+uri+"%'";
		ResultSet rs = tu.executeQuery(sql);
		int sid = 0;
		if(rs.next())
		{
			sid = rs.getInt("id");
			//return new Spider(rs.getInt("id"));
		}

		tu.closeRs(rs);

		if(sid>0)
			return new Spider(sid);
		else
			return null;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canAdd()
	 */
	public boolean canAdd() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canUpdate()
	 */
	public boolean canUpdate() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canDelete()
	 */
	public boolean canDelete() {
		return false;
	}
	
	/**
	 * @return Returns the id.
	 */
	public int getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(int id) {
		this.id = id;
	}

	/**
	 * @return Returns the user.
	 */
	public int getUser() {
		return User;
	}
	/**
	 * @param user The user to set.
	 */
	public void setUser(int user) {
		User = user;
	}

	public int getChannel() {
		return Channel;
	}

	public void setChannel(int channel) {
		Channel = channel;
	}

	public int getStatus() {
		return Status;
	}

	public void setStatus(int status) {
		Status = status;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getListStart() {
		return ListStart;
	}

	public void setListStart(String listStart) {
		ListStart = listStart;
	}

	public String getListEnd() {
		return ListEnd;
	}

	public void setListEnd(String listEnd) {
		ListEnd = listEnd;
	}

	public String getListReg() {
		return ListReg;
	}

	public void setListReg(String listReg) {
		ListReg = listReg;
	}

	public void setUrl(String url) {
		Url = url;
	}

	public String getUrl() {
		return Url;
	}

	public void setCharset(String charset) {
		Charset = charset;
	}

	public String getCharset() {
		return Charset;
	}

	public void setUrl2(String url2) {
		Url2 = url2;
	}

	public String getUrl2() {
		return Url2;
	}

	public void setUrl3(String url3) {
		Url3 = url3;
	}

	public String getUrl3() {
		return Url3;
	}

	public void setImageFolder(String imageFolder) {
		ImageFolder = imageFolder;
	}

	public String getImageFolder() {
		return ImageFolder;
	}

	public void setItemCharset(String itemCharset) {
		ItemCharset = itemCharset;
	}

	public String getItemCharset() {
		return ItemCharset;
	}

	public void setHrefReg(String hrefReg) {
		HrefReg = hrefReg;
	}

	public String getHrefReg() {
		return HrefReg;
	}

	public String getUrl_First() {
		return Url_First;
	}

	public void setUrl_First(String url_First) {
		Url_First = url_First;
	}

	public String getProgram() {
		return Program;
	}

	public void setProgram(String program) {
		Program = program;
	}

	public int getGroup() {
		return Group;
	}

	public void setGroup(int group) {
		Group = group;
	}

	public int getItemStatus() {
		return ItemStatus;
	}

	public void setItemStatus(int itemStatus) {
		ItemStatus = itemStatus;
	}

	public int getIsDownloadImage() {
		return IsDownloadImage;
	}

	public void setIsDownloadImage(int isDownloadImage) {
		IsDownloadImage = isDownloadImage;
	}

	public String getTitleKeyword() {
		return TitleKeyword;
	}

	public void setTitleKeyword(String titleKeyword) {
		TitleKeyword = titleKeyword;
	}
    public int getPeriod(){
		return Period;
	}
	public void setPeriod(int period){
		Period = period;
	}

	/**
	 * @param transfer the transfer to set
	 */
	public void setTransfer(String transfer) {
		this.transfer = transfer;
	}

	/**
	 * @return the transfer
	 */
	public String getTransfer() {
		return transfer;
	}

	public int getIsGlobalID() {
		return IsGlobalID;
	}

	public void setIsGlobalID(int isGlobalID) {
		IsGlobalID = isGlobalID;
	}
}
