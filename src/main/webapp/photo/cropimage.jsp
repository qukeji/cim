<%@ page language="java" import="java.util.*,tidemedia.cms.util.*,tidemedia.cms.publish.*, java.io.IOException, java.sql.SQLException,java.util.ArrayList,org.im4java.core.ConvertCmd,
 org.im4java.core.IM4JavaException, org.im4java.core.IMOperation, org.im4java.process.ArrayListOutputConsumer, org.im4java.process.ProcessStarter,java.io.*,
 tidemedia.cms.base.MessageException,org.json.JSONObject,tidemedia.cms.system.*" pageEncoding="utf-8"%>
<%@page import="java.util.regex.Pattern"%>
<%@ include file="../config.jsp"%>
 
 <%!
 public String LogTitle="图片裁剪";
 public String crop(String oldpath,String newpath,String SiteFolder,Site site,String url,int width,int height,int x,int y) {
	       // System.out.println(oldpath+"=="+newpath+"--"+width+"--"+height+"--"+x+"---"+y+"====参数");
		String res ="";
		try{
		String path = FileUtil.getIM4JAVAPath();

		if(path.length()>0) ProcessStarter.setGlobalSearchPath(path);
		ConvertCmd cmd = new ConvertCmd();
		IMOperation op = new IMOperation();
		ArrayListOutputConsumer consumer = new ArrayListOutputConsumer();
		cmd.setOutputConsumer(consumer);
		ArrayList<String> cmdOutput = consumer.getOutput(); 
		op.addImage(oldpath);//原始图片地址 
		/** width：裁剪的宽度 * height：裁剪的高度 * x：裁剪的横坐标 * y：裁剪纵坐标 */ 
		op.crop(width, height, x, y); 
		op.addImage(newpath);//裁剪后图片地址 
		cmd.run(op);
		
        Publish publish = new Publish();
        String path_=Util.ClearPath(newpath.replace(SiteFolder,""));
        res = "{\"success\":true,\"url\":\""+url+path_+"\"}";
        publish.InsertToBePublished(path_,SiteFolder,site);
		PublishManager.getInstance().CopyFileNow();
		}catch(Exception e){
		// System.out.println("--------");
		e.printStackTrace();
		// System.out.println("--------");
		res = "{success:false}";
		}
		return res;
	}
	
	public String DownloadFile(String url) throws MessageException,
			SQLException {

		int transcode_channelid = CmsCache.getParameter(
				"sys_config_photo").getJson().getInt("channelid");
		Channel channel = CmsCache.getChannel(transcode_channelid);
		String Path = channel.getRealImageFolder();
		String SiteFolder = channel.getSite().getSiteFolder();
		String RealPath = SiteFolder + (SiteFolder.endsWith("/") ? "" : "/")
				+ Path;
		String FileName = Util.getFileName(url);// 获取文件名
		String FileExt = Util.getFileExt(FileName);
		CmsFile cmsfile = new CmsFile();
		String NewFileName = cmsfile.getNewFileName(FileName, Path, 0);
		
		boolean downFlag = false ;

		String url2 = channel.getSite().getExternalUrl2();
		if(url.startsWith(url2)){//图片是本地图片，复制到缓存目录
			url = url.replace(url2,SiteFolder);
			downFlag = FileUtil.copyFile(url,RealPath + "/temp/"+NewFileName);
		}else{
			downFlag = Util.downloadFile(url, RealPath + "/temp/"+NewFileName);
		}
		
		if (downFlag) {
			Log.SystemLog(LogTitle, "" + url + "  下载成功");
			return RealPath + "/temp/"+NewFileName;
		} else {
			Log.SystemLog(LogTitle, "" + url + "  下载失败");
			return "";
		}
	}
 %>
 <%
  String callback=getParameter(request,"callback");
  int ChannelID = getIntParameter(request,"ChannelID");
  int  X1 = getIntParameter(request,"X1");
  int Y1 = getIntParameter(request,"Y1");
  int width = getIntParameter(request,"width");
  int height = getIntParameter(request,"height");
  int water_mark = getIntParameter(request,"water_mark");
  int mask_scheme = getIntParameter(request,"mask_scheme");
  String mask_location=getParameter(request,"mask_location");
  String oldImage = getParameter(request,"filepath");
  System.out.println("图片裁剪："+oldImage  +"--"+width+"--"+height+"--"+X1+"---"+Y1);

//图片及图片库配置
Channel channel = null;
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
int sys_channelid_image = photo_config.getInt("channelid");
channel = CmsCache.getChannel(sys_channelid_image);
Site site = channel.getSite();//
String Path = channel.getRealImageFolder();//图片库地址
String SiteUrl = site.getExternalUrl();//图片库预览地址
String SiteFolder = site.getSiteFolder();//图片库目录
String RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;//服务器目录

  String url=channel.getSite().getExternalUrl2();
  int lastIndex = oldImage.lastIndexOf("/");
  String FileName = oldImage.substring(lastIndex+1);
  String oldImagePath=DownloadFile(oldImage);
  String reg = "http://[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\\.?(:[0-9]+)*";
  
  
	CmsFile cmsfile = new CmsFile();
	String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);//新文件名
	String FilePath = RealPath + "/" +NewFileName;
	String newImage = FilePath.replaceAll(reg,SiteFolder);  
	FileUtil.copyFile(oldImagePath, FilePath);//复制图片
  System.out.println("ceshi="+oldImagePath +"=="+newImage +"--");
  String res = crop(FilePath,newImage,SiteFolder,site,url,width,height,X1,Y1);

  if(water_mark==1){
      boolean succ = FileUtil.waterMaskByIm4java(newImage,mask_scheme,mask_location);
      System.out.println("newImage======="+newImage+"           succ"+succ);
  }
//   System.out.println(res);
  out.println(callback+"("+res.toString()+")");
 %>
