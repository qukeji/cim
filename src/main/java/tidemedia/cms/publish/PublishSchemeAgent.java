/*
 * Created on 2004-12-26
 *
 * Window - Preferences - Java - Code Style - Code Templates
 */
package tidemedia.cms.publish;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Log;
import tidemedia.cms.util.Util;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * @author Administrator
 * 
 */
public class PublishSchemeAgent implements Runnable {
	private static final long serialVersionUID = -7128203829971899888L;
	private Thread runner;
	// private long NoTask_BeginTime =
	// 0;//没有发布任务开始的时间，如果没有任务超过10分钟，则结束PublishAgent运行
	private int SleepTime;// 线程睡眠周期

	private static String message = "";//进程信息

	public PublishSchemeAgent() {
	}

	public void Start() {
		// 主系统才开启线程 20160608
		if (!CmsCache.getConfig().getActive().equals("1"))
		{
			message = Util.getCurrentDate("MM-dd HH:mm:ss")+" active为0，引擎关闭";
			return;
		}

		message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 发布方案监控已经启动";
		
		if (runner == null) {
			runner = new Thread(this);
			runner.start();
		}
	}

	public void run() {
		try {			
			// 0 待发布
			// 1 已经发布
			// 3 正在发布
			// 4 发布失败
			while (true) {
				
				String Sql = "select * from publish_scheme where Status=2";
				TableUtil tu = new TableUtil();				
				ResultSet Rs = tu.executeQuery(Sql);
				ArrayList objs = new ArrayList();				
				while (Rs.next()) {
					int id = Rs.getInt("id");
					objs.add(id);
				}
				tu.closeRs(Rs);
				
				if(objs.size()>0)
				{
					for(int i = 0;i<objs.size();i++)
					{
						int ps_id = (Integer)objs.get(i);
						TideFtpClient tideftp = FtpManager.getFtp(ps_id);
						
						message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 检查暂停发布方案是否恢复,编号："+ps_id;
						
				    	if(tideftp.getFtp()!=null) 
				    	{				    		
				    		//ftp 已经能连接了
				    		PublishScheme ps = CmsCache.getPublishScheme(ps_id);
				    		ps.Enable();
				    		//把标记失败的重新加入发布队列 加上Status=4 20190916
				    		Sql = "update publish_item set Status=0,Message='重新开始ftp发布' where Status=4 and PublishScheme=" + ps_id;
	  	  					tu.executeUpdate(Sql);
	  	  					Log.SystemLog("发布方案","ftp登录成功，恢复发布方案："+ps.getName()+"("+ps.getId()+")");
	  	  					message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 发布方案已经恢复,编号："+ps_id;
				    	}
					}
				}

				message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 发布方案监控线程休眠 ";
				Thread.sleep(120000);// 休眠10分钟 10*60*1000=600000
			}

		} catch (MessageException e) {
			message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
			ErrorLog.SaveErrorLog("发布方案监控进程错误", "", 0, e);
			e.printStackTrace(System.out);
		} catch (SQLException e) {
			message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
			ErrorLog.SaveErrorLog("发布方案监控进程错误", "", 0, e);
			e.printStackTrace(System.out);
		} catch (InterruptedException e) {
			message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
			ErrorLog.SaveErrorLog("发布方案监控进程错误", "", 0, e);
			e.printStackTrace(System.out);
		}
		message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 发布方案监控进程结束";
	}



	
	/**
	 * @return Returns the runner.
	 */
	public Thread getRunner() {
		return runner;
	}

	/**
	 * @param runner
	 *            The runner to set.
	 */
	public void setRunner(Thread runner) {
		this.runner = runner;
	}

	/**
	 * @return Returns the sleepTime.
	 */
	public int getSleepTime() {
		return SleepTime;
	}

	/**
	 * @param sleepTime
	 *            The sleepTime to set.
	 */
	public void setSleepTime(int sleepTime) {
		SleepTime = sleepTime;
	}

	public static String getMessage() {
		return message;
	}

	public static void setMessage(String message) {
		PublishSchemeAgent.message = message;
	}	
}
