<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.spider.*,
				java.util.*,
				java.io.*,
				org.json.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.*,
				java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}

public static String cmd1(String[] ss, boolean print) {
	String OS = System.getProperty("os.name").toLowerCase();

	if(OS.indexOf("windows")>=0)
	{
		return "";//windows系统不执行了
	}
	String bufs = "";
	List<String> commend = new java.util.ArrayList<String>();
	ProcessBuilder builder = new ProcessBuilder();
	builder.command(commend);
	builder.redirectErrorStream(true);
	
	for (int i = 0; i < ss.length; i++) {
//			System.out.println("comment:"+ss[i]);
		commend.add(ss[i]);
	}

	String commend_desc = commend.toString().replace(", ", " ");

	try {
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream();
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while ((line2 = br2.readLine()) != null)
			buf2.append(line2);
		bufs = buf2.toString();
		br2.close();
		is2.close();
		process1.destroy();
		if (print)
			System.out.println("bufs:" + bufs);
	} catch (Exception e) {
		//e.printStackTrace(System.out);
		System.out.println(e.getMessage() + "\r\n cmd:" + commend_desc);
	}	
	return bufs;
}

//获取数据库连接数
public String getValue(String sql){

	String value = "" ;
	try{
		TableUtil tu = new TableUtil();
		ResultSet Rs = tu.executeQuery(sql);
		if(Rs.next()) {
			value = Rs.getString("value");
		}
		tu.closeRs(Rs);
	}catch(Exception e) {
		e.printStackTrace();			
	}
	return value ;

} 

%>


<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

JSONObject o = new JSONObject();


//统计数据

//服务器运行时长 uptime|awk '{print $1,$3}'

String[] ss = {"/bin/sh","-c","cat /proc/uptime| awk -F. '{run_days=$1 / 86400;run_hour=($1 % 86400)/3600;run_minute=($1 % 3600)/60;run_second=$1 % 60;printf(\"%d天%d时%d分%d秒\",run_days,run_hour,run_minute,run_second)}'"};
String time = cmd1(ss,false);
//String[] times = time.split(" ");
//String time1 = times[0].replaceFirst(":","时");
//String time2 = time1.replaceFirst(":","分");
//time = times[1]+"天"+time2+"秒";

//cpu使用情况sar 1 1|grep \"Average:\"|awk '{print $3}'
//String[] ss1 = {"/bin/sh","-c","sar 1 1 |grep  -A 1 'user' |tail -n 1 | awk -F ' ' '{print $3}'"};
String[] ss1 = {"/bin/sh","-c","sar 1 1|grep \"Average:\"|awk '{print $3}'"};
String cpu = cmd1(ss1,false)+"%";

//内存使用情况  echo \"100*`free -m|awk '{if(NR!=1) print}'|awk '{if(NR!=2) print $3}'`/`free -m|awk '{if(NR!=1) print}'|awk '{if(NR!=2) print $2}'`\" |bc
String[] ss2 = {"/bin/sh","-c","echo \"`free -m |awk '{if(NR==2){print int($3*100/$2)}}'`\" | bc"};
String free = cmd1(ss2,false)+"%";

//存储使用情况 
//String Filesystem_ = CmsCache.getParameterValue("Filesystem");  df -H|grep '"+Filesystem_+"'|awk '{print $5}'
String disk_folder = CmsCache.getParameter("disk_folder").getContent();
//String[] ss3 = {"/bin/sh","-c","df -h | head -2 | awk '{print $5}' | tail -1"};
String[] ss3 = {"/bin/sh","-c","df -h |grep "+disk_folder+" | head -2 | awk '{print $5}' | tail -1"};
String Filesystem = cmd1(ss3,false);

//模板发布线程使用情况
int template_now = TemplatePublishAgent.getPublishing_thread_number() ;
int template_max = TemplatePublishAgent.getMax_thread_number() ;
//文件发布线程使用情况
int file_now = FilePublishAgent.getCopying_thread_number() ;
int file_max = FilePublishAgent.getMax_thread_number() ;
//数据库连接
String sql = "show variables like 'max_connections'";
String connection_max = getValue(sql);
sql = "show status like 'Threads_connected'";
String connection_now = getValue(sql);

o.put("time", time);
o.put("cpu", cpu);
o.put("free", free);
o.put("Filesystem", Filesystem);
o.put("template_now", template_now);
o.put("template_max", template_max);
o.put("file_now", file_now);
o.put("file_max", file_max);
o.put("connection_now", connection_now);
o.put("connection_max", connection_max);

out.println(o);
%>