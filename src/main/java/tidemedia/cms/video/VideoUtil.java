package tidemedia.cms.video;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Log;

import tidemedia.cms.util.Util;
//tidemedia.cms.video;
public class VideoUtil {

	/**
	 * 视频截图
	 * @param videofile	源视频文件路径
	 * @param imagefile	截图文件路径
	 * @param minute mintue为秒数，如果为空，从视频的第1/10处截屏
	 * @param size 如120*80
	 * @throws MessageException
	 * @throws SQLException
	 */
	public static boolean CaptureImage(String ffmpeg,String videofile,String imagefile,String minute,String size) throws MessageException, SQLException
	{
		System.out.println("CaptureImage:"+videofile+","+minute);
		imagefile = Util.ClearPath(imagefile);
	
		ProcessBuilder builder = new ProcessBuilder();
		List<String> commend=new java.util.ArrayList<String>();
		commend.add(ffmpeg);
		//-ss参数要放在第一个，否则速度很慢
		commend.add("-ss");
		if(minute.length()==0)
		{
			int duration = getDuration(ffmpeg,videofile);
			if(duration>10)
				minute = (duration/10) + "";
			else
				minute = "1";
		}
		commend.add(minute);//commend.add("08");		
		commend.add("-i");
		commend.add(videofile);
		commend.add("-y");
		commend.add("-f");
		commend.add("image2");
		commend.add("-vframes");
		commend.add("1");
		
		if(size.length()>0)
		{
			commend.add("-s");		
			commend.add(size);//commend.add("145x80");
		}
		commend.add(imagefile);	
		builder.command(commend);
		String commend_desc = commend.toString().replace(", ", " ");
		System.out.println(commend_desc);
		builder.redirectErrorStream(true);
		StringBuilder buf = new StringBuilder(); // 保存ffmpeg的输出结果流
		try {
			int i = imagefile.lastIndexOf("/");
			File file = new File(imagefile.substring(0,i));
			if(!file.exists())
				file.mkdirs();
			file = null;
			Process process = builder.start();
			InputStream is = process.getInputStream(); // 获取ffmpeg进程的输出流
			BufferedReader br = new BufferedReader(new InputStreamReader(is)); // 缓冲读入
			String line = null;
			while((line = br.readLine()) != null) buf.append(line); // 循环等待ffmpeg进程结束			
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("ffmpeg输出内容为：" + buf);
		}
		
		File f = new File(imagefile);
		if(!f.exists())
		{
			return false;
		}
		else
			return true;
	}
	
	//获取视频信息，duration 时长 bitrate 码流 width 宽 height 高 videotype 编码方式 fps 帧率
	@SuppressWarnings("unchecked")
	public static HashMap getVideoInfo(String ffmpeg[]){
		HashMap map = new HashMap();
		String duration = "";//时长
		String bitrate = "";//码流
		String widthHeight="";//分辨率
		String videoType = "";//编码方式
		String fps ="";//帧率
		 
		try {
			 
			String videoInfo =VideoUtil.cmd(ffmpeg, false);
		 	 System.out.println("videoInfowhl:"+videoInfo);
			if(videoInfo.indexOf("No such file")!=-1){
				 
				Log.SystemLog("转码服务端", "视频源文件无法读取："+ffmpeg+","+videoInfo);
			}
			duration = getDurations(videoInfo," Duration: ");
 		     bitrate = getBitrate(videoInfo, " bitrate: ");
			 videoType = getVideoType(videoInfo, " Video: ");
			
                         widthHeight = getRegex(videoInfo,"[0-9]{2,}x[0-9]{2,}");
			 fps = getRegex(videoInfo, "[0-9]{1,}(.[0-9]+)* fps");
			 map.put("Duration", duration);
			 map.put("Bitrate", bitrate);
			 map.put("VideoType",videoType);
			 map.put("WidthHeight", widthHeight);
			 map.put("Fps", fps);
			 System.out.println(map.get("Duration")+"=Durationwhl");
		} catch (Exception e) {
		 
			e.printStackTrace();
		}
		return map;
	}
	//取视频时长，单位是秒
	public static int getDuration(String ffmpeg,String videofile)
	{
		String duration = "";
		List<String> commend=new java.util.ArrayList<String>();
		
		 ProcessBuilder builder = new ProcessBuilder();
		 
		commend.add(ffmpeg);
		commend.add("-i");
		commend.add(videofile);

		builder.command(commend);
		builder.redirectErrorStream(true);
		
		String commend_desc = commend.toString().replace(", ", " ");
		System.out.println(commend_desc);
		try{
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream(); 
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while((line2 = br2.readLine()) != null) buf2.append(line2);
		
		String bufs = buf2.toString();System.out.println("bufs:"+bufs);
		
		if(bufs.indexOf("No such file")!=-1 || bufs.indexOf("HTTP error 404 Not Found")!=-1)
		{
			Log.SystemLog("转码服务端", "视频源文件无法读取，请检查sys_video中source_folder的配置是否正确："+commend_desc+","+bufs);
		}
		
		String s_ = " Duration: ";
		int ii = bufs.indexOf(s_);//前面多一个空格，避免meta信息中其他Duration干扰
		if(ii!=-1)
		{
			bufs = bufs.substring(ii);
			int jj = bufs.indexOf(",");
			bufs = bufs.substring(0,jj);//System.out.println(bufs);
			duration = bufs.substring(s_.length(),s_.length()+8);
			System.out.println("duration:"+duration);
			//if(duration.startsWith("00:")) duration = duration.substring(3);
		}
		else
		{
			Log.SystemLog("转码服务端", "没有读取到' Duration: '："+commend_desc);
		}
		}catch(Exception e){
			
			e.printStackTrace(System.out);
			if(e.getMessage().indexOf("Cannot run program")!=-1)
			{				
				Log.SystemLog("转码服务端", "ffmpeg命令无法运行，请检查sys_video中ffmpeg路径配置是否正确："+commend_desc);
			}
			else
			{
				System.out.println(commend_desc);
			}
		}
		int d = getTime(duration);
		System.out.println("d:"+d);
		return d;
	}
	
	//执行一个命令
	public static String cmd(String s[],boolean print)
	{	System.out.println("enter cmd");
		List<String> commend=new java.util.ArrayList<String>();
		ProcessBuilder builder = new ProcessBuilder();
		builder.command(commend);
		builder.redirectErrorStream(true);
		
		//String[] ss = Util.StringToArray(s, " ");
		for(int i = 0;i<s.length;i++)
		{
			commend.add(s[i]);
		}
				
		String commend_desc = commend.toString().replace(", ", " ");
		System.out.println("commend_desc:"+commend_desc);
		try{
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream(); 
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		String bufs = null;
		while((line2 = br2.readLine()) != null) buf2.append(line2+"\r\n");
			  bufs = buf2.toString();
			
			process1.destroy();
			if(print)System.out.println("bufsCmd:"+bufs);	
			return bufs;
		}catch(Exception e){			
			e.printStackTrace(System.out);
			System.out.println(e.getMessage());
		}
		return "";
	}	
	
	//获取时间
	public static int getTime(String s)
	{
		 
			System.out.println("getTime:"+s);
			String[] ss = Util.StringToArray(s, ":");
			if(ss==null || ss.length!=3)
				return 0;
			String s3 = ss[2];
			//System.out.println("s3:"+s3);
			int i = s3.indexOf(".");
			if(i!=-1)
				s3 = s3.substring(0,i);
			
			
			System.out.println("t:"+  Util.parseInt(ss[0])*3600 + Util.parseInt(ss[1])*60 + Util.parseInt(s3));
			return   Util.parseInt(ss[0])*3600 + Util.parseInt(ss[1])*60 + Util.parseInt(s3);
		 
	}
	
	//更新进度
	public static void updateProgress(int itemid,int progress) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		String sql = "update channel_transcode set progress=" + progress + " where id=" + itemid;
		tu.executeUpdate(sql);
	}
	
	/**
	 * 更新音视频媒资转码状态Status2 = 0 等待转码 1 正在转码 2 转码完成 3 转码失败
	 * @author wanghailong
	 * @param globalid
	 * @param status
	 * @throws MessageException
	 * @throws SQLException
	 * 
	 */	 
	public static void updateStatus(int globalid,int status) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		String sql = "update channel_s4_a_d set Status2="+status+" where globalid="+globalid;
		tu.executeUpdate(sql);
	}
	
	//更新转码状态和原因 Status2 = 0 等待转码 1 正在转码 2 转码完成 3 转码失败
	public static void updateStatus(int itemid,int status,String message) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		String sql = "update channel_transcode set Status2="+status+",reason=concat(IFNULL(reason,''),'  " + tu.SQLQuote(message) + "  ')";
		if(status!=2) sql += ",progress=0";
		sql += " where id=" + itemid;
		System.out.println(sql);
		tu.executeUpdate(sql);
	}
	
	//更新分发状态 0 等待分发，1 分发完成
	public static void updatePublishStatus(int itemid,int status) throws MessageException, SQLException
	{
		TableUtil tu = new TableUtil();
		String sql = "update channel_transcode set PublishStatus="+status+" where id=" + itemid;
		tu.executeUpdate(sql);
	}
	//获取时长
	public static String getDurations(String videoInfo,String sub){
		int index1 = videoInfo.indexOf(sub);
		String temp = "";
		 if(index1!=-1){
			String dur = videoInfo.substring(index1);
			int j1 = dur.indexOf(",");
			dur = dur.substring(0,j1);
			 temp = dur.substring(sub.length(),sub.length()+8);
		}else{
			temp="";
		}
		 return temp;
	}
	//获取码率
	public static String getBitrate(String videoInfo,String sub){
		int index1 = videoInfo.indexOf(sub);
		String temp = "";
		 if(index1!=-1){
			String dur = videoInfo.substring(index1);
			int j1 = dur.indexOf(",");
			dur = dur.substring(0,j1);
			 temp = dur.substring(sub.length(),sub.length()+9);
		}else{
			temp="";
		}
		 return temp;
	}
	//获取编码方式
	public static String getVideoType(String videoInfo,String sub){
		System.out.println(videoInfo);
		int index1 = videoInfo.indexOf(sub);
		System.out.println(index1);
		String temp = "";
		 if(index1!=-1){
			String dur = videoInfo.substring(index1);
			int j1 = dur.indexOf(",");
			dur = dur.substring(0,j1)+" ";
			 
			 temp = dur.substring(sub.length(),sub.length()+5);
		}else{
			temp="";
		}
		 return temp;
	}
	 
	 
	 //通过正则来提取
	public static String getRegex(String videoInfo,String reg){
		Pattern pat = Pattern.compile(reg);
		 Matcher mat = pat.matcher(videoInfo);
		 while(mat.find())
			 return mat.group();
		 return "";
	}
}
