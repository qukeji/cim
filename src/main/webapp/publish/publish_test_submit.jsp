<%@ page import="java.sql.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.PublishScheme,
				java.io.*,
				org.apache.commons.net.ftp.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
//out.println("....");
int siteId = getIntParameter(request,"siteId");
String filepath = getParameter(request,"file");
PublishScheme ps =CmsCache.getPublishScheme(siteId);
String html = "";
//html+="<tr><td align='right' valign='middle'><br>测试结果：</td><td valign='middle'>";
try{
long begin_time = System.currentTimeMillis();

FTPClient ftp = new FTPClient();


if (!ps.getPort().equals(""))
{
	int port = Util.parseInt(ps.getPort());
	ftp.setDefaultPort(port);
 }
ftp.setDefaultTimeout(40000);			
ftp.connect(ps.getServer());
html+="<br>正在连接服务器...";
out.print("连接反馈："+ftp.getReplyString());
boolean f = ftp.login(ps.getUsername(),ps.getPassword());
if(f)
	html+="<br>登录成功.";
else
	html+="<br>登录失败.";

html += " 用时：" + (System.currentTimeMillis()-begin_time) + "ms";

ftp.setBufferSize(4096);//4096比1024*1024速度要快
ftp.setControlKeepAliveTimeout(500); 
ftp.setSoTimeout(40000);
ftp.setFileType(FTPClient.BINARY_FILE_TYPE);
ftp.enterLocalPassiveMode();
String FtpRoot = ftp.printWorkingDirectory();
html+="<br>root目录:"+FtpRoot;
Site site = CmsCache.getSite(ps.getSite());
html+="<br>本地站点目录："+site.getSiteFolder();
String temp = site.getSiteFolder() + "/tidecms_test.html";
if(!filepath.equals(""))
	temp = site.getSiteFolder().concat(filepath);

String filename = Util.ClearPath(temp);
File file = new File(filename);
System.out.println("tide......"+file.exists());
 if(!file.exists()){
	if(filename.endsWith("tidecms_test.html")){
	html+="<br>创建测试文件:"+filename;
	byte[] buf = "TideCMS测试".getBytes();
	FileOutputStream o = new FileOutputStream(file);
	o.write(buf);
	o.close();
	}

}
System.out.println("tide......"+file.exists());
if(file.exists())//文件存在 开始上传测试
{	System.out.println("tide2......");
	html+="<br>上传文件:"+filename;

	InputStream is = new FileInputStream(file);
	String OnlyFileName = filename.substring(filename.lastIndexOf("/")+1);
	html+="<br>文件名:"+OnlyFileName;
	OutputStream output;

	long begin_time2 = System.currentTimeMillis();
	ftp.changeWorkingDirectory("/");
	html+="<br>切换目录，用时:" + (System.currentTimeMillis()-begin_time2) + "ms";
	long starttime = System.currentTimeMillis();	

	boolean storefile = ftp.storeFile(OnlyFileName,is);
	html+="<br>storeFile 用时:" + (System.currentTimeMillis()-begin_time2) + "ms";
	long endtime = System.currentTimeMillis();
	
	/* 测试用 2015-9-14
	starttime = System.currentTimeMillis();
	ftp.setBufferSize(10240);//10k
	File file_ = new File(filename.replace("tidecms_test.html","index_test.shtml"));
	is = new FileInputStream(file_);
	storefile = ftp.storeFile("index_test.shtml",is);
	html+="<br>storeFile2 用时:" + (System.currentTimeMillis()-starttime) + "ms,buffer:10k,size:"+file_.length();

	ftp.setBufferSize(4096);
	starttime = System.currentTimeMillis();
	file_ = new File(filename.replace("tidecms_test.html","index_test.shtml"));
	is = new FileInputStream(file_);
	storefile = ftp.storeFile("index_test.shtml",is);
	html+="<br>storeFile3 用时:" + (System.currentTimeMillis()-starttime) + "ms,buffer:8000,size:"+file_.length();

	ftp.setBufferSize(1024*1024*10);
	starttime = System.currentTimeMillis();
	file_ = new File(filename.replace("tidecms_test.html","news.rar"));
	is = new FileInputStream(file_);
	storefile = ftp.storeFile("news.rar",is);
	html+="<br>storeFile3 用时:" + (System.currentTimeMillis()-starttime) + "ms,buffer:1024*1024*10,size:"+file_.length();

	ftp.setBufferSize(40960);
	starttime = System.currentTimeMillis();
	file_ = new File(filename.replace("tidecms_test.html","news.rar"));
	is = new FileInputStream(file_);
	storefile = ftp.storeFile("news.rar",is);
	html+="<br>storeFile3 用时:" + (System.currentTimeMillis()-starttime) + "ms,buffer:40960,size:"+file_.length();

	starttime = System.currentTimeMillis();
	InputStream inputStream = new FileInputStream(filename.replace("tidecms_test.html","index_test.shtml"));
	OutputStream outputStream = ftp.storeFileStream("index_test.shtml");

	byte[] bytesIn = new byte[4096];
	int read = 0;

	while((read = inputStream.read(bytesIn)) != -1) {
		outputStream.write(bytesIn, 0, read);
	}

	inputStream.close();
	outputStream.close();
	html+="<br>storeFile4 用时:" + (System.currentTimeMillis()-starttime) + "ms";
	*/
	long time = System.currentTimeMillis()- begin_time;

	long size =file.length();
	 System.out.println(size+"=="+time+"=="+endtime+"=="+starttime);
	
	String time_ = "";
	String speed = "";
	if(time>=1000){
		time = time/1000;
		time_ = time + "s";
		long temp1 = size/1024;
		if(temp1>0)
			speed = temp1/time+"k/s";
		 else
			 speed = size/time+"byte/s";
	}
	else
	{
		time_ = time + "ms";
		speed = "极快";
	}

		 //= time>0?size/time+"b/ms":"";	 
	if(storefile)
		html+="<br>上传成功,用时:"+time_+",速度："+speed;
	else
		html+="<br>上传失败";
	 
 }else{
    html +="<br>上传文件："+filename+"不存在";
	html +="<br>上传失败";
}	
ftp.logout();
html+="<br>退出FTP";
}catch(Exception e)
{
	html = e.getMessage();
}
out.println(html);
%>
	
