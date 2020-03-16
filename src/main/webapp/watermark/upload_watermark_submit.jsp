<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				
				magick.*,
				java.io.File,
				java.util.*,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@page import="org.apache.commons.io.FileUtils"%>
<%@ include file="../config.jsp"%>
<%!
public String getParameter(String tempstr)
{
	if(tempstr==null)
		return "";
	else
		return tempstr;
}

public int getIntParameter(String tempstr)
{
	if(tempstr.equals(""))
		return 0;
	else
	{
		int i = 0;
		try
		{
			i = Integer.valueOf(tempstr).intValue();
		}
		catch(Exception e)
		{
		}
		return i;
	}
}
%>
<%
/**
  *王海龙 2016.3.20 转码水印方案
  *
  *
  */
String tempPath			= "";
String ReturnValue		= "";
String ReturnValue1		= "";
tempPath = request.getRealPath("/temp");

DiskFileUpload upload = new DiskFileUpload();
upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");

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
int ChannelID = getIntParameter(request,"ChannelID");//当前频道id
String NewFileName = "";

File file = new File(RealPath);
if(!file.exists())
	file.mkdirs();

List items = upload.parseRequest(request);
Iterator iter = items.iterator();
while (iter.hasNext())
{
    FileItem item = (FileItem) iter.next();
    if (item.isFormField()) 
    {
		String FieldName = item.getFieldName();
    } 
}
 iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (!item.isFormField())
    {
		String FieldName = item.getFieldName();
		String FileName = item.getName();
		String FileExt = "";
		int index = FileName.lastIndexOf(".");
		if(index!=-1)
		{
			FileExt = FileName.substring(index+1);//文件扩展名
		}
		if(!FileName.equals(""))
		{	
			CmsFile cmsfile = new CmsFile();
			NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),ChannelID);//新文件名
			String FilePath = RealPath + "/" +NewFileName;
		    File uploadedFile = new File(FilePath);
		    item.write(uploadedFile);
			ReturnValue = FilePath;
			ReturnValue1 = NewFileName;
		}
    } 
}
%>
 parent.getDialog().Close({close:function(){parent.popiframe_1.$("#watermark").val('<%=Util.JSQuote(ReturnValue)%>');
 parent.popiframe_1.$("#filename").val('<%=Util.JSQuote(ReturnValue1)%>');
 
 }});