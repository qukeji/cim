/*
 * Created on 2004-12-25
 *
 */
package tidemedia.cms.publish;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.*;
import tidemedia.cms.util.Util;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Vector;
import java.util.concurrent.ConcurrentHashMap;

/**
 * @author Administrator
 *
 */
public class PublishManager {
	 static private PublishManager instance;
	 private TemplatePublishAgent template_publishagent = null;//第一个模板发布队列
	 private FilePublishAgent file_publishagent = null;//第二个模板发布队列，所有的全部文档发布都走第二队列
	 private PublishSchemeAgent publish_scheme_agent = null;

	 //private String		publishingFileName = "";//正在发布生成的文件名
	 private String		copyingFileName = "";//正在上传的文件名

	 public HashMap<String,String> publishingFiles = new HashMap<String,String>();//正在模板发布的文件，正在发布的文件不能被分发
	 public ArrayList<String> copyingfiles = new ArrayList<String>();//正在分发的文件，正在分发的文件，不能被模板发布

	 /*2016.11.4*/
	 //正在模板发布的文件，正在发布的文件不能被分发 分发的时候先检查是否存在，如果存在就wait，否则就分发
	 //分发前，检查是否在发布，如果在发布，就wait，否则加入正在分发的hashmap，分发完成，从hashmap中去掉，并notify_all
	 private static ConcurrentHashMap<String, String> publishing_files_2016 =new ConcurrentHashMap<String, String>();

	//正在分发的文件，正在分发的文件，不能被模板发布
	 //发布前，检查是否在分发，如果在分发，就wait，否则加入正在发布的hashmap，发布完成，从hashmap中去掉，并notify_all
	 private static ConcurrentHashMap<String, String> copying_files_2016 =new ConcurrentHashMap<String, String>();

	 public ArrayList<Publish2015> publishing_thread = new ArrayList<Publish2015>();

	 private Vector<Integer> PublishingTask = new Vector<Integer>();//正在被执行的发布任务编号

	 static synchronized public PublishManager getInstance()  {
		 if (instance == null ) {
			instance = new PublishManager();
		 }

		 return instance;
	 }

	 public void StartTemplatePublishAgent() throws MessageException, SQLException {
		if(template_publishagent!=null)
		{
			template_publishagent.getRunner().stop();
		}
		 template_publishagent=null;
		 template_publishagent = new TemplatePublishAgent();
		 template_publishagent.Start();
	 }

	 public void StartFilePublishAgent() throws MessageException, SQLException {
		if(file_publishagent!=null)
		{
			file_publishagent.getRunner().stop();
		}
		file_publishagent=null;
		file_publishagent = new FilePublishAgent();
		file_publishagent.Start();
	 }

	 private PublishManager()
	 {
		if (publish_scheme_agent != null) {
			publish_scheme_agent.getRunner().stop();
		}
		publish_scheme_agent = null;
		publish_scheme_agent = new PublishSchemeAgent();
		publish_scheme_agent.Start();
	 }

	 //2016.11.6 liyonghai 等待发布，如果该文件正在分发，就等待，否则开始发布，并记入文件发布对象
	 //publishing_files_2016 copying_files_2016
	 //file 全路径，经过clearpath处理
	 //应该去掉synchronized，否则会有等待锁死 2017.06.14
	 public void waitForPublish_(String file)
	 {
		 String s = copying_files_2016.get(file);
		 if(s==null)
		 {
			 //没有正在分发
		 }
		 else
		 {
			 //正在分发
			 try {
				System.out.println("wait for publish " + file + " begin "+ Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
				synchronized(s){s.wait();}
				System.out.println("wait for publish " + file + " end "+ Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
			} catch (InterruptedException e) {
				System.out.println("wait error:"+e.getMessage());
				e.printStackTrace();
			}
		 }

		 publishing_files_2016.put(file, Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
	 }

	 //2016.11.6 文件模板发布完毕后调用
	 public synchronized void removePublishingFile(String file)
	 {
		 String s = publishing_files_2016.get(file);
		 if(s!=null)
		 {
			 synchronized(s){
			 s.notifyAll();}
			 publishing_files_2016.remove(file);
		 }
	 }

	 //2016.11.6 liyonghai 等待分发，如果该文件正在模板发布，就等待，否则开始分发，并记入文件分发对象
	 //publishing_files_2016 copying_files_2016
	//应该去掉synchronized，否则会有等待锁死 2017.06.14
	 public void waitForCopy_(String file)
	 {
		 String s = publishing_files_2016.get(file);
		 if(s==null)
		 {
			 //没有正在分发
		 }
		 else
		 {
			 //正在分发
			 try {
				System.out.println("wait for copy " + file + " begin "+ Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
				synchronized(s){s.wait();}
				System.out.println("wait for copy " + file + " end "+ Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
			} catch (InterruptedException e) {
				System.out.println("wait copy error:"+e.getMessage());
				e.printStackTrace();
			}
		 }

		 copying_files_2016.put(file, Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
	 }

	 //2016.11.6 文件分发完毕后调用
	 public synchronized void removeCopyingFile(String file)
	 {
		 String s = copying_files_2016.get(file);
		 if(s!=null)
		 {
			 synchronized(s){
			 s.notifyAll();}
			 copying_files_2016.remove(file);
		 }
	 }

	 //检查是否能进行下一步操作，flag=1 文件发布检查 flag=2 模板发布检查
	 public synchronized boolean checkCando(int flag,String file)
	 {
		 //文件发布检查 waitForCopy
		 if(flag==1)
		 {
			 String s = publishing_files_2016.get(file);
			 if(s==null)
			 {
				 copying_files_2016.put(file, Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
				 return true;
			 }
			 else
			 {
				 return false;
			 }
		 }
		 else if(flag==2) //模板发布检查 waitForPublish
		 {
			 String s = copying_files_2016.get(file);
			 if(s==null)
			 {
				 publishing_files_2016.put(file, Util.getCurrentDate("yyyy-MM-dd HH:mm:ss"));
				 return true;
			 }
			 else
			 {
				return false;
			 }
		 }
		 else
			 return false;
	 }

	 //清除文件标记，生成文件或上传文件结束后调用
	 public synchronized void clearFileName(int flag)
	 {
	 }

	 //设置要执行的模板发布任务id,如果其他线程正在发布该任务，返回false
	 public synchronized boolean addPublishTask(int taskid)
	 {
		 if(PublishingTask.contains(taskid))
		 {
			 return false;
		 }
		 else
		 {
			 PublishingTask.add(taskid);
			 return true;
		 }
	 }

	 //模板发布任务执行完毕，清除掉
	 public synchronized void removePublishTask(int taskid)
	 {
		 /*
		System.out.println("taskid:"+taskid);
		for(int i = 0;i < PublishingTask.size();i++){
			 System.out.println("a:"+PublishingTask.get(i));
		} */
		PublishingTask.remove(new Integer(taskid));
		/*for(int i = 0;i < PublishingTask.size();i++){
			 System.out.println("b:"+PublishingTask.get(i));
		} */
	 }

	 //没有发布任务的时候，清除全部
	 public synchronized void removeAllPublishTask()
	 {
		PublishingTask.removeAllElements();
	 }

	 //2015/10/17 改成多线程发布
	 public synchronized void PublishNow() throws MessageException, SQLException
	 {
		//主系统才开启线程 20160608
		if(!CmsCache.getConfig().getActive().equals("1"))
			return;
	 }

	 public synchronized void CopyFileNow() throws MessageException, SQLException
	 {

		if(!CmsCache.getConfig().getActive().equals("1"))
			return;
	 }

	 public void FilePublish(int userid) throws MessageException, SQLException
	 {
	 	AddFilePublish(userid);
	 	PublishNow();
	 	//StartPublishAgent();
	 }

	 public void AddFilePublish(int userid) throws MessageException, SQLException
	 {
	 	AddPublishTask(Publish.FILE_PUBLISH,0,0,userid,0);
	 }

	 //频道发布,在频道管理里面操作
	 public void ChannelPublish(int channelid,int includesubchannel,int userid,int PublishAllItems) throws MessageException, SQLException
	 {
		Channel channel = CmsCache.getChannel(channelid);

		int action = LogAction.channel_publish;
		if(includesubchannel==1 && PublishAllItems==1)
		{
			//s = "发布频道(子频道,全部)";
			action = action + (1+2);
		}
		else
		{
			if(includesubchannel==1)
				action = action + 1;//s = "发布频道(子频道)";
			if(PublishAllItems==1)
				action = action + 2;//s = "发布频道(全部)";
		}

		new Log().ChannelLog(action, channelid, userid,channel.getSiteID());
	 	if(includesubchannel==1)
	 	{
	 		ArrayList<Integer> arraylist = channel.listAllSubChannelIDs();

			for(int j = 0;j<arraylist.size();j++)
			{
				int id_ = ((Integer)arraylist.get(j)).intValue();
				Channel ch = CmsCache.getChannel(id_);
				if(ch.getType()== Channel.Category_Type || ch.getType()== Channel.Channel_Type || ch.getType()== Channel.MirrorChannel_Type)
					AddChannelPublish(id_,userid,PublishAllItems);
			}
	 	}
	 	AddChannelPublish(channelid,userid,PublishAllItems);
	 	//StartPublishAgent();
	 	PublishNow();
	 }

	 public void AddChannelPublish(int channelid,int userid,int PublishAllItems) throws MessageException, SQLException
	 {
	 	//发布频道时，立即执行，要唤醒sleep thread
		Channel channel = CmsCache.getChannel(channelid);
	 	ArrayList<ChannelTemplate> templatefiles = channel.getChannelTemplates(ChannelTemplate.ContentTemplateType);//获取内容页模板列表
	 	if(templatefiles.size()>0)
	 		AddPublishTask(Publish.CHANNEL_PUBLISH,channelid,0,userid,PublishAllItems);
	 	else
	 		AddPublishTask(Publish.CHANNEL_PUBLISH_NOCONTENT,channelid,0,userid,PublishAllItems);//没有内容页的频道发布，优先级排第一
	 }

	 public void AddPublishTask(int publishtype,int channelid,int itemid,int userid,int PublishAllItems) throws MessageException, SQLException
	 {
		 PublishTask task = new PublishTask();

		 task.setPublishType(publishtype);
		 task.setChannelID(channelid);
		 task.setItemID(itemid);
		 task.setUserID(userid);
		 task.setPublishAllItems(PublishAllItems);

		 task.Add();
	 }

	 //发布频道，包括索引模板和附加模板，如果是分类，还要触发上级频道
	 public void PublishChannelAndUp(int channelid,int userid) throws MessageException, SQLException
	 {
		Channel channel = CmsCache.getChannel(channelid);

		/*
		ArrayList<ChannelTemplate> templatefiles = channel.getChannelTemplates(ChannelTemplate.ContentTemplateType);//获取内容页模板列表
		if(templatefiles.size()>0)
			AddPublishTask(Publish.CHANNEL_PUBLISH,channelid,0,userid,0);
		else
			AddPublishTask(Publish.CHANNEL_PUBLISH_NOCONTENT,channelid,0,userid,0);//没有内容页的频道发布，优先级排第一
		*/

		//2015/10/16修改
		ArrayList tfs = channel.getChannelTemplates();
		for(int i = 0;i<tfs.size();i++)
		{
			ChannelTemplate ct = (ChannelTemplate)tfs.get(i);
			if(ct.getActive()==1 && (ct.getTemplateType()==1 || ct.getTemplateType()==3))
			{
				//列表页或附加页模板，模板状态为允许发布
				 PublishTask task = new PublishTask();

				 task.setPublishType(Publish.CHANNEL_PUBLISH);
				 task.setChannelID(channelid);
				 task.setItemID(0);
				 task.setUserID(userid);
				 task.setPublishAllItems(0);
				 task.setChannelTemplateID(ct.getId());
				 task.setCanPublishTime(ct.getCanPublishTime());
				 task.Add();


			}
		}

		//如果该频道是分类，还需要发布它的父频道
		if(channel.getType()== Channel.Category_Type)
			PublishChannelAndUp(channel.getParent(),userid);
	 }

	 //发布频道,当文档发生变化
	 public void DocumentPublish(int channelid,int userid) throws MessageException, SQLException
	 {
		 PublishChannelAndUp(channelid,userid);
	 	Channel ch = CmsCache.getChannel(channelid);
	 	if(ch.hasMirrorChannel())//同时发布镜像频道
	 	{
	 		ArrayList<Integer> arraylist = ch.getMirrorChannelIDs();
	 		for(int i = 0;i<arraylist.size();i++)
	 		{
	 			int chid = ((Integer)arraylist.get(i)).intValue();
	 			PublishChannelAndUp(chid,userid);
	 		}
	 	}
	 	//publishagent.AddDocumentPublish(channelid,itemid,userid);
	 	//StartPublishAgent();
	 	PublishNow();
	 }

	 //由文档触发的发布 为审核通过，同时触发频道发布
	 public void DocumentPublish(int channelid,int itemid,int userid) throws MessageException, SQLException
	 {
		AddDocumentPublish(channelid,itemid,userid);
		PublishChannelAndUp(channelid,userid);
	 	Channel ch = CmsCache.getChannel(channelid);
	 	if(ch.hasMirrorChannel())//同时发布镜像频道
	 	{
	 		ArrayList<Integer> arraylist = ch.getMirrorChannelIDs();
	 		for(int i = 0;i<arraylist.size();i++)
	 		{
	 			int chid = ((Integer)arraylist.get(i)).intValue();
	 			AddDocumentPublish(chid,itemid,userid);
	 			PublishChannelAndUp(chid,userid);
	 		}
	 	}
	 	PublishNow();
	 }

	 //指定文档发布
	 public void OnlyDocumentPublish(int channelid,int itemid,int userid) throws MessageException, SQLException
	 {
	 	AddDocumentPublish(channelid,itemid,userid);
	 	PublishNow();
	 }

	 public void AddDocumentPublish(int channelid,int itemid,int userid) throws MessageException, SQLException
	 {
	 	//立即发布一个文档，要唤醒sleep thread
	 	AddPublishTask(Publish.ONLY_DOCUMENT_PUBLISH,channelid,itemid,userid,0);
	 }

	 //删除文档，触发频道发布
	 public void DeleteDocumentPublish(int channelid,int userid) throws MessageException, SQLException
	 {
		PublishChannelAndUp(channelid,userid);
	 	//StartPublishAgent();
	 	PublishNow();
	 }

	/*
	public PublishAgent getPublishagent() {
		return publishagent;
	}

	public void setPublishagent(PublishAgent publishagent) {
		this.publishagent1 = publishagent;
	}
	*/


	public void setCopyingFileName(String copyingFileName) {
		this.copyingFileName = copyingFileName;
	}

	public String getCopyingFileName() {
		return copyingFileName;
	}



	public void addPublishArray()
	{
	}

	public synchronized void clearCopyingFile()
	{
		copyingfiles.clear();
	}

	//给文件发布使用
	public synchronized void executeUpdate(String sql) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
	}

	 public static ConcurrentHashMap<String, String> getCopying_files_2016() {
		return copying_files_2016;
	}

	 public static ConcurrentHashMap<String, String> getPublishing_files_2016() {
		return publishing_files_2016;
	}
}
