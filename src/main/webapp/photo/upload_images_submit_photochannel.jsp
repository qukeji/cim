<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				java.util.*,
				java.sql.*,
				org.json.*,
				magick.*,
				java.io.File,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
/**
 *		修改人		日期		备注
 *		郭庆光		20150129	图片库频道列表页频道批量上传图片
 *
 */
public int getIntParameter(String tempstr)
{
	if(tempstr.equals(""))
		return 0;
	else
		return Integer.valueOf(tempstr).intValue();
}

public String getParameter(String tempstr)
{
	if(tempstr==null)
		return "";
	else
		return tempstr;
}
%>
<%
DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FolderName		= "";
String fieldname2		= "";
String ReturnValue		= "";
String ReturnValue2		= "";
String Type				= "";
String Watermark		= "";
String Client			= "";
String mask_location	= "";
int ChannelID			= 0;
int Width				= 0;
int Height				= 0;
int CompressWidth		= 0;
int	CompressHeight		= 0;
int IsCompress			=0;//是否压缩
int UseCompress			=0;//是否使用压缩后图片
int parentGlobalID		=0;//parent的globalid
int fieldgroup			=0;


String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;

tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();

tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);

java.util.List items;

//try{
items = upload.parseRequest(request);
//}
//catch(org.apache.commons.fileupload.FileUploadException e){}

java.util.Iterator iter = items.iterator();
//
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (item.isFormField()) {
		String FieldName = item.getFieldName();
		//
		if(FieldName.equals("ChannelID"))
			ChannelID = getIntParameter(item.getString());
		else if(FieldName.equals("parentGlobalID"))
			parentGlobalID = getIntParameter(item.getString());
		else if(FieldName.equals("fieldgroup"))
			fieldgroup = getIntParameter(item.getString());
		else if(FieldName.equals("Type"))
			Type = getParameter(item.getString());
		else if(FieldName.equals("Watermark"))
			Watermark = getParameter(item.getString());
		if(FieldName.equals("mask_location"))
			mask_location = getParameter(item.getString());
		else if(FieldName.equals("IsCompress"))
			IsCompress = getIntParameter(item.getString());
		else if(FieldName.equals("UseCompress"))
			UseCompress = getIntParameter(item.getString());
		else if(FieldName.equals("Width"))
			Width = getIntParameter(item.getString());
		else if(FieldName.equals("Height"))
			Height = getIntParameter(item.getString());
		else if(FieldName.equals("Client"))
			Client = getParameter(item.getString());
		else if(FieldName.equals("fieldname"))
			fieldname2 = getParameter(item.getString());
		else if(FieldName.equals("browser"))
			browser = item.getString();
		else if(FieldName.equals("Username"))
			Username = item.getString();
		else if(FieldName.equals("Password"))
			Password = item.getString();
    } 
}

//

tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
if(browser.equals("msie")){
	if(session.getAttribute("CMSUserInfo")!=null)
	{
		userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
	}
	if(userinfo_session!=null && userinfo_session.getId()!=0)
	{
		isCan=true;
	}
}else if(browser.equals("mozilla")){
	TableUtil tu=new TableUtil("user");
	String Sql = "select * from userinfo where Username='" +tu.SQLQuote(Username) + "' and Password='" +tu.SQLQuote(Password) + "'";
	ResultSet Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		userinfo_session.setId(Rs.getInt("id"));
		isCan=true;
	}
	tu.closeRs(Rs);
}

//

if(isCan){
HashMap field_photo = new HashMap();
String sys_config_photo_gallery = CmsCache.getParameterValue("sys_config_photo_gallery_photochannel");
try{
JSONObject o = new JSONObject(sys_config_photo_gallery);
JSONArray global = o.getJSONArray("global");
for(int i =0;i<global.length();i++)
{
	JSONObject oo = global.getJSONObject(i);
	//
	field_photo.put(oo.getString("field"),new String[]{oo.getString("width"),oo.getString("height")});
}
}catch(Exception e){}

Channel channel = CmsCache.getChannel(ChannelID);
Site site = null;
String Path = "";
boolean need_httpurl = true;
int force_httpurl = 0;
String RealPath = "";
String SiteFolder = "";
String SiteUrl = "";
int companyid = userinfo_session.getCompany();//租户id
//把图片库频道编号的配置移到sys_config_photo中了，废除sys_channelid_photo 2012-10-12
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
int sys_channelid_image = photo_config.getInt("channelid");
force_httpurl = photo_config.getInt("force_httpurl");

//int sys_channelid_image = CmsCache.getParameter("sys_channelid_photo").getIntValue();
if(sys_channelid_image>0)
{
	//配置了图片库
	Channel channel2 = CmsCache.getChannel(ChannelID);
	channel = CmsCache.getChannel(sys_channelid_image);
	site = channel.getSite();
	Path = channel.getRealImageFolder();
	SiteUrl = site.getExternalUrl();
	if(channel2.getSiteID()==channel.getSiteID() && force_httpurl==0)
	{
		need_httpurl = false;
	}
}
else
{
	Path = channel.getRealImageFolder();
	site = channel.getSite();
	SiteUrl = site.getUrl();
}
SiteFolder = site.getSiteFolder();
RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;
//

	File file = new File(RealPath);
	if(!file.exists())
		file.mkdirs();

iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (!item.isFormField()) {
		String FieldName = item.getFieldName();
		String FileName = item.getName();
		String FileExt = "";

		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);

		int index = FileName.lastIndexOf(".");
		if(index!=-1)
		{
			FileExt = FileName.substring(index+1);
		}

		if(!FileName.equals(""))
		{
			Publish publish = new Publish();
			CmsFile cmsfile = new CmsFile();
			String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);

			String FilePath = RealPath + "/" +NewFileName;
		    File uploadedFile = new File(FilePath);
		    item.write(uploadedFile);

			FileUtil.optimizeImage(FilePath);
			uploadedFile = new File(FilePath);

			String photo = Util.ClearPath((need_httpurl?SiteUrl:"") + Path + "/" + NewFileName);
			publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName),SiteFolder,site);
			//ReturnValue.replace("//","/");

			String FileFullPath = Util.ClearPath(SiteUrl + Path + "/" + NewFileName);
			

			
			String[] s1 = (String[])field_photo.get("Photo_b");//大图
			String[] s2 = (String[])field_photo.get("Photo_s");//小图
			String[] s3 = (String[])field_photo.get("Photo_m");//中图

			int w,h;
			String photo_s = "";
			String photo_m = "";
			String photo_b = "";
			
			if(s1!=null)
			{
				w = Util.parseInt(s1[0]);
				h = Util.parseInt(s1[1]);
				
				String NewFileName1 = NewFileName.replace(".","_b.");
				String compressFile1 = RealPath + "/" +NewFileName1;
				
				FileUtil.compressImage2IM(RealPath + "/" +NewFileName,compressFile1,w,h,1);
				//if(Type.equals("Image")){
				if(Watermark.equals("Yes"))
					  FileUtil.waterMaskByIm4java(compressFile1,mask_location);
			   // }
				photo_b = Util.ClearPath((need_httpurl?SiteUrl:"") + Path + "/" + NewFileName1);
				publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName1),SiteFolder,site);
			}

			if(s2!=null)
			{
				w = Util.parseInt(s2[0]);
				h = Util.parseInt(s2[1]);
				//
				String NewFileName2 = NewFileName.replace(".","_s.");
				String compressFile2 = RealPath + "/" +NewFileName2;
				FileUtil.compressImage2IM(RealPath + "/" +NewFileName,compressFile2,w,h,1);
				photo_s = Util.ClearPath((need_httpurl?SiteUrl:"") + Path + "/" + NewFileName2);
				publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName2),SiteFolder,site);
			}

			if(s3!=null)
			{
				w = Util.parseInt(s3[0]);
				h = Util.parseInt(s3[1]);
				//
				String NewFileName2 = NewFileName.replace(".","_m.");
				String compressFile2 = RealPath + "/" +NewFileName2;
				FileUtil.compressImage2IM(RealPath + "/" +NewFileName,compressFile2,w,h,1);
				photo_m = Util.ClearPath((need_httpurl?SiteUrl:"") + Path + "/" + NewFileName2);
				publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName2),SiteFolder,site);
			}
			long FileSize = uploadedFile.length();

			//if(s1!=null) uploadedFile.delete();

			ReturnValue = Util.ClearPath(Path + "/" + NewFileName);

			HashMap map = new HashMap();
			map.put("Title",FileName);
			map.put("Content","");
			map.put("Status","1");
			map.put("Parent",parentGlobalID+"");
			map.put("Photo",photo);
			map.put("Filesize",FileSize+"");
			if(companyid != 0){
				map.put("companyid",companyid+"");
			}
			map.put("User",userinfo_session.getId()+"");
			if(s1!=null)	map.put("Photo_b",photo_b);
			if(s2!=null)	map.put("Photo_s",photo_s);
			if(s3!=null)	map.put("Photo_m",photo_m);

			//
			ItemUtil util = new ItemUtil();
			int gid = util.addItemGetGlobalID(ChannelID,map);

			//发布
			publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName),SiteFolder,site);
			PublishManager.getInstance().CopyFileNow();
		}
//		}
    } 
}
//
%>
top.TideDialogClose({refresh:'right'});
<%}else{System.out.println("上传失败");%>
	alert('上传失败,请重试!');
<%}%>
