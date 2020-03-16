<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.publish.*,
				java.nio.charset.Charset,
				java.net.URLDecoder,
				java.util.*,
				java.sql.*,
				java.io.*,
				org.json.*,
				org.jsoup.*,
				org.jsoup.nodes.Element,
				org.jsoup.select.Elements"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%
	init1();//初始化参数
	handleDate(request);
%>
<%!
    static String localDir = "";//本地保存目录
	static String path = "";//访问地址
	static Site site =null;
	static String SiteFolder = "";
	static String imageFolder="";

	public void init1(){
		try {
			TideJson photo_config  = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
			int sys_channelid_image = photo_config.getInt("channelid");
			site = CmsCache.getChannel(sys_channelid_image).getSite();
			SiteFolder = site.getSiteFolder();
			imageFolder = CmsCache.getChannel(sys_channelid_image).getRealImageFolder();
			localDir = SiteFolder  + imageFolder;
			path = site.getExternalUrl()+imageFolder;
		} catch (MessageException e) {
			e.printStackTrace();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	//判断文章是否已存在
	public static Integer isexist(int channelid,String news_uuid){
		int id = 0; 
		try{
			//检测标题是否存在
			TableUtil tu = new TableUtil();
			Channel channel = CmsCache.getChannel(channelid);
			String sql = "select id from " + channel.getTableName() + " where Category="+channelid+" and news_uuid='" + tu.SQLQuote(news_uuid) + "' and Active=1";
			//System.out.println("sql:"+sql);
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next())
			{
				id = rs.getInt("id");
			}
			tu.closeRs(rs);
		}catch (Exception e) {
			e.printStackTrace();
		}
		return id ;
	}
	public JSONObject handleDate(HttpServletRequest request) throws IOException, JSONException, MessageException, SQLException {
        JSONObject jsonObject = new JSONObject();
        if("POST".equals(request.getMethod())){
            BufferedReader streamReader = new BufferedReader( new InputStreamReader(request.getInputStream()));
            StringBuilder responseStrBuilder = new StringBuilder();
            String inputStr;
            while ((inputStr = streamReader.readLine()) != null) responseStrBuilder.append(inputStr);
            JSONObject json = new JSONObject(responseStrBuilder.toString());
            jsonObject = enteringDate(json);
        }else{
            jsonObject.put("message","请求方式不对");
            jsonObject.put("code",500);
        }
        return jsonObject;
    }
    //重复入库时更新点赞数，阅读数
	public void updateDocument(int itemid,int channelid,int news_read_count,int news_like_count) throws MessageException, SQLException {
		String tableName = CmsCache.getChannel(channelid).getTableName();
		TableUtil tu = new TableUtil();
		String sql = "update "+tableName+" set news_read_count="+news_read_count+",news_like_count="+news_like_count+",Status=1 where id="+itemid;
		tu.executeUpdate(sql);
	}
	public JSONObject enteringDate(JSONObject data) throws MessageException, SQLException, JSONException {

	    String sourceType = data.getString("sourceType");//來源
		TideJson hot_channel= CmsCache.getParameter("spider_source_parentid").getJson();
		Integer parent_channelid = hot_channel.getInt(sourceType);
		String channelName =data.getString("channelName");
		Integer channelid= 0;
		String sql="select id from channel where Name ='"+channelName+"' and parent="+parent_channelid;
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next()){
			channelid = rs.getInt("id");
		}
		tu.closeRs(rs);

		if(channelid==0){
			return null;
		}
		

		HashMap<String,String> mapParam = new HashMap<String, String>();
		String globalid =  data.getString("globalid");
		String news_uuid = data.getString("news_uuid");
		String article_author =data.getString("article_author");

		int news_read_count = Util.parseInt(data.getString("news_read_count"));
		int news_like_count = Util.parseInt(data.getString("news_like_count"));
		
		mapParam.put("news_read_count",news_read_count+"");
		mapParam.put("news_like_count",news_like_count+"");

		if(!news_uuid.equals("")){//uuid不为空，说明是微信采集，判断是否重复入库
			int itemid = isexist(channelid,news_uuid);
			if(itemid!=0){//说明重复文章入库,更新
				/*mapParam.put("Status", "1");
				ItemUtil.updateItemById(channelid, mapParam, itemid, 1);*/
				//用sql更新点赞数，阅读数
				updateDocument(itemid,channelid,news_read_count,news_like_count);
				Document document = new Document();
				document.setUser(1);
				document.Approve(itemid+"",channelid);
				return null;
			}
		}

        String Title =data.getString("Title");
		String DocFrom = data.getString("DocFrom");
		String SpiderUrl =data.getString("SpiderUrl");
		String Summary = data.getString("Summary");
		String Photo =data.getString("Photo");
		String Content = data.getString("Content");

		if(!Photo.equals("")){
		    String suffix = Photo.substring(Photo.lastIndexOf("."),Photo.length());
			String target = System.currentTimeMillis()+"."+suffix;
			if(Util.downloadFile(Photo,localDir+"/"+target)){
			    Publish publish = new Publish();
    			publish.InsertToBePublished(Util.ClearPath(imageFolder) + "/" + target,SiteFolder,site);
    			PublishManager.getInstance().CopyFileNow();
			}
			Photo = path+"/"+target;
		}

		String content = "";
		if(!Content.equals("")){
			Content = "<div id='js_content'>"+Content+"</div>";
			Element js_content = Jsoup.parse(Content);
			//处理图片
			Elements eles = js_content.getElementsByTag("img");//js_content.children();
			int n=0;
			for(Element element:eles){
				String img = element.attr("src");
				if(!img.equals("")){
				    String suffix2 = img.substring(img.lastIndexOf("."),img.length());
					String target2 = System.currentTimeMillis()+"_"+(n++)+"."+suffix2;
					if(Util.downloadFile(img,localDir+"/"+target2)){
			            Publish publish = new Publish();
    			        publish.InsertToBePublished(Util.ClearPath(imageFolder) + "/" + target2,SiteFolder,site);
    			        PublishManager.getInstance().CopyFileNow();
		        	}
					element.getElementsByTag("img").attr("src",path+"/"+target2);
				}						
			}
			//处理视频
			Elements eles_video = js_content.getElementsByTag("iframe");
			for(Element element1:eles_video){
				String video = element1.attr("src");
				if(!video.equals("")){
					element1.getElementsByTag("iframe").attr("src",video);
				}						
			}
			content = js_content.toString();
		}
				
		mapParam.put("DocFrom",DocFrom);
		mapParam.put("globalid",globalid);
		mapParam.put("SpiderUrl",SpiderUrl);
		mapParam.put("Content",content);
		mapParam.put("Summary",Summary);
		mapParam.put("Photo",Photo);
		mapParam.put("Title",Title);
		mapParam.put("Status",1+"");
		mapParam.put("article_author",article_author);		
		mapParam.put("news_uuid", news_uuid);//文章唯一标识

		ItemUtil its = new ItemUtil();
		int gid = its.addItemGetGlobalID(channelid, mapParam);//根据频道id入库微博数据

		int itemId = CmsCache.getDocument(gid).getId();
		int channelId = CmsCache.getDocument(gid).getChannelID();
		Document document = new Document();
		document.setUser(1);
		document.Approve(itemId+"",channelId);

		return null;
    }
%>

