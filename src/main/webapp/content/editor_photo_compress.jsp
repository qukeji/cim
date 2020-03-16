<%@ page import="org.json.*,tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.net.URL,
				org.apache.commons.io.FileUtils,
				tidemedia.cms.publish.*"%>
<%@ page contentType="text/json;charset=utf-8" %>
<%@ include file="../config.jsp" %>
<%	
		/**
		  *用途：编辑器图片压缩
		  *王海龙 2015/7/29 添加
		  *
		  *
		  */
		response.setContentType("text/json; charset=utf-8");
		String img = getParameter(request,"img");
 		int id= getIntParameter(request,"channelid");
 
		CmsFile cmsfile = new CmsFile();
		Channel channel = CmsCache.getChannel(id);
		String Path = channel.getRealImageFolder();
		String SiteFolder = channel.getSite().getSiteFolder();
		String url = channel.getSite().getExternalUrl2();
		if(img.startsWith(url))
			img = img.replace(url,SiteFolder);
		String FileName = Util.getFileName(img);
		String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),id);
		String file_ = Util.ClearPath(SiteFolder + "/" + Path + "/" + NewFileName);
		String file__ = Util.ClearPath(channel.getSite().getExternalUrl2() + "/" + Path + "/" + NewFileName);
		//String sourceimg = imgSrc.replace("http://221.224.162.180:19880/img/","/web/img/");
		boolean result = FileUtil.compressImage2IM(img,file_,150,0,0);
		if(!result)
		{ 
			//无法直接压缩先下载到服务器
			try
			{
				String file = SiteFolder+"/"+Path+"/"+FileName;
				java.io.File imgFile =  new java.io.File(file);
				FileUtils.copyURLToFile(new URL(img),imgFile);
				result = FileUtil.compressImage2IM(img,file_,150,0,0);
				if(imgFile.exists())
					imgFile.delete();
				
			}
			catch(Exception e)
			{
				
			}
		}
		
		JSONObject obj = new JSONObject();
        if(result)
 		{
 			Publish publish = new Publish();
			publish.InsertToBePublished(Util.ClearPath(Path) + "/" + NewFileName,SiteFolder,channel.getSite());
			PublishManager.getInstance().CopyFileNow();
		    obj.put("img",file__);
 		}
		out.println(obj.toString());	 
 %>
