package tidemedia.cms.system;

import static org.quartz.CronScheduleBuilder.cronSchedule;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import org.quartz.CronTrigger;
import org.quartz.JobDataMap;
import org.quartz.JobDetail;
import org.quartz.JobKey;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;
import org.quartz.simpl.SimpleThreadPool;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;

/**
 * @author haoyingshuang@tidemedia.com
 */
public class QuartzUtil{
	private Integer ActionUser = 0;//操作者id
	public QuartzUtil() throws MessageException, SQLException {
		super();
	}

	public boolean Check(String jobname) throws SQLException, MessageException {
		TableUtil tu = new TableUtil();
		boolean flag = true;
		String Sql = "select * from quartz_manager where Jobname='"+jobname+"'";
		ResultSet Rs = tu.executeQuery(Sql);
		if(Rs.next()){
			flag = false;
		}
		tu.closeRs(Rs);
		return flag;
	}

	// 启动任务
	public void Enable(int id) throws Exception {
		TableUtil tu = new TableUtil();
		String Sql = "";
		 Sql = "select * from quartz_manager where id=" + id;
		String title = "";
		ResultSet Rs = tu.executeQuery(Sql);
		if(Rs.next()){
			title = tu.convertNull(Rs.getString("Title"));
		}
		Sql = "update quartz_manager set ";
		Sql += "Status=1";
		Sql += " where id=" + id;
		tu.executeUpdate(Sql);
		tu.closeRs(Rs);
		new Log().ScheduleLog(LogAction.schedule_start, title, id, ActionUser);
		startJob(id);
	}
	
	//关闭任务
	public void Disable(int id) throws Exception {
		closeJob(id);
		TableUtil tu = new TableUtil();
		String Sql = "";
		Sql = "select * from quartz_manager where id=" + id;
		String title = "";
		ResultSet Rs = tu.executeQuery(Sql);
		if(Rs.next()){
			title = tu.convertNull(Rs.getString("Title"));
		}
		Sql = "update quartz_manager set ";
		Sql += "Status=0";
		Sql += " where id=" + id;
		tu.executeUpdate(Sql);
		tu.closeRs(Rs);
		new Log().ScheduleLog(LogAction.schedule_end, title, id, ActionUser);
	}
	
	/**
	 * 启动调度程序
	 * @param id
	 * @throws MessageException
	 * @throws SQLException
	 * 动态传递参数，王海龙修改
	 */
	public void startJob(int id) throws MessageException, SQLException{		
			TableUtil tu = new TableUtil();
			String sql = "select * from quartz_manager where Status=1 and id="+id;
			ResultSet rs = tu.executeQuery(sql);
			String jobname = "";
			String jobtime = "";
			String program = "";
			String triggername = "";
			String title = "";
			if(rs.next()){
				int id_ = rs.getInt("id");
				int type = rs.getInt("type");
				jobname = "job_"+id_;
				jobtime = rs.getString("Jobtime");
				program = rs.getString("Program");
				title 	= rs.getString("Title");
				triggername = "trigger_"+id_;
				Scheduler sched;
				try {
					/*sched = getScheduler();
					Class c  =  null;
					if(type==1 || type==2)
					{//1：服务器脚本类型调度 2：程序文件类型调度  3为javabean
						QuartzFile tj = new QuartzFile();
						tj.setFilepath(program);
						tj.setType(type);
						
						program = "tidemedia.cms.system.QuartzFile";
					}
					System.out.println("=-===================="+program);
					c = Class.forName(program);
					JobDetail job1 = newJob(c).withIdentity(jobname, "group1").build();
					CronTrigger trigger = newTrigger().withIdentity(triggername, "group1")
							.withSchedule(cronSchedule(jobtime)).build();
					sched.scheduleJob(job1, trigger);	
					sched.start();
					Log.SystemLog("调度管理", "启用调度任务："+title);*/
					sched = getScheduler();
					JobDetail jobDetail = null;
					if(type==1 || type==2)
					{
						//程序文件或脚本
						jobDetail = newJob(QuartzFile.class).withIdentity(jobname, "group1").build();
						JobDataMap dataMap = jobDetail.getJobDataMap();
						dataMap.put("filepath", program);
						dataMap.put("type", type);
					}
					else 
					{
						//javabean
						Class c = Class.forName(program);
						jobDetail = newJob(c).withIdentity(jobname, "group1").build();
					}
					CronTrigger trigger = newTrigger().withIdentity(triggername, "group1")
					.withSchedule(cronSchedule(jobtime)).build();
					sched.scheduleJob(jobDetail, trigger);	
					sched.start();
					Log.SystemLog("调度管理", "启用调度任务："+title);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					Log.SystemLog("调度管理", "启用调度任务："+title+" 失败！"+e.getMessage());
					e.printStackTrace();
				} 
				
			}
			tu.closeRs(rs);

	}
	
	/**
	 * 关闭调度程序
	 * @param id
	 * @throws MessageException
	 * @throws SQLException
	 */
	public static void closeJob(int id) throws MessageException, SQLException{
		QuartzJob job = new QuartzJob(id);
		try {
			getScheduler().deleteJob(JobKey.jobKey("job_"+id, "group1"));
			Log.SystemLog("调度管理", "关闭调度任务："+job.getTitle());
		} catch (Exception e1) {
			Log.SystemLog("调度管理", "关闭调度任务："+job.getTitle()+" 失败！"+e1.getMessage());
		} 	
	}
	
	//获取Scheduler
	public static Scheduler getScheduler() throws SchedulerException, ParseException, ClassNotFoundException {
		SchedulerFactory sf = new StdSchedulerFactory();
		Scheduler sched = sf.getScheduler();
		SimpleThreadPool tp = new SimpleThreadPool();
		tp.setThreadCount(10);
		// 创建一个工作
		//sched.start();
		return sched;
	}

	public Integer getActionUser() {
		return ActionUser;
	}

	public void setActionUser(Integer actionUser) {
		ActionUser = actionUser;
	}
	
}
