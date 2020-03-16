<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.Date,
				java.text.DecimalFormat,
				java.text.SimpleDateFormat,
				java.util.*,
				java.sql.*,
				tidemedia.cms.spider.*,
				java.io.*,
				org.json.*,
				tidemedia.cms.publish.*,
				java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
    public static String cmd1(String[] ss, boolean print) {
	String bufs = "";
	List<String> commend = new java.util.ArrayList<String>();
	ProcessBuilder builder = new ProcessBuilder();
	builder.command(commend);
	builder.redirectErrorStream(true);
	
	for (int i = 0; i < ss.length; i++) {
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
		e.printStackTrace(System.out);
		System.out.println(e.getMessage() + "\r\n cmd:" + commend_desc);
	}	
	return bufs;
}
%>
<%
 String[] ss = {"/bin/sh","-c","uptime|awk '{print $1,$3}'"};
String time = cmd1(ss,false);

String[] times = time.split(" ");
String time1 = times[0].replaceFirst(":","时");
String time2 = time1.replaceFirst(":","分");
time = times[1]+" 天"+time2+"秒";
JSONArray arr = new JSONArray();
arr.put(time);
out.println(arr);

%>






