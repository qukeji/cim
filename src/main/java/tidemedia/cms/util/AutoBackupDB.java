package tidemedia.cms.util;

import java.io.File;
import java.sql.SQLException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.filefilter.DirectoryFileFilter;
import org.apache.commons.io.filefilter.FileFilterUtils;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;
import org.quartz.Job;
import org.quartz.JobExecutionContext;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.system.CmsCache;
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

public class AutoBackupDB implements Job
{
	
	public void execute(JobExecutionContext arg0)
    {
		try	
		{			 
			backup();
		}
		catch (Exception e)
		{
			e.printStackTrace(System.out);
		}
   }
	
	public  void backup() 
		throws MessageException, SQLException, DocumentException
	{
		TideJson tj = CmsCache.getParameter("sys_backup_cfg").getJson();
		String   file_path = tj.getString("xml_path");
		String   db_path  = tj.getString("db_path");
		File     file = new File(file_path);
		List<File>     list = (List<File>) FileUtils.listFiles(file,FileFilterUtils.suffixFileFilter(".xml"),DirectoryFileFilter.INSTANCE);
		Set<String> databases = new HashSet<String>();  
		
		if(db_path.equals(""))
		{
			Log.SystemLog("备份中心", "系统自动备数据库失败，没有配置备份路径");
			return;
		}
		
		//读取 用户名、密码、数据库名、IP
		for(int i=0;i<list.size();i++)
		{ 
			SAXReader saxReader=new SAXReader();            
			Document doc=saxReader.read(list.get(i)+"");
			List xmlList = doc.selectNodes("//Context/Resource");
			
			for (Object childNodes : xmlList)
		    {
				Element element = (Element) childNodes; 
				String username=element.attributeValue("username");
				String password=element.attributeValue("password");
				String url=element.attributeValue("url");
			 
				if(url!=null)
				{
					String  []str=url.split("//");
					String  ip=url.split("//")[1].split("/")[0].split(":")[0];
					String  databaseName=url.split("//")[1].split("/")[1].split("[?]")[0];
					if(databases.add(databaseName))
					{   
						String   shell_path = tj.getString("shell_path");
					    if(shell_path.equals(""))
					    	shell_path="/tomcat/bin/db_backup.sh";
						shell_path  +=" "+username+" "+password+" "+ip+" "+databaseName+" "+db_path;
						
						BackupDatabase bd = new BackupDatabase();
						bd.setCmd(shell_path);
						bd.setDatabase(databaseName);
						bd.setPath(db_path);
						bd.Start();
					}
				 }
			  }
		}

	}

}
