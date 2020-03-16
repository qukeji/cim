<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*,
				java.util.*,
				magick.*,
				java.io.File,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%!
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
%>
<%
/**
*		修改人		修改时间		备注
*		郭庆光		20130702		修改 Photo字段
*		张赫东      2013/7/19       修改 Photo地址
*			
**/
//System.out.println("12---2------:");
DiskFileUpload upload = new DiskFileUpload();

String tempPath			= "";
String FolderName		= "";
String fieldname2		= "";
String ReturnValue		= "";
String ReturnValue2		= "";
String Type				= "";
String Watermark		= "";
String Client			= "";
String transcode_need	= "";//是否需要转码
String videotype2		= "";//不转码时对应的格式
int ChannelID			= 0;
int itemid				= 0;//文档编号
int globalid			= 0;
String videotype		= "";



String browser			= "";
String Username			= "";
String Password			= "";
boolean isCan			=false;

tidemedia.cms.system.Site defaultSite = tidemedia.cms.system.CmsCache.getDefaultSite();

tempPath = request.getRealPath("/temp");

upload.setSizeThreshold(16000);
upload.setSizeMax(-1);
upload.setRepositoryPath(tempPath);
upload.setHeaderEncoding("UTF-8");
java.util.List items;

//try{
items = upload.parseRequest(request);
//}
//catch(org.apache.commons.fileupload.FileUploadException e){}

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
		else if(FieldName.equals("itemid"))
			itemid = getIntParameter(item.getString());
		else if(FieldName.equals("globalid"))
			globalid = getIntParameter(item.getString());
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
		else if(FieldName.equals("videotype"))
			videotype = item.getString();
		else if(FieldName.equals("transcode_need"))
			transcode_need = item.getString();
		else if(FieldName.equals("videotype2"))
			videotype2 = item.getString();
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

//System.out.println("13---2------:"+userinfo_session.getId());
String Photo = "";
int transcode_channelid = CmsCache.getParameter("sys_channelid_transcode").getIntValue();

if(isCan){

Channel channel = CmsCache.getChannel(transcode_channelid);
String Path = channel.getRealImageFolder();
String SiteFolder = channel.getSite().getSiteFolder();
String RealPath = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;
//System.out.println("RealPath:"+RealPath);
File file = new File(RealPath);

HashMap map_ext = new HashMap();
//String p_video_type = CmsCache.getParameterValue("sys_video_type");
//JSONObject ooo = new JSONObject(p_video_type);
//JSONArray o = ooo.getJSONArray("birate");

TideJson tj = CmsCache.getParameter("sys_video").getJson();
JSONArray o = new JSONArray(tj.getString("birate"));
for(int i =0;i<o.length();i++)
{
	JSONObject oo = o.getJSONObject(i);
	map_ext.put(oo.getString("value"),oo.getString("ext"));
}

if(!file.exists())
		file.mkdirs();

iter = items.iterator();
while (iter.hasNext()) {
    FileItem item = (FileItem) iter.next();

    if (!item.isFormField()) {
		String FieldName = item.getFieldName();
		String FileName = item.getName();
		String FileExt = "";
//System.out.println("FileName----------=="+FileName);
//System.out.println(new String(FileName.getBytes("ISO-8859-1"),"gbk"));
		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);

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
			String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId());
		    File uploadedFile = new File(RealPath + "/" +NewFileName);
		    item.write(uploadedFile);
			//System.out.println("newfilename---------:"+NewFileName);
		
			//图片域名先使用转码频道所在的站点的外部正式域名
			ReturnValue = Util.ClearPath(Path + "/" + NewFileName);
			int m = ReturnValue.lastIndexOf(".");
			
			ItemUtil util = new ItemUtil();

			TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
			if(photo_config==null){Log.SystemLog("转码系统", "图片及图片库没有配置");return;}
			int sys_channelid_image = photo_config.getInt("channelid");
			Channel channel2 = CmsCache.getChannel(sys_channelid_image);
			Site site2 = channel2.getSite();
			String Path2 = channel2.getRealImageFolder();
			String SiteUrl2 = site2.getExternalUrl();
			String fileext = Util.getFileExt(ReturnValue);//获取文件扩展名
			String onlyfilename = NewFileName.replace("."+fileext, "_0.jpg");
			//System.out.println("path2:"+Path2+",onlyfilename:"+onlyfilename);
			Photo = SiteUrl2 + Path2 + "/" + onlyfilename;
			
			//先创建一个文章 获取其itemid 和globalid
			HashMap map_new = new HashMap();
			map_new.put("Title",FileName+"");
			//System.out.println("==="+NewFileName);
			map_new.put("tidecms_addGlobal","1");
			map_new.put("User",userinfo_session.getId()+"");
			int gid_new = util.addItem(ChannelID,map_new).getGlobalID();//转码频道
			//System.out.println("======gid_new:=ChannelID=="+gid_new+"--"+ChannelID);
			Document doc = new Document(gid_new);
			
			if(transcode_need.equals("0"))
			{
				
				HashMap map = new HashMap();
				
				map.put("video_source",ReturnValue);
				map.put("video_source_size",uploadedFile.length()+"");
				map.put("Photo",Photo);
				util.updateItemByGid(ChannelID,map,gid_new,0);
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
					map2.put("Parent",gid_new+"");
					map2.put("Status","1");
					map2.put("Status2","0");
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
				map2.put("Parent",globalid+"");
				map2.put("filesize",uploadedFile.length()+"");
				map2.put("transcode_time","0");
				map2.put("Status","1");
				map2.put("Status2","2");
				int id = util.addItemGetID(transcode_channelid,map2);//转码频道

//				已作废 2013/8/26 张赫东				
//				String api = TranscodeConfig.getApi();
//				if(api.length()>0)
//					Util.connectHttpUrl(api+"?itemid="+id, true);

			}

			String FileFullPath = Util.ClearPath(channel.getSite().getUrl() + Path + "/" + NewFileName);

			//发布
			Publish publish = new Publish();
			publish.InsertToBePublished(Util.ClearPath(Path) + "/" + NewFileName,SiteFolder,channel.getSite());
		
			Log l = new Log();
		
			l.setTitle(doc.getTitle());
			
			l.setUser(userinfo_session.getId());
			l.setItem(doc.getId());
			l.setLogType("上传视频");
			l.setFromType("channel");
			l.setFromKey(ChannelID + "");
			l.Add();
		}
		}
    } 
}
%>