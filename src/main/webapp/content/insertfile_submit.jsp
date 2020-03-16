<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
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
<%!
/**
*  1. 胡翔 20190806 修改   上传图片是将companyid入库
*/

public int getIntParameter(String tempstr)
{
	if(tempstr.equals(""))
		return 0;
	else
	{
		int i = 0;
		try{
			i = Integer.valueOf(tempstr).intValue();
		}catch(Exception e){}
		return i;
	}
}

public String getParameter(String tempstr)
{
	if(tempstr==null)
		return "";
	else
		return tempstr;
}
//获取图片尺寸
public JSONObject getPhotoSize(String name,int type){
	JSONObject json = new JSONObject() ;
	try{
		String sql = "select Width,Height from photo_scheme where Name='"+name+"' and Type="+type;
		TableUtil tu=new TableUtil();
		ResultSet Rs = tu.executeQuery(sql);
		if(Rs.next()){
			json.put("width",Rs.getInt("Width"));
			json.put("height",Rs.getInt("Height"));
		}
		tu.closeRs(Rs);
	}catch(Exception e){
		e.printStackTrace();
	}
	return json ;
}
//图片裁剪
public void crop(String oldpath,String newpath,int width,int height,int x,int y) {
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
	
	}catch(Exception e){
		e.printStackTrace();
	}
}
//智能裁剪
public String cmd(String s, boolean print){

	System.out.println(s);

	String bufs = "";
	long begin = System.currentTimeMillis();
	List<String> commend = new java.util.ArrayList<String>();
	ProcessBuilder builder = new ProcessBuilder();
	builder.command(commend);
	builder.redirectErrorStream(true);

	String[] ss = Util.StringToArray(s, " ");
	for (int i = 0; i < ss.length; i++) {
		commend.add(ss[i]);
	}

	String commend_desc = commend.toString().replace(", ", " ");

	try {
		Process process1 = builder.start();
		InputStream is2 = process1.getInputStream();
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf2 = new StringBuilder();
		String line2 = null;
		while ((line2 = br2.readLine()) != null)
		buf2.append(line2 + "\r\n");
		bufs = buf2.toString();
		br2.close();
		is2.close();
		process1.destroy();
		if (print)
			System.out.println("bufs:" + bufs);
	} catch (Exception e) {
		e.printStackTrace(System.out);
		System.out.println(e.getMessage() + "\r\n cmd:" + commend_desc);
	}
	return bufs;
}
//获取裁剪后图片地址
public boolean getCropPath(int cropWidth, int cropHeight, int photoType,String FilePath,String newFilePath,String cropimage_path,int open){
	boolean flag = true;
	try {
		//原始图片尺寸
		int[] dim = FileUtil.getSizeByIm4java(FilePath);
		int Width1 = dim[0];
		int Height1 = dim[1];
		int x = 0;
		int y = 0;

		//计算裁剪后图片宽度（w）高度(h)
		int Height2 = Width1*cropHeight/cropWidth;
		int Width2  = Height1*cropWidth/cropHeight ;

		if(Height2<Height1){//裁高

			y = (Height1-Height2)/2 ;
			Height1 = Height2 ;

		}else if(Height2>Height1){//裁宽
			
			x = (Width1-Width2)/2 ;
			Width1 = Width2 ;
		}
		

		//是否智能裁剪
//		int open = CmsCache.getParameter("cropimage").getIntValue();
		if(open==1){

			String cmdString = cropimage_path+" -s "+FilePath+" -d "+newFilePath+" -w "+Width1+" -h "+Height1;
			cmd(cmdString,false);

		}else{//算法裁剪
			crop(FilePath,newFilePath,Width1,Height1,x,y);
		}
	} catch (Exception e) {
		flag = false;
		e.printStackTrace(System.out);
	}
	return flag ;
}
//判断频道是否需要智能裁剪功能
public boolean iscrop(int ChannelID,String cropimage_channel)throws MessageException, SQLException{

	Channel channel = CmsCache.getChannel(ChannelID);
	String channelCode = channel.getChannelCode();

//	String cropimage_channel = CmsCache.getParameterValue("cropimage_channel");

	String[] cropimage_channels = cropimage_channel.split(",");
	for(int i=0;i<cropimage_channels.length;i++){
		String code = cropimage_channels[i];

		if(code.endsWith("*")){
			code = code.substring(0,code.length()-1);
			if(channelCode.startsWith(code)){
				return true ;
			}
		}else if(channelCode.equals(code)){
			return true ;
		}
	}
	return false ;
}
%>
<%
//System.out.println("current time is :"+System.currentTimeMillis());
DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FolderName		= "";
String fieldname2		= "";
String ReturnValue		= "";
String ReturnValue2		= "";
String ReturnFileSize	= "";
String Type				= "";
String Watermark		= "";
String mask_location	= "";
String Client			= "";
int ChannelID			= 0;
int Width				= 0;
int Height				= 0;
int CompressWidth		= 0;
int	CompressHeight		= 0;
int mask_scheme = 0;
int IsCompress			=0;//是否压缩
//int UseCompress			=0;//是否使用压缩后图片
int photoType = 0 ;//列表图片类型

String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;

tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();
//System.out.println("defalutsite:"+defaultSite);
tempPath = request.getRealPath("/temp");
//System.out.println("tempPath:"+tempPath);
upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");
java.util.List items;

//try{
items = upload.parseRequest(request);
//}
//catch(org.apache.commons.fileupload.FileUploadException e){}
//System.out.println("tempPath22:"+tempPath);
java.util.Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (item.isFormField()) {
		String FieldName = item.getFieldName();
		//System.out.println(FieldName);
		if(FieldName.equals("ChannelID"))
			ChannelID = getIntParameter(item.getString());
		else if(FieldName.equals("Type"))
			Type = getParameter(item.getString());
		else if(FieldName.equals("Watermark"))
			Watermark = getParameter(item.getString());
		if(FieldName.equals("mask_location"))
			mask_location = item.getString();
		else if(FieldName.equals("IsCompress"))
			IsCompress = getIntParameter(item.getString());
//		else if(FieldName.equals("UseCompress"))
//			UseCompress = getIntParameter(item.getString());
		else if(FieldName.equals("CompressHeight"))
			CompressHeight = getIntParameter(item.getString());
		else if(FieldName.equals("CompressWidth"))
			CompressWidth = getIntParameter(item.getString());
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
		else if(FieldName.equals("photoType"))
			photoType = getIntParameter(item.getString());
		else if(FieldName.equals("mask_scheme"))
			mask_scheme = getIntParameter(item.getString());
		//System.out.println(FieldName+":"+item.getString("utf-8"));
		System.out.println("Watermark="+Watermark+",mask_location="+mask_location+",mask_scheme="+mask_scheme);
    } 
}

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

if(isCan){
Channel channel = CmsCache.getChannel(ChannelID);
//图片库频道编号
int sys_channelid_image = 0;

String Path = "";
String SiteFolder = "";
String SiteUrl = "";
String RealPath = "";
Site site = null;
boolean need_httpurl = true;
int force_httpurl = 0;
if(!Type.equals("Image")) need_httpurl = false;
//如果不是图片上传，默认不需要http url

//把图片库频道编号的配置移到sys_config_photo中了，废除sys_channelid_photo 2012-10-12
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
if(photo_config!=null){
	sys_channelid_image = photo_config.getInt("channelid");
	force_httpurl = photo_config.getInt("force_httpurl");
}
int companyid = userinfo_session.getCompany();//租户id

if(sys_channelid_image>0&&Type.equals("Image"))
{
	//配置了图片库
	Channel channel2 = CmsCache.getChannel(ChannelID);
	channel = CmsCache.getChannel(sys_channelid_image);
	site = channel.getSite();
	Path = channel.getRealImageFolder();
	//按租户分目录
	int upload_by_company = CmsCache.getParameter("upload_by_company").getIntValue();
	if(upload_by_company==1&&companyid!=0){
		Path = "/"+companyid+Path;
	}
	SiteUrl = site.getExternalUrl();
	//System.out.println("siteid:"+channel2.getSiteID()+","+channel.getSiteID()+","+force_httpurl);
	if(channel2.getSiteID()==channel.getSiteID() && force_httpurl==0)
	{
		need_httpurl = false;
	}
	//System.out.println("need_httpurl:"+need_httpurl+","+Path);
}
else
{
	Path = channel.getRealImageFolder();
	site = channel.getSite();
	SiteUrl = site.getUrl();
}

SiteFolder = site.getSiteFolder();
RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;

File file = new File(RealPath);
if(!file.exists())
	file.mkdirs();

iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (!item.isFormField()) {
		String FieldName = item.getFieldName();
		String FileName = item.getName();
		String FileExt = "";//扩展名
//System.out.println("FileName=="+FileName);
//System.out.println(new String(FileName.getBytes("ISO-8859-1"),"gbk"));
		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);
		String Title = FileName;

		int index = FileName.lastIndexOf(".");
		if(index!=-1)
		{
			FileExt = FileName.substring(index+1);
		}
//System.out.println("Client:"+Client);
//		if(FileExt.equalsIgnoreCase("gif") || FileExt.equalsIgnoreCase("jpg") || FileExt.equalsIgnoreCase("bmp") || FileExt.equalsIgnoreCase("jpeg"))
//		{
		if(!FileName.equals(""))
		{

			CmsFile cmsfile = new CmsFile();
			String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);
			String FilePath = RealPath + "/" +NewFileName;
			System.out.println("FilePath:"+FilePath);
			 File uploadedFile1 = new File(FilePath);
		    item.write(uploadedFile1);
		    
			if(need_httpurl)
			{
				ReturnValue += Util.ClearPath(SiteUrl + Path + "/" + NewFileName);
			}
			else
			{
				ReturnValue += Util.ClearPath(Path + "/" + NewFileName);
			}
			
			//ReturnValue.replace("//","/");

			String FileFullPath = Util.ClearPath(SiteUrl + Path + "/" + NewFileName);

			if(Type.equals("Image"))
			{

				String ThumbnailName1="",ThumbnailName2="",ThumbnailName3="";

				//System.out.println(FilePath);
				FileUtil.optimizeImage(FilePath);
				
				if(IsCompress==1 && (CompressWidth>0 || CompressHeight>0))
				{
					String compressFile = FilePath.replace("."+FileExt,"_s."+FileExt);
					FileUtil.compressImage2IM(FilePath,compressFile,CompressWidth,CompressHeight,0);
//					if(UseCompress==1)
//					{
						//uploadedFile.delete();
						
						NewFileName = NewFileName.replace("."+FileExt,"_s."+FileExt);
						FilePath=compressFile;
//					}
					
				}
				else
				{
					TideJson cropimage_ = CmsCache.getParameter("cropimage_").getJson();//智能裁剪配置
					String cropimage_channel = cropimage_.getString("cropimage_channel");
					String cropimage_path = cropimage_.getString("cropimage_path");
					int open = cropimage_.getInt("open");

					if(iscrop(ChannelID,cropimage_channel)&&(!FileName.endsWith(".gif"))){//配置了裁剪频道并不是动图

						//裁剪后图片名
						String NewFileName1 = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);
						String newFilePath = RealPath + "/" +NewFileName1 ;

						JSONObject json = new JSONObject();
						//判断列表图片类型
						if(photoType==1){
							json = getPhotoSize("列表三图",1);
						}else if(photoType==2){
							json = getPhotoSize("列表大图",1);
						}else if(photoType==5){
							json = getPhotoSize("轮播图",1);
						}else{
							json = getPhotoSize("列表单图",1);
						}
						//图片尺寸
						int cropWidth = json.getInt("width");
						int cropHeight = json.getInt("height");
						
						boolean flag = getCropPath(cropWidth,cropHeight,photoType,FilePath,newFilePath,cropimage_path,open);
						if(flag){//裁剪成功

							if(NewFileName1.lastIndexOf(".")!=-1){
								ThumbnailName1 = NewFileName1.substring(0,NewFileName1.lastIndexOf(".")) + "_t1080." + FileExt;
								ThumbnailName2 = NewFileName1.substring(0,NewFileName1.lastIndexOf(".")) + "_t720." + FileExt;
								ThumbnailName3 = NewFileName1.substring(0,NewFileName1.lastIndexOf(".")) + "_t480." + FileExt;
							}else{
								ThumbnailName1 = NewFileName1 + "_t1080.jpg";
								ThumbnailName2 = NewFileName1 + "_t720.jpg";
								ThumbnailName3 = NewFileName1 + "_t480.jpg";
							}
							//压缩
							FileUtil.compressImage2IM(newFilePath,RealPath + "/" + ThumbnailName1,cropWidth,cropHeight,0);
							FileUtil.compressImage2IM(newFilePath,RealPath + "/" + ThumbnailName2,(int)(cropWidth*690/1035),(int)(cropHeight*390/585),0);
							FileUtil.compressImage2IM(newFilePath,RealPath + "/" + ThumbnailName3,(int)(cropWidth*345/1035),(int)(cropHeight*195/585),0);
							//删除原图
							//uploadedFile.delete();
							//uploadedFile.renameTo(new File(FilePath.replace("."+FileExt,"_original."+FileExt)));
							File cropFile = new File(newFilePath);
							cropFile.delete();

							FilePath = RealPath + "/" + ThumbnailName1 ;
							NewFileName = ThumbnailName1 ;

							//发布图2，图3
							Publish publish_ = new Publish();
							publish_.InsertToBePublished(Util.ClearPath(Path + "/" + ThumbnailName2),SiteFolder,site);
							publish_.InsertToBePublished(Util.ClearPath(Path + "/" + ThumbnailName3),SiteFolder,site);

						}

						ReturnValue2 = "parent.$('#" + fieldname2 + "_s" + "').val('" + Util.ClearPath(Path + "/" + ThumbnailName1.replace(".","_s.")) + "');";
					}else{
						ReturnValue2 = "parent.$('#" + fieldname2 + "_s" + "').val('" + Util.ClearPath(Path + "/" + NewFileName.replace(".","_s.")) + "');";
					}
				}

				if(Watermark.equals("Yes"))
				{
					/*
					String maskFile = defaultSite.getTemplateFolder() + "/watermask.png";
					File mfile = new File(maskFile);
					if(mfile.exists())
					{
					System.setProperty("jmagick.systemclassloader","no");
					ImageInfo imageinfo = new ImageInfo(RealPath + "/" + NewFileName);
					MagickImage mask = new MagickImage(new ImageInfo(maskFile));
					MagickImage image = new MagickImage(imageinfo);

					int w = image.getDimension().width;
					int h = image.getDimension().height;
					int w1 = mask.getDimension().width;
					int h1 = mask.getDimension().height;

					image.compositeImage(CompositeOperator.AtopCompositeOp,mask,w-10-w1,h-10-h1);
					image.writeImage(imageinfo);

					if (mask != null) mask.destroyImages(); 
					if (image != null) image.destroyImages(); 
					}
*/
					//System.out.println("mask_location="+mask_location);
					boolean succ = FileUtil.waterMaskByIm4java(FilePath,mask_scheme,mask_location);
					System.out.println("succ:"+succ+",newfilename="+RealPath+"/"+NewFileName);

				}
				
				ReturnValue = Util.ClearPath(Path + "/" + NewFileName);
				if(need_httpurl){
					ReturnValue = Util.ClearPath(SiteUrl+ReturnValue);
				}
				File uploadedFile = new File(FilePath.replace("."+FileExt,"_original."+FileExt));
			    item.write(uploadedFile);
			    Title = uploadedFile.getName();
			    String original_filepath = Path + "/" +Title;
			    String original_filerealpath = RealPath + "/" +Title;
				if(sys_channelid_image>0)
				{//配置了图片库，图片要入库，入图片库时，获取Photo字段图片的大小
					File tmpfile = new File(original_filerealpath);
					File tmpfile1 = new File(FilePath);
					long FileSize_KB = tmpfile.length();

					HashMap map = new HashMap();
					map.put("Title",Title);
					map.put("Status","1");
					map.put("Photo",original_filepath);
					map.put("Filesize",FileSize_KB+"");
					if(companyid != 0){
						map.put("companyid",String.valueOf(companyid));
					}
					ItemUtil.addItemGetGlobalID(sys_channelid_image,map);
					ReturnFileSize = "parent.$('#FileSize_KB').val('" + FileSize_KB + "');";
				}
			}
			else if(Type.equals("Flash"))
			{
				//Insert Flash
				ReturnValue = "";
				//ReturnValue ="<object classid=\"clsid:D27CDB6E-AE6D-11cf-96B8-444553540000\" codebase=\"http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,29,0\" width=\"" + Width + "\" height=\"" + Height + "\">";
				//ReturnValue +="  <param name=\"movie\" value=\"" + FileFullPath + "\" />";
				//ReturnValue +="  <param name=\"quality\" value=\"high\" />";
				//ReturnValue +="  <param name=\"wmode\" value=\"opaque\" />";
				ReturnValue +="  <embed src=\"" + FileFullPath + "\" wmode=\"opaque\" quality=\"high\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\" width=\"" + Width + "\" height=\"" + Height + "\"></embed>";
				//ReturnValue +="</object>";
			}
			else if(Type.equals("Video"))
			{
				if(FileExt.equalsIgnoreCase("mpg") || FileExt.equalsIgnoreCase("mpeg") || FileExt.equalsIgnoreCase("asf") || FileExt.equalsIgnoreCase("avi") || FileExt.equalsIgnoreCase("wmv"))
				{
					ReturnValue ="<OBJECT ID=\"MediaPlayer1\" width=\"" + Width + "\" height=\"" + Height + "\"";
					ReturnValue +="	CLASSID=\"CLSID:22D6f312-B0F6-11D0-94AB-0080C74C7E95\"";
					ReturnValue +="	CODEBASE=\"http://activex.microsoft.com/activex/controls/mplayer/en/nsmp2inf.cab#Version=5,1,52,701\"";
					ReturnValue +="	 standby=\"Loading Microsoft Windows Media Player components...\"";
					ReturnValue +="	 type=\"application/x-oleobject\">";
					ReturnValue +="<Param Name=\"FileName\" Value=\"" + FileFullPath + "\">";
					ReturnValue +="</OBJECT>";
				}
				else if(FileExt.equalsIgnoreCase("mov"))
				{
					ReturnValue ="<OBJECT CLASSID=\"clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B\" width=\"" + Width +"\" height=\"" + Height +"\"  CODEBASE=\"http://www.apple.com/qtactivex/qtplugin.cab\">";
					ReturnValue +="<PARAM name=\"SRC\" VALUE=\"" + FileFullPath + "\">";
					ReturnValue +="<PARAM name=\"AUTOPLAY\" VALUE=\"true\">";
					ReturnValue +="<PARAM name=\"CONTROLLER\" VALUE=\"TRUE\">";
					ReturnValue +="<PARAM name=\"LOOP\" VALUE=\"TRUE\">";
					ReturnValue +="<PARAM name=\"TYPE\" VALUE=\"video/quicktime\">";
					ReturnValue +="<PARAM name=\"PLUGINSPAGE\" VALUE=\"http://www.apple.com/quicktime/download/indext.html\">";
					ReturnValue +="<PARAM name=\"target\" VALUE=\"myself\">";
					ReturnValue +="<embed width=\"" + Width +"\" height=\"" + Height + "\" src=\"" +  FileFullPath + "\" target=\"myself\" controller=\"true\" type=\"video/quicktime\" autoplay=\"true\" pluginspage=\"http://www.apple.com/quicktime/download/indext.html\"></OBJECT>";
				}
				else if(FileExt.equalsIgnoreCase("rm") || FileExt.equalsIgnoreCase("ram"))
				{
					ReturnValue ="<object id=video1 classid=\"clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA\" width=\""+Width+"\" height=\""+Height+"\" align=\"absmiddle\">";
					ReturnValue +="	<param name=\"controls\" value=\"ImageWindow\">";
					ReturnValue +="	<param name=\"console\" value=\"Clip1\">";
					ReturnValue +="	<param name=\"autostart\" value=\"true\">";
					ReturnValue +="	<PARAM NAME=\"LOOP\" VALUE=\"true\">";
					ReturnValue +="	<param name=\"src\" value=\""+ FileFullPath + "\">";
					ReturnValue +="	<embed src=\"" + FileFullPath + "\" type=\"audio/x-pn-realaudio-plugin\" console=\"Clip1\" controls=\"ImageWindow\" width=\"" + Width + "\" height=\"" + Height + "\" autostart=true align=\"absmiddle\">";
					ReturnValue +="	</embed> <br>";
					ReturnValue +="  </object><br>";
					ReturnValue +="  <object id=video1 classid=\"clsid:CFCDAA03-8BE4-11cf-B84B-0020AFBBCCFA\" height=20 width=\"" + Width +"\">";
					ReturnValue +="	<param name=\"controls\" value=\"ControlPanel\">";
					ReturnValue +="	<param name=\"console\" value=\"Clip1\">";
					ReturnValue +="	<embed type=\"audio/x-pn-realaudio-plugin\" console=\"Clip1\" controls=\"ControlPanel\" height=20 width=\"" + Width + "\" autostart=true>";
					ReturnValue +="	</embed> ";
					ReturnValue +="  </object>";
				}
			}
			else if(Type.equals("UeditorVideo"))
			{
				ReturnValue = FileFullPath ;
			}

			//发布
			Publish publish = new Publish();
			publish.InsertToBePublished(Util.ClearPath(Path) + "/" + NewFileName,SiteFolder,site);
			PublishManager.getInstance().CopyFileNow();
		}
//		}
    } 
}
%>
<%if(Client.equals("editor")){%>
<script language=javascript>
var dialog		= window.parent ;
var oEditor		= dialog.InnerDialogLoaded() ;
var FCK			= oEditor.FCK ;//alert(FCK);
FCK.InsertHtml("<%=Util.JSQuote(ReturnValue)%>");
dialog.CloseDialog() ;
</script>
<%}else if(Client.equals("DirectUpload")){
//直接上传，返回直接的地址
out.println(ReturnValue);
}else{%>
 
 parent.getDialog().Close({close:function(){parent.$("#<%=fieldname2%>").val('<%=Util.JSQuote(ReturnValue)%>');<%=ReturnValue2%>;<%=ReturnFileSize%>}});
 
<%}%>
<%}else{%>
	alert('上传失败,请重试!');
<%}%>
