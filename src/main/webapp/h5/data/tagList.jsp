<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.jsoup.nodes.Element,
				org.jsoup.select.Elements,
				org.jsoup.*,
				java.util.*,
				java.sql.*,
				tidemedia.cms.publish.*,
				java.io.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%!
	public String readToString(String fileName) {  
        String encoding = "UTF-8";  
        File file = new File(fileName);  
        Long filelength = file.length();  
        byte[] filecontent = new byte[filelength.intValue()];  
        try {  
            FileInputStream in = new FileInputStream(file);  
            in.read(filecontent);  
            in.close();  
        } catch (FileNotFoundException e) {  
            e.printStackTrace();  
        } catch (IOException e) {  
            e.printStackTrace();  
        }  
        try {  
            return new String(filecontent, encoding);  
        } catch (UnsupportedEncodingException e) {  
            System.err.println("The OS does not support " + encoding);  
           e.printStackTrace();  
            return null;  
        }  
    }  
	
	public int getRealSourceChannel(int source_category_id){
		int RealChannel=0;
		try{
			 RealChannel=CmsCache.getParameter("relation_h5_source").getJson().getInt(source_category_id+"");
		}catch(Exception e){
			System.out.println(e.toString());
			return 0;
		}
		return RealChannel;
	}
	
	public void publishPhoto(String h5imageFolder,Site site) throws Exception{
		Publish publish = new Publish();
		publish.InsertToBePublished(Util.ClearPath(h5imageFolder),site.getSiteFolder(),site);
		PublishManager.getInstance().CopyFileNow();						
	}
	
	public void insertSource(int source_category_id,HashMap map)throws Exception{
		ItemUtil tu=new ItemUtil();
		tu.addItemGetGlobalID(source_category_id,map);
	}
	
	public int isExistSource(int Realchannelid,int sourceid)throws Exception{
		int id=0;
		TableUtil tu=new TableUtil();
		String sql="select * from "+CmsCache.getChannel(Realchannelid).getTableName()+" where sourceid="+sourceid+" and active=1 ";
		ResultSet rs=tu.executeQuery(sql);
		if(rs.next()){
			id=rs.getInt("id");
		}
		tu.closeRs(rs);
		return id;
	}

%>
<%
	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();// 图片及图片库配置
	int sys_channelid_image = photo_config.getInt("channelid");
	Channel channel = CmsCache.getChannel(sys_channelid_image);
	Site site = channel.getSite();
	String SiteUrl = site.getExternalUrl2();//访问目录
//	String SiteFolder = site.getSiteFolder();
//	String RealPath = SiteFolder + (SiteFolder.endsWith("/") ? "" : "/") + "images/h5/";//服务器真实路径
//	File file = new File(RealPath);
//	if (!file.exists())
//		file.mkdirs();
%>
<%
	int id = getIntParameter(request,"id");
	int page1 = getIntParameter(request,"page");
	int pageNum = getIntParameter(request,"pagenum");

	if (page1 < 1)
		page1 = 1;
	if (pageNum < 1)
		pageNum = 20;

	int Realchannelid=getRealSourceChannel(id);//H5编辑器资源库频道

	JSONObject json=new JSONObject() ;

	TableUtil tu=new TableUtil();
	String Listsql="select Title,sourceid,FROM_UNIXTIME(PublishDate) as PublishDate,Content from "+CmsCache.getChannel(Realchannelid).getTableName()+" where category="+Realchannelid+" and active=1 order by update_time desc ";
	String Countsql="select  count(*) from "+CmsCache.getChannel(Realchannelid).getTableName()+" where category="+Realchannelid+" and active=1 order by update_time desc";

	ResultSet rs = tu.List(Listsql,Countsql,page1,pageNum);
	int TotalNumber = tu.pagecontrol.getRowsCount();

	json.put("errcode",0);
	json.put("message","返回成功");
	json.put("totalCount",TotalNumber);

	JSONArray data=new JSONArray();
	while(rs.next()){
		String update_time=rs.getString("PublishDate");
		String sourceid=rs.getString("sourceid");
		String Content=rs.getString("Content");
		String title=rs.getString("title");

		org.jsoup.nodes.Document doc = Jsoup.parse(Content);
		//img标签图片本地化
		int j = 0 ;
		Elements elements = doc.getElementsByTag("img");
		for(Element element : elements){
			String img = element.attr("src") ;//img地址
			if(!img.equals("")&& !img.startsWith("http")){
				element.attr("src", SiteUrl+img);//替换为http路径
			}
		}

		//url背景图片本地化
		int n = 0 ;
		Elements allelements = doc.getElementsByAttribute("style");
		for(Element element : allelements){
			String style = element.attr("style");//style样式
			if(style.indexOf("url(")!=-1){
				String img_url = style.substring(style.indexOf("url")+4);//背景图地址
				if(img_url.startsWith("'")||img_url.startsWith("\"")){
					img_url = img_url.substring(1,img_url.indexOf(")")-1);
				}else{
					img_url = img_url.substring(0,img_url.indexOf(")"));
				}
				if(!img_url.equals("")&& !img_url.startsWith("http")){
					style = style.replace(img_url, SiteUrl+img_url);
					element.attr("style", style);
				}
			}
		}
		Content = doc.body().html();
		JSONObject obj=new JSONObject();
		obj.put("title",title);
		obj.put("id",sourceid);
		obj.put("style",Content);
		obj.put("update_time",update_time);
		obj.put("create_date",update_time);
		data.put(obj);
	}
	tu.closeRs(rs);
	json.put("data",data);
	out.println(json);

	/*
	String tomcatPath = request.getRealPath("/");
	String filepath = tomcatPath+"/h5/data1218/tagList_"+id+"_"+page1+".txt";
	//out.println("filepath："+filepath+"<br><br>");
	File fileSource=new File(filepath);
	String result = readToString(filepath);
	JSONObject json=new JSONObject() ;
	boolean filevaild=true;
	try{
		json = new JSONObject(result);
	}catch(Exception e){
		filevaild=false;
	}
	
	boolean fileexist=true;
	if(filevaild){//txt存在
	    if(json.getInt("errcode")==0&&json.getInt("totalCount")>0){//说明有数据

	        JSONArray arr = json.getJSONArray("data");
	        for(int i=0;i<arr.length();i++){
					
	            JSONObject json_message = arr.getJSONObject(i);
				int img_id = json_message.getInt("id");
				String html = json_message.getString("style");
				org.jsoup.nodes.Document doc = Jsoup.parse(html);

				//img标签图片本地化
				int j = 0 ;
				Elements elements = doc.getElementsByTag("img");
				for(Element element : elements){
					String img = element.attr("src") ;//img地址
					//out.println("img："+img+"<br><br>");
					if(!img.equals("")){
						String img_new = id+"_"+img_id+"_"+(j++)+".png";
						String path = RealPath+"/"+img_new ;
						//out.println("path："+path+"<br><br>");
						File file1 = new File(path);
						if(!file1.exists()){
							Util.downloadFile(img,path);//本地化图片
							publishPhoto("/images/h5/"+img_new,site);
							fileexist=false;
						}
						element.attr("src", "/images/h5/"+img_new);//替换为相对路径
					}
				}

				//url背景图片本地化
				int n = 0 ;
				Elements allelements = doc.getElementsByAttribute("style");
				for(Element element : allelements){
					String style = element.attr("style");//style样式
					if(style.indexOf("url(")!=-1){
						String img_url = style.substring(style.indexOf("url")+4);//背景图地址
						if(img_url.startsWith("'")||img_url.startsWith("\"")){
							img_url = img_url.substring(1,img_url.indexOf(")")-1);
						}else{
							img_url = img_url.substring(0,img_url.indexOf(")"));
						}
						if(!img_url.equals("")){
							String img_new = "style_"+id+"_"+img_id+"_"+(n++)+".png";
							String path = RealPath+"/"+img_new ;
							File file1 = new File(path);
							if(!file1.exists()){
								Util.downloadFile(img_url,path);
								publishPhoto("/images/h5/"+img_new,site);
							}
							style = style.replace(img_url, "/images/h5/"+img_new);
							element.attr("style", style);
						}
					}
				}
						
				int id1=isExistSource(Realchannelid,img_id);
				//out.println("id1："+id1+"<br><br>");
				String content = doc.body().html().replaceAll("微小宝","").replaceAll("weixiaobao","").replaceAll("wxb","").replaceAll("WXB","");
				if(id1==0){
				    HashMap map=new HashMap ();
					map.put("Title",id+"_"+img_id+"_"+page1);
					map.put("sourceid",img_id+"");
					map.put("Content",content);
					insertSource(Realchannelid,map);
				}else{
					HashMap map=new HashMap ();
					map.put("Content",content);
					ItemUtil tu=new ItemUtil();
					tu.updateItemById(Realchannelid,map,id1,10);
				}
				json_message.put("style", doc.body().html());
			}
		}
		if(fileexist)fileSource.renameTo(new File(filepath+"_move"));
	}else{

		TableUtil tu=new TableUtil();

		String Listsql="select Title,sourceid,FROM_UNIXTIME(PublishDate) as PublishDate,Content from "+CmsCache.getChannel(Realchannelid).getTableName()+" where category="+Realchannelid+" order by OrderNumber asc ";
		String Countsql="select  count(*) from "+CmsCache.getChannel(Realchannelid).getTableName()+" where category="+Realchannelid+" order by OrderNumber asc";

		ResultSet rs = tu.List(Listsql,Countsql,page1,10);

		int TotalNumber = tu.pagecontrol.getRowsCount();

		json.put("errcode",0);
		json.put("message","返回成功");
		json.put("totalCount",TotalNumber);

		JSONArray data=new JSONArray();
		while(rs.next()){
			String update_time=rs.getString("PublishDate");
			String sourceid=rs.getString("sourceid");
			String style=rs.getString("Content");
			String title=rs.getString("title");

			org.jsoup.nodes.Document doc = Jsoup.parse(style);

			JSONObject obj=new JSONObject();
			obj.put("title",title);
			obj.put("id",sourceid);
			obj.put("style",style);
			obj.put("update_time",update_time);
			obj.put("create_date",update_time);
			data.put(obj);
		}
		tu.closeRs(rs);
		json.put("data",data);
		
	}
	out.println(json);
	*/
%>
