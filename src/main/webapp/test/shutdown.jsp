<%@ page import="java.sql.*,java.util.*,java.io.*,
				tidemedia.cms.publish.PublishScheme,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.util.Util"%><%@ page contentType="text/html;charset=utf-8" %>
<%
StringBuffer cmdout = new StringBuffer(); 

String cmd = "";
cmd = "sudo /tomcat/bin/shutdown.sh";
cmd = "shutdown now";

Process process = Runtime.getRuntime().exec(cmd);     //执行一个系统命令
InputStream fis = process.getInputStream();
BufferedReader br = new BufferedReader(new InputStreamReader(fis));
String line = null;

while ((line = br.readLine()) != null) {
    cmdout.append(line).append(System.getProperty("line.separator")).append("<br>");
}
                
out.println("执行系统命令后的结果为：\n<br>" + cmdout.toString()); 
//new TableUtil().executeUpdate("truncate table channel_s3_a_g");
		%>
