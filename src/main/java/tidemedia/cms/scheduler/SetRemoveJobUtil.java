package tidemedia.cms.scheduler;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.quartz.SchedulerException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.Log;

public class SetRemoveJobUtil implements Job {
	static int firstTimeInit=0;
	public SetRemoveJobUtil() {
		// TODO Auto-generated constructor stub
	}

	public void execute(JobExecutionContext jobCtx)throws JobExecutionException {
		int gid = jobCtx.getJobDetail().getJobDataMap().getInt("gid");
		try {
			if(gid<=0) {
				Log.SystemLog("定时撤销", "定时撤销失败，gid="+gid);
				return;
			}
			tidemedia.cms.system.Document document = new tidemedia.cms.system.Document(gid);
			String title = document.getTitle();
			if(document.getStatus()==0){
				Log.SystemLog("定时撤销", "文章已撤销：gid="+gid+",title="+title);
				return;
			}
			String id_ = document.getId() + "";
			int ChannelID = document.getChannelID();
			//document.Approve(id_, ChannelID);
			document.Delete2(id_, ChannelID);
			Log.SystemLog("定时撤销", "正在撤销文章，gid="+gid+",title="+title);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ParseException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public static void setPublishJob2(int gid) throws SQLException, MessageException, SchedulerException{
		
		
		deleteSetPublishDate2(gid);//数据库中删除
		TimetoTask.removerevokeJob(gid);//removeJob(gid);//定时任务中删除
		addSetPublishDate2(gid);//数据库中添加任务
		addTask2(gid);//定时任务中添加
	}
	
	public static boolean addSetPublishDate2(int globalid){

	
		Document doc;
		try {
			doc = new Document(globalid);
			String spd = doc.getValue("Revoketime");
			String title = doc.getValue("Title");
			if(spd.length()==16){//2013-08-03 14:09
				spd+=":00";
			}
			TableUtil tu = new TableUtil();
			String sql = "";
			sql = "insert into tidecms_to_publish (globalid,republishtime) values("+globalid+",'"+spd+"')";
			Log.SystemLog("定时撤销", "添加撤销任务,gid="+globalid+",title="+title);
			tu.executeUpdate(sql);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return true;
	}
	
	
public static boolean deleteSetPublishDate2(int globalid){

		TableUtil tu;
		try {
			tu = new TableUtil();
			String sql = "";
			sql = "delete from tidecms_to_publish where globalid="+globalid+" and republishtime is not null";
			tu.executeUpdate(sql);
			
		} catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return true;
	}


	public static  void addTask2(int globalid){
		try{
			tidemedia.cms.system.Document doc = new tidemedia.cms.system.Document(globalid);
			String spd = doc.getValue("Revoketime");
			if(spd.length()==16){//2013-08-03 14:09
				spd+=":00";
			}
			TimetoTask  t = new TimetoTask();
			t.revoketask(spd, globalid);//task(spd,globalid);
		}catch (MessageException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch (SchedulerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	 public static void initSetPublishDate() throws MessageException, SQLException, SchedulerException, ParseException
	 {	
		 	Log.SystemLog("定时撤销", "初始化开始");
		 	TableUtil tu = new TableUtil();
		 	String sql = "";
		 	long now=System.currentTimeMillis()/1000;
			String date = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new java.util.Date(now));
		 	sql = "select * from tidecms_to_publish where republishtime>'"+date+"'";
		 	Log.SystemLog("定时撤销", "定时初始化sql="+sql);
		 	ResultSet rs = tu.executeQuery(sql);
		 	int gid=0;
		 	String republishtime="";
		 	while(rs.next()){
		 		gid = rs.getInt("globalid");
		 		republishtime = rs.getString("republishtime");
				TimetoTask  t = new TimetoTask();
				if(firstTimeInit!=0) t.removerevokeJob(gid);//removeJob(gid);
				t.revoketask(republishtime, gid);//task(republishtime,gid);
				firstTimeInit++;
				Log.SystemLog("定时撤销", "正在加载定时任务:gid="+gid+",republishtime="+republishtime);
		 	}
		 	tu.closeRs(rs);
		 	Log.SystemLog("定时撤销", "初始化完成");
		 	
	 }
	 
}
