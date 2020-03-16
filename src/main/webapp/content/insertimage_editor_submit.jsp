<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				java.sql.*,
				java.util.*,
				java.io.File,
				magick.*,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
public int getIntParameter(String tempstr)
{
	if(tempstr.equals(""))
		return 0;
	else
		return Integer.valueOf(tempstr).intValue();
}
%>
<% 
/**
* 1,胡翔 2019/8/6 修改  上传图片时同时将companyid入库
*/
//编辑器中上传图片的调用程序
DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FolderName		= "";
String ReturnValue		= "";
String Thumbnail		= "";
String keepbig			= "";
String Watermark		= "";
String mask_location	= "";
String sharpen			= "";
String Client			= "";
String sourceType		= "";

String txtLnkUrl		= "";
String cmbLnkTarget		= "";
String cmbAlign			= "";

int ChannelID			= 0;
int txtWidth		= 0;
int txtHeight		= 0;
int	txtBorder		= 0;
int txtHSpace		= 0;
int txtVSpace		= 0;
int mask_scheme = 0;
String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;

tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);

System.setProperty("jmagick.systemclassloader","no");

java.util.List items = upload.parseRequest(request);

java.util.Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (item.isFormField()) {
		String FieldName = item.getFieldName();
		if(FieldName.equals("ChannelID"))
			ChannelID = getIntParameter(item.getString());
		if(FieldName.equals("Thumbnail"))
			Thumbnail = item.getString();
		if(FieldName.equals("keepbig"))
			keepbig = item.getString();
		if(FieldName.equals("Watermark"))
			Watermark = item.getString();
		if(FieldName.equals("mask_location"))
			mask_location = item.getString();
		if(FieldName.equals("sharpen"))
			sharpen = item.getString();
		if(FieldName.equals("txtWidth"))
			txtWidth = getIntParameter(item.getString());
		if(FieldName.equals("txtHeight"))
			txtHeight = getIntParameter(item.getString());
		if(FieldName.equals("txtBorder"))
			txtBorder = getIntParameter(item.getString());
		if(FieldName.equals("txtHSpace"))
			txtHSpace = getIntParameter(item.getString());
		if(FieldName.equals("txtVSpace"))
			txtVSpace = getIntParameter(item.getString());
		if(FieldName.equals("txtLnkUrl"))
			txtLnkUrl = (item.getString());
		if(FieldName.equals("cmbLnkTarget"))
			cmbLnkTarget = (item.getString());
		if(FieldName.equals("cmbAlign"))
			cmbAlign = (item.getString());
		if(FieldName.equals("Client"))
			Client = (item.getString());
		else if(FieldName.equals("browser"))
			browser = item.getString();
		else if(FieldName.equals("Username"))
			Username = item.getString();
		else if(FieldName.equals("Password"))
			Password = item.getString();
		else if(FieldName.equals("mask_scheme"))
			mask_scheme = getIntParameter(item.getString());
		//if(FieldName.equals("sourceType"))
		//	sourceType = getIntParameter(item.getString());
    } 
}
System.out.println("Watermark="+Watermark+",mask_location="+mask_location+",mask_scheme="+mask_scheme);
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

Channel channel = null;
Site site = null;
boolean need_httpurl = true;
int force_httpurl = 0;
String RealPath = "";
String SiteUrl = "";
String Path = "";
//int sys_channelid_image = CmsCache.getParameter("sys_channelid_photo").getIntValue();
//把图片库频道编号的配置移到sys_config_photo中了，废除sys_channelid_photo 2012-10-12
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
if(photo_config==null){out.println("error:图片及图片库没有配置，请联系系统管理员.");return;}
int sys_channelid_image = photo_config.getInt("channelid");
force_httpurl = photo_config.getInt("force_httpurl");

int companyid = userinfo_session.getCompany();
if(sys_channelid_image>0)
{
	Channel channel2 = CmsCache.getChannel(ChannelID);
	channel = CmsCache.getChannel(sys_channelid_image);
	 Path = channel.getRealImageFolder();
	//按租户分目录
	 int upload_by_company = CmsCache.getParameter("upload_by_company").getIntValue();
	 if(upload_by_company==1&&companyid!=0){
	 	Path ="/"+ companyid+Path;
	 }
	site = channel.getSite();
	//SiteUrl = site.getExternalUrl();
	SiteUrl = site.getUrl();//编辑器图片地址改为内网地址
	if(channel2.getSiteID()==channel.getSiteID() && force_httpurl==0)
	{
		need_httpurl = false;
	}
}
else
{
	channel = CmsCache.getChannel(ChannelID);
	site = channel.getSite();
	SiteUrl = site.getUrl();
	 Path = channel.getRealImageFolder();
}
 


String SiteFolder = site.getSiteFolder();
//String RealPath = application.getRealPath(Path);

RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;

File file = new File(RealPath);
if(!file.exists())
	file.mkdirs();

	//System.out.println(ChannelID+"::"+RealPath+"::"+Path);
	String Photo = "";

iter = items.iterator();

try{
while (isCan && iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (!item.isFormField()) {
		String FieldName = item.getFieldName();
		String FileName = item.getName();
		String FileExt = "";
//System.out.println(FieldName+FileName);
		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);
		String Title = FileName;

		int index = FileName.lastIndexOf(".");
		if(index!=-1)
		{
			FileExt = FileName.substring(index+1);
		}

		if(FileExt.equalsIgnoreCase("gif") || FileExt.equalsIgnoreCase("jpg") || FileExt.equalsIgnoreCase("bmp") || FileExt.equalsIgnoreCase("jpeg") || FileExt.equalsIgnoreCase("png"))
		{
			if(!FileName.equals(""))
			{
				CmsFile cmsfile = new CmsFile();
				String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);
				String FilePath = RealPath + "/" +NewFileName;
				/*File uploadedFile = new File(FilePath);
				item.write(uploadedFile);
				FileUtil.optimizeImage(FilePath);*/
				File uploadedFile1 = new File(FilePath);
			    File uploadedFile = new File(FilePath.replace("."+FileExt,"_original."+FileExt));
			    item.write(uploadedFile);
			    item.write(uploadedFile1);
			    Title = uploadedFile.getName();
			    String original_filepath = Path + "/" +Title;
				
				 	

				String ThumbnailName = "";
				String newfilefullname = Util.ClearPath(SiteUrl + Path + "/" + NewFileName);

				if(sys_channelid_image>0)
				{//配置了图片库，图片要入库
					long Filesize = uploadedFile.length();
					HashMap map = new HashMap();
					map.put("Title",Title);
					map.put("Status","1");
					map.put("Photo",original_filepath);
					map.put("Filesize",Filesize+"");
					map.put("User",userinfo_session.getId()+"");
					if(companyid != 0){
						map.put("companyid",String.valueOf(companyid));
					}
					ItemUtil.addItemGetGlobalID(sys_channelid_image,map);
				}

				if(Thumbnail.equals("yes"))
				{				
					if(keepbig.equals("yes")) 
					{
						if(NewFileName.lastIndexOf(".")!=-1)
							ThumbnailName = "s"+NewFileName.substring(0,NewFileName.lastIndexOf(".")) + "." + FileExt;
						else
							ThumbnailName = "s"+NewFileName + ".jpg";
					}
					else
					{
						ThumbnailName = NewFileName;
					}

					FileUtil.compressImage2IM(FilePath,RealPath + "/" + ThumbnailName,txtWidth,txtHeight,0);
					
					if(Watermark.equals("yes"))
					{	
						boolean succ = FileUtil.waterMaskByIm4java(RealPath + "/" +ThumbnailName,mask_scheme, mask_location);
					}

					if(sharpen.equals("yes"))//锐化
					{
						boolean succ = FileUtil.sharpenImage(RealPath + "/" + ThumbnailName);
					}

					String imgStr = "<img src=\"" + Util.ClearPath(channel.getSite().getUrl() + Path + "/" + ThumbnailName) + "\" ";
					if(txtWidth!=0)
						imgStr += " width='" + txtWidth + "'";
					if(txtHeight!=0)
						imgStr += " height='" + txtHeight + "'";
					if(txtHSpace!=0)
						imgStr += " hspace='" + txtHSpace + "'";
					if(txtVSpace!=0)
						imgStr += " vspace='" + txtVSpace + "'";
					if(txtBorder!=0)
						imgStr += " border='" + txtBorder + "'";
					else
						imgStr += " border='0'";
					if(!cmbAlign.equals(""))
						imgStr += " align='" + cmbAlign + "'";
					imgStr += ">";

					if(keepbig.equals("yes"))
						ReturnValue += "<a href='" + newfilefullname + "'>"+imgStr + "</a>";
					else
						ReturnValue += imgStr;
				}
				else
				{
					if(Watermark.equals("yes"))
					{	
						boolean succ = FileUtil.waterMaskByIm4java(FilePath,mask_scheme,mask_location);
						System.out.println("succ:"+succ);
					}

					if(sharpen.equals("yes"))//锐化
					{
						boolean succ = FileUtil.sharpenImage(FilePath);
					}
					String imgStr = "<img src=\"" + newfilefullname + "\" ";
					if(txtWidth!=0)
						imgStr += " width='" + txtWidth + "'";
					if(txtHeight!=0)
						imgStr += " height='" + txtHeight + "'";
					if(txtHSpace!=0)
						imgStr += " hspace='" + txtHSpace + "'";
					if(txtVSpace!=0)
						imgStr += " vspace='" + txtVSpace + "'";
					if(txtBorder!=0)
						imgStr += " border='" + txtBorder + "'";
					else
						imgStr += " border='0'";
					if(!cmbAlign.equals(""))
						imgStr += " align='" + cmbAlign + "'";
					imgStr += ">";

					if(txtLnkUrl.equals(""))
						ReturnValue += imgStr;
					else
						ReturnValue += "<a href='" + txtLnkUrl + "' " + ((cmbLnkTarget.equals(""))?"":"target='" + cmbLnkTarget + "'" )+ ">" + imgStr + "</a>";
				}

					//ReturnValue = ReturnValue.replace("///","/");
					//ReturnValue = ReturnValue.replace("//","/");
					//插入待发布图片
					Publish publish = new Publish();
					publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName),SiteFolder,channel.getSite());
					if(Thumbnail.equals("yes") && keepbig.equals("yes"))
						publish.InsertToBePublished(Util.ClearPath(Path + "/" + ThumbnailName),SiteFolder,channel.getSite());
					PublishManager.getInstance().CopyFileNow();

			}
		}
    } 
}
}catch(Exception e){ e.printStackTrace();ReturnValue="error:缩略图功能没有安装，请联系系统管理员!";}
catch(java.lang.NoClassDefFoundError e1){ReturnValue="error:缩略图功能没有安装，请联系系统管理员!";}
catch(java.lang.UnsatisfiedLinkError e){ReturnValue="error:缩略图功能没有安装，请联系系统管理员!";}
%><%=(ReturnValue)%>