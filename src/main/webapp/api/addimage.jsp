 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				tidemedia.cms.publish.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				java.io.*,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
String tempPath			= "";
String Token = "";
DiskFileUpload upload = new DiskFileUpload();
tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");
java.util.List items = upload.parseRequest(request);

int channelid = 0;
String resize="";
java.util.Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();
	String field = item.getFieldName();
	//out.print("field:"+field);
	if (item.isFormField()) {
		//out.print("field2:"+field);
		if(field.equals("ChannelID"))
		{
			channelid = Util.parseInt(item.getString());
		}
		if(field.equals("resize")){
			resize = item.getString();
		}
		if(field.equals("Token")){Token = (item.getString());}
	}
}

int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);

int status = 0;
int imageID=0;
String href = "";
String site = "";
String msg = "";
JSONObject os = new JSONObject();

//System.out.println("resize="+resize);

if(login == 1 && channelid>0)
{

	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
	int sys_channelid_image = photo_config.getInt("channelid");
	int force_httpurl = photo_config.getInt("force_httpurl");
	Channel channel2 = CmsCache.getChannel(sys_channelid_image);
	Channel channel = CmsCache.getChannel(channelid);
	//Site site_ = channel.getSite();
	if(force_httpurl==1){
		site = channel2.getSite().getExternalUrl();
	}else{
		site = channel.getSite().getUrl();
	}
	String Path = channel2.getRealImageFolder();
	String SiteFolder = channel2.getSite().getSiteFolder();
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
			String NewFileName="";
			String newfilefullname="";
			if(FileExt.equalsIgnoreCase("gif") || FileExt.equalsIgnoreCase("jpg") || FileExt.equalsIgnoreCase("bmp") || FileExt.equalsIgnoreCase("jpeg") || FileExt.equalsIgnoreCase("png"))
			{
				CmsFile cmsfile = new CmsFile();
				NewFileName = cmsfile.getNewFileName(FileName,Path,0);
				File uploadedFile = new File(RealPath + "/" +NewFileName);
				item.write(uploadedFile);	

				newfilefullname = Util.ClearPath(Path + "/" + NewFileName);
				
				status = 1;
				href = newfilefullname;

			}else{
				JSONObject o_ = new JSONObject();
				o_.put("status",0);
				o_.put("msg","你上传的图片格式不符合要求。");
				out.println(o_.toString());
				return;
			}
			HashMap map = new HashMap<String,String>();
			Publish publish = new Publish();
			map.put("Photo",newfilefullname);
			map.put("Title",NewFileName);
			map.put("Status","1");
			publish.InsertToBePublished(newfilefullname,channel.getSite().getSiteFolder(),channel);
			String field="";
			int width = 0;
			int height = 0;
			if (resize.length() > 0) {
				try {
					String sourceFileRealPath = RealPath + "/" +NewFileName;
					String destFileRealpath = "";
					String cutFilePathname="";
					JSONArray ja = new JSONArray(resize);
					for(int i=0;i<ja.length();i++){
						JSONObject jo =ja.getJSONObject(i);
						field = jo.getString("field");
						width = jo.getInt("width");
						height = jo.getInt("height");
						destFileRealpath = sourceFileRealPath.replace("."+FileExt,"_"+i+"."+FileExt);
						cutFilePathname  = newfilefullname.replace("."+FileExt,"_"+i+"."+FileExt);
						//System.out.println(sourceFileRealPath+","+","+destFileRealpath+field+","+width+","+height);
						FileUtil.compressImage2IM(sourceFileRealPath,destFileRealpath,width,height,1);
						map.put(field,cutFilePathname);
						os.put (field,cutFilePathname);

						//发布
						publish.InsertToBePublished(cutFilePathname,channel.getSite().getSiteFolder(),channel);
						PublishManager.getInstance().CopyFileNow();
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					msg = "resize is not a jsonarray";
				}
			}
			ItemUtil util = new ItemUtil();
			imageID = util.addItem(channelid, map).getId();
		}
	}
}

JSONObject o = new JSONObject();
o.put("status",status);
o.put("href",href);
o.put("site",site);
o.put("imageID",imageID+"");
o.put("msg",msg);
if(resize.length()>0){
	o.put("resize",os.toString());
}

out.println(o.toString());
%>