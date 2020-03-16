<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				java.io.*,
				java.net.*,
				java.sql.*,
				java.util.*,
				magick.*,
				org.json.*,
				java.io.*,
				org.im4java.core.ConvertCmd,
				org.im4java.core.IM4JavaException, 
				org.im4java.core.IMOperation, 
				org.im4java.process.ArrayListOutputConsumer, 
				org.im4java.process.ProcessStarter,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%

int type = getIntParameter(request,"type");
int IsCompress = getIntParameter(request,"IsCompress");
int CompressWidth = getIntParameter(request,"CompressWidth");
int CompressHeight = getIntParameter(request,"CompressHeight");
String  picid = getParameter(request,"picid");//图片库选中图片
int ChannelID = getIntParameter(request,"ChannelID");//当前频道id
Channel channel = CmsCache.getChannel(ChannelID);
String Path = "";
String SiteFolder = "";
String SiteUrl = "";
String RealPath = "";
Site site = null;
//图片及图片库配置
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();
if(photo_config==null&&type==1){out.println("error:图片及图片库没有配置，请联系系统管理员.");return;}
int sys_channelid_image = photo_config.getInt("channelid");
int companyid = userinfo_session.getCompany();//获取租户id
channel = CmsCache.getChannel(sys_channelid_image);
if(sys_channelid_image>0)
{
	//配置了图片库
	channel = CmsCache.getChannel(sys_channelid_image);
	site = channel.getSite();
	Path = channel.getRealImageFolder();
	//按租户分目录
	int upload_by_company = CmsCache.getParameter("upload_by_company").getIntValue();
	if(upload_by_company==1&&companyid!=0){
		Path = "/"+companyid+Path;
	}
	SiteUrl = site.getExternalUrl();
}
else
{
	Path = channel.getRealImageFolder();
	site = channel.getSite();
	SiteUrl = site.getUrl();
}
SiteFolder = site.getSiteFolder();//图片库目录
RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;//服务器目录


String html = "";
JSONObject data = new JSONObject();
if(picid.length()==0||picid.equals("undefined")){
	return;
}

String[] gid_ = picid.split(",");
for(int i=0;i<gid_.length;i++){
	int gid = Util.parseInt(gid_[i]);
	Document doc = new Document(gid);
	String photoPath = doc.getValue("Photo");
	System.out.println("photoPath==="+photoPath);
	String photoRealPath = "";
	System.out.println("SiteUrl==="+SiteUrl);
	System.out.println("SiteFolder==="+SiteFolder);
	if(!photoPath.startsWith("http")){
		photoRealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/")+photoPath;
	}else{
		photoRealPath = photoPath.replace(SiteUrl,SiteFolder);
	}
	System.out.println("photoRealPath==="+photoRealPath);
	String FileName = photoRealPath.substring(photoRealPath.lastIndexOf("/")+1);//文件名
	String FileExt = photoRealPath.substring(photoRealPath.lastIndexOf(".")+1);//文件扩展名

	CmsFile cmsfile = new CmsFile();
	String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);//新文件名
	String FilePath = RealPath + "/" +NewFileName;

	FileUtil.copyFile(photoRealPath, FilePath);//复制图片
	
	String compressFile = FilePath.replace("."+FileExt,"_s."+FileExt);//压缩文件名
	if(IsCompress==1){
		FileUtil.compressImage2IM(FilePath,compressFile,CompressWidth,CompressHeight,0);
		File uploadedFile = new File(FilePath);
		uploadedFile.delete();
		data.put("filename", Path+NewFileName.replace("."+FileExt,"_s."+FileExt));
		html += "<p style=\"text-align:center\"><img src=\""+SiteUrl+Path+NewFileName.replace("."+FileExt,"_s."+FileExt)+"\" border=\"0\" alt=\"\" /></p>";
	}else{
		data.put("filename", Path+NewFileName);
		html += "<p style=\"text-align:center\"><img src=\""+SiteUrl+Path+NewFileName+"\" border=\"0\" alt=\"\" /></p>";
	}
	
	
}
if(type==1){
	//System.out.println("html==="+html);
	out.println(html);
}else{
	out.println(data.toString());
}
%>



