<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
				com.artofsolving.jodconverter.*,
				com.artofsolving.jodconverter.openoffice.connection.*,
				com.artofsolving.jodconverter.openoffice.converter.*,
				java.text.*,
				java.util.*,
				java.io.*,
				java.sql.*,
				java.net.*,
				org.json.*,
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
*		张赫东		2013/8/22		word导入功能
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

items = upload.parseRequest(request);


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
	TableUtil tu=new TableUtil();
	String Sql = "select * from userinfo where Username='" +tu.SQLQuote(Username) + "' and Password='" +tu.SQLQuote(Password) + "'";
	ResultSet Rs = tu.executeQuery(Sql);
	if(Rs.next())
	{
		userinfo_session.setId(Rs.getInt("id"));
		isCan=true;
	}
	tu.closeRs(Rs);
}

String Photo = "";
int transcode_channelid = CmsCache.getParameter("sys_channelid_transcode").getIntValue();

if(isCan){

Channel channel = CmsCache.getChannel(transcode_channelid);
String Path = channel.getRealImageFolder();
System.out.println("path1="+Path);
String SiteFolder = channel.getSite().getSiteFolder();
String syswordpath = CmsCache.getParameterValue("sys_wordpath");//word 文件在服务器上的位置 配置系统参数
String sys_wordphotopath = CmsCache.getParameterValue("sys_wordphotopath");//word图片文件在服务器上的位置 配置系统参数 例如/web/html/resource
System.out.println("syswordpath:"+syswordpath);
String RealPath = syswordpath + Path;
File file = new File(RealPath);

HashMap map_ext = new HashMap();


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

		String ss ="";
		if(!FileName.equals(""))
		{

			CmsFile cmsfile = new CmsFile();
			String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId());
		    File uploadedFile = new File(RealPath + "/" +NewFileName);
		    item.write(uploadedFile);
			System.out.println("newfilename---------:"+NewFileName);
		
			//图片域名先使用转码频道所在的站点的外部正式域名
			ReturnValue = Util.ClearPath(Path + "/" + NewFileName);
			int m = ReturnValue.lastIndexOf(".");

			
			String wordpath = RealPath+NewFileName;
			System.out.println("wordpath="+wordpath);//word 源文件在服务器上的路径

			if (!wordpath.equals("")){
				// 首先启动服务 在cmd下  执行：cd  C:\Program Files\OpenOffice.org 3\program
				//启动命令：soffice -headless -accept="socket,port=8100;urp; 
				//Linux下的命令：soffice -headless -accept="socket,host=127.0.0.1,port=8100;urp;" -nofirststartwizard &
			String FirstLOC=wordpath;											//生成wrod文件位置
			String LasttLOC=wordpath.substring(0, wordpath.length()-4)+"_0.html";//生成html文件位置
			//System.out.println("LasttLOC="+LasttLOC);
			
			File inputFile = new File(FirstLOC);     
			File outputFile = new File(LasttLOC);  
			OpenOfficeConnection con = new SocketOpenOfficeConnection(8100);   
			
			try {  
				con.connect();  
			} catch (ConnectException e) {  
				System.err.println("文件转换出错，请检查OpenOffice服务是否启动。");  
				e.printStackTrace();  
			}  
			DocumentConverter converter = new OpenOfficeDocumentConverter(con);  
			converter.convert(inputFile, outputFile);  
			con.disconnect(); 
			//复制图片到图片库
			TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
			if(photo_config==null){Log.SystemLog("转码系统", "图片及图片库没有配置");return;}
			int sys_channelid_image = photo_config.getInt("channelid");
			Channel channel2 = CmsCache.getChannel(sys_channelid_image);
			Site site2 = channel2.getSite();
			String Path2 = channel2.getRealImageFolder();
			String SiteUrl2 = site2.getExternalUrl();
			System.out.println("path22="+Path2);
			System.out.println("SiteUrl2="+SiteUrl2);
			String wordphotopath =sys_wordphotopath+Path2;//word 文件生成的图片在服务器上的位置 可以固定 也可以设置成系统参数
			
				File newfile = new File(RealPath);
				File[] files = newfile.listFiles();
				for (int i = 0; i < files.length; i++) {
				  if(!files[i].isDirectory()&&files[i].getName().endsWith("png")){
			  if(files[i].getName().startsWith(NewFileName.substring(0, NewFileName.length()-5)))
				  {
				  		FileUtil fu = new FileUtil();
						fu.copyFile(RealPath+files[i].getName(), wordphotopath+files[i].getName());
				 System.out.println("RealPath="+RealPath+files[i].getName()); 
				 System.out.println("wordphotopath="+wordphotopath+files[i].getName());
			    System.out.println("filesname="+files[i].getName()); 
			  }
		  
		  }
		}

			File f = new File(LasttLOC);
			int ch = 0;  			
			try {
				FileInputStream filein = new FileInputStream(f); 
				InputStreamReader fr = new InputStreamReader(filein);
				while((ch = fr.read())!=-1 )  
				{  
				ss+=(char)ch;				
				}
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			}
			

			ItemUtil util = new ItemUtil();
			
			TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
			if(photo_config==null){Log.SystemLog("转码系统", "图片及图片库没有配置");return;}
			int sys_channelid_image = photo_config.getInt("channelid");
			Channel channel2 = CmsCache.getChannel(sys_channelid_image);
			Site site2 = channel2.getSite();
			String Path2 = channel2.getRealImageFolder();
			//编辑器中图片地址 可获取 也可写成固定的
			String SiteUrl2 = site2.getExternalUrl();
			//String SiteUrl2 = "http://cms.ygcq.com.cn:9028";

			String fileext = Util.getFileExt(ReturnValue);//获取文件扩展名
			String onlyfilename = NewFileName.replace("."+fileext, "_0.jpg");
			//System.out.println("path2:"+Path2+",onlyfilename:"+onlyfilename);
			Photo = SiteUrl2 + Path2 + "/" + onlyfilename;
			String wphoto =SiteUrl2+Path2;

			ss=ss.replace("<IMG SRC=\"","<img src=\""+wphoto);
			System.out.println("11ss="+ss); 

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
				//map.put("Photo",Photo);
				map.put("Content",ss);//word 转换成HTML 加入到编辑器

				util.updateItemByGid(ChannelID,map,gid_new,0);
				int[] t = Util.StringToIntArray(videotype,",");
				for(int i = 0;i<t.length;i++)
				{
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
				
			}

			String FileFullPath = Util.ClearPath(channel.getSite().getUrl() + Path + "/" + NewFileName);

			//发布
			Publish publish = new Publish();
			publish.InsertToBePublished(Util.ClearPath(Path) + "/" + NewFileName,SiteFolder,channel.getSite());
		
			Log l = new Log();
		
			l.setTitle(doc.getTitle());
			
			l.setUser(userinfo_session.getId());
			l.setItem(doc.getId());
			l.setLogType("上传word");
			l.setFromType("channel");
			l.setFromKey(ChannelID + "");
			l.Add();
		}
		}
    } 
}
%>