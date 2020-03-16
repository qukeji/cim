package tidemedia.cms.publish;

import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.CmsCache;

public class Publish2015 implements Runnable{

	private Thread 	runner;
	private long	threadid = 0;
	private int 	publish_task_id = 0;//模板发布任务编号
	
	public void Start()
	{
		//主系统才开启线程 20160608
		if(!CmsCache.getConfig().getActive().equals("1"))
			return;
			
		if(runner==null)
		{
	        runner = new Thread(this);
	        //start_time = System.currentTimeMillis();
	        runner.start();
	        
	        threadid = runner.getId();
			//System.out.println("CopyFile#"+threadid+" Start");
		}
	}
	
	@Override
	public void run() {
		try {
			 //0待发布
			 //1 发布完成
			 //2 正在发布
			 //3 发布失败
		System.out.println("publish_task_id:"+publish_task_id+",publish 0");
		if(publish_task_id>0)
		{
				TableUtil tu = new TableUtil();
				PublishTask pt = new PublishTask(publish_task_id);
				
				Publish publish = new Publish();
				publish.setPublishType(pt.getPublishType());
				publish.setChannelID(pt.getChannelID());
				publish.setPublishAllItems(pt.getPublishAllItems());
				System.out.println("publish_task_id:"+publish_task_id+",publish 1");
				if(pt.getPublishType()==Publish.ONLY_DOCUMENT_PUBLISH)
				{
					//System.out.println("add task item id:"+publishtask_1.getItemID());
					publish.addPublishItems(pt.getItemID());
				}
				publish.setPublishTaskID(pt.getTaskID());
				publish.setPublishtask(pt);
				System.out.println("GenerateFile begin "+publish_task_id);
				boolean r = publish.GenerateFile();
				System.out.println("GenerateFile end "+publish_task_id+","+r);
				if(r)
				{
					long PublishEnd = System.currentTimeMillis();
					if(pt.getPublishType()==Publish.CHANNEL_PUBLISH)
					{
						tu.executeUpdate("update publish_task set Status=1,Message=Concat(Message,'结束发布\r\n'),PublishEnd="+PublishEnd+" where Status=2 and ChannelID="+pt.getChannelID()+" and ChannelTemplateID="+pt.getChannelTemplateID());
					}
					else
					{
						tu.executeUpdate("update publish_task set Status=1,Message=Concat(Message,'结束发布\r\n'),PublishEnd="+PublishEnd+" where id=" + publish_task_id);
					}					
					System.out.println("GenerateFile CopyFileNow begin");
					//PublishManager.getInstance().CopyFileNow();
					System.out.println("GenerateFile CopyFileNow end");
					System.out.println("finish task :"+pt.getTaskID()+",publishtype:"+pt.getPublishType());
				}
				System.out.println("publish_task_id:"+publish_task_id+",publish 2");
		}
		System.out.println("publish_task_id:"+publish_task_id+",publish 3");
		TemplatePublishAgent.PublishDone();
		System.out.println("publish_task_id:"+publish_task_id+",publish 4");
		
		} catch (SQLException e) {
			System.out.println("publish2015 "+e.getMessage());
			e.printStackTrace();
		} catch (MessageException e) {
			System.out.println("publish2015 "+e.getMessage());
			e.printStackTrace();
		}
	}

	public int getPublish_task_id() {
		return publish_task_id;
	}

	public void setPublish_task_id(int publish_task_id) {
		this.publish_task_id = publish_task_id;
	}

}
