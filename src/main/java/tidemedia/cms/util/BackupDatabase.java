package tidemedia.cms.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import tidemedia.cms.system.Log;


/**
 * 用途 ：自动备份数据库
 *	1，丁文豪   20150409     	编写功能
 *  2.丁文豪    20150410         增加筛选重复数据库的功能
 *  3.丁文豪    20150416			调度执行的jsp改成java bean 
 *  4.丁文豪    20150416	        auto_backup.jsp sh路径用参数 
 *	5.丁文豪    20150416			程序修改默认的目录是/web/backup/ 
 *	6.丁文豪    20150416		              备份的开始和结束写入系统日志。
 *  7.丁文豪    20150416			修改程序，如果没有配置备份路径，写入日志，程序返回
 */

public class BackupDatabase implements Runnable
{
	
	private String cmd ;
	private String path;
	private String database;
	private Thread runner;
	
	public void Start()
	{
		if(runner==null)
		{
			runner = new Thread(this);
	        runner.start();
		}
	}
	 
	@Override
	public void run() 
	{
		List<String> commend=new java.util.ArrayList<String>();
		ProcessBuilder builder = new ProcessBuilder();
		String[] ss = Util.StringToArray(cmd, " ");
		StringBuilder buf = new StringBuilder();
		for(int i = 0;i<ss.length;i++)
		{
			commend.add(ss[i]);
		}
		
		builder.command(commend);
		builder.redirectErrorStream(true);
		try
		{
			Log.SystemLog("备份中心", Util.getCurrentDateTime()+","+database+"数据库开始备份！");  
			
			Process process = builder.start();
			InputStream is = process.getInputStream(); 
			BufferedReader br= new BufferedReader(new InputStreamReader(is));
			String line = null;
			
			while((line = br.readLine()) != null)
				buf.append(line+"\r\n");
			
			br.close();
			is.close();
			process.destroy();
	
         	Log.SystemLog("备份中心", Util.getCurrentDateTime()+","+database+"数据库备份完成");
		}
		catch(Exception e)
		{			
			Log.SystemLog("备份中心", Util.getCurrentDateTime()+","+database+"数据库备份失败！");  
			e.printStackTrace(System.out);
		}
		
	}

	public void setCmd(String cmd)
	{
		this.cmd = cmd;
	}

	public String getCmd()
	{
		return cmd;
	}
	 
	public void setPath(String path) {
		this.path = path;
	}
	 
	public String getPath() {
		return path;
	}
	 
	public void setDatabase(String database) {
		this.database = database;
	}
	 
	public String getDatabase() {
		return database;
	}

	public Thread getRunner() {
		return runner;
	}

	public void setRunner(Thread runner) {
		this.runner = runner;
	}
}
