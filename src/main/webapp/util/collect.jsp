<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.jsoup.nodes.Element,
				org.jsoup.select.Elements,
				org.jsoup.*,
				java.util.*,
				java.io.*,java.sql.*,
				java.net.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	static String localDir = "";//本地保存目录
	static String path = "";//访问地址
	static JSONArray arr = null;
	static String token = "";

	//初始化目录
	public static void init1(){
		try {
			TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置		
			int sys_channelid_image = photo_config.getInt("channelid");			
			Site site = CmsCache.getChannel(sys_channelid_image).getSite();					
			String SiteFolder = site.getSiteFolder();	
			String Path = CmsCache.getChannel(sys_channelid_image).getRealImageFolder();         	
			localDir = SiteFolder + (SiteFolder.endsWith("/")?"":"/") + Path;			
			path = site.getExternalUrl()+Path;						
			arr = CmsCache.getParameter("collects").getJson().getJSONArray("collects");						
			token = CmsCache.getParameter("tide_token").getContent();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	//判断文章是否已存在
	public static boolean exists(int channelid,int id){
		boolean chongfu = false ;
		try{
			//检测标题是否存在
			TableUtil tu = new TableUtil();
			Channel channel = CmsCache.getChannel(channelid);
			String sql = "select id from " + channel.getTableName() + " where Category="+channelid+" and source_id=" + id + " and Active=1";
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next())
			{
				chongfu = true;
			}
			tu.closeRs(rs);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return chongfu ;
	}
	//采集文章内容页入库
	public static void getDocument(JSONArray arr,int channelId){
		try{
			for(int j=0;j<arr.length();j++){
				JSONObject json_item = (JSONObject) arr.get(j);

				int id  = json_item.getInt("id");
				if(exists(channelId,id)){//说明以获取过此活动
					continue;
				}
				String title  = json_item.getString("Title");
				String SpiderUrl  = json_item.getString("SpiderUrl");
				String from  = json_item.getString("from");
				String Content  = json_item.getString("Content");
				//String Summary  = json_item.getString("Summary");
				String Photo  = json_item.getString("Photo");
				if(!Photo.equals("")){
					String target = System.currentTimeMillis()+".jpeg";
					Util.downloadFile(Photo,localDir+target);
					Photo = path+target ;
				}
				String content = "";
				if(!Content.equals("")){
					Content = "<div id='js_content'>"+Content+"</div>";
					Element js_content = Jsoup.parse(Content);
					//处理图片
					Elements eles = js_content.getElementsByTag("img");//js_content.children();
					int n=0;
					for(Element element:eles){
						String img = element.attr("data-src");
						//System.out.println(img);
						if(!img.equals("")){
							String target2 = System.currentTimeMillis()+"_"+(n++)+".jpeg";
							Util.downloadFile(img,localDir+target2);
							element.getElementsByTag("img").attr("src",path+target2);
						}						
					}
					//处理视频
					Elements eles_video = js_content.getElementsByTag("iframe");
					for(Element element1:eles_video){
						String video = element1.attr("data-src");
						if(!video.equals("")){
							element1.getElementsByTag("iframe").attr("src",video);
						}						
					}
					content = js_content.toString();
				}

				HashMap<String, String> log = new HashMap<String, String>();
				log.put("Title", title);
				log.put("SpiderUrl", SpiderUrl);
				log.put("Photo", Photo);
				log.put("Content", content);
				log.put("source_id", id+"");
				log.put("DocFrom", from);
				log.put("tidecms_addGlobal", "1");
				try{
					int itemId = ItemUtil.addItemGetID(channelId,log);
					Document document = new Document();
					document.Approve(itemId+"",channelId);
				}catch(Exception e){
					continue;
				}
			}

		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static int getItemId(int channelId){
		int source_id = 0;
		try{
			TableUtil tu = new TableUtil();
			Channel channel = CmsCache.getChannel(channelId);
			String sql = "select source_id from " + channel.getTableName() + " where Active=1 and Category="+channelId+" order by source_id desc";
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next())
			{
				source_id = rs.getInt("source_id");
			}
			tu.closeRs(rs);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return source_id ;
	}
%>

<%

	int itemID = 0;//上次同步文章编号	


	//初始化
	init1();
	//System.out.println("arr:"+arr);
	for(int i=0;i<arr.length();i++){	
		JSONObject weixin_json = (JSONObject) arr.get(i);	
		String key = weixin_json.getString("cloudid");//云采集频道编号
		int channelId = weixin_json.getInt("channelId");//入库编号
		int type = weixin_json.getInt("type");//线索汇聚1，热点2，
		itemID = getItemId(channelId);
		String url = "http://115.29.150.217:888/cms_cloud/api/getitems_.jsp?id="+key+"&itemID="+itemID+"&Token="+token+"&type="+type;		
		String result = Util.connectHttpUrl(url);//同步接口返回值
		JSONObject json = new JSONObject(result);
		if(json.getInt("code")==200){//请求成功
			JSONArray arr = json.getJSONArray("list");		 
//			//out.println(arr.length()+"<br>");
			//采集文章入库
			getDocument(arr,channelId);
			Log.SystemLog("采集调用", "入库频道："+channelId+";请求接口："+url+";请求结果：成功");
		}else{
			Log.SystemLog("采集调用", "请求接口："+url+";请求结果："+json.getString("message"));
		}		

	}
%>
