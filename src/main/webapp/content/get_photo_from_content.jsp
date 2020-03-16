<%@ page import="org.jsoup.Jsoup,
				org.jsoup.select.Elements,
				org.json.*,
				org.jsoup.nodes.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				org.apache.commons.io.FileUtils,
				java.net.URL,tidemedia.cms.publish.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/**
		  *用途：编辑器图片压缩
		  *王海龙 2015/7/29 修改
		  *
		  *
		  */
	String content	=   getParameter(request,"content");
	int	channelid	=  getIntParameter(request,"channelid");

	//图片库
	 TideJson tj = CmsCache.getParameter("sys_config_photo").getJson();
	 //{"channelid":"14296","force_httpurl":"1"}
	 channelid = tj.getInt("channelid");

	JSONArray array = new JSONArray();
	org.jsoup.nodes.Document document =Jsoup.parse(content);  

	Elements elements = document.getElementsByTag("img");  
	
	if(elements.size()==1)
	{
		JSONObject obj = new JSONObject();
        //获取每个img标签的src属性的内容，即图片地址，加"abs:"表示绝对路径  
        String imgSrc = elements.get(0).attr("abs:src");  
		CmsFile cmsfile = new CmsFile();
		Channel channel = CmsCache.getChannel(channelid);
		String Path = channel.getRealImageFolder();
		String SiteFolder = channel.getSite().getSiteFolder();
		String FileName = Util.getFileName(imgSrc);
		String NewFileName = cmsfile.getNewFileName(FileName,Path,userinfo_session.getId(),channelid);
		String file_ = Util.ClearPath(SiteFolder + "/" + Path + "/" + NewFileName);
		String url = channel.getSite().getExternalUrl2();
		String file__ = Util.ClearPath(url + "/" + Path + "/" + NewFileName);
		if(imgSrc.startsWith(url))//图片地址是客户自己的，但是不能再服务器上wget
			imgSrc = imgSrc.replace(url,SiteFolder);
		//String sourceimg = imgSrc.replace("http://221.224.162.180:19880/img/","/web/img/");
		boolean result = FileUtil.compressImage2IM(imgSrc,file_,150,0,0);
		if(!result)
		{//无法直接压缩先下载到服务器
			try
			{
				String file = SiteFolder+"/"+Path+"/"+FileName;
				java.io.File imgFile =  new java.io.File(file);
				FileUtils.copyURLToFile(new URL(imgSrc),imgFile);
				result = FileUtil.compressImage2IM(file,file_,150,0,0);
				if(imgFile.exists())
					imgFile.delete();
				
			}
			catch(Exception e)
			{
				
			}
		}
		if(result)
		{

            Publish publish = new Publish();
			publish.InsertToBePublished(Util.ClearPath(Path) + "/" + NewFileName,SiteFolder,channel.getSite());
			PublishManager.getInstance().CopyFileNow();
			obj.put("img",file__);
			array.put(obj);
     	} 
	}
	 else if(elements.size()>1)
	{
		//编辑器多图
		 for(Element element : elements)
   		 {  
   		 	JSONObject obj = new JSONObject();
       		 //获取每个img标签的src属性的内容，即图片地址，加"abs:"表示绝对路径  
       	    String imgSrc = element.attr("abs:src");  
       	    obj.put("img",imgSrc);
			array.put(obj);
   		 }
	}
	out.println(array.toString());
%>
