<%@ page import="java.sql.*,
				tidemedia.cms.base.*,java.util.*,
				tidemedia.cms.system.*,tidemedia.cms.publish.*,org.apache.commons.net.ftp.*,
				tidemedia.cms.util.*,java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
out.println("begin");
//tidemedia.cms.video.VideoUtil.Transcode("/web/html/video/2011-11-10/201111101320855707342_9.flv","/web/html/video/2011-11-10/201111101320855707342_9.flv",0,0);


String duration = "";
		List<String> commend=new java.util.ArrayList<String>();
		
		 ProcessBuilder builder = new ProcessBuilder();
		
		/*
		commend.add("/tide/bin/ffmpeg");
		commend.add("-y");
		commend.add("-i");
		commend.add("/home/5s.mov");
		commend.add("-i");
		commend.add("/home/logo_1920.png");
		commend.add("-filter_complex");
		commend.add("overlay=20:20,scale='672:trunc(ow/a/2)*2'");
		commend.add("-metadata");
		commend.add("\u7f16\u7801\u8f6f\u4ef6=\"\u6cf0\u5f97\u65b9\u821f\u3000tidecms8.0\"");
		commend.add("-b");
		commend.add("70k");
		commend.add("-ar");
		commend.add("22050");
		commend.add("-vcodec");
		commend.add("libx264");
		//-deinterlace   
		commend.add("/home/5s_1.mp4");
		*/

		//commend.add("/lunbo/test_1023");
		commend.add("/tide/bin/ffmpeg");
		commend.add("-headers");
		commend.add("Referer:http://bbtv.kksmg.com/live/bbtv_zhanwai.html?cid=1620&st=0\r\n");
		commend.add("-y");
		commend.add("-i");
		commend.add("http://live-cdn.kksmg.com/channels/tvie/audio_shdt/flv:fm/live");
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
		out.println("bufs:"+bufs);

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