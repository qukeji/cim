package tidemedia.cms.plugin;

import java.io.File;
import java.io.IOException;
import java.net.SocketException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPFile;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.cdn.ChinaCache;
import tidemedia.cms.publish.PublishScheme;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelTemplate;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.ItemSnap;
import tidemedia.cms.system.Log;
import tidemedia.cms.system.Site;
import tidemedia.cms.system.TemplateFile;
import tidemedia.cms.util.Util;

public class DelApi extends Table implements Runnable{
	
	private int 		GlobalID 	= 0;//文档全局编号
	private int			ChannelID 	= 0;//频道编号
	private int			ItemID 		= 0;//文档编号
	private int			SiteID 		= 0;//站点编号
	private boolean 	delLocal 	= true;//删除本地
	
	private Thread 	runner;

	public DelApi() throws MessageException, SQLException {
		super();
	}

	public void Start()
	{
		if(runner==null)
		{
	        runner = new Thread(this);
	        runner.start();	        
		}
	}
	
	public void run()
	{
			try {
				DeleteFiles();
			} catch (MessageException e) {
				e.printStackTrace();
				System.out.println(e.getMessage());
			} catch (SQLException e) {
				e.printStackTrace();
				System.out.println(e.getMessage());
			} catch (SocketException e) {
				e.printStackTrace();
				System.out.println(e.getMessage());
			} catch (IOException e) {
				e.printStackTrace();
				System.out.println(e.getMessage());
			}
	}
	
	public void DeleteFiles() throws MessageException, SQLException, SocketException, IOException
	{
		//System.out.println("delfile:"+ItemID+","+ChannelID);
		Channel channel = null;
		Document doc = null;
		
		if(ItemID>0 && ChannelID>0)
		{			
			doc = new Document(ItemID,ChannelID);
			channel = doc.getChannel();
		}
		else
			return;
		
		if(channel!=null && doc!=null)
		{
			SiteID = channel.getSiteID();
			ArrayList<ChannelTemplate> templatefiles = new ArrayList<ChannelTemplate>();
			
			templatefiles = channel.getChannelTemplates(2);//获取内容页模板列表
	     	
			ArrayList files = new ArrayList();
			for(int iii = 0;iii<templatefiles.size();iii++)
			{
				ChannelTemplate ct = (ChannelTemplate)templatefiles.get(iii);
						
	     		String filename = doc.getFullHref(ct);
	     		//DeleteFileByName(filename);
	     		files.add(filename);
	     		for(int i = 2;i<=doc.getTotalPage();i++)
	     		{
	     			String newfilename = "";
	     			int j = filename.lastIndexOf(".");
	     			if(j!=-1)
	     			{
	     				newfilename = filename.substring(0,j) + "_" + i + filename.substring(j);
	     			}
	     			files.add(newfilename);
	     			//DeleteFileByName(newfilename);
	     		}
			}
			
			if(files.size()>0) DeleteFileByName(files);
		}
	}
	
	public void DeleteFileByName(ArrayList files_arr) throws MessageException, SQLException, SocketException, IOException
	{
		//System.out.println("deletefilebyname:"+filename);
		Site site = CmsCache.getSite(SiteID);
		
		String files_arr_ = "";
		for(int i =0;i<files_arr.size();i++)
		{
			if(i>=10)
			{
				files_arr_ += "...等";
			}
			files_arr_ += (files_arr_.length()>0?",":"") + (String)files_arr.get(i);
		}
		Log.SystemLog("删除文件", "准备删除"+files_arr.size()+"个文件："+files_arr);
		
		if(delLocal)
		{
			for(int i =0;i<files_arr.size();i++)
			{
				String filename = (String)files_arr.get(i);
				String filename_ = site.getSiteFolder() + filename;
				File file = new File(filename_);
				boolean r = file.delete();
				file = null;
				Log.SystemLog("删除文件", "删除本地文件："+filename_+" 是否成功删除:"+r);
			}
		}
		
        ArrayList<PublishScheme> schemes = site.getPublishSchemes();
     	for(int i = 0;i<schemes.size();i++)
     	{    
     		PublishScheme ps = (PublishScheme)schemes.get(i);
     		//if(ps.getId()>0 && ps.canPublish(filename))
     		//{
     			//String newfilename = ps.getToFileName(filename);
     			//if(newfilename.length()==0) newfilename = filename;
     			if(ps.getCopyMode()==1)//ftp
     			{
     				FTPClient ftp = new FTPClient();
     				if(!ftp.isConnected())
     				{
     					if(!ps.getPort().equals(""))
     					{
     						int port = Util.parseInt(ps.getPort());
     						ftp.setDefaultPort(port);
     					}
     					ftp.setDefaultTimeout(10000);			
     					ftp.connect(ps.getServer());
     					ftp.login(ps.getUsername(),ps.getPassword());	
     					ftp.setSoTimeout(10000);
     					ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
     					//ftp.setReaderThread(false);
     					if(ps.getFtpMode()==1)
     						ftp.enterLocalPassiveMode();
     				}
     				
     				for(int j = 0;j<files_arr.size();j++)
     				{
     					String filename = (String)files_arr.get(j);
     					
     					if(!ps.canPublish(filename)) continue;
     					
     					String newfilename = ps.getToFileName(filename);
     	     			if(newfilename.length()==0) newfilename = filename;
     				String ftp_filename = Util.ClearPath(ftp.printWorkingDirectory().replace("\"", "") + newfilename);
     				//System.out.println("ftp_filename:"+ftp_filename);
     				FTPFile[] files = ftp.listFiles(ftp_filename);
     				/*
     				if(files==null)
     				{
     					System.out.println("ftp list file is null");
     				}
     				else
     				{
     					System.out.println("ftp list file is "+files.length);
     				}*/
     				if(files==null || files.length==0)
     				{
     					Log.SystemLog("删除文件", "远程文件不存在："+ftp_filename+",site："+site.getName()+",scheme："+ps.getName()+"");
     				}
     				else
     				{
	     				boolean retu = ftp.deleteFile(ftp_filename);
	     				//print("delete file "+retu + " " + filename+",site:"+site.getName()+",scheme:"+ps.getName());
	     				String retu_ = "";
	     				if(retu) retu_ = "删除远程文件成功，";
	     				else retu_ = "删除远程文件失败，";
	     				Log.SystemLog("删除文件",  retu_ + ftp_filename+",site："+site.getName()+",scheme："+ps.getName());
     				}
     				}
     				ftp.logout();
     				ftp.disconnect();
     			}
     			else if(ps.getCopyMode()==2)// file copy
     			{
     				for(int j = 0;j<files_arr.size();j++)
     				{
     					String filename = (String)files_arr.get(j);
     					if(!ps.canPublish(filename)) continue;
     					
     				String newfilename_local = ps.getToFileName(filename);//获取文件最终位置的相对路径
     				String destFileFolder=ps.getDestFolder();//获取目标目录
     				if(newfilename_local.length()==0)newfilename_local=filename;
     				String local_filepath=destFileFolder+newfilename_local;//本地物理文件路径
     				File destFile=new File(local_filepath);
     				if(!destFile.exists()){
     					Log.SystemLog("删除文件", "本地发布目录文件不存在："+local_filepath+",site："+site.getName()+",scheme："+ps.getName()+"");
     				}else{
     					if(destFile.isDirectory()){
     						Log.SystemLog("删除文件", "本地发布目录目标为文件目录，无法删除 ："+local_filepath+",site："+site.getName()+",scheme："+ps.getName()+"");
     					}else{
     						boolean result=destFile.delete();//删除文件结果
     						String retu_ = "";
    	     				if(result) retu_ = "删除本地发布目录文件成功，";
    	     				else retu_ = "删除本地发布目录文件失败，";
    	     				Log.SystemLog("删除文件",  retu_ + local_filepath+",site："+site.getName()+",scheme："+ps.getName());
     					}
     				}
     				}
     			}
     		//}
     	}
     	
     	Log.SystemLog("删除文件", "完成删除"+files_arr.size()+"个文件："+files_arr);
	}
	
	public void DeleteFileByName(String filename) throws MessageException, SQLException, SocketException, IOException
	{
		System.out.println("deletefilebyname:"+filename);
		Site site = CmsCache.getSite(SiteID);
		
		if(delLocal)
		{
			String filename_ = site.getSiteFolder() + filename;
			File file = new File(filename_);
			file.delete();
			file = null;
			Log.SystemLog("删除文件", "删除本地文件："+filename_+" 是否成功删除:"+new File(filename_).exists());
		}
		
        ArrayList<PublishScheme> schemes = site.getPublishSchemes();
     	for(int i = 0;i<schemes.size();i++)
     	{    
     		PublishScheme ps = (PublishScheme)schemes.get(i);
     		if(ps.getId()>0 && ps.canPublish(filename))
     		{
     			String newfilename = ps.getToFileName(filename);
     			if(newfilename.length()==0) newfilename = filename;
     			if(ps.getCopyMode()==1)//ftp
     			{
     				FTPClient ftp = new FTPClient();
     				if(!ftp.isConnected())
     				{
     					if(!ps.getPort().equals(""))
     					{
     						int port = Util.parseInt(ps.getPort());
     						ftp.setDefaultPort(port);
     					}
     					ftp.setDefaultTimeout(10000);			
     					ftp.connect(ps.getServer());
     					ftp.login(ps.getUsername(),ps.getPassword());	
     					ftp.setSoTimeout(10000);
     					ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
     					//ftp.setReaderThread(false);
     					if(ps.getFtpMode()==1)
     						ftp.enterLocalPassiveMode();
     				}
     				String ftp_filename = Util.ClearPath(ftp.printWorkingDirectory().replace("\"", "") + newfilename);
     				//System.out.println("ftp_filename:"+ftp_filename);
     				FTPFile[] files = ftp.listFiles(ftp_filename);
     				/*
     				if(files==null)
     				{
     					System.out.println("ftp list file is null");
     				}
     				else
     				{
     					System.out.println("ftp list file is "+files.length);
     				}*/
     				if(files==null || files.length==0)
     				{
     					Log.SystemLog("删除文件", "远程文件不存在："+ftp_filename+",site："+site.getName()+",scheme："+ps.getName()+"");
     				}
     				else
     				{
	     				boolean retu = ftp.deleteFile(ftp_filename);
	     				//print("delete file "+retu + " " + filename+",site:"+site.getName()+",scheme:"+ps.getName());
	     				String retu_ = "";
	     				if(retu) retu_ = "删除远程文件成功，";
	     				else retu_ = "删除远程文件失败，";
	     				Log.SystemLog("删除文件",  retu_ + ftp_filename+",site："+site.getName()+",scheme："+ps.getName());
     				}
     			}
     			else if(ps.getCopyMode()==2)// file copy
     			{
     				String newfilename_local = ps.getToFileName(filename);//获取文件最终位置的相对路径
     				String destFileFolder=ps.getDestFolder();//获取目标目录
     				if(newfilename_local.length()==0)newfilename_local=filename;
     				String local_filepath=destFileFolder+newfilename_local;//本地物理文件路径
     				File destFile=new File(local_filepath);
     				if(!destFile.exists()){
     					Log.SystemLog("删除文件", "本地发布目录文件不存在："+local_filepath+",site："+site.getName()+",scheme："+ps.getName()+"");
     				}else{
     					if(destFile.isDirectory()){
     						Log.SystemLog("删除文件", "本地发布目录目标为文件目录，无法删除 ："+local_filepath+",site："+site.getName()+",scheme："+ps.getName()+"");
     					}else{
     						boolean result=destFile.delete();//删除文件结果
     						String retu_ = "";
    	     				if(result) retu_ = "删除本地发布目录文件成功，";
    	     				else retu_ = "删除本地发布目录文件失败，";
    	     				Log.SystemLog("删除文件",  retu_ + local_filepath+",site："+site.getName()+",scheme："+ps.getName());
     					}
     				}
     			}
     		}
     	}
     	
		if(CmsCache.getConfig().getCustomer().equals("vodone"))//第一视频客户
		{
			String url = ChinaCache.addUrl("", filename,SiteID);
			if(!url.equals("")) ChinaCache.Refresh(url); 
		}
	}
	
	@Override
	public void Add() throws SQLException, MessageException {
		
	}

	@Override
	public void Delete(int id) throws SQLException, MessageException {
		
	}

	@Override
	public void Update() throws SQLException, MessageException {
		
	}

	@Override
	public boolean canAdd() {
		return false;
	}

	@Override
	public boolean canDelete() {
		return false;
	}

	@Override
	public boolean canUpdate() {
		return false;
	}

	public int getGlobalID() {
		return GlobalID;
	}

	public void setGlobalID(int globalID) {
		GlobalID = globalID;
	}

	public void setSiteID(int siteID) {
		SiteID = siteID;
	}

	public int getSiteID() {
		return SiteID;
	}

	public void setDelLocal(boolean delLocal) {
		this.delLocal = delLocal;
	}

	public boolean isDelLocal() {
		return delLocal;
	}

	public void setChannelID(int channelID) {
		ChannelID = channelID;
	}

	public int getChannelID() {
		return ChannelID;
	}

	public void setItemID(int itemID) {
		ItemID = itemID;
	}

	public int getItemID() {
		return ItemID;
	}
	public static void main(String[] args) {
		
	}
}
