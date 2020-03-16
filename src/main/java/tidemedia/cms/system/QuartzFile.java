package tidemedia.cms.system;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.sql.SQLException;
import java.util.List;

import org.quartz.Job;
import org.quartz.JobDataMap;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.util.Util;

/**
 * 
 * @author hailong
 * execute获取动态传递过来的参数，去除filepath,type变量
 */
public class QuartzFile implements Job {
	/*private  String filepath = "";
	private  int type = 0;
	

	public String getFilepath() {
		return filepath;
	}

	public void setFilepath(String filepath) {
		this.filepath = filepath;
	}
	
	public  int getType() {
		return type;
	}

	public  void setType(int type) {
		this.type = type;
	} */
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// TODO Auto-generated method stub
		//获取job传递过来的参数 王海龙修改
		JobDataMap dataMap = arg0.getJobDetail().getJobDataMap();
		
		int type = dataMap.getInt("type");
		String filepath = dataMap.getString("filepath");
		try {
			if(type==1){//调度服务器脚本
				doScript(filepath);
			}
			if(type==2){//调度程序文件
				doExeFile(filepath);
			}	
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static void main(String[] args){
		String content = Util.connectHttpUrl("http://www.tidedemo.com/log.php");
		//String content = Util.connectHttpUrl("http://192.168.1.250:888/vms/test/b.jsp");
		System.out.println(content);
	}
	public  void doExeFile(String filepath) throws MessageException, SQLException {	
		 connectHttpUrl(filepath, "utf-8");
		//Util.connectHttpUrl(filepath, "utf-8");
		Log.SystemLog("调度管理", "调度执行程序文件，"+ filepath);
	}
	public  void doScript(String filepath) throws MessageException, SQLException{
		File file = new File(filepath);
    	if(file.exists()){
    		//windows 下批处理文件为*.bat   linux 下*.sh 
    		String filepath_ = filepath;
    		try {
    			Log.SystemLog("调度管理", "调度执行脚本文件，"+ filepath_);
    			ProcessBuilder builder = new ProcessBuilder();
    			List<String> commend = new java.util.ArrayList<String>();
    			commend.add(filepath_);
    			builder.command(commend);
    			builder.redirectErrorStream(true);
    			java.lang.Process process = builder.start();

    			InputStream is2 = process.getInputStream();
    			BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
    			StringBuilder buf2 = new StringBuilder();
    			String line2 = null;
    			while ((line2 = br2.readLine()) != null){
    				buf2.append(line2);
    				System.out.println("----------"+buf2.toString());
    			}
    			String bufs = buf2.toString();
    		} catch (Exception e) {
    			e.printStackTrace();
    		}
    	}else{
    		Log.SystemLog("调度管理", "脚本文件不存在，"+ filepath);
    	}
		
	}
	public  String connectHttpUrl(String url,String charset)
	{
		String content = "";
		String sCurrentLine = "";
		java.net.URL l_url;
		try 
		{
			if(charset.length()==0) charset = "utf-8";
			l_url = new java.net.URL(url);
			java.net.HttpURLConnection con = (java.net.HttpURLConnection) l_url.openConnection();
			con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.0.5) Gecko/2008120122 Firefox/3.0.5");
			con.setRequestProperty("Accept-Encoding", "gzip, deflate");
			HttpURLConnection.setFollowRedirects(true);
			con.setInstanceFollowRedirects(false);
			con.connect(); 
			//java.io.InputStream l_urlStream =  new GZIPInputStream(con.getInputStream()); 
			java.io.InputStream l_urlStream = con.getInputStream();
			java.io.BufferedReader l_reader = new java.io.BufferedReader(new java.io.InputStreamReader(l_urlStream,charset)); 
			while ((sCurrentLine = l_reader.readLine()) != null) 
			{ 
				content+=sCurrentLine; 
			}		
		
		} catch (MalformedURLException e) {
			System.out.println("cann't connect " + url + "," + e.getMessage());
		} catch (IOException e) {
			System.out.println("cann't connect " + url + "," + e.getMessage());
		} 
		return content;
	}	
}
