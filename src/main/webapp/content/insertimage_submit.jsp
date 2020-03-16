<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.*,
				java.sql.*,
				java.io.File,
				magick.*,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
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
DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FolderName		= "";
String ReturnValue		= "";
String Thumbnail		= "";
String Watermark		= "";
String Client			= "";//0 编辑器上传 1 内容页中文本框上传 2 编辑器中拖动图片上传
String sourceType		= "";

String txtLnkUrl		= "";
String cmbLnkTarget		= "";
String cmbAlign			= "";
String txtAlt			= "";

int ChannelID			= 0;
int txtWidth		= 0;
int txtHeight		= 0;
int	txtBorder		= 0;
int txtHSpace		= 0;
int txtVSpace		= 0;

int status			= 1;

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
		//out.println(FieldName+",");
		if(FieldName.equals("ChannelID"))
			ChannelID = getIntParameter(item.getString());
		if(FieldName.equals("Thumbnail"))
			Thumbnail = item.getString();
		if(FieldName.equals("Watermark"))
			Watermark = item.getString();
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
		if(FieldName.equals("txtAlt"))
			txtAlt = (item.getString());
		if(FieldName.equals("cmbLnkTarget"))
			cmbLnkTarget = (item.getString());
		if(FieldName.equals("cmbAlign"))
			cmbAlign = (item.getString());
		if(FieldName.equals("Client"))
			Client = (item.getString());
		//if(FieldName.equals("sourceType"))
		//	sourceType = getIntParameter(item.getString());
    } 
}

if(Thumbnail.equals("Yes"))
{
	if(txtHeight==0)
		txtHeight = 1;
	if(txtWidth==0)
		txtWidth = 1;
}
//out.println(ChannelID);
Channel channel = CmsCache.getChannel(ChannelID);

	String Path = channel.getRealImageFolder();
	//if(!RootPath.equals("/"))
	//	Path = RootPath + Path;

	String SiteFolder = channel.getSite().getSiteFolder();
	//String RealPath = application.getRealPath(Path);
	String RealPath = "";

	RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;
	//out.println(RealPath);
	File file = new File(RealPath);
	if(!file.exists())
		file.mkdirs();

	//System.out.println(ChannelID+"::"+RealPath+"::"+Path);
	String Photo = "";

iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (!item.isFormField()) {
		String FieldName = item.getFieldName();
		String FileName = item.getName();
		String FileExt = "";
		//out.println(FieldName+FileName);
		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);

		int index = FileName.lastIndexOf(".");
		if(index!=-1)
		{
			FileExt = FileName.substring(index+1);
		}

		if(FileExt.equalsIgnoreCase("gif") || FileExt.equalsIgnoreCase("jpg") || FileExt.equalsIgnoreCase("bmp") || FileExt.equalsIgnoreCase("jpeg") || FileExt.equalsIgnoreCase("png") || FileExt.equalsIgnoreCase("pdf"))
		{
			if(!FileName.equals(""))
			{
				CmsFile cmsfile = new CmsFile();
				String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);
				File uploadedFile = new File(RealPath + "/" +NewFileName);
				item.write(uploadedFile);

				if(Watermark.equals("Yes"))
				{	
					Parameter p = CmsCache.getParameter("sys_watermask_file");
					String maskFile = p.getContent();
					File mfile = new File(maskFile);
					if(mfile.exists())
					{

					ImageInfo imageinfo = new ImageInfo(RealPath + "/" + NewFileName);
					MagickImage mask = new MagickImage(new ImageInfo(maskFile));
/*
			      QuantizeInfo quantizeInfo = new QuantizeInfo(); 
                  quantizeInfo.setColorspace(ColorspaceType.GRAYColorspace);
                  quantizeInfo.setNumberColors(2);                    
                  quantizeInfo.setTreeDepth(3);
				  mask.quantizeImage(quantizeInfo);
				  mask.transparentImage(PixelPacket.queryColorDatabase("black"), Integer.MAX_VALUE - 6000);
                  mask.transparentImage(PixelPacket.queryColorDatabase("white"), Integer.MAX_VALUE -500 );
*/
					//Dimension dim = image.getDimension();


					MagickImage image = new MagickImage(imageinfo);

				   int w = image.getDimension().width;
				   int h = image.getDimension().height;
					//Dimension dim1 = mask.getDimension();
				   int w1 = mask.getDimension().width;
				   int h1 = mask.getDimension().height;
//System.out.println(w+","+w1);
					image.compositeImage(CompositeOperator.AtopCompositeOp,mask,w-10-w1,h-10-h1);
					image.writeImage(imageinfo);

					if (mask != null) mask.destroyImages(); 
					if (image != null) image.destroyImages(); 
					}
				}


				String ThumbnailName = "";

				if(Thumbnail.equals("Yes"))
				{
					if(NewFileName.lastIndexOf(".")!=-1)
						ThumbnailName = "s"+NewFileName.substring(0,NewFileName.lastIndexOf(".")) + "." + FileExt;
					else
						ThumbnailName = "s"+NewFileName + ".jpg";
					
					try
					{
						ImageInfo info = new ImageInfo(RealPath + "/" + NewFileName);
						MagickImage image = new MagickImage(new ImageInfo(RealPath + "/" + NewFileName));
						MagickImage scaled = image.scaleImage(txtWidth,txtHeight);//小图片文件的大小.
						scaled.setFileName(RealPath + "/" + ThumbnailName);
						scaled.writeImage(info);
					}catch(java.lang.UnsatisfiedLinkError e)
					{
						throw new tidemedia.cms.base.MessageException("缩略图功能没有安装!");
					}catch(java.lang.NoClassDefFoundError e1)
					{
						throw new tidemedia.cms.base.MessageException("缩略图功能没有安装!");
					}

					ReturnValue += "<a href='" + Util.ClearPath(channel.getSite().getUrl() + Path + "/" + NewFileName) + "'><img border=0 src='" + Util.ClearPath(channel.getSite().getUrl() + Path + "/" + ThumbnailName) + "' alt='"+txtAlt+"'></a>";
				}
				else
				{
					String imghref = Util.ClearPath(channel.getSite().getUrl() + Path + "/" + NewFileName);
					String imgStr = "<img src=\"" +imghref + "\" alt='"+txtAlt+"'";
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

					if(Client.equals("1"))
						ReturnValue = Util.ClearPath(Path + "/" + NewFileName);
				}

					//ReturnValue = ReturnValue.replace("///","/");
					//ReturnValue = ReturnValue.replace("//","/");
					//插入待发布图片
					Publish publish = new Publish();
					publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName),SiteFolder,channel.getSite());
					if(Thumbnail.equals("Yes"))
						publish.InsertToBePublished(Util.ClearPath(Path + "/" + ThumbnailName),SiteFolder,channel.getSite());

			}
		}
		else
		{
			status = 0;ReturnValue = "文件类型不符合要求.";
		}
    } 
}
if(Client.equals("1") || Client.equals("2"))
{
	if(status==0)
		out.println(JsonUtil.fail(ReturnValue));
	if(status==1)
		out.println(JsonUtil.success(ReturnValue));
}
else
{
	out.println(ReturnValue);
}
%>