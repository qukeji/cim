package tidemedia.cms.scheduler;

import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.quartz.Job;
import org.quartz.JobBuilder;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.SimpleTrigger;
import org.quartz.TriggerKey;
import org.quartz.impl.JobDetailImpl;
import org.quartz.impl.StdSchedulerFactory;
import org.quartz.impl.triggers.SimpleTriggerImpl;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelPrivilege;
import tidemedia.cms.system.Log;



public class TimetoTask {

	/**
	 * @param args
	 * @throws Exception 
	 * @throws SchedulerException 
	 */
	public static String JobGroupName="jGroup1";
	public static String JobItemPre="auto_approve_";
	public static String TriggerGroupName="mTrigger1";
	public static String JobGroupName2="jGroup2";
	public static String JobItemPre2="auto_approve_2";
	public static String TriggerGroupName2="mTrigger2";
	
	    @SuppressWarnings("deprecation")
		public static  void task(String time,int gid) throws SchedulerException, ParseException, MessageException, SQLException {
		// TODO Auto-generated method stub
	    	if(gid<=0){
	    		Log.SystemLog("定时发布", "添加任务失败，gid="+gid+",time="+time);
	    		return;
	    	}
			JobDetail jobDetail	= new JobDetailImpl(JobItemPre+gid,JobGroupName, SetPublishJobUtil.class);
			jobDetail.getJobDataMap().put("gid", gid);
		    SimpleDateFormat df2 =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
		    Date date = df2.parse(time.toString());
			Calendar c1 = Calendar.getInstance();
		    c1.setTime(date);
		    SimpleTrigger	simpleTrigger = new SimpleTriggerImpl(JobItemPre+gid,TriggerGroupName,c1.getTime());    
			SchedulerFactory schedulerFactory = new StdSchedulerFactory();
			Scheduler scheduler = schedulerFactory.getScheduler();
			scheduler.scheduleJob(jobDetail, simpleTrigger);
			scheduler.start();
			Log.SystemLog("定时发布", "添加定时任务，gid="+gid+",time="+time);
	    }
	    
		public static  void revoketask(String time,int gid) throws SchedulerException, ParseException, MessageException, SQLException {
			// TODO Auto-generated method stub
		    	if(gid<=0){
		    		Log.SystemLog("定时撤销", "添加任务失败，gid="+gid+",time="+time);
		    		return;
		    	}
				JobDetail jobDetail	= new JobDetailImpl(JobItemPre2+gid,JobGroupName2, SetRemoveJobUtil.class);
				jobDetail.getJobDataMap().put("gid", gid);
			    SimpleDateFormat df2 =  new SimpleDateFormat ("yyyy-MM-dd HH:mm:ss");
			    Date date = df2.parse(time.toString());
				Calendar c1 = Calendar.getInstance();
			    c1.setTime(date);
			    SimpleTrigger	simpleTrigger = new SimpleTriggerImpl(JobItemPre2+gid,TriggerGroupName2,c1.getTime());    
				SchedulerFactory schedulerFactory = new StdSchedulerFactory();
				Scheduler scheduler = schedulerFactory.getScheduler();
				scheduler.scheduleJob(jobDetail, simpleTrigger);
				scheduler.start();
				Log.SystemLog("定时撤销", "添加定时任务，gid="+gid+",time="+time);
		    }
	    
	    public static void removeJob(int gid) throws SchedulerException, MessageException, SQLException{
	    	String jobName = JobItemPre+gid;
	    	SchedulerFactory sf = new StdSchedulerFactory();
	    	Scheduler sched = sf.getScheduler();
	    	//TriggerKey tk = new TriggerKey(jobName,"jGroup1");
	    	sched.pauseTrigger(new TriggerKey(jobName,JobGroupName));//停止触发器
	    	sched.unscheduleJob(new TriggerKey(jobName,TriggerGroupName));//移除触发器
	    	sched.deleteJob(new JobKey(jobName,JobGroupName));//删除任务
	    	Log.SystemLog("定时发布", "删除定时任务，gid="+gid);
	    }
	    
	    public static void removerevokeJob(int gid) throws SchedulerException, MessageException, SQLException{
	    	String jobName = JobItemPre2+gid;
	    	SchedulerFactory sf = new StdSchedulerFactory();
	    	Scheduler sched = sf.getScheduler();
	    	//TriggerKey tk = new TriggerKey(jobName,"jGroup1");
	    	sched.pauseTrigger(new TriggerKey(jobName,JobGroupName2));//停止触发器
	    	sched.unscheduleJob(new TriggerKey(jobName,TriggerGroupName2));//移除触发器
	    	sched.deleteJob(new JobKey(jobName,JobGroupName2));//删除任务
	    	Log.SystemLog("定时删除", "删除定时任务，gid="+gid);
	    }

}


