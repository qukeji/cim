package tidemedia.cms.video;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.List;

import tidemedia.cms.util.Util;

public class StreamAgent implements Runnable{

	private String cmd = "";
	private Thread 	runner;
	private int log = 0;//0不打印 1打印除了“frame=  288 fps= 26 q=30.0 size=    1246kB time=00:00:11.47 bitrate= 889.8kbits/s“，2全打印
	private int log_num = 0;
	private long	threadid = 0;
	private String message = "";

	public void start()
	{
		runner = null;
	    runner = new Thread(this);
	    threadid = runner.getId();
	    runner.start();
	}
	
	public void run() {
		//String s = "/usr/bin/ffmpeg -i http://live1.av.jiaodong.net/channels/yttv/YTTV-1/flv:2000K -re -strict experimental -acodec copy -vcodec libx264 -b 1000k -threads 64 -f flv";
		//s += " \"rtmp://192.168.4.30/rtRVScore/Vs8j6vg?pub/video\"";
		List<String> commend=new java.util.ArrayList<String>();
		ProcessBuilder builder = new ProcessBuilder();
		builder.command(commend);
		builder.redirectErrorStream(true);
		
		String[] ss = Util.StringToArray(cmd, " ");
		for(int i = 0;i<ss.length;i++)
		{
			commend.add(ss[i]);
		}
				
		String commend_desc = commend.toString().replace(", ", " ");
		System.out.println(threadid+" commend_desc:"+commend_desc);
		try {
			Process process1 = builder.start();
			InputStream is2 = process1.getInputStream(); 
			BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
			
			while((message = br2.readLine()) != null) 
			{
				if(log!=0)
				{
					if(log==1)
					{
						if(message.indexOf("frame=")==-1 && message.indexOf("0x0 is invalid")==-1 && message.indexOf("non-existing SPS 0")==-1) 
							System.out.println(threadid+" " +Util.getCurrentDateTime()+":"+message);
						else
						{
							if(log_num<10)
							{
								System.out.println(threadid+" " +Util.getCurrentDateTime()+":"+message);
								log_num ++;
							}
						}
					}
					else
						System.out.println(threadid+" " +Util.getCurrentDateTime()+":"+message);
				}
				//buf2.append(line2+"\r\n");
			}
				
			process1.destroy();

		} catch (IOException e) {
			e.printStackTrace(System.out);
		}
		
		start();
	}
	
	public String getCmd() {
		return cmd;
	}

	public void setCmd(String cmd) {
		this.cmd = cmd;
	}	
	
	public int getLog() {
		return log;
	}

	public void setLog(int log) {
		this.log = log;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}	
}
