<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
                org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*,
				java.io.File,
				java.util.*,
				magick.*,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
/**
 *		修改人		日期		备注
 *
 *		王海龙		20131203	增加上传视频不转码功能
 *
 */
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
//System.out.println("video");
String tempPath			= "";
String FolderName		= "";
String ReturnValue		= "";
 
String Client			= "";
String sourceType		= "";

 
int ChannelID			= 0;
int width		= 480;
int height		= 400;

String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;


String videotype = "";
String videotype2 = "";
String ReWrite = "";
String  transcode_need = "";
String videoUrl="";//视频地址
int globalid  = 0;
int SiteID = 0;
int itemid = 0;
tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);

System.setProperty("jmagick.systemclassloader","no");

java.util.List items = upload.parseRequest(request);

java.util.Iterator iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();
	System.out.println("item:"+item.getFieldName());
    if (item.isFormField()) {
		String FieldName = item.getFieldName();
		if(FieldName.equals("ChannelID"))
			ChannelID = getIntParameter(item.getString());
		if(FieldName.equals("txtWidth"))
			width = getIntParameter(item.getString());
		if(FieldName.equals("txtHeight"))
			height = getIntParameter(item.getString());
		if(FieldName.equals("Client"))
			Client = (item.getString());
		else if(FieldName.equals("browser"))
			browser = item.getString();
		else if(FieldName.equals("Username"))
			Username = item.getString();
		else if(FieldName.equals("Password"))
			Password = item.getString();
		else if(FieldName.equals("videotype"))
			videotype = item.getString();
		else if(FieldName.equals("transcode_need"))
			transcode_need = item.getString();
		else if(FieldName.equals("videotype2"))
			videotype2 = item.getString();
		else if(FieldName.equals("globalid"))
			globalid = getIntParameter(item.getString());
		else if(FieldName.equals("SiteID"))
		    SiteID = getIntParameter(item.getString());
		 else if(FieldName.equals("itemid"))
			itemid = getIntParameter(item.getString());
		//if(FieldName.equals("sourceType"))
		//	sourceType = getIntParameter(item.getString());
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
	TableUtil tu=new TableUtil("user");//新产品中要配置user数据源
	String Sql = "select * from userinfo where Username='" +tu.SQLQuote(Username) + "' and Password='" +tu.SQLQuote(Password) + "'";
	ResultSet Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		userinfo_session.setId(Rs.getInt("id"));
		isCan=true;
	}
	tu.closeRs(Rs);
}

//System.out.println("ChannelID:"+ChannelID);


 
int transcode_channelid = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
 
String Photo = "";
iter = items.iterator();
try{
Channel transcode_channel = CmsCache.getChannel(transcode_channelid);
String Path = transcode_channel.getRealImageFolder();
String SiteFolder = transcode_channel.getSite().getSiteFolder();
String RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;
File file = new File(RealPath);

HashMap map_ext = new HashMap();

TideJson tj = CmsCache.getParameter("sys_video").getJson();
JSONArray o = new JSONArray(tj.getString("birate"));
for(int i =0;i<o.length();i++)
{
	JSONObject oo = o.getJSONObject(i);
	map_ext.put(oo.getString("value"),oo.getString("ext"));
}

if(!file.exists())
		file.mkdirs();


while (isCan && iter.hasNext()) {
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

		   //if(FileExt.equalsIgnoreCase("flv") || FileExt.equalsIgnoreCase("mp4")){
			if(!FileName.equals(""))
			{
				CmsFile cmsfile = new CmsFile();
				String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId());
				File uploadedFile = new File(RealPath + "/" +NewFileName);
				item.write(uploadedFile);	
			    //读取视频信息
			    // String ffmpeg =tj.getString("ffmpeg")+" -i "+ Util.ClearPath(RealPath + "/" +NewFileName);
			    // HashMap mapInfo =  VideoUtil.getVideoInfo(ffmpeg);
			    ReturnValue = Util.ClearPath(Path + "/" + NewFileName);
			    int m = ReturnValue.lastIndexOf(".");
			 
			 
				ItemUtil util = new ItemUtil();
				TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
				if(photo_config==null){Log.SystemLog("转码系统", "图片及图片库没有配置");return;}
				int sys_channelid_image = photo_config.getInt("channelid");
				//System.out.println("the photo channel++++++++++==============="+sys_channelid_image);
				Channel channel2 = CmsCache.getChannel(sys_channelid_image);
				Site site2 = channel2.getSite();
				String Path2 = channel2.getRealImageFolder();
				String SiteUrl2 = site2.getExternalUrl();
				String fileext = Util.getFileExt(ReturnValue);//获取文件扩展名
				String onlyfilename = NewFileName.replace("."+fileext, "_0.jpg");
				//System.out.println("path2:"+Path2+",onlyfilename:"+onlyfilename);
				Photo = SiteUrl2 + Path2 + "/" + onlyfilename;
				 
                 Document doc = new Document(itemid,ChannelID);
				if(transcode_need.equals("0"))
				{
					/*
					HashMap map = new HashMap();					
					map.put("video_source",ReturnValue);
					map.put("video_source_size",uploadedFile.length()+"");
					map.put("Photo",Photo);
					util.updateItemByGid(ChannelID,map, doc.getGlobalID(),0);
                    */                    
					int[] t = Util.StringToIntArray(videotype,",");
					for(int i = 0;i<t.length;i++)
					{
						//System.out.println("======videotype:==="+videotype);
						String video_dest = "";
						if(m!=-1)
							video_dest = ReturnValue.substring(0,m) + "_" + t[i] + "." + (String)map_ext.get(t[i]+"");						
						HashMap map2 = new HashMap();
						map2.put("Title",doc.getTitle());
						map2.put("video_source",ReturnValue);
						map2.put("video_type",t[i]+"");
						map2.put("User",userinfo_session.getId()+"");
						map2.put("tidecms_addGlobal","1");
						map2.put("video_dest",video_dest);
						map2.put("Parent",doc.getGlobalID()+"");
						map2.put("Status","1");
						map2.put("Status2","0");	
						videoUrl = video_dest;//视频地址是转码后视频地址
						int id = util.addItemGetID(transcode_channelid,map2);//转码频道
						//System.out.println("----id-----"+id);
					}
					TranscodeManager tm = TranscodeManager.getInstance();
					tm.Start();
				}

				//不需要转码
				if(transcode_need.equals("1"))
				{   
					
					HashMap map2 = new HashMap();
					map2.put("Title",doc.getTitle());
					map2.put("video_source",ReturnValue);
					map2.put("video_type",videotype2);
					map2.put("User",userinfo_session.getId()+"");
					map2.put("tidecms_addGlobal","1");
					map2.put("video_dest",ReturnValue);
					map2.put("Parent",doc.getGlobalID()+"");
					map2.put("filesize",uploadedFile.length()+"");
					map2.put("transcode_time","0");
					map2.put("Status","1");
					map2.put("Status2","2");
					videoUrl = ReturnValue;//视频地址是原视频地址
					int id = util.addItemGetID(transcode_channelid,map2);//转码频道
					//System.out.println("--not transcode--id-----"+id);
					//FileUtil fileutil = new FileUtil();
		            //fileutil.PublishFiles(NewFileName,Path ,SiteFolder,userinfo_session.getId(),transcode_channel.getSite());				
					}

				String FileFullPath = Util.ClearPath(transcode_channel.getSite().getUrl() + Path + "/" + NewFileName);

				//发布
				Publish publish = new Publish();
				publish.InsertToBePublished(Util.ClearPath(Path) + "/" + NewFileName,SiteFolder,transcode_channel.getSite());
			
		
				/*
				String newfilefullname = Util.ClearPath( Path + "/" + NewFileName);				
				HashMap hash = VideoUtil.getSize(RealPath + "/" +NewFileName);
				int w = (Integer)hash.get("width");
				int h = (Integer)hash.get("height");
				if(w!=0) width = w;
				if(h!=0) height = h;

				ReturnValue = newfilefullname;
				Publish publish = new Publish();
				publish.InsertToBePublished(Util.ClearPath(Path + "/" + NewFileName),SiteFolder,channel.getSite());
				*/
			}
		//}
    } 
}
}catch(Exception e){ e.printStackTrace();videoUrl="error:" + e.getMessage();}

if(videoUrl.startsWith("error:"))
{
	out.println(videoUrl);
}
else
{
	videoUrl = Util.base64(Util.ClearPath(videoUrl));
%>
<div style="width:480px; height:360px;margin:0 auto;" align="center">
<span id="tide_video" photoid="">
<script>
showPlayer({video:"<%=(videoUrl)%>"});
</script>
</span>
</div>
<%}%>
