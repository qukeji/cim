<%@ page import="tidemedia.cms.util.*,
				 tidemedia.cms.system.*,
				 tidemedia.cms.base.*,
				 tidemedia.cms.publish.*,
				 java.io.*,
				 java.util.*,
				 java.sql.*,
				 org.json.*,
				 org.jsoup.*,
				 org.jsoup.nodes.Element,
				 org.jsoup.select.Elements,
				 org.apache.commons.lang.StringEscapeUtils,
				 java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
    /*

           添加编辑图片
	

	*/
    // out.print(request.getMethod());
	
	

    try {
        out.print((handleDate(request).toString()));
    } catch (Exception e) {
        JSONObject  jsonObject = new JSONObject();
        jsonObject.put("code","500");
        jsonObject.put("message","异常:"+e.toString());
        out.println(jsonObject.toString());
        e.printStackTrace();
    }
    
  //回传图片相关
  	
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
			//System.out.println("site=========================="+site.getId());
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
        	try{
	            BufferedReader streamReader = new BufferedReader( new InputStreamReader(request.getInputStream()));
	            StringBuilder responseStrBuilder = new StringBuilder();
	            String inputStr;
	            while ((inputStr = streamReader.readLine()) != null) responseStrBuilder.append(inputStr);
	            JSONObject json = new JSONObject(responseStrBuilder.toString());
	            jsonObject = enteringDate(json);
            }catch(Exception e){
            	e.printStackTrace();
            }
        }else{
            jsonObject.put("message","请求方式不对");
            jsonObject.put("code",500);
        }
        return jsonObject;
    }
/*
    {
        "id": 2804,
            "company_id": 4,
            "modify_date": 1522233333,
            "uid": 4,
            "user": "聚现",
            "title": "【一不小心上了镜】中加柏仁学校特约",
            "photo": "http://video.juyun.tv/image/02804742/live_02804742_1499418431756.jpg",
            "url": "http://juxian.juyun.tv/live.php?id=2804",
            "cloumn": "一不小心上了镜子",
            "tag": "中国，china",
            "desc": "我的视频",
            "content":"图文介绍"
    }*/
    
    public JSONObject enteringDate(JSONObject data) throws Exception {
    	
    	//回传图片相关
    	String serialNo = "photo_back";
    	Channel channel = CmsCache.getChannel(serialNo);
    	int channelId = channel.getId();
    	String tableName = channel.getTableName();
    	
        if("".equals(localDir)||"".equals(path)){
             init1();  
        }
		//System.out.println(data.toString());
        JSONObject reJson = new JSONObject();
		//获取该系统是否开启多租户 1开启 0未开启
		String zuhu = CmsCache.getParameter("zuhu").getIntValue()+"";
		int companySystemId  =0;
		if("1".equals(zuhu)){
		//系统对应编号
			//通过企业编号获取该企业在系统中的对应编号
			TableUtil tuCompany = new TableUtil("user");
			String companySql = "select * from company where JuxianID="+data.getInt("company_id")+"  and  jurong = 1";
			ResultSet companyRs = tuCompany.executeQuery(companySql);
			if(companyRs.next()){
				companySystemId = companyRs.getInt("id");
			}
			tuCompany.closeRs(companyRs);
			if(companySystemId==0){
				 reJson.put("code",500);
				 reJson.put("message","对应租户不存在");
				 return reJson;
			}
		}
		//获取PGC频道id
		int pgcGraphicChannelid = 0;
		String channelSql = "";
		channelSql = "select * from channel where application = 'pgc_doc'";
		TableUtil tuChannel= new TableUtil();
		ResultSet channelRs= tuChannel.executeQuery(channelSql);
		if(channelRs.next()){
			pgcGraphicChannelid= channelRs.getInt("id");
		}
		tuChannel.closeRs(channelRs);
		if(pgcGraphicChannelid==0){
			reJson.put("code",500);
			reJson.put("message","未找到入库频道");
			return reJson;
		}
		if("1".equals(zuhu)){
			String sql_channel = "select * from channel where parent ="+pgcGraphicChannelid+" and company="+companySystemId;
			//System.out.println(sql_channel);
			ResultSet rsChannel= tuChannel.executeQuery(sql_channel);
			if(rsChannel.next()){
				pgcGraphicChannelid = rsChannel.getInt("id");
			}else{
				reJson.put("code",500);
				reJson.put("message","未找到入库频道");
				return reJson;
			}

		}

		String columnname = data.getString("cloumn");
		Integer columnid = data.getInt("cloumn_id");
		int sourcechannelid= 0;
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
					sourcechannelid = sourceRs.getInt("id");
					break;
				}
			}
		}
		tuChannel.closeRs(sourceRs);
		if(createAble){
			JSONObject ex1 = new JSONObject();
			ex1.put("columnid",columnid);
			if(columnid==0)columnname="公共栏目";
			sourcechannelid = createChannel(columnname,pgcGraphicChannelid,1,"","",ex1.toString(),1);
		}
        HashMap map = new HashMap();
        map.put("Title", data.getString("title"));
        map.put("juxian_companyid", data.getString("company_id"));
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        long lt = new Long(data.getString("modify_date"));

        String Photo = data.getString("photo");//封面图
		if(!Photo.equals("")){
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
		}        

		String Content = data.getString("content");
		Content = StringEscapeUtils.unescapeHtml(Content);
		//System.out.println("before"+Content);
		if(!Content.equals("")){
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
						String suffix2 = img.substring(img.lastIndexOf(".")+1,img.length());
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
		}
		//System.out.println("afterContent="+Content);

        map.put("ModifyDate", lt+"");
        map.put("juxian_user", data.getString("uid"));
		map.put("juxian_username",data.getString("user"));
		map.put("Photo",Photo);
        //map.put("live_shareurl",  data.getString("url"));
        map.put("juxian_sourceid",data.getString("id"));
        map.put("Summary",data.getString("desc"));
        map.put("Content",Content);
		map.put("tag",data.getString("tag"));
		map.put("url",data.getString("url"));
		map.put("juxian_phone",data.getString("phone"));

        TableUtil tu_exist = new TableUtil();
        String sql_exist = "select * from "
                        + CmsCache.getChannel(sourcechannelid).getTableName()
                        + " where Active=1 and juxian_sourceid="
                        + data.getString("id");
        ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
        ItemUtil it = new ItemUtil();
        if (rs_exist.next()){
			int active = rs_exist.getInt("active");
			int globalid = rs_exist.getInt("globalid");
			String ModifyDate = rs_exist.getString("ModifyDate");
			if((ModifyDate)==null||"".equals(ModifyDate)){
			    ModifyDate= "0";
			}
			Long ts = new Long(ModifyDate);
			Long tm = new Long(data.getLong("modify_date"));
			if (ts <tm||tm==0){
				map.put("ModifyDate", tm+"");
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
			it.addItemGetGlobalID(sourcechannelid, map);
			reJson.put("code",200);
			reJson.put("message","创建成功");
		}
		tu_exist.closeRs(rs_exist);
		return reJson;
    }
	
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
    
	public int createChannel(String Name,int parent,int Type,String SerialNo,String FolderName,String Extra1,int TemplateInherit) throws MessageException, SQLException{
		int channelId = 0 ;
		try{
			if(SerialNo.equals("")){
				SerialNo = CmsCache.getChannel(parent).getAutoSerialNo();
			}
			if(FolderName.equals("")){
				int index = SerialNo.lastIndexOf("_"); 
				FolderName = SerialNo;
				if(index!=-1){
					FolderName = SerialNo.substring(index+1);
				}
			}		
		Channel channel = new Channel();
		channel.setName(Name);	//频道名
		channel.setParent(parent);//父编号
		channel.setType(Type);//独立表单
		channel.setSerialNo(SerialNo);//标识名
		channel.setFolderName(FolderName);//目录名
		channel.setExtra1(Extra1);//设置拓展属性
		channel.setTemplateInherit(TemplateInherit);//继承上级模板
		channel.setListProgram("***");//列表页
		channel.setDocumentProgram("***");//内容页
		channel.Add();
		channelId = channel.getId();
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
		return channelId ;
	}
	
%>
