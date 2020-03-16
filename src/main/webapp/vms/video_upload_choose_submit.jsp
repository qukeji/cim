<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.publish.*,
				tidemedia.cms.video.*,
				tidemedia.cms.user.*,
				org.json.JSONArray,
				org.json.JSONObject,
				java.sql.*,
				java.util.*,
				java.io.File,
				org.apache.commons.fileupload.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/*
*		创建人/修改人		最后修改时间		备注
*		郭庆光				20130621			vms中选择视频功能 最后处理程序，需配置系统参数local_video_path,视频在服务器中目录
*		郭庆光				20130702			修改 Photo字段	
*		王海龙				20131122			添加服务器上传视频不转码功能
*/


	int userid = 0;
	int ChannelID			= 0;
	int  copy = 2;//默认不复制
	String videotype        = "";//转码格式
	String videotype2       ="";//不转码
	String transcode_need   ="";//是否需要转码
	String ReturnValue		= "";
	String filepathname="";	
	String filename="";
	String filepath="";
	String url = "";//视频地址
    String root = "";//视频根目录
    String folderName = "";//视频子目录
	
	ChannelID=getIntParameter(request,"ChannelID");//选择视频时的频道id
	videotype=getParameter(request,"videotype");//转码格式
	filename =getParameter(request,"filename");//视频文件名
	root =getParameter(request,"root");//视频路径
	folderName =getParameter(request,"foldername");//视频路径
	userid   =getIntParameter(request,"userid");//选择人的id
	videotype2 = getParameter(request,"videotype2");//视频码率
	transcode_need = getParameter(request,"transcode_need");//是否需要转码
	copy = getIntParameter(request,"copy");//1复制，2不复制
	url = getParameter(request,"url");
	filepath = root+"/"+folderName;
	
	String Photo = "";
	int transcode_channelid = CmsCache.getParameter("sys_channelid_transcode").getIntValue();
	Channel channel = CmsCache.getChannel(transcode_channelid);
	String Path = channel.getRealImageFolder();
	String SiteFolder = channel.getSite().getSiteFolder();
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


	String[] files = filename.split(",");
	for(int j=0;j<files.length;j++){	
		
        //filename = files[j]; 
		String FileName = files[j];
		filepathname = filepath+"/"+FileName;//视频在服务器中的绝对路径
     
		FileName = FileName.substring(FileName.lastIndexOf("\\")+1);
		//int index = FileName.lastIndexOf(".");
		if(!FileName.equals(""))
		{
            
			CmsFile cmsfile = new CmsFile();
			String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId());
		    File uploadedFile = new File(RealPath + "/" +NewFileName);
			//通过ffmpeg获取视频文件的信息
			//System.out.println(filepathname+"==filePathNamewhl");
			//String ffmpeg =tj.getString("ffmpeg")+" -i "+ Util.ClearPath(RealPath + "/" +NewFileName);
			 
			String ffmpeg =tj.getString("ffmpeg")+" -i "+ Util.ClearPath(filepathname);
			
			HashMap mapInfo =  VideoUtil.getVideoInfo(ffmpeg);
		    //item.write(uploadedFile);			
	    
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
			// System.out.println("path2:"+Path2+",onlyfilename:"+onlyfilename);
			Photo = SiteUrl2 + Path2 + "/" + onlyfilename;
			//先创建一个文章 获取其itemid 和globalid
			HashMap map_new = new HashMap();
			map_new.put("Title",FileName+"");
			// System.out.println("==="+NewFileName);
			map_new.put("tidecms_addGlobal","1");
			map_new.put("User",userinfo_session.getId()+"");
			
			//视频信息
			String timeInfo = mapInfo.get("Duration").toString();
			int dur = VideoUtil.getTime(timeInfo);
			map_new.put("Duration",dur+"");
			map_new.put("ml",mapInfo.get("Bitrate"));
			map_new.put("bmfs",mapInfo.get("VideoType"));
			map_new.put("fbl",mapInfo.get("WidthHeight"));
			map_new.put("zl",mapInfo.get("Fps"));			
			
			int gid_new = util.addItem(ChannelID,map_new).getGlobalID();//转码频道

			Document doc = new Document(gid_new);
            FileUtil fileutil = new FileUtil();  
			
			//判断是否需要转码
			if(transcode_need.equals("0")){
				//System.out.println("tratranscode_needn="+transcode_need);
				HashMap map = new HashMap();
				
				map.put("video_source",ReturnValue);				
				map.put("video_source_size",uploadedFile.length()+"");
				map.put("Photo",Photo);
				util.updateItemByGid(ChannelID,map,gid_new,0);
				int[] t = Util.StringToIntArray(videotype,",");

				for(int i = 0;i<t.length;i++)
				{
					// System.out.println("======videotype:==="+videotype);
					String video_dest = "";
					if(m!=-1)
						video_dest = ReturnValue.substring(0,m) + "_" + t[i] + "." + (String)map_ext.get(t[i]+"");
				
					HashMap map2 = new HashMap();
					map2.put("Title",doc.getTitle());
					map2.put("video_type",t[i]+"");
					map2.put("video_dest",video_dest);
					map2.put("User",userinfo_session.getId()+"");
					map2.put("tidecms_addGlobal","1");
					map2.put("Parent",gid_new+"");
					map2.put("Status","1");
					map2.put("Status2","0");

					if(copy==2)//不复制
					{			
						map2.put("video_source",folderName+"/"+FileName);
						if(url.equals(""))
						{   
							map2.put("video_source_folder",root+"/");
						}
						else
						{//vms和转码不在一台服务器上要配置sys_video,select_folder的url
							map2.put("video_source_folder",url+"/");							
						}
					}
					else
					     map2.put("video_source",ReturnValue);

					int id = util.addItemGetID(transcode_channelid,map2);//转码频道
					// System.out.println("----id-----"+id);
				}
			  if(copy==1)
			   {//复制到转码视频源目录
				  fileutil.copyFile(filepathname,RealPath + "/" +NewFileName);
			   }
			  TranscodeManager tm = TranscodeManager.getInstance();
			  tm.Start();
			 }
			 //不需要转码
			 if(transcode_need.equals("1")){
			    HashMap map2 = new HashMap();
				map2.put("Title",doc.getTitle());
				map2.put("video_source",ReturnValue);
				map2.put("video_type",videotype2);
				map2.put("video_dest",ReturnValue);
				map2.put("Parent",gid_new+"");
				map2.put("filesize",uploadedFile.length()+"");
				map2.put("transcode_time","0");
				map2.put("Status","1");
				map2.put("Status2","2");
			    int id = util.addItemGetID(transcode_channelid,map2);//转码频道
			    fileutil.copyFile(filepathname,RealPath + "/" +NewFileName);//复制转码源视频目录		      
			 }
		     
				//发布
			  Publish publish = new Publish();
			  publish.InsertToBePublished(Util.ClearPath(Path) + "/" + NewFileName,SiteFolder,channel.getSite());
			  PublishManager.getInstance().CopyFileNow();	

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
     

%>
