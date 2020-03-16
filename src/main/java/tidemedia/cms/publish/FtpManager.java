package tidemedia.cms.publish;

import org.apache.commons.net.ftp.FTPClient;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.util.Util;

import java.io.IOException;
import java.net.SocketException;
import java.sql.SQLException;
import java.util.ArrayList;


public class FtpManager {

	private static ArrayList<TideFtpClient> ftps=new ArrayList<TideFtpClient>();

	//获取封装过的ftp对象
	public static TideFtpClient getFtp(int publishschemeid) throws MessageException, SQLException
	{
		TideFtpClient tideftp = getTideFtpClient(publishschemeid);
				
		//FTPClient ftp = new FTPClient();//tideftp.getFtp();
		//tideftp.setFtp(ftp);
		/*
		try {
			if (ftp != null && ftp.isConnected()) {
				ftp.logout();
			}
		} catch (Exception io) {
			System.out.println("getftp logout1");
			io.printStackTrace();
		} finally {
			// 注意,一定要在finally代码中断开连接，否则会导致占用ftp连接情况
			try {
				ftp.disconnect();
			} catch (Exception io) {
				System.out.println("getftp logout2");
				io.printStackTrace();
			}
		}*/
	      
		FTPClient ftp = initFtpClient(publishschemeid,tideftp);
		if(ftp==null)
		{
			System.out.println("first login error " + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
			ftp = initFtpClient(publishschemeid,tideftp);
		}
		
		if(ftp==null)
		{
			System.out.println("ftp is null two " + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")+","+tideftp.getMessage());
		}
		
		tideftp.setFtp(ftp);
		
		return tideftp;
	}

	//public boolean sendNoOp()     throws IOException
	private static FTPClient initFtpClient(int publishschemeid, TideFtpClient tideftp) throws MessageException, SQLException
	{
		boolean result = true;
		FTPClient ftp = new FTPClient();
		String message_ = "";
		long begin = System.currentTimeMillis();
		PublishScheme ps = CmsCache.getPublishScheme(publishschemeid);

		//System.out.println("ftpcopy1 "+FileName+" "+(System.currentTimeMillis()-begin));
		if(!ps.getPort().equals(""))
		{
			int port = Util.parseInt(ps.getPort());
			ftp.setDefaultPort(port);
		}

		//ftp.setBufferSize(1048576);//1024*1024
		//ftp.setBufferSize(4096);//2015-9-14测试发现这个速度较快，比1024*1024快，还要考虑tomcat内存
		ftp.setBufferSize(10240);//10k
		ftp.setDefaultTimeout(40000);			
		try {
			ftp.connect(ps.getServer());
			result = ftp.login(ps.getUsername(),ps.getPassword());	
			ftp.setSoTimeout(40000);
			ftp.setConnectTimeout(40000);
			ftp.setKeepAlive(true);
			ftp.setControlKeepAliveTimeout(600);//10分钟
			ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
		} catch (Exception e) {
			result = false;
			tideftp.setMessage("登录错误，信息："+e.getMessage());
			System.out.println("login error:"+ps.getServer()+","+ps.getUsername()+","+e.getMessage() + "," + Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
		}
		message_ += ",4:"+(System.currentTimeMillis()-begin);
		//ftp.setReaderThread(false);
		//System.out.println("ftpcopy2 "+FileName+" "+(System.currentTimeMillis()-begin));
		if(ps.getFtpMode()==1)
			ftp.enterLocalPassiveMode();

		if((System.currentTimeMillis()-begin)>1000)
			System.out.println("get ftp slow " + message_);
		
		if(result)
			return ftp;
		else
			return null;
	}
	
	//不需要添加synchronized，否则一个ftp卡住，其他进程也请求不到，2015.12.10
	public static TideFtpClient getFtp_(int publishschemeid) throws MessageException, SQLException
	{
		String message_ = "";
		long begin = System.currentTimeMillis();
		TideFtpClient tideftp = getTideFtpClient(publishschemeid);
		PublishScheme ps = CmsCache.getPublishScheme(publishschemeid);
		message_ += "1:"+(System.currentTimeMillis()-begin);

		FTPClient ftp = tideftp.getFtp();
		String m_ = "ftp connection "+ftp.isConnected() + " "+tideftp.toString()+",size:"+ftps.size();
		
		boolean connect = false;
		/*
		if(ftp.isAvailable())
		{
			message_ += ",2:"+(System.currentTimeMillis()-begin);
			
			//间隔4秒没有被使用，就重新登录
			if((System.currentTimeMillis()-tideftp.getLast_use_time())>4000)
			{				
				message_ += ",22222:"+(System.currentTimeMillis()-begin);	
				connect = false;
				m_ += ",大于4秒";
			}
			else
			{
				connect = true;
				try {
					ftp.changeWorkingDirectory("/");//切换到根下面
					m_ += ",切换到根";
					message_ += ",222:"+(System.currentTimeMillis()-begin);				
				} catch (IOException e) {
					message_ += ",2222:"+(System.currentTimeMillis()-begin);		
					connect = false;
					m_ += ",切换到根失败";
				}
			}
		}
		else
		{
			message_ += ",22:"+(System.currentTimeMillis()-begin);
			connect = false;
			m_ += ",avaiable is false";
		}*/
		
		//2016.11.7 每次都重新连接，尝试一下
		connect = false;
		
		message_ += ",3:"+(System.currentTimeMillis()-begin);
		if(!connect)
		{
			//System.out.println("ftpcopy1 "+FileName+" "+(System.currentTimeMillis()-begin));
			if(!ps.getPort().equals(""))
			{
				int port = Util.parseInt(ps.getPort());
				ftp.setDefaultPort(port);
			}
			
			ftp.setBufferSize(1048576);//1024*1024
			//ftp.setBufferSize(4096);//2015-9-14测试发现这个速度较快，比1024*1024快，还要考虑tomcat内存
			ftp.setDefaultTimeout(40000);			
			try {
				ftp.connect(ps.getServer());
				ftp.login(ps.getUsername(),ps.getPassword());	
				ftp.setSoTimeout(40000);
				ftp.setConnectTimeout(40000);
				ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
			} catch (SocketException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
			message_ += ",4:"+(System.currentTimeMillis()-begin);
			//ftp.setReaderThread(false);
			//System.out.println("ftpcopy2 "+FileName+" "+(System.currentTimeMillis()-begin));
			if(ps.getFtpMode()==1)
				ftp.enterLocalPassiveMode();
			
			m_ += ",登录";
			//Linux下的ftp使用ftp.enterLocalPassiveMode会经常断线
			//FtpRoot = ftp.printWorkingDirectory().replace("\"", "");
			//System.out.println("Connect ftp server.."+ps.getId()+","+FtpRoot);
		}
		message_ += ",5:"+(System.currentTimeMillis()-begin);
		/*
		//Ftp使用"/"作为目录分隔符
		if(!ps.getRemoteFolder().equals("") && !ps.getRemoteFolder().equals("/"))
		{
			ftp.changeWorkingDirectory(FtpRoot + "/" + ps.getRemoteFolder());
		}
		else
			ftp.changeWorkingDirectory(FtpRoot);
		*/
		if((System.currentTimeMillis()-begin)>1000)
			System.out.println("get ftp slow " + message_);		
		
		System.out.println(m_+","+ps.getName()+","+ Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
		return tideftp;
	}
	
	//同时只能有一个进程请求获取ftp对象 2015.12.10
	private synchronized static TideFtpClient getTideFtpClient(int publishschemeid) throws MessageException, SQLException
	{
		for(int i = 0;i<ftps.size();i++)
		{
			TideFtpClient f = (TideFtpClient)ftps.get(i);
			//同一个发布方案且未使用
			if(f.getPublish_scheme_id()==publishschemeid && !f.isUsed())
			{
				f.setUsed(true);
				return f;
			}
		}
		
		//如果队列中没有对应ftp对象
		TideFtpClient tideftp = new TideFtpClient();
		tideftp.setPublish_scheme_id(publishschemeid);
		ftps.add(tideftp);
		tideftp.setUsed(true);
		
		return tideftp;
	}
	
	public static void clearFtps()
	{
		ftps = new ArrayList();
	}
	
	public static ArrayList<TideFtpClient> getFtps() {
		return ftps;
	}

	public static void setFtps(ArrayList<TideFtpClient> ftps) {
		FtpManager.ftps = ftps;
	}	
}
