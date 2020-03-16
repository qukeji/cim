<%@ page import="java.sql.*,
				tidemedia.cms.base.*,java.util.*,
				tidemedia.cms.system.*,tidemedia.cms.publish.*,org.apache.commons.net.ftp.*,
				org.apache.commons.io.*,org.json.*,
				tidemedia.cms.util.*,java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
	public String cmd(String s,boolean print)
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
		
		try{
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream(); 
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while((line2 = br2.readLine()) != null) buf2.append(line2+"\r\n");
			String bufs = buf2.toString();
			
			process1.destroy();
			if(print)System.out.println("\r\nbufs:"+bufs);	
		}catch(Exception e){			
			e.printStackTrace(System.out);
			System.out.println(e.getMessage());
		}
		
		System.out.println("\r\n"+Util.getCurrentDate("yyyy-MM-dd HH:mm:ss")+","+(System.currentTimeMillis()-begin)+","+commend_desc+"\r\n");
		
		return "";
	}

	public ArrayList<Integer> getKeyframe(String videofile)
	{
		videofile = "\\\\tomcat_ceshi\\\\webapps\\\\cms\\\\test2\\\\total.ts";
		String duration = "";
		List<String> c=new java.util.ArrayList<String>();
		long begin = System.currentTimeMillis();
		ProcessBuilder builder = new ProcessBuilder();
		 
		c.add("/usr/bin/ffprobe");
		//c.add("E:/video/ffprobe");
		c.add("-show_frames");
		c.add("-f");
		c.add("lavfi");
		c.add("\"movie="+videofile+",select=gt(scene\\,0.3)\"");
		c.add("-show_frames");
		c.add("-print_format");
		c.add("json=c=1");
		//c.add(videofile);

		builder.command(c);
		builder.redirectErrorStream(true);
		String bufs = "";
		String commend_desc = c.toString().replace(", ", " ");
		System.out.println(commend_desc);
		ArrayList<Integer> keyframes = new ArrayList<Integer>();
		try{
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream(); 
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		
		String s = "pkt_dts_time\": \"";
		while((line2 = br2.readLine()) != null)
		{System.out.println(line2);
			//"pkt_dts_time": "450.510989"
			if(line2.contains("\"key_frame\": 1"))
			{
				int m = line2.indexOf(s);
				if(m!=-1)
				{
					String line3 = line2.substring(m+s.length());
					int n = line3.indexOf("\"");
					if(n!=-1)
						line3 = line3.substring(0,n);
					//System.out.println(line3);
					int l = (int)(Util.parseFloat(line3)*1000);
					keyframes.add(l);
				}
				
				//buf2.append(line2+"\r\n");
			}
		}
		
		bufs = buf2.toString();
		

		}catch(Exception e){
			System.out.println(e.getMessage());
			e.printStackTrace(System.out);

		}
		System.out.println("keyframe:"+videofile+",time:"+(System.currentTimeMillis()-begin));
		return keyframes;
	}
%>
<%
out.println("begin");
//tidemedia.cms.video.VideoUtil.Transcode("/web/html/video/2011-11-10/201111101320855707342_9.flv","/web/html/video/2011-11-10/201111101320855707342_9.flv",0,0);


String duration = "";
		
		
		for(int i = 0;i<7;i++)
		{
			String file = "/tomcat_ceshi/webapps/cms/test2/183"+(i+3)+".mp4";
			String file_ts = "/tomcat_ceshi/webapps/cms/test2/183"+(i+3)+".ts";
			String s = "/usr/bin/ffmpeg -y -i "+file+" -f mpegts -copyinkf -acodec copy -vcodec copy -vbsf h264_mp4toannexb "+file_ts;
			//cmd(s,false);
		}

		String target_file = "/tomcat_ceshi/webapps/cms/test2/total.ts";
		String tss = "";
	    for(int i = 0;i<7;i++)
	    {
	    	String name = "/tomcat_ceshi/webapps/cms/test2/183"+(i+3)+".ts"; 
	    	tss += (tss.length()>0?"|":"") + Util.ClearPath(name);
	    }
	    String cmd = "/usr/bin/ffmpeg -y -i concat:"+tss+" -copyinkf -acodec copy -vcodec copy " + target_file;

	    //cmd(cmd,false);

		///usr/bin/ffmpeg -i /tomcat_ceshi/webapps/cms/test2/total.ts -vf "select=gt(scene\,0.6),scale=640:360" -vsync vfr /tomcat_ceshi/webapps/cms/test2/total%03d.jpg
		cmd = "/usr/bin/ffmpeg -i "+target_file+" -filter_complex 'select=gt(scene,0.6),scale=640:360' -vsync vfr total%03d.jpg";
		//cmd(cmd,true);
		
		///tomcat_ceshi/webapps/cms/test2/
		cmd = "/usr/bin/ffprobe -show_frames -f lavfi -i 'movie=/tomcat_ceshi/webapps/cms/test2/total.ts,select=gt(scene\\,0.3)' -show_frames -print_format json=c=1";
		//cmd(cmd,true);

		String input = FileUtils.readFileToString(new File("/tomcat_ceshi/webapps/cms/test2/total.json"), "UTF-8");
		JSONObject jsonObject = new JSONObject(input);
		JSONArray jsonArray = jsonObject.getJSONArray("");
		out.println(input);

		//ArrayList frames = getKeyframe(target_file);
		//out.println("frames:"+frames.size());
		/*
		ProcessBuilder builder = new ProcessBuilder();
		
		//commend.add("/lunbo/test_1023");
		commend.add("/usr/bin/ffmpeg");
		commend.add("-i");
		commend.add("ahttp://live-cdn.kksmg.com/channels/tvie/audio_shdt/flv:fm/live");
//-i /home/logo_1920.png -filter_complex \"overlay=20:20,scale='672:trunc(ow/a/2)*2'\" 
		builder.command(commend);
		builder.redirectErrorStream(true);
		
		String commend_desc = commend.toString().replace(",", " ");
		out.println(commend_desc+"<br>");

		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream(); 
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while((line2 = br2.readLine()) != null) 
		{
			System.out.println(line2);
			buf2.append(line2+"<br>");
		}
		
		String bufs = buf2.toString();
		out.println("bufs:"+bufs);*/

/*
ProcessBuilder builder = new ProcessBuilder();
		java.util.List<String> commend=new java.util.ArrayList<String>();
		commend.add("/usr/bin/ffmpeg");
		commend.add("-y");
commend.add("-i");
commend.add("/web/html/video/2011-11-10/201111101320855707342_9.flv");
commend.add("-b");
commend.add("1047k");
commend.add("-ar");
commend.add("22050");
commend.add("-vcodec");
commend.add("libx264");
		commend.add("-metadata");
		String s = "编码软件";
		String ss = "";
		char[] c = s.toCharArray();
		for(char tmp:c)
		{
			ss += ("\\u" + Integer.toHexString(tmp));
		}
		s = "泰得方舟　";
		String sss = "";
		c = s.toCharArray();
		for(char tmp:c)
		{
			sss += ("\\u" + Integer.toHexString(tmp));
		}
		commend.add(ss+"=\""+sss+"tidecms8.0\"");
commend.add("/web/html/video/2011-11-9/20111191320853551745_9_3.flv");
		builder.command(commend);
		builder.redirectErrorStream(true);
		
		//System.out.println("commend:"+commend.toString());
		
		StringBuilder buf = new StringBuilder(); 
Process process = builder.start();
			InputStream is = process.getInputStream(); // 获取ffmpeg进程的输出流
			BufferedReader br = new BufferedReader(new InputStreamReader(is)); // 缓冲读入
			String line = null;
			int duration = 0;
			int current = 0;
			int progress = 0;
			while((line = br.readLine()) != null) 
			{
				out.println(line);
			}
*/
%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!