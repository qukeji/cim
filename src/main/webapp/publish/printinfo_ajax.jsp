<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.PublishScheme,
				java.io.*,
				org.apache.commons.net.ftp.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//禁止编辑发布方案
if(userinfo_session.hasPermission("DisableEditPublishScheme"))
{	out.close();return;}

int id = getIntParameter(request,"id");
int function  = getIntParameter(request,"function");
String docname	= getParameter(request,"filename");
/*
	function  0:测试登陆 1：测试上传文件 2：删除远程服务器上的该文件
*/
PublishScheme ps =CmsCache.getPublishScheme(id);

FTPClient ftp = new FTPClient();
if(function!=0){
	long  t1 =  System.currentTimeMillis();
	ftp.setDefaultTimeout(40000);			
	ftp.connect(ps.getServer());
	if(function==1){
		out.println("<br>正在连接服务器...");
		out.print("<br>连接反馈："+ftp.getReplyString());
	}
	
	boolean f = ftp.login(ps.getUsername(),ps.getPassword());
	if(f){
		out.println("<br>登录成功.");
	}else{
		out.println("<br>登录失败.");

	}
	if(function==1 && f){
		ftp.logout();
		long  t2 =  System.currentTimeMillis();
		long t = t2-t1;
		out.println("<br>登陆所用的总时间 "+(t*0.001)+" 秒");
		
	}
	if(function==2 && f){
		ftp.setSoTimeout(40000);
		ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
		ftp.enterLocalPassiveMode();
		Site site = CmsCache.getSite(ps.getSite());
		String filename = Util.ClearPath(site.getSiteFolder()+docname);
		File file = new File(filename);
		if(!file.exists()){
			out.println("<br>测试文件不存在");
			ftp.logout();
		}else{
			String FtpRoot = ftp.printWorkingDirectory();
			out.println("<br>root目录:"+FtpRoot);
			out.println("<br>本地站点目录："+site.getSiteFolder());
			String includeFolders = ps.getIncludeFolders();
			double size=0;
			size=file.length()/1000;
			
			if((file.length()%1000)==0){
				size = size;
			}else{
				size=size+1.0;
			}
			/*if(!file.exists())
			{
				out.println("<br>创建测试文件:"+filename);
				byte[] buf = "TideCMS测试".getBytes();
				FileOutputStream o = new FileOutputStream(file);
				o.write(buf);
				o.close();
			}*/
			out.println("<br>上传文件:"+filename);
			InputStream is = new FileInputStream(file);
			String OnlyFileName = filename.substring(filename.lastIndexOf("/")+1);
			out.println("<br>文件名:"+OnlyFileName);
			OutputStream output;
			String RemoteFolder = ps.getRemoteFolder();
			ftp.changeWorkingDirectory(FtpRoot+RemoteFolder);
			boolean storefile = ftp.storeFile(OnlyFileName,is);
			if(storefile)
				out.println("<br>上传成功");
			else
				out.println("<br>上传失败");
			ftp.logout();
			long  t2 =  System.currentTimeMillis();
			long t = t2-t1;
			double speed = 0.0;
			out.println("<br>上传所用的总时间 "+(t*0.001)+" 秒");
			out.println("<br>文件大小 "+size+" kb");
			double j = (double)Math.round(size/(t*0.001))*100/100.0;
			out.println("<br>上传速度 "+j+" kb/s");
		}
	}
	if(function==3 && f){

		ftp.setSoTimeout(40000);
		ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
		ftp.enterLocalPassiveMode();
		String FtpRoot = ftp.printWorkingDirectory();
		Site site = CmsCache.getSite(ps.getSite());	
		String includeFolders = ps.getIncludeFolders();
		String RemoteFolder = ps.getRemoteFolder();
		String filename = Util.ClearPath(FtpRoot+RemoteFolder+docname);
		ftp.changeWorkingDirectory(FtpRoot+RemoteFolder);
		String OnlyFileName = filename.substring(filename.lastIndexOf("/")+1);
		boolean isdelete = ftp.deleteFile(OnlyFileName);
		if(isdelete){
			out.println("<br>删除 \""+filename+"\" 成功");
			long  t2 =  System.currentTimeMillis();
			long  t = t2-t1;
			out.println("<br>删除所用的总时间 "+(t*0.001)+" 秒");
				
		}else{
			out.println("<br>删除失败,文件可能不存在");
		}
		ftp.logout();
	}
}else{
	
}


%>