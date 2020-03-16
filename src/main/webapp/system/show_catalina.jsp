<%@ page import="org.apache.axis.client.*,tidemedia.cms.base.*,java.sql.*,tidemedia.cms.system.*,java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String	FileName		= getParameter(request,"FileName");
String  log_path = CmsCache.getParameterValue("tomcat_log");

if(log_path.length()==0)//如果没有指定目录，使用默认的
{
	String s = (request.getRealPath("/"));
	int ii = s.indexOf("webapps");
	if(ii!=-1)
	{
		String s2 = s.substring(0,ii);
		s2 = s2 + "/logs/";
		log_path = s2;
	}
}

if(FileName.contains("..") || log_path.contains(".."))
{ response.sendRedirect("../noperm.jsp");return;}

if(FileName.equals(""))
{
	File file = new File(log_path);

	if(file.exists())
	{
		File[] files = file.listFiles();

		java.util.Arrays.sort(files,new java.util.Comparator(){   
			  public int compare(Object o1,   Object o2)   {   
				  File f1 = (File)o1;File   f2   =   (File)o2;
				   long diff = f2.lastModified() - f1.lastModified();
				   if (diff > 0)
					  return 1;
				   else if (diff == 0)
					  return 0;
				   else
					  return -1;  
		}});

		out.println("日志目录："+log_path+"<br>");
		for(int i = 0;i<files.length;i++)
		{
			out.println("<a href='show_catalina.jsp?FileName="+files[i].getName()+"'>"+files[i].getName()+"</a><br>");
		}
	}
	else
	{
		out.println("日志目录不存在，请设置好tomcat_log参数");
	}
}
else
{
	String log_file = log_path + "/" + FileName;
	out.println(log_file+"<br>");
	RandomAccessFile raf = new RandomAccessFile(log_file, "r");  
	long len = raf.length();  
	String lastLine = ""; 
	int line_num = 0;
	if (len != 0L) {  
	  long pos = len - 1;  
	  while (pos > 0) {   
		pos--;  
		raf.seek(pos);  
		if (raf.readByte() == '\n') {  
		  String line = raf.readLine();
		  line = new String(line.getBytes("iso8859-1"),"utf-8");
		  lastLine = line+"<br>\r\n" + lastLine; 
		  line_num++;
		  if(line_num>500)  break;  
		}  
	  }  
	}  
	raf.close();  
	out.println(lastLine);
}
%>