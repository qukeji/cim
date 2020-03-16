package tidemedia.cms.spider;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.util.Util;

public class SpiderAgent implements Runnable{
	private Thread runner;

	private static int max_thread_number = 1;// 最大采集线程数量
	private static AtomicInteger running_thread_number = new AtomicInteger(0);// 正在执行的线程数量
	private static ConcurrentHashMap<String, String> running_spiderid =new ConcurrentHashMap<String, String>();
	private static String message = "";//进程信息
	
	public void Start() {

		System.out.println("准备启动采集进程");
		setMessage(Util.getCurrentDate("MM-dd HH:mm:ss")+" 采集引擎启动");
		
		if (runner == null) {
			runner = new Thread(this);
			runner.start();
		}
	}
	
	@Override
	public void run() {
		
		try {			
			// 0 关闭
			// 1启动
			while (true) {				
				//如果发生数据库错误，继续执行
				try{
				String last_file_name = "";
				//System.out.println("max_copy_thread_number:" + max_thread_number + ",copying_thread_number:"	+ copying_thread_number);
				max_thread_number = CmsCache.getParameter("spider_thread_number").getIntValue();
				int num = max_thread_number - running_thread_number.get();
				message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 可用线程数量:"+num;
				
				int num1 = 0;
				int num2 = 0;
				
				if (num > 0) {
					// 还有可用的发布线程
					//String Sql = "select * from publish_item where Status=0 and UNIX_TIMESTAMP()>=CanCopyTime order by id limit " + num;
					String Sql = "select * from spider where status=1 and UNIX_TIMESTAMP()>=NextRunTime order by id ";
					TableUtil tu = new TableUtil();
					TableUtil tu1 = new TableUtil();
					ResultSet Rs = tu.executeQuery(Sql);
					
					HashMap<Integer, String> map = new HashMap();
					while (Rs.next()) {
						int id_ = Rs.getInt("id");
						num = max_thread_number - running_thread_number.get();
						if(num>0 && !checkRun(id_))
						{
							running_spiderid.put(id_ + "", Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
							running_thread_number.incrementAndGet();
							SpiderRunner sj = new SpiderRunner(id_);
							sj.Start();
						}
						else
							break;
					}
					tu.closeRs(Rs);
				}
				message = Util.getCurrentDate("MM-dd HH:mm:ss")+" 线程休眠";
				Thread.sleep(100);// 休眠500毫秒
				}catch (SQLException e) {
					message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
					ErrorLog.SaveErrorLog("采集进程错误", "", 0, e);
					e.printStackTrace(System.out);
				}
			}

		} catch (MessageException e) {
			message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
			ErrorLog.SaveErrorLog("采集进程错误", "", 0, e);
			e.printStackTrace(System.out);
		}  catch (InterruptedException e) {
			message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 错误："+e.getMessage();
			ErrorLog.SaveErrorLog("采集进程错误", "", 0, e);
			e.printStackTrace(System.out);
		}
		message = message + "," + Util.getCurrentDate("MM-dd HH:mm:ss")+" 进程结束";
	}

	public static String getMessage() {
		return message;
	}

	public static void setMessage(String message) {
		SpiderAgent.message = message;
	}

	public static void RunDone(int spider_id) {
		running_thread_number.decrementAndGet();
		String s = running_spiderid.get(spider_id+"");
		if(s!=null) running_spiderid.remove(spider_id+"");
		
		if(running_thread_number.get()<0) 
		{
			System.out.println("有错误发生，采集进程running_thread_number为负数");
			running_thread_number.set(0);
		}
	}

	public static boolean checkRun(int spider_id) {		
		String s = running_spiderid.get(spider_id+"");
		if(s!=null) 
			return true;
		else
			return false;
	}
	
	public static int getMax_thread_number() {
		return max_thread_number;
	}

	public static int getRunning_thread_number() {
		return running_thread_number.get();
	}
	
	public Thread getRunner() {
		return runner;
	}	
}
