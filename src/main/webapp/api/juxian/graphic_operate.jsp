<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.publish.*,
				org.json.*,
				org.jsoup.nodes.Element,
				org.jsoup.select.Elements,
				org.jsoup.*,
				org.apache.commons.lang.StringEscapeUtils,
				java.io.*,
				java.util.*,
				java.sql.ResultSet,
				java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
/*
添加编辑图片
*/
try {
	out.print((handleDate(request).toString()));
} catch (Exception e) {
	JSONObject  jsonObject = new JSONObject();
	jsonObject.put("code","500");
	jsonObject.put("message","异常:");
	out.println(jsonObject.toString());
	e.printStackTrace();
}
%>
<%!
static String localDir = "";//本地保存目录
static String path = "";//访问地址
static Site site =null;
static String SiteFolder = "";
static String imageFolder="";

public static void init1(){
	try {
		TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置		
		int sys_channelid_image = photo_config.getInt("channelid");			
		site = CmsCache.getChannel(sys_channelid_image).getSite();		
			 
		SiteFolder = site.getSiteFolder();	
		imageFolder = CmsCache.getChannel(sys_channelid_image).getRealImageFolder();         	
		localDir = SiteFolder  + imageFolder;			
		path = site.getExternalUrl()+imageFolder;						
	} catch (Exception e) {
		e.printStackTrace();
	}
}

public JSONObject handleDate(HttpServletRequest request) throws Exception{
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


public JSONObject enteringDate(JSONObject data) throws Exception {
	if("".equals(localDir)||"".equals(path)){
		 init1();  
	}

	JSONObject reJson = new JSONObject();

	int  company_id =0;
	if(data.has("company_id")){
		company_id = data.getInt("company_id");
	}

	//获取聚现信息
	String sys_config = CmsCache.getParameterValue("sync_juxian_live");
	JSONObject ConfigObject = new JSONObject(sys_config);
	
	//cms多站点
	JSONArray SiteList = ConfigObject.getJSONArray("list");
	if(SiteList.length()==0){
		reJson.put("code",500);
		reJson.put("message","同步库不存在");
		return reJson;
	}
	//获取cms多站点下对应的媒体号频道
	String CurrentSourceChannel = "";
	for (int i = 0; i < SiteList.length(); i++) {
		JSONObject SiteObject = SiteList.getJSONObject(i);
		int SiteId = SiteObject.getInt("site");
		
		// 判断该文章所属校园号是否有通过审核
		boolean company_exist = false;
		TableUtil tu_company = new TableUtil();
		String sql_company = "select * from channel_company_s" + SiteId + "_info where company_id="+company_id+" and status=1 ";
		ResultSet rs_company = tu_company.executeQuery(sql_company);
		if (rs_company.next()) {
			company_exist = true;
		}
		tu_company.closeRs(rs_company);

		// 校园号已通过审核
		if (company_exist) {
			// 获取媒体号内容管理频道id
			int sourcechannelid = 0;
			TableUtil tu_source = new TableUtil();
			String sql_source = "select id from channel  where SerialNo='company_s" + SiteId + "_source' ";
			ResultSet rs_source = tu_source.executeQuery(sql_source);
			if(rs_source.next()) {
				sourcechannelid = rs_source.getInt("id");
			}
			tu_source.closeRs(rs_source);

			//获取企业对应的内容稿池频道, 取下面全部子频道
			Channel ch = CmsCache.getChannel(sourcechannelid);
			ArrayList<Channel> ListChannel = new ArrayList<Channel>();
			String Sql = "select * from channel where ChannelCode like '"+ ch.getChannelCode() + "%' order by OrderNumber,id";
			TableUtil tu = new TableUtil();
			ResultSet Rs = tu.executeQuery(Sql);
			while (Rs.next()) {
				int j = Rs.getInt("id");
				Channel ch1 = CmsCache.getChannel(j);
				ListChannel.add(ch1);
			}
			tu.closeRs(Rs);
			
			for (Channel chone : ListChannel) {
				if(!chone.getExtra2().startsWith("{")){
					continue;
				}
				JSONObject jsonEx = new JSONObject(chone.getExtra2());
				//企业编号 终端用户
				if((jsonEx.has("company")&&(jsonEx.getInt("company")==company_id))||(jsonEx.has("user")&&(jsonEx.getInt("user")==data.getInt("uid")))){
					if(!CurrentSourceChannel.equals("")){
						CurrentSourceChannel += ",";
					}
					CurrentSourceChannel += chone.getId();
				}
			}
		}
	}

	if(CurrentSourceChannel.equals("")){
		reJson.put("code",500);
		reJson.put("message","同步库不存在");
		return reJson;
	}

	String[] CurrentSourceChannels = CurrentSourceChannel.split(",");
	for(int j=0;j<CurrentSourceChannels.length;j++){
		int CurrentSourceChannel_id = Integer.parseInt(CurrentSourceChannels[j]);//媒体号频道id
		
		//当前时间
		SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		long lt = new Long(data.getString("modify_date"));
		Date date = new Date(lt*1000);
		String dateStr = simpleDateFormat.format(date);
		//数据入库
		HashMap map = new HashMap();
		map.put("Title", data.getString("title"));
		map.put("juxian_companyid", company_id+"");
		map.put("ModifiedDate", dateStr);
		map.put("juxian_user", data.getString("user"));
		map.put("Photo", data.getString("photo"));
		map.put("juxian_sourceid",data.getString("id"));
		map.put("Summary",data.getString("desc"));
		map.put("doc_type","0");

		String Content = data.getString("content");
		Content = StringEscapeUtils.unescapeHtml(Content);
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
				String video = element1.attr("data-src");
				if(!video.equals("")){
					element1.getElementsByTag("iframe").attr("src",video);
				}						
			}
			Content = js_content.toString();
		}
		System.out.println(Content);
		map.put("Content",Content);

		//判断聚现资源是否存在
		TableUtil tu_exist = new TableUtil();
		String sql_exist = "select * from "+CmsCache.getChannel(CurrentSourceChannel_id).getTableName()+" where Category="+CurrentSourceChannel_id+" and juxian_companyid="+company_id+" and juxian_sourceid="+data.getString("id");
		int item_id=0;
		ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
		ItemUtil it = new ItemUtil();
		if (rs_exist.next()) {
			item_id = rs_exist.getInt("id");			
			int globalid = rs_exist.getInt("globalid");
			String ModifyDate = rs_exist.getString("ModifiedDate");
			Long ts = new Long(ModifyDate);
			Long tm = new Long(data.getLong("modify_date"));
			if (ts <tm){
				map.put("ModifiedDate", tm+"");
				it.updateItemByGid(CurrentSourceChannel_id,map,globalid,0);
				if(rs_exist.getInt("status")==1){
					Document document = new Document();//发布
					document.Approve(rs_exist.getString("id"),CurrentSourceChannel_id);
				}
				
				reJson.put("code",200);
				reJson.put("message","更新成功");
			}else{
				reJson.put("code",200);
				reJson.put("message","数据库数据修改时间小于数据修改时间");
			}
		}else{
			map.put("juxian_type",1+"");
			map.put("tidecms_addGlobal","1");
			//it.addItemGetGlobalID(CurrentSourceChannel_id, map);
			item_id = it.addItemGetID(CurrentSourceChannel_id, map);
			reJson.put("code",200);
			reJson.put("message","创建成功");
			
		}
		if(item_id>0)
		{
			Publish publish = new Publish();
			publish.setPublishType(Publish.ONLY_DOCUMENT_PUBLISH);
			publish.setChannelID(CurrentSourceChannel_id);
			publish.setPublishAllItems(0);
			publish.addPublishItems(item_id);
			publish.GenerateFile();
		}
		tu_exist.closeRs(rs_exist);
	}
	return reJson;
}
%>