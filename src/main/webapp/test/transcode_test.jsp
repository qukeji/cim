<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,java.util.*,java.io.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
		String videofile = "\\\\SVCTAG-GT5BT2X\\video\\vv\\html4pub\\sns\\video_original\\4bfdd6ae37b81_1274926766_20010.avi";
		String video_dest = "\\\\SVCTAG-GT5BT2X\\video\\vv\\html4pub\\sns\\video_original\\4bfdd6ae37b81_1274926766_20010.flv";
		Parameter p = CmsCache.getParameter("sys_ffmpeg");
		
		ProcessBuilder builder = new ProcessBuilder();
		List<String> commend=new java.util.ArrayList<String>();
		commend.add(p.getContent());
		commend.add("-i");
		commend.add(videofile);
		commend.add("-ab");
		commend.add("56");
		commend.add("-ar");
		commend.add("22050");
		commend.add("-b");
		commend.add("1200");
		commend.add("-r");
		commend.add("25");
		commend.add("-s");
		commend.add("720*576");
		commend.add(video_dest);
		builder.command(commend);
		builder.redirectErrorStream(true);
		StringBuilder buf = new StringBuilder(); // 保存ffmpeg的输出结果流
		try {

			Process process = builder.start();
			InputStream is = process.getInputStream(); // 获取ffmpeg进程的输出流
			BufferedReader br = new BufferedReader(new InputStreamReader(is)); // 缓冲读入
			String line = null;
			while((line = br.readLine()) != null) 
			{
				buf.append(line); // 循环等待ffmpeg进程结束	
				System.out.println(line);
			}
			//System.out.println(buf);
			
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("ffmpeg输出内容为：" + buf);
		}
		
%>