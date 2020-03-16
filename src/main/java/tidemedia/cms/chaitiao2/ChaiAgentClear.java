package tidemedia.cms.chaitiao2;

import java.io.File;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Log;
import tidemedia.cms.util.Util;
public class ChaiAgentClear implements Runnable{

	/**
	 * @param args
	 */
	
	private Thread 	runner;
	public static String rootfolder = "";//"D:/rtREC/";//要截图的拆条文件的跟目录
	public static String ffmpeg = "";//"D:/ffmpeg-20130614-git-6fe419b-win64-static/bin/ffmpeg.exe";//ffmpeg路径配置
	public static String chaitiao_cmd_print = "";
	public static int chaitiao_photo_log = 0;
	public static String f4vpp = "";//f4v路径
	public static int day = 3;//默认3天

	public static int delday = -20;//数据保留20天
	public static int second=3600;//每小时 清除一遍数据库
	public static String tablename = "channel_chaitiao_f4v";
	int chaitiao_f4v_channelid=0;
	
	
	public ChaiAgentClear()
	{
		try {
			rootfolder = CmsCache.getParameterValue("chaitiao_rootfolder");
			ffmpeg = CmsCache.getParameterValue("chaitiao_ffmpegpath");
			chaitiao_cmd_print = CmsCache.getParameterValue("chaitiao_cmd_print");
			f4vpp = CmsCache.getParameterValue("chaitiao_f4vpp");
			day = CmsCache.getParameter("chaitiao_save_day").getIntValue();
			chaitiao_f4v_channelid=CmsCache.getParameter("chaitiao_f4v_channelid").getIntValue();
			if(chaitiao_f4v_channelid>0) tablename=CmsCache.getChannel(chaitiao_f4v_channelid).getTableName();
			
		} catch (MessageException e) {
			e.printStackTrace(System.out);
		} catch (SQLException e) {
			e.printStackTrace(System.out);
		}
		
		rootfolder = Util.ClearPath(rootfolder);
	}
	
	public void Start()
	{
		if(day==0) day = 3;
		if(rootfolder.length()==0 || ffmpeg.length()==0)
		{
			Log.SystemLog("拆条系统","chaitiao_rootfolder,chaitiao_ffmpegpath 未配置.");
			return;
		}
		
		if(f4vpp.length()==0)
		{
			Log.SystemLog("拆条系统","chaitiao_f4vpp未配置.");
			return;
		}
		if(runner==null)
		{
			runner = new Thread(this);
	        runner.start();
		}
	}
	
	public void run() {
        //boolean forever = true;
		int sleeptime = 60000;//10秒
        Thread thisThread = Thread.currentThread();
        System.out.println("chaitiao clear  running.....");

        while(thisThread==runner) {
        	
        	//chaitiao_photo_log = CmsCache.getParameter("chaitiao_cmd_print").getIntValue();
        	
        	File f = new File(rootfolder);
        	
        	if(!f.exists())
        	{
        		Log.SystemLog("拆条清理", "截图根目录不存在.");
        		runner = null;
        	}
        	
        	File[] files = f.listFiles();
        	
        	for(int i = 0;files!=null && i<files.length;i++)
    		{
    			if(files[i].isDirectory())
    			{
    				
    				String p = files[i].getPath();
    				if(p.contains("screenshot") || p.contains("publish") || p.contains("mp4"))
    				{    					
    				}
    				else
    				{
    					//需要处理的目录
    					
    					for(int j = day;j<10;j++)
    					{
    						String pp = Util.ClearPath(p+"/"+getTodayZeroTime(-j));
    						File file_pp = new File(pp);
    						if(file_pp.exists())
        					{
    							File[] fs = file_pp.listFiles();
    							System.out.println("clear:"+pp);
    							if(fs==null||fs.length==0)
    								file_pp.delete();
    							else
    							{
    								for(int m = 0;m<fs.length && m<20;m++)
    								{
    									fs[m].delete();
    									//System.out.println("clear delete:"+fs[m].getPath());
    								}
    							}
        					}
    					}
    				}
    			} 
    		}
    		long now = System.currentTimeMillis();
    		//System.out.println(now);
        	if(now%second ==0){//每个小时运行一次
    			boolean delresult=clearChaiF4vTable();
    			if(!delresult){
    				Log.SystemLog("拆条清理", "清理"+tablename+"时出现错误！");
    			}
    		}

    		
        	try {
				Thread.sleep(sleeptime);//10秒
			} catch (InterruptedException e) {
				e.printStackTrace();
			}  
        }
	}
	private static boolean clearChaiF4vTable()  {
		// TODO Auto-generated method stub
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.add(Calendar.DAY_OF_MONTH, delday);
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		DateFormat df2 = new SimpleDateFormat("HHmm");
		String deldate=df.format(nowDate.getTime());
		String deltime=df2.format(nowDate.getTime());		
		System.out.println(deldate);
		System.out.println(deltime);		
		//String sql = "select count(*) from "+tablename+" where datetime<"+deldate+" or (datetime="+deldate+" and minute<"+deltime+")";
		String sql = "delete from "+tablename+" where datetime<"+deldate+" or (datetime="+deldate+" and minute<"+deltime+")";
		//System.out.println(sql);
		TableUtil tu;
		try {
			tu = new TableUtil();
			tu.executeUpdate(sql);
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return false;
		}
		return true;
		
	}



	/**
	 * 获取当天零点时间戳
	 * 
	 * @return
	 */
	public static String getTodayZeroTime(int num) 
	{
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.add(Calendar.DAY_OF_MONTH,num);
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		DateFormat df = new SimpleDateFormat("yyyyMMdd");
		return df.format(nowDate.getTime());
	}
	
	/**
	 * @return Returns the runner.
	 */
	public Thread getRunner() {
		return runner;
	}
	/**
	 * @param runner The runner to set.
	 */
	public void setRunner(Thread runner) {
		this.runner = runner;
	}

}
