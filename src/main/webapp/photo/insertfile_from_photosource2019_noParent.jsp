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


int parentGlobalID = getIntParameter(request,"parentGlobalID");
String  picid = getParameter(request,"picid");//图片库选中图片
int ChannelID = getIntParameter(request,"ChannelID");//当前频道id

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
String html = "";
JSONObject data = new JSONObject();
if(picid.length()==0||picid.equals("undefined")){
	return;
}

HashMap field_photo = new HashMap();
String sys_config_photo_gallery = CmsCache.getParameterValue("sys_config_photo_gallery");
JSONObject o = new JSONObject(sys_config_photo_gallery);
JSONArray global = o.getJSONArray("global");
for(int i =0;i<global.length();i++)
{
	JSONObject oo = global.getJSONObject(i);
	//System.out.println(oo.getString("field"));
	field_photo.put(oo.getString("field"),new String[]{oo.getString("width"),oo.getString("height")});
}



String[] gid_ = picid.split(",");
for(int i=0;i<gid_.length;i++){
	int gid = Util.parseInt(gid_[i]);
	Document doc = new Document(gid);
	String photoPath = doc.getValue("Photo");
	String photoRealPath = "";
	if(!photoPath.startsWith("http")){
		photoRealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/")+photoPath;
	}else{
		photoRealPath = photoPath.replace(SiteUrl,SiteFolder);
	}
	String FileName = photoRealPath.substring(photoRealPath.lastIndexOf("/")+1);//文件名
	String FileExt = photoRealPath.substring(photoRealPath.lastIndexOf(".")+1);//文件扩展名
	CmsFile cmsfile = new CmsFile();
	Publish publish = new Publish();
	String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);//新文件名
	String FilePath = RealPath + "/" +NewFileName;
	FileUtil.copyFile(photoRealPath, FilePath);//复制图片
	File uploadedFile = new File(FilePath);
	long filesize = uploadedFile.length();
	
	

	HashMap map = new HashMap();
	map.put("Title",NewFileName);
	map.put("Filesize",filesize+"");
	map.put("Content","");
	map.put("Status","1");
	map.put("Parent",parentGlobalID+"");
	map.put("Photo", Path + "/" +NewFileName);
	//System.out.println("Photo:"+photo+",Photo_m:"+photo_m+",Photo_s:"+photo_s);
	ItemUtil util = new ItemUtil();
	int glid = util.addItemGetGlobalID(sys_channelid_image,map);
	//发布
	publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName),SiteFolder,site);
}
out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
%>



