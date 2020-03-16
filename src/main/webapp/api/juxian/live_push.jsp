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
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html;charset=utf-8" %>

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
//获取PGC资源同步的入库频道
public static JSONObject getPgcChannel(int company_id,int columnid,String columnname) throws MessageException, SQLException, JSONException {

	JSONObject reJson = new JSONObject();

	//获取PGC根频道id
	int pgcGraphicChannelid = 0;
	String channelSql = "select * from channel where application = 'pgc_live'";
	TableUtil tuChannel= new TableUtil();
	ResultSet channelRs= tuChannel.executeQuery(channelSql);
	if(channelRs.next()){
		pgcGraphicChannelid= channelRs.getInt("id");
	}
	tuChannel.closeRs(channelRs);
	if(pgcGraphicChannelid==0){
		reJson.put("zuhu_id",0);
		reJson.put("PgcChannel",0);
		return reJson;
	}

	//获取PGC入库频道（未开启租户，入库到根频道，开启后入库到租户频道）
	int companySystemId  =0;
	int zuhu = CmsCache.getParameter("zuhu").getIntValue();//该系统是否开启多租户 1开启 0未开启
	if(zuhu==1){
		//通过企业编号获取该企业在系统中的对应编号
		TableUtil tuCompany = new TableUtil("user");
		String companySql = "select * from company where JuxianID="+company_id+"  and  jurong = 1";
		ResultSet companyRs = tuCompany.executeQuery(companySql);
		if(companyRs.next()){
			companySystemId = companyRs.getInt("id");
		}
		tuCompany.closeRs(companyRs);
		if(companySystemId==0){
			reJson.put("zuhu_id",companySystemId);
			reJson.put("PgcChannel",0);
			return reJson;
		}

		//判读租户频道是否存在
		String sql_channel = "select * from channel where parent ="+pgcGraphicChannelid+" and company="+companySystemId;
		ResultSet rsChannel= tuChannel.executeQuery(sql_channel);
		if(rsChannel.next()){
			pgcGraphicChannelid = rsChannel.getInt("id");
		}
		tuChannel.closeRs(rsChannel);
		if(pgcGraphicChannelid==0){
			reJson.put("zuhu_id",companySystemId);
			reJson.put("PgcChannel",0);
			return reJson;
		}
	}

	//获取栏目入库频道
	int PgcChannel = 0 ;
	String sourceSql = "select * from channel where parent = "+pgcGraphicChannelid;
	ResultSet sourceRs = tuChannel.executeQuery(sourceSql);
	boolean createAble = true;
	while(sourceRs.next()){
		String ex = sourceRs.getString("Extra1");
		if("".equals(ex)){
			continue;
		}
		JSONObject jsonObject = new JSONObject(ex);
		if(jsonObject.has("columnid")){
			if(columnid==jsonObject.getInt("columnid")){
				createAble = false;
				PgcChannel = sourceRs.getInt("id");
				break;
			}
		}
	}
	tuChannel.closeRs(sourceRs);
	if(createAble){//未找到栏目，创建栏目频道
		JSONObject ex1 = new JSONObject();
		ex1.put("columnid",columnid);
		if(columnid==0)columnname="公共栏目";

		Channel channel = new Channel();
		channel.setName(columnname);	//频道名
		channel.setParent(pgcGraphicChannelid);//父编号
		channel.setType(1);//独立表单
		channel.setExtra1(ex1.toString());//设置拓展属性
		channel.setTemplateInherit(1);//继承上级模板
		channel.setListProgram("***");//列表页
		channel.setDocumentProgram("***");//内容页
		channel.Add();
		PgcChannel = channel.getId();
	}

	reJson.put("zuhu_id",companySystemId);
	reJson.put("PgcChannel",PgcChannel);
	return reJson;
}
//获取媒体号资源同步的入库频道
public static String getCurrentSourceChannel(int company_id,int uid) throws MessageException, SQLException, JSONException {

	String CurrentSourceChannel = "";

	//获取聚现信息
	String sys_config = CmsCache.getParameterValue("sync_juxian_live");
	JSONObject ConfigObject = new JSONObject(sys_config);

	//cms多站点
	JSONArray SiteList = ConfigObject.getJSONArray("list");
	if(SiteList.length()==0){
		return CurrentSourceChannel;
	}

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
				if((jsonEx.has("company")&&(jsonEx.getInt("company")==company_id))||(jsonEx.has("user")&&(jsonEx.getInt("user")==uid))){
					if(!CurrentSourceChannel.equals("")){
						CurrentSourceChannel += ",";
					}
					CurrentSourceChannel += chone.getId();
				}
			}
		}
	}

	return CurrentSourceChannel;
}

//判断聚现资源是否存在
public JSONObject add(int sourcechannelid,int juxian_sourceid,int company_id,String modify_date,HashMap map,int type) throws MessageException, SQLException, JSONException {
	JSONObject reJson = new JSONObject();

	int item_id=0;
	TableUtil tu_exist = new TableUtil();
	String sql_exist = "select * from "+CmsCache.getChannel(sourcechannelid).getTableName()
			+" where Active=1 and Category="+sourcechannelid
			+" and juxian_companyid="+company_id;
	if(type==1){//PGC
		sql_exist += " and juxian_liveid="+juxian_sourceid;
	}else{
		sql_exist += " and juxian_sourceid="+juxian_sourceid;
	}

	ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
	ItemUtil it = new ItemUtil();
	if (rs_exist.next()){
		item_id = rs_exist.getInt("id");
		int globalid = rs_exist.getInt("globalid");
		String ModifyDate = rs_exist.getString("ModifiedDate");
		if((ModifyDate)==null||"".equals(ModifyDate)){
			ModifyDate= "0";
		}
		Long ts = new Long(ModifyDate);
		Long tm = new Long(modify_date);
		if (ts <tm||tm==0){
			map.put("ModifiedDate", tm+"");
			it.updateItemByGid(sourcechannelid,map,globalid,0);
			if(rs_exist.getInt("status")==1){
				//发布
				Document document = new Document();
				document.Approve(rs_exist.getString("id"),sourcechannelid);
			}
			reJson.put("code",200);
			reJson.put("message","更新成功");
		}else{
			reJson.put("code",200);
			reJson.put("message","数据库数据修改时间小于数据修改时间");
		}
	}else{
		item_id = it.addItemGetGlobalID(sourcechannelid, map);
		reJson.put("code",200);
		reJson.put("message","创建成功");
	}
	tu_exist.closeRs(rs_exist);

	if(item_id>0)
	{
		Publish publish = new Publish();
		publish.setPublishType(Publish.ONLY_DOCUMENT_PUBLISH);
		publish.setChannelID(sourcechannelid);
		publish.setPublishAllItems(0);
		publish.addPublishItems(item_id);
		publish.GenerateFile();
	}

    return reJson ;
}

public JSONObject enteringDate(JSONObject data) throws SQLException, MessageException, JSONException {

	JSONObject reJson = new JSONObject();

	//初始化图片库信息
    if("".equals(localDir)||"".equals(path)){
		 init1();
	}
	//回传图片相关
	String serialNo = "photo_back";
	Channel channel = CmsCache.getChannel(serialNo);
	int channelId = channel.getId();
	String tableName = channel.getTableName();

	//接收的参数
	int juxian_companyid = data.getInt("company_id");//聚现企业id
	int cloumn_id = data.getInt("cloumn_id");//聚现栏目id
	String columnname = data.getString("cloumn");//聚现栏目名
	String title = data.getString("title");//聚现资源名称
	String modify_date = data.getString("modify_date");//聚现资源提交时间
	String Photo = data.getString("photo");//封面图
	int juxian_user = data.getInt("uid");//聚现用户id
	String juxian_username = data.getString("user");//聚现用户名
	int juxian_sourceid = data.getInt("id");//聚现资源id
	String url = data.getString("url");//资源地址
	String juxian_phone = data.getString("phone");//聚现用户手机号

	String message = "";

	//PGC资源同步
	JSONObject PgcChannel = getPgcChannel(juxian_companyid,cloumn_id,columnname);
	int PgcChannel_id = PgcChannel.getInt("PgcChannel");
	int zuhu_id = PgcChannel.getInt("zuhu_id");

	//图片本地化
	if(!Photo.equals("")){
		Photo = fun_Photo(Photo,tableName,channelId,zuhu_id);
	}
	SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	long lt = new Long(modify_date);
	Date date = new Date(lt*1000);
	String dateStr = simpleDateFormat.format(date);

	//PGC资源同步
	if(PgcChannel_id==0){
		message = "未找到PGC入库频道,";
		reJson.put("code",200);
		reJson.put("message",reJson);
	}else{
		HashMap map = new HashMap();
		map.put("Title", title);
		map.put("juxian_companyid", juxian_companyid+"");
		map.put("juxian_user", juxian_user+"");
		map.put("juxian_username",juxian_username);
		map.put("Photo",Photo);
		map.put("state", data.getString("state"));
		map.put("juxian_liveid",juxian_sourceid+"");
		map.put("pc_url",data.getString("pc_url"));
		map.put("app_url",data.getString("app_url"));
		map.put("start",data.getString("start"));
		map.put("type",data.getString("type"));
		map.put("password",data.getString("password"));
		map.put("money",data.getString("money"));
		map.put("url",url);
		map.put("juxian_phone",juxian_phone);
		if(data.has("topic")){
			map.put("topic",data.getString("topic"));
		}
		map.put("ModifiedDate", dateStr);
		reJson = add(PgcChannel_id,juxian_sourceid,juxian_companyid,modify_date,map,1);
	}

	//媒体号资源同步
	String CurrentSourceChannel = getCurrentSourceChannel(juxian_companyid,juxian_user);//获取cms多站点下对应的媒体号频道
	if(CurrentSourceChannel.equals("")){
		message = message+"未找到媒体号入库频道";
		reJson.put("code",200);
		reJson.put("message",reJson);
	}else{
		String[] CurrentSourceChannels = CurrentSourceChannel.split(",");
		for(int j=0;j<CurrentSourceChannels.length;j++){
			int CurrentSourceChannel_id = Integer.parseInt(CurrentSourceChannels[j]);//媒体号频道id
			HashMap map = new HashMap();
			map.put("Title", data.getString("title"));
			map.put("juxian_companyid", data.getString("company_id"));
			map.put("ModifiedDate", dateStr);
			map.put("juxian_user", data.getString("user"));
			map.put("Photo4", data.getString("photo"));
			map.put("live_shareurl",  data.getString("app_url"));
			map.put("state", data.getString("state"));
			map.put("juxian_liveid",data.getString("id"));
			map.put("doc_type","4");
			reJson = add(CurrentSourceChannel_id,juxian_sourceid,juxian_companyid,modify_date,map,0);
		}
	}

	return reJson;
}

	public JSONObject handleDate(HttpServletRequest request) throws IOException, JSONException, SQLException, MessageException {
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


	public String fun_content(String Content,String tableName,int channelId,int companySystemId) throws JSONException, MessageException, SQLException {
		Content = "<div id='js_content'>"+Content+"</div>";
		Element js_content = Jsoup.parse(Content);
		//处理图片
		Elements eles = js_content.getElementsByTag("img");//js_content.children();
		int n=0;
		for(Element element:eles){
			String img = element.attr("src");//图片地址
			if(!img.equals("")){
				//判断是否需要进行本地化
				JSONObject isExitJson2 = ifEixt(img,tableName,channelId);
				boolean isSave2 = (boolean)isExitJson2.get("isSave");
				String orFileName2 = isExitJson2.getString("orFileName");//文件名
				if(isSave2){//需要进行本地化图片
					String suffix2= img.substring(img.lastIndexOf(".")+1,img.length());
					String target2 = System.currentTimeMillis()+"_"+(n++)+"."+suffix2;
					if(Util.downloadFile(img,localDir+"/"+target2)){//本地化成功后替换img路径
						Publish publish = new Publish();
						publish.InsertToBePublished(Util.ClearPath(imageFolder) + "/" + target2,SiteFolder,site);
						PublishManager.getInstance().CopyFileNow();
						element.getElementsByTag("img").attr("src",path+"/"+target2);
						//本地化成功，图片入库到回传频道
						saveBack(target2,companySystemId,channelId,orFileName2);
					}
				}else{
					//图片之前已进行过本地化，直接从回传频道取地址替换img路径
					element.getElementsByTag("img").attr("src",isExitJson2.getString("photo"));
				}
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

		return Content;
	}
	//图片本地化
	public String fun_Photo(String Photo,String tableName,int channelId,int  companySystemId) throws JSONException, MessageException, SQLException {
		//判断是否需要进行本地化
		JSONObject isExitJson = ifEixt(Photo,tableName,channelId);
		boolean isSave = (boolean)isExitJson.get("isSave");
		String orFileName = isExitJson.getString("orFileName");
		if(isSave){//需要进行本地化图片
			String suffix = Photo.substring(Photo.lastIndexOf(".")+1,Photo.length());
			String target = System.currentTimeMillis()+"."+suffix;
			if(Util.downloadFile(Photo,localDir+"/"+target)){//本地化成功后替换photo变量
				Publish publish = new Publish();
				publish.InsertToBePublished(Util.ClearPath(imageFolder) + "/" + target,SiteFolder,site);
				PublishManager.getInstance().CopyFileNow();
				Photo = path+"/"+target;
				//本地化成功，图片入库到回传频道
				saveBack(target,companySystemId,channelId,orFileName);
			}
		}else{
			//图片之前已进行过本地化，直接从回传频道取地址替换photo变量
			Photo = isExitJson.getString("photo");
		}

		return Photo;
	}
	//图片入库
	public void saveBack(String title,int companyId,int channelId,String orFileName){
		String file = (new StringBuilder(String.valueOf(SiteFolder))).append("/").append(Util.ClearPath(imageFolder) + "/" + title).toString();
		File f = new File(file);
		long fileSize = 0;
		if(f.exists()&&f.isFile()){
			fileSize = f.length()/1000;
		}
		HashMap hashMap = new HashMap();
		hashMap.put("Title", title);
		hashMap.put("companyid",companyId+"");
		hashMap.put("Photo",path+"/"+title);
		hashMap.put("Filesize",String.valueOf(fileSize));
		hashMap.put("OriginalFileName",orFileName);
		try{
			ItemUtil itemUtil = new ItemUtil();
			itemUtil.addItemGetGlobalID(channelId, hashMap);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	//判断图片是否存在
	public JSONObject ifEixt(String fileName,String tableName,int channelId){
		//初始化
		boolean isSave = true;
		String orFileName = fileName.substring(fileName.lastIndexOf("/")+1);
		String photo = "";
		JSONObject json = new JSONObject();
		try{
			TableUtil tu = new TableUtil();

			String queryExistSql = "select * from " + tableName + " where category = " + channelId + " and "
					+"OriginalFileName = '" + orFileName +"' and Active = 1";
			ResultSet rs = tu.executeQuery(queryExistSql);
			if(rs.next()){
				photo = rs.getString("Photo");
				isSave = false;
			}
			tu.closeRs(rs);
			json.put("isSave", isSave);
			json.put("orFileName", orFileName);
			json.put("photo", photo);
		}catch(Exception e){
			e.printStackTrace();
		}
		return json;
	}

%>

<%
/*
添加编辑图片
*/


	JSONObject jsonObject = new JSONObject();
	try {
		jsonObject = handleDate(request) ;
		out.print(jsonObject.toString());
	} catch (Exception e) {
		e.printStackTrace();
		jsonObject.put("code","500");
		jsonObject.put("message","接口异常");
		out.print(jsonObject.toString());
	}
%>