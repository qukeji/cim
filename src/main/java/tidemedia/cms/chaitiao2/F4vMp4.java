package tidemedia.cms.chaitiao2;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.SocketException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.net.ftp.FTPClient;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Log;
import tidemedia.cms.util.FileUtil;
import tidemedia.cms.util.Util;

public class F4vMp4 implements Runnable{

	/**
	 * @param args
	 */
	private Thread 	runner;
	public String path = "";
	public String ffmpeg = "";
	public String f4vpp = "";
	public String rootfolder = "";
	public String mp4_prev_upload = "";
	public static String debug_channel = "cipZmuQ";
	
	public F4vMp4(String path1,String ffmpeg1,String f4v1,String rootfolder1)
	{
		path = path1;
		ffmpeg = ffmpeg1;
		f4vpp = f4v1;
		rootfolder = rootfolder1;
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

	}
	
	public void run2() {
		String mp4_path = path.replace(".f4v", ".mp4");
		String cmd = ffmpeg+" -y -i "+path+" -copyinkf -c copy "+mp4_path;
		//System.out.println(cmd);
		cmd(cmd,false);
	}
	

	
	public void run2_0901() {
		
		String folder = Util.getFilePath(path);//路径
		String name = Util.getFileName(path);//文件名
		String name_prev = "";
		String cmd = "";
		//获取上一个文件
		int i = name.indexOf(".");
		if(i!=-1)
		{
			String s = name.substring(0, i);			
			name_prev = getPrevName(s);
			System.out.println(name+","+s+","+name_prev);
		}
		
		String f4v_prev = folder + "/" + name_prev + ".f4v";
		File f = new File(f4v_prev);
		if(!f.exists())
		{
			System.out.println(f4v_prev+"不存在");
			return;
		}
		
		String mp4_prev = folder + "/" + name_prev + "_.mp4";
		f = new File(mp4_prev);
		int duration = 0;
		if(f.exists())
		{
			duration = getDuration(mp4_prev);
		}
		
		if(path.contains(debug_channel))System.out.println("duration:"+duration+","+mp4_prev);
		if(path.contains(debug_channel))System.out.println("duration:"+getDuration(path)+","+path);
		
		
		if(duration==0)
		{
			System.out.println(mp4_prev+"不存在或文件太小");
			//生成前一段视频的mp4文件
			cmd = ffmpeg+" -y -i "+f4v_prev+" -copyinkf -c copy "+mp4_prev;
			cmd(cmd,false);
		}
		
		//生成当前视频的mp4文件
		String mp4_path = path.replace(".f4v", "_.mp4");
		cmd = ffmpeg+" -y -i "+path+" -copyinkf -c copy "+mp4_path;
		cmd(cmd,false);
		
		//生成ts文件
		String ts_prev = mp4_prev.replace(".mp4", ".ts");
		String ts_path = mp4_path.replace(".mp4", ".ts");
		cmd = ffmpeg+" -y -i "+mp4_prev+" -f mpegts -copyinkf -c copy -vbsf h264_mp4toannexb " + ts_prev;
		cmd(cmd,false);
		cmd = ffmpeg+" -y -i "+mp4_path+" -f mpegts -copyinkf -c copy -vbsf h264_mp4toannexb " + ts_path;
		cmd(cmd,false);
		
		//合并ts
		String mp4_concat = mp4_path.replace(".mp4", "_concat.mp4");
		cmd = ffmpeg + " -y -i concat:"+ts_prev+"|"+ts_path+" -copyinkf -c copy -bsf:a aac_adtstoasc " + mp4_concat;
		cmd(cmd,false);
		int duration_concat = getDuration(mp4_concat);
		if(path.contains(debug_channel))System.out.println("duration:"+duration_concat+","+mp4_concat);
		//分段
		int segment_time = duration_concat/2 + 1;
		
		cmd = ffmpeg +" -y -i "+mp4_concat+" -copyinkf -f segment -c copy -segment_time "+segment_time+" -map 0 "+folder+"/temp%03d.mp4";
		cmd(cmd,false);
		
		if(new File(folder+"/temp002.mp4").exists())
		{
			System.out.println("segment error,"+mp4_concat+","+duration_concat+","+segment_time);
			new File(folder+"/temp002.mp4").delete();
		}
		else
			System.out.println("segment,"+mp4_concat+","+duration_concat+","+segment_time);
		
		//重命名
		String temp_prev = mp4_path.replace(".mp4", "_000.mp4");
		String temp_path = mp4_path.replace(".mp4", "_001.mp4");
		cmd = ffmpeg +" -y -i "+folder+"/temp000.mp4 -copyinkf -c copy " + temp_prev;
		cmd(cmd,false);
		cmd = ffmpeg +" -y -i "+ folder+"/temp001.mp4 -copyinkf -c copy " + temp_path;
		cmd(cmd,false);

		cmd = ffmpeg +" -y -i "+ temp_prev +" -copyinkf -c copy " + mp4_prev.replace("_.mp4", ".mp4");
		cmd(cmd,false);
		cmd = ffmpeg +" -y -i "+ temp_path +" -copyinkf -c copy " + mp4_path.replace("_.mp4", ".mp4");
		cmd(cmd,false);
		cmd = ffmpeg +" -y -i "+ temp_path +" -copyinkf -c copy " + mp4_path;
		cmd(cmd,false);
		if(path.contains(debug_channel)) System.out.println("duration:"+getDuration(mp4_prev.replace("_.mp4", ".mp4"))+","+mp4_prev.replace("_.mp4", ".mp4"));
		if(path.contains(debug_channel)) System.out.println("duration:"+getDuration(mp4_path.replace("_.mp4", ".mp4"))+","+ mp4_path.replace("_.mp4", ".mp4"));
		if(path.contains(debug_channel))
		{
			System.out.println(path+","+new File(path).length());
			System.out.println(mp4_concat+","+new File(mp4_concat).length());
			System.out.println(folder+"/temp001.mp4"+","+new File(folder+"/temp001.mp4").length());
			System.out.println(temp_path+","+new File(temp_path).length());
			System.out.println(mp4_path.replace("_.mp4", ".mp4")+","+new File(mp4_path.replace("_.mp4", ".mp4")).length());
			System.out.println(mp4_path+","+new File(mp4_path).length());
		}
		
		//清理临时文件
		if(!path.contains("o1oV9Vm"))
		{
			new File(temp_prev).delete();
			new File(temp_path).delete();
			new File(mp4_concat).delete();
			new File(ts_prev).delete();
			new File(ts_path).delete();
		}
		
		mp4_prev_upload = mp4_prev;
   	
	}
	
	public void run1() {
    	String temp_mp4 = path.replace(".f4v", "_.mp4");
    	String mp4 = path.replace(".f4v", ".mp4");
    	//2013-08-15 还是加上f4vpp处理，否则可能会有问题
    	CopyF4vToMp4(path,temp_mp4); //去掉f4vpp处理看看
    	//处理mp4，丢弃多余的帧
    	//System.out.println("temp_mp4:"+temp_mp4+",mp4:"+mp4);
    	String cmd = ffmpeg + " -y -i "+temp_mp4+" -qscale 1 " + mp4;
    	cmd(cmd, false);
    	
    	File f_mp4 = new File(mp4);
    	if(f_mp4.exists())
    	{
    		new File(temp_mp4).delete();
    		//new File(path).delete();
    	}
    	
    	if(path.contains("19uK7fc") || path.contains("r55uf2J"))
    	{
			String path_mp4 = path.replace(".f4v", ".mp4");
			FTPClient ftp=new FTPClient();
			try {
				ftp.setDefaultTimeout(40000);
				ftp.connect("211.148.197.154");
				ftp.login("web","tidecms2013");
				ftp.setSoTimeout(40000);
				ftp.setConnectTimeout(40000);
				ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
				ftp.enterLocalPassiveMode();
				
				String ftp_target = path_mp4.replace(rootfolder,"");
				ftp_target = "/"+ftp_target.replace("19uK7fc","82j7Cab").replace("r55uf2J","3f3z39a");
				//System.out.println("上传的文件为："+files2[1].getPath());
				long startFtp = System.currentTimeMillis();
				System.out.println("ftp upload:"+path_mp4+","+ftp_target);
				FileUtil.FtpCopy(ftp,path_mp4, ftp_target);//第二个参数是要上传的文件的路径，第三个参数是上传后的路径，都带文件名
				//传图片
				String photo1 = rootfolder + "screenshot/" + path.replace(rootfolder, "");
				photo1 = photo1.replace(".f4v", ".jpg");
				//System.out.println("photo1:"+photo1);
				String photo2 = photo1.replace(rootfolder,"");
				photo2 ="/"+ photo2.replace("19uK7fc","82j7Cab").replace("r55uf2J","3f3z39a");
				photo2=Util.ClearPath(photo2);
				//System.out.println("photo2:"+photo2);
				ftp.changeWorkingDirectory("/");
				FileUtil.FtpCopy(ftp, photo1, photo2);
				ftp.disconnect();
				long endFtp = System.currentTimeMillis();
				System.out.println("上传时间是:"+(endFtp-startFtp)); 			
			} catch (SocketException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
    	}
   	
	}	
	
	//把f4v拷贝成mp4，放在临时目录下面
	public boolean CopyF4vToMp4(String f4v,String mp4)
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
		//System.out.println("cmd:"+cmd);
		cmd(cmd,false);
		
		return result;
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
	
	//执行一个命令
	public static String cmd(String s,boolean print)
	{
		long begin = System.currentTimeMillis();
		List<String> commend=new java.util.ArrayList<String>();
		ProcessBuilder builder = new ProcessBuilder();
		builder.command(commend);
		builder.redirectErrorStream(true);
		
		String[] ss = Util.StringToArray(s, " ");
		for(int i = 0;i<ss.length;i++)
		{
			commend.add(ss[i]);
		}
				
		String commend_desc = commend.toString().replace(", ", " ");
		//System.out.println(commend_desc);
		try{
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream(); 
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while((line2 = br2.readLine()) != null) buf2.append(line2+"\r\n");
			String bufs = buf2.toString();
			
			process1.destroy();
			if(print)System.out.println("bufs:"+bufs);	
		}catch(Exception e){			
			e.printStackTrace(System.out);
			System.out.println(e.getMessage());
		}
		
		if(commend_desc.contains(debug_channel))
		System.out.println(Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")+","+(System.currentTimeMillis()-begin)+","+commend_desc);
		
		return "";
	}	
	
	public static String getPrevName(String s)
	{
		if(s.length()!=4) return "";//长度必须是4
		
		String m = s.substring(0,2);
		String n = s.substring(2,4);
		
		int nn = Util.parseInt(n);
		if(nn==0)
		{
			int mm = Util.parseInt(m) - 1;
			String m_ = mm + "";
			if(mm<10) m_ = "0" + m_;
			return m_ + "59";
		}
		else
		{
			nn = nn -1;
			String n_ = nn + "";
			if(nn<10) n_ = "0" + n_;
			return m + n_;
		}
	}
	

	//取视频时长，单位是秒
	public int getDuration(String videofile)
	{
		String duration = "";
		List<String> commend=new java.util.ArrayList<String>();
		
		 ProcessBuilder builder = new ProcessBuilder();
		 
		commend.add(ffmpeg);
		commend.add("-i");
		commend.add(videofile);

		builder.command(commend);
		builder.redirectErrorStream(true);
		String bufs = "";
		String bufs_ = "";
		//String commend_desc = commend.toString().replace(", ", " ");
		//System.out.println(commend_desc);
		try{
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream(); 
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while((line2 = br2.readLine()) != null) buf2.append(line2);
		
		bufs = buf2.toString();		
		
		String s_ = " Duration: ";
		int ii = bufs.indexOf(s_);//前面多一个空格，避免meta信息中其他Duration干扰
		if(ii!=-1)
		{
			bufs_ = bufs.substring(ii);
			int jj = bufs_.indexOf(",");
			bufs_ = bufs_.substring(0,jj);//System.out.println(bufs_);
			duration = bufs_.substring(s_.length(),s_.length()+8);
			//System.out.println("duration:"+duration);
			//if(duration.startsWith("00:")) duration = duration.substring(3);
		}

		}catch(Exception e){			
			e.printStackTrace(System.out);
		}
		int d = getTime(duration);
		
		if(d<=20)System.out.println("bufs:"+bufs_+","+bufs);
		//System.out.println("d:"+d);
		return d;
	}	
	
	// 获取时间
	public static int getTime(String s) {
		// System.out.println(s);
		String[] ss = Util.StringToArray(s, ":");
		if (ss == null || ss.length != 3)
			return 0;
		String s3 = ss[2];
		int i = s3.indexOf(".");
		if (i != -1)
			s3 = s3.substring(0, i);
		return Util.parseInt(ss[0]) * 3600 + Util.parseInt(ss[1]) * 60+ Util.parseInt(s3);
	}	
}
