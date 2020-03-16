 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				java.io.*,
				org.apache.commons.fileupload.*,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
JSONObject o=new JSONObject();
try{
String Token="";
//Pattern pattern = Pattern.compile("[0-9]{6}");
//boolean Channelid_valid_flag=false;

String tempPath			= "";
DiskFileUpload upload = new DiskFileUpload();
tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");
java.util.List items = upload.parseRequest(request);

int channelid = 0;
String ChannelID="";
java.util.Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();
	String field = item.getFieldName();
	//out.print("field:"+field);
	if (item.isFormField()) {
		//out.print("field2:"+field);
		if(field.equals("ChannelID"))
		{
			 ChannelID=item.getString();
			//int channelid_int=0;
			//Channelid_valid_flag=pattern.matches("^[1-9]\\d{1,9}$", ChannelID);
			channelid = Util.parseInt(item.getString());
		}
		if(field.equals("Token")){
			 Token=item.getString();
			
		}
	}
}

int status = 0;
String href = "";
String site = "";

int login = 0;
int userid=0;
if(Token.length()>0) {
	login = UserInfoUtil.AuthByToken(Token);
	userid=UserInfoUtil.AuthUserByToken(Token);
}
if(Token.length()==0)
{
	o.put("status",0);
	o.put("message","缺少登录令牌");
}
else if(login!=1)
{
	o.put("status",0);
	o.put("message","登录失败");
}else if(channelid==0){
		o.put("message","频道参数不符合要求");
		o.put("status",0);
}else if(channelid!=15267){
	o.put("message","该频道不是图片库频道，无法上传");
	o.put("status",0);
}

if(channelid>0&&channelid==15267)
{
	Channel channel = CmsCache.getChannel(channelid);
	String Path = channel.getRealImageFolder();
	//out.println("Path:"+Path);
	String SiteFolder = channel.getSite().getSiteFolder();
	Site site_=channel.getSite();
	site = channel.getSite().getUrl();
	String RealPath = "";
	RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;
	File file = new File(RealPath);
	if(!file.exists())
		file.mkdirs();

	iter = items.iterator();
	while (iter.hasNext()) {
		//out.println("kkk");
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
			
			if(FileExt.equalsIgnoreCase("gif") || FileExt.equalsIgnoreCase("jpg") || FileExt.equalsIgnoreCase("bmp") || FileExt.equalsIgnoreCase("jpeg") || FileExt.equalsIgnoreCase("png"))
			{
				CmsFile cmsfile = new CmsFile();
				String NewFileName = cmsfile.getNewFileName(FileName,Path,0);
				File uploadedFile = new File(RealPath + "/" +NewFileName);
				item.write(uploadedFile);	

				String newfilefullname = Util.ClearPath(Path + "/" + NewFileName);
				
				FileUtil fileutil = new FileUtil();
				fileutil.PublishFiles(NewFileName, RealPath.replace(SiteFolder, ""),
				SiteFolder, userid, site_);
				
				status = 1;
				href = newfilefullname;
			}
			
		}
	}


//JSONObject o = new JSONObject();
	if(!href.equals("")||href==null){
		o.put("status",status);
		o.put("href",href);
		o.put("site",site);
		o.put("message","上传成功");
	}else{
		o.put("status",0);
		o.put("message","上传失败，请检查相关文件以及图片参数");
	}

}
}catch(Exception e){
	o.put("status",0);
	o.put("message","上传失败，请检查相关文件以及图片参数");
	
}
out.println(o.toString());
%>