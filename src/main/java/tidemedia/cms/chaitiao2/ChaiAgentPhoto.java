package tidemedia.cms.chaitiao2;

import java.io.BufferedReader;
import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.SocketException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Log;
import tidemedia.cms.util.Util;

public class ChaiAgentPhoto implements Runnable{

	/**
	 * @param args
	 */
	private Thread 	runner;
	public static String rootfolder = "";//"D:/rtREC/";//要截图的拆条文件的跟目录
	public static String ffmpeg = "";//"D:/ffmpeg-20130614-git-6fe419b-win64-static/bin/ffmpeg.exe";//ffmpeg路径配置
	public static String chaitiao_cmd_print = "";
	public static int chaitiao_photo_log = 0;
	public static String f4vpp = "";//f4v路径
	public static int	log_number = 0;
	public static int	chaitiao_f4v_channelid = 0;//f4v文件处理存放频道编号
	//public static String p="";
	
	public ChaiAgentPhoto()
	{
		try {
			rootfolder = CmsCache.getParameterValue("chaitiao_rootfolder");
			ffmpeg = CmsCache.getParameterValue("chaitiao_ffmpegpath");
			chaitiao_cmd_print = CmsCache.getParameterValue("chaitiao_cmd_print");
			f4vpp = CmsCache.getParameterValue("chaitiao_f4vpp");
			chaitiao_f4v_channelid = CmsCache.getParameter("chaitiao_f4v_channelid").getIntValue();
		} catch (MessageException e) {
			e.printStackTrace(System.out);
		} catch (SQLException e) {
			e.printStackTrace(System.out);
		}
		
		rootfolder = Util.ClearPath(rootfolder);
	}
	
	public void Start()
	{
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
		
		if(chaitiao_f4v_channelid==0)
		{
			Log.SystemLog("拆条系统","拆条f4v素材处理频道编号没有配置.");
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
		int sleeptime = 10000;//10秒
        Thread thisThread = Thread.currentThread();
        System.out.println("chaitiao2  running.....");

        while(thisThread==runner) {
        	
        	//chaitiao_photo_log = CmsCache.getParameter("chaitiao_cmd_print").getIntValue();
        	
        	File f = new File(rootfolder);
        	
        	if(!f.exists())
        	{
        		Log.SystemLog("拆条", "截图根目录不存在.");
        		runner = null;
        	}
        	
        	File[] files = f.listFiles();
        	int k = 0;
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
    					long stime = System.currentTimeMillis();
    					String pp = Util.ClearPath(p+"/"+Util.getCurrentDate("yyyyMMdd"));
    					File file_pp = new File(pp);
    					if(file_pp.exists())
    					{
    						k++;
        					//System.out.println("准备截图："+pp);
        					try {
								try {
									Capture(pp);
								} catch (ParseException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							} catch (SocketException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (IOException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (MessageException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							} catch (SQLException e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}

        					//System.out.println("f4v folder2:"+pp+","+Util.getCurrentDateTime()+","+(System.currentTimeMillis()-stime));    						
    					}
    					else
    					{
    						Log.SystemLog("拆条", "要截图的频道目录："+pp+" 不存在.");
    					}
    				}
    			} 
    		}
	    	
        	if(k==0)
        	{
        		Log.SystemLog("拆条", "要截图的频道目录不存在，根目录："+rootfolder);
        		sleeptime = 300000;
        	}
        	else
        		sleeptime = 10000;//10秒

        	try {
				Thread.sleep(sleeptime);//10秒
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
        }
	}
	
	//找出此目录下需要截图的f4v文件并截图
	public void Capture(String folder) throws SocketException, IOException, MessageException, SQLException, ParseException
	{
		File file = new File(folder);
		if(!file.exists()) return;
		
		File[] files2 = file.listFiles(new FilenameFilter() {
		    public boolean accept(File dir, String name) {
		        return name.endsWith(".f4v");
		    }
		});
		if(files2==null || files2.length<2) 
		{
			Log.SystemLog("拆条", "没找到需要截图的f4v,"+folder);
			return;
		}
		
		List list = table_f4v();
	    done_flvs(list);
    }
	
	//查询数据库时间最后一条 到当前时间所有的f4v 文件 插入到channel_chaitiao_f4v中  返回List存在的f4v路径
	public List table_f4v() throws MessageException, SQLException, ParseException
	{
		Channel channel = CmsCache.getChannel(chaitiao_f4v_channelid);
		ArrayList list =new ArrayList();
		File f = new File(rootfolder);
		File[] files = f.listFiles();
		for(int j = 0;files!=null && j<files.length;j++)
		{
			if(files[j].isDirectory())
			{	
				String p = files[j].getPath();
				if(p.contains("screenshot") || p.contains("publish") || p.contains("mp4"))
			{    					
			}
			else
			{		
					String nowday_ = Util.getCurrentDate("yyyyMMdd");
					long nowday = Long.parseLong(nowday_);
					String minute="";
					int datetime=0;
					//查询数据库最后一条
					String sql = "select minute,datetime from "+channel.getTableName()+" where chaitiao_channel='"+p.substring(p.length()-7,p.length())+
					"' order by datetime desc,minute desc limit 1";
					//System.out.println("sql为="+sql);
					TableUtil tu = new TableUtil();
					ResultSet Rs = tu.executeQuery(sql);
					if(Rs.next())
					{	
						minute	= Rs.getString("minute");
						datetime= Rs.getInt("datetime");
						 
					  SimpleDateFormat sdf_= new SimpleDateFormat("HHmm");
					  Date abirthday_ = sdf_.parse(minute);
					  Calendar acal = Calendar.getInstance();
					  acal.setTime(abirthday_);
					  acal.add(Calendar.MINUTE, 1);
					  String minute_plus1=(new SimpleDateFormat("HHmm")).format(acal.getTime());
						
					  	 //获取数据库最后一条到当前时间的分钟数
						 String str3=nowday_+minute_plus1+"00";
						 SimpleDateFormat sdf3= new SimpleDateFormat("yyyyMMddHHmmss");
						 Date birthday3 = sdf3.parse(str3);
						  Long time1= birthday3.getTime();//这就是距离1970年1月1日0点0分0秒的毫秒数
						  long time2 =System.currentTimeMillis();
						  long time3_=time2-time1;
						  long time3=time3_/(60*1000);
						  //System.out.println("数据库最后一条时间到现在时间分钟数="+time3);
						  int inttime3 =Integer.parseInt(String.valueOf(time3));
						  String num=p.substring(p.length()-7,p.length());
						  //跨天的时候分钟数会变成负数 天数需要变成昨天的
						  if(inttime3<0)
						  {
							  inttime3=inttime3+(60*24);
							  System.out.println("数据库最后一条时间到现在时间分钟数 变正数="+inttime3);
						  }
						  //处理每天晚上23:58和23:59 的f4v
						  if(minute.equals("2357"))
						  {
							  for(int i=1;i<3;i++){
								  String str_=minute;
								  SimpleDateFormat sdf= new SimpleDateFormat("HHmm");
									 Date birthday_ = sdf.parse(str_);
								  Calendar cal = Calendar.getInstance();
								  cal.setTime(birthday_);
								  cal.add(Calendar.MINUTE, i);
								  String minute58=(new SimpleDateFormat("HHmm")).format(cal.getTime());
								  System.out.println(minute58);
								  
								  String min_path=p+"/"+datetime+"/"+minute58+".f4v";

								  File min58_p = new File(min_path);
								  int status = 0;
								  String sql_inser="";
								  if(min58_p.exists()){									  
									  status=1;
								  }
								  sql_inser = "insert into "+channel.getTableName()+" (Title,chaitiao_channel,datetime,minute,last_insert,exist,Status,Active,ModifiedDate) values('"+min_path+"','"+num+"',"+nowday+",'"+minute58+"',now(),"+status+",0,1,UNIX_TIMESTAMP())";
								  
								  TableUtil tu3 = new TableUtil();
								  int insertid = tu3.executeUpdate_InsertID(sql_inser);

							  }
						  }
						  
						  String[] arr = new String[inttime3];
						  for(int i=0;i<inttime3-1;i++)
						  {
							  String str_=minute_plus1;
							  SimpleDateFormat sdf= new SimpleDateFormat("HHmm");
							  Date birthday_ = sdf.parse(str_);
							  Calendar cal = Calendar.getInstance();
							  cal.setTime(birthday_);
							  cal.add(Calendar.MINUTE, i);
							  String minute_s=(new SimpleDateFormat("HHmm")).format(cal.getTime());
							  
							  //判断表中最后一条时间是否大于当前时间
							  SimpleDateFormat nowtemp = new SimpleDateFormat("yyyyMMddHHmm");
							  String nowdatetime = nowtemp.format(new java.util.Date());
							  String lasttime=nowday+minute_s;
							  
							  if(nowdatetime.compareTo(lasttime)>0){
							  String f_path=p+"/"+nowday+"/"+minute_s+".f4v";
							  arr[i]=f_path;
							  //System.out.println("xinxin数组内容为"+arr[i]);
							  String last_s ="now()";
							  String sql_inser="";
							  int status = 0;
							  
							  File fpath=new File(arr[i]);
								if(fpath.exists())
								  {
									  status = 1;
								  }
									sql_inser = "insert into "+channel.getTableName()+"(Title,chaitiao_channel,datetime,minute,last_insert,exist,Category,Status,Active,ModifiedDate) values('"+f_path+"','"+num+"',"+nowday+",'"+minute_s+"',"+last_s+","+status+",0,0,1,UNIX_TIMESTAMP())";
								  	//System.out.println("sql_where_insert="+sql_inser);
									TableUtil tu3 = new TableUtil();
									tu3.executeUpdate(sql_inser);
							  }else{
								  //System.out.println("大于现在时间不作处理");
							  }
						  }
						  
							//查询当前时间到0000所有没有生成的f4v文件 
						  String sql_s = "select * from "+channel.getTableName()+" where chaitiao_channel='"+num+"' and Status=0 and ModifiedDate>UNIX_TIMESTAMP()-7200";//20小时
						  //System.out.println("查询所有未生成f4v的文件sql_s="+sql_s);
						  TableUtil tu4 = new TableUtil();
						  ResultSet rs2 = tu4.executeQuery(sql_s);
							while(rs2.next()){
								int id = rs2.getInt("id");
								String minute2 = rs2.getString("minute");
								int datetime2= Rs.getInt("datetime");
								String no_exist_path=p+"/"+datetime2+"/"+minute2+".f4v";
								//System.out.println("no_exist_path="+no_exist_path);
								
								 File fpath=new File(no_exist_path);
								 if(fpath.exists())
								 {
									  list.add(new String[]{no_exist_path,id+""});
									  //System.out.println("存在路径!!!!!"+fpath);
								 }
							}
							tu4.closeRs(rs2);
							
					}else
					{
						System.out.println("没有查到数据库的数据 自动扫描所有的加入到数据库   并转成mp4 exist 设置为1");
						getflvs();
					}
					tu.closeRs(Rs);
				}	
			}
		}
		return list;
	}
	
	//第一次数据库中没数据的时候，插入已经存在的f4v
	//查询00：00 到当前时间所有的f4v 文件 插入到channel_chaitiao_f4v中  返回List存在的f4v路径
	public void getflvs() throws ParseException, MessageException, SQLException
	{	
		Channel channel = CmsCache.getChannel(chaitiao_f4v_channelid);
		List<String> list =new ArrayList<String>();
		File f = new File(rootfolder);
		File[] files = f.listFiles();
		for(int j = 0;files!=null && j<files.length;j++)
		{
			if(files[j].isDirectory())
			{
				 String p = files[j].getPath();
		if(p.contains("screenshot") || p.contains("publish") || p.contains("mp4"))
		{    					
		}
		else
		{
			String nowday_ = Util.getCurrentDate("yyyyMMdd");
			long nowday = Long.parseLong(nowday_);
			 //获取0000到当前时间的分钟数
			 SimpleDateFormat tempDate2 = new SimpleDateFormat("yyyyMMdd");
			 String now6 = tempDate2.format(new java.util.Date());
			 String str3=now6+"000000";
			 SimpleDateFormat sdf3= new SimpleDateFormat("yyyyMMddHHmmss");
			 Date birthday3 = sdf3.parse(str3);
			  Long time1= birthday3.getTime();//这就是距离1970年1月1日0点0分0秒的毫秒数
			  long time2 =System.currentTimeMillis();
			  long time3_=time2-time1;
			  long time3=time3_/(60*1000);
			  System.out.println("分钟数="+time3);
			  int inttime3 =Integer.parseInt(String.valueOf(time3));
			  
			  //循环出0000~当前时间
			  String[] arr = new String[inttime3];
			  for(int i=0;i<time3;i++)
			  {
				  //System.out.println("Gooooooo2222");
				  String str_="0000";
				  SimpleDateFormat sdf= new SimpleDateFormat("HHmm");
				  Date birthday_ = sdf.parse(str_);
				  Calendar cal = Calendar.getInstance();
				  cal.setTime(birthday_);
				  cal.add(Calendar.MINUTE, i);
				  String minute=(new SimpleDateFormat("HHmm")).format(cal.getTime());
				  String f_path=p+"/"+nowday+"/"+minute+".f4v";
				  arr[i]=f_path;
				  //System.out.println("数组内容为"+arr[i]);
				  String last_s ="now()";
				  String sql5="";
				  int status=0;
				  File fpath=new File(arr[i]);
				  if(fpath.exists())
				  {
					   list.add(fpath.getPath());
					    status=1;
				  }
				  	sql5 = "insert into "+channel.getTableName()+"(Title,chaitiao_channel,datetime,minute,last_insert,exist,Category,Status,Active,ModifiedDate) values('"+f_path+"','"+p.substring(p.length()-7,p.length())+"',"+nowday+",'"+minute+"',"+last_s+","+status+",0,0,1,UNIX_TIMESTAMP())";
					//System.out.println("sql5555="+sql5);
					TableUtil tu3 = new TableUtil();
					tu3.executeUpdate(sql5);
			  }
		}
				}
			}
	}
	
	//传一个数组    处理数组中的所有f4v文件   
	public void  done_flvs(List list) throws MessageException, SQLException, ParseException
	{
		Channel channel = CmsCache.getChannel(chaitiao_f4v_channelid);
		TableUtil tu = new TableUtil();
		for(Object o : list)
		{
			String[] s = (String[])o;
			String filename = s[0];
			String id = s[1];
			

			if(filename.length()>0)
			{
				boolean cap = Capture2(filename);
			    if(cap)
			    {
			    	//f4v转mp4
			    	F4vMp4 f = new F4vMp4(filename, ffmpeg, f4vpp, rootfolder);
			    	f.run2();
			    	//System.out.println("run2");
			    	//f.Start();//南宁台上传到cutv，定制程序
			    }

		        String sql = "update "+channel.getTableName()+" set chaitiao_status=1,exist=1,Status=1 where id="+id;
				//System.out.println("update的sql为="+sql);
				tu.executeUpdate(sql);
			}
		}
	}
	
	



	public static boolean Capture2(String filename)
	{
		boolean result = true;
		File f = new File(filename);
		if(!f.exists())
		{
			Log.SystemLog("拆条", "要截图的f4v不存在,"+filename);
			return false;
		}
		f = null;
		String destfile = rootfolder + "/screenshot/" + filename.replace(rootfolder, "");
		destfile = destfile.replace(".f4v", ".jpg");
		f = new File(destfile);
		if(f.exists())
		{
			//Log.SystemLog("拆条", "截图已经存在,"+destfile);
			//System.out.println("截图已经存在:"+destfile);
			return false;
		}
				
		List<String> commend = new java.util.ArrayList<String>();
		ProcessBuilder builder = new ProcessBuilder();
		//ffmpeg -i "d:\test\1JY35.f4v" -y -f image2 -ss 00:00:00 -vframes 1 -vf "scale=60:-1" "d:\test1\1JY35.jpg"
		//String reourcefilepath = rootfloder+"/"+sid+"/"+zerotime+"/"+lastfilename;
		
		//System.out.println(destfile);
		String folder = Util.getFilePath(destfile);
		//System.out.println("folder:"+folder);
		File file = new File(folder);
		if(!file.exists())
			file.mkdirs();
		file = null;

		commend.add(ffmpeg);
		commend.add("-i");
		commend.add(filename);
		commend.add("-y");
		commend.add("-f");
		commend.add("image2");
		commend.add("-ss");
		commend.add("00:00:01");//截取00:00:00 可能会有灰图片
		commend.add("-vframes");
		commend.add("1");
		commend.add("-vf");
		commend.add("scale=60:-1");
		commend.add(destfile);
		

		builder.command(commend);
		builder.redirectErrorStream(true);

		String commend_desc = commend.toString().replace(", ", " ");
		if(chaitiao_cmd_print.length()>0)System.out.println(commend_desc);
		try {
			Process process1 = builder.start();
			InputStream is2 = process1.getInputStream();
			BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
			StringBuilder buf2 = new StringBuilder();
			String line2 = null;
			while ((line2 = br2.readLine()) != null)
				buf2.append(line2 + "\r\n");
			String bufs = buf2.toString();
			if(chaitiao_cmd_print.length()>0)
				System.out.println("bufs:" + bufs);
		} catch (Exception e) {
			result = false;
			e.printStackTrace(System.out);
			System.out.println(e.getMessage());
		}
		//System.out.println("截图完成:"+destfile);
		if(result)
		{
			//只记录10次即可
			if(log_number<10)
			{
				Log.SystemLog("拆条", "f4v："+filename+"生成截图："+destfile);
				log_number++;
			}
		}
		else
		{
			Log.SystemLog("拆条", "f4v："+filename+"没有生成截图："+destfile);
		}
		
		return result;
	}

	/**
	 * 获取当天零点时间戳
	 * 
	 * @return
	 */
	public static Long getTodayZeroTime() 
	{
		Calendar nowDate = new java.util.GregorianCalendar();
		nowDate.set(Calendar.HOUR_OF_DAY,0);
		nowDate.set(Calendar.MINUTE,0);
		nowDate.set(Calendar.SECOND,0);
		nowDate.set(Calendar.MILLISECOND,0);
		return nowDate.getTimeInMillis();
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
	
	//把f4v拷贝成mp4，放在临时目录下面
	public static boolean CopyF4vToMp4(String f4v,String mp4)
	{
		boolean result = true;
		File f_ = new File(f4v);
		//如果源文件不存在
		if(!f_.exists()) return false;
		File f__ = new File(mp4);
		//如果目标文件已经存在
		if(f__.exists()) return true;
	
		String folder = Util.getFilePath(mp4);
		System.out.println("folder:"+folder);
		File file = new File(folder);
		if(!file.exists())
			file.mkdirs();
		file = null;
		
		String cmd = f4vpp + " -i "+f4v+" -o " + mp4;
		System.out.println("cmd:"+cmd);
		//ChaiAgentMp4.cmd(cmd,false);
		
		return result;
	}	
}
