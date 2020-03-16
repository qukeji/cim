<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,tidemedia.cms.publish.*,org.apache.commons.net.ftp.*,
				tidemedia.cms.util.*,java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%//@ include file="../config.jsp"%>
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
%>


<%

//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
String filename = "D:\\web\\html3\\caipiaowap\\content\\morenew_10.jsp";
String Directory = "/content/";
     		PublishScheme ps = new PublishScheme(117);
     		if(ps.getId()>0)
     		{
     			if(ps.getCopyMode()==1)//ftp
     			{
     				FTPClient ftp = new FTPClient();
     				if(!ftp.isConnected())
     				{
     					ftp.setDefaultTimeout(40000);			
     					ftp.connect(ps.getServer());
     					ftp.login(ps.getUsername(),ps.getPassword());
						out.println(ps.getUsername()+","+ps.getPassword()+"<br>");
     					ftp.setSoTimeout(40000);
     					ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
						ftp.enterLocalPassiveMode();
     					//ftp.setReaderThread(false);
						String FtpRoot = ftp.printWorkingDirectory();
						System.out.println("connect server:"+ps.getServer());
						out.println("root:"+FtpRoot+"<br>");
		InputStream is = null;
		File file = null;
		try {
			file = new File(filename);
			is = new FileInputStream(file);
		} catch (FileNotFoundException e1) {
			System.out.println(filename+",文件未发现!");
		}
		
		int position = 0;
		
String OnlyFileName = filename.substring(filename.lastIndexOf("\\")+1);
out.println("OnlyFileName:"+OnlyFileName);
		ftp.changeWorkingDirectory(Directory);

		System.out.println("work:"+ftp.printWorkingDirectory());
		if(is!=null)
		{	
OutputStream output;
boolean storefile = ftp.storeFile(OnlyFileName,is);
out.println("storefile:"+storefile);
		}
     				}
     				
      			}
     		}

%><%=Util.FormatDate("yyyy-MM-dd HH:mm:ss",200*1000)%>
<br>Over!