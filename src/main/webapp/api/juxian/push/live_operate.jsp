<%@ page import="tidemedia.cms.util.*,
				 tidemedia.cms.system.*,
				 java.io.InputStreamReader,
				 java.io.BufferedReader,
				 java.io.IOException,
				 java.sql.SQLException,
				 java.io.PrintWriter,
				 org.json.JSONObject,
				 org.json.JSONException,
				 org.json.JSONArray,
				 java.util.*,
               tidemedia.cms.base.TableUtil,
               tidemedia.cms.system.ItemUtil,
               tidemedia.cms.system.CmsCache,
               tidemedia.cms.system.Channel,
               tidemedia.cms.system.Document,
               tidemedia.cms.base.MessageException,
               java.sql.ResultSet,
               java.text.SimpleDateFormat,
               tidemedia.cms.publish.*
"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
    /*

               新建编辑活动


    */
   // out.print(request.getMethod());
   /*
   {"id":2804,"company_id":4,"modify_date":293333333,"uid":4,"user":"聚现","title":"【一不小心上了镜】中加柏仁学校特约3333","photo":"http://video.juyun.tv/image/02804742/live_02804742_1499418431756.jpg","pc_url":"http://juxian.juyun.tv/live_web.php?id=2804","app_url":"http://juxian.juyun.tv/live_app.php?id=2804","url":"http://juxian.juyun.tv/live.php?id=2804","cloumn":"一不小心上了镜子","state":1,
"views":10,
"start":1598099649,
"type":0,
"password":"","money":1.2F,"cloumnid":1}*/
    try {
        /*response.setCharacterEncoding("utf-8");
        PrintWriter reOut = response.getWriter();
        response.setContentType("text/html;charset=utf-8");
        reOut.print((handleDate(request).toString()));
        reOut.flush();
        reOut.close();*/
        out.print((handleDate(request).toString()));
    } catch (Exception e) {
        JSONObject  jsonObject = new JSONObject();
        jsonObject.put("code","500");
        jsonObject.put("message","异常:"+e.toString());
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
						System.out.println("site=========================="+site.getId());
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
		channelSql = "select * from channel where application = 'pgc_live'";
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
			System.out.println(sql_channel);
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
		String Photo = data.getString("photo");
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
        HashMap map = new HashMap();
        map.put("Title", data.getString("title"));
        map.put("juxian_companyid", data.getString("company_id"));

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        long lt = new Long(data.getString("modify_date"));
        //Date date = new Date(lt*1000);
		//String dateStr = simpleDateFormat.format(date);
		//System.out.println("dateStr========="+dateStr);
        map.put("ModifyDate", lt+"");
        map.put("juxian_user", data.getString("uid"));
		map.put("juxian_username",data.getString("user"));
        map.put("Photo", Photo);
        map.put("state", data.getString("state"));
        map.put("juxian_liveid",data.getString("id"));
		map.put("pc_url",data.getString("pc_url"));
		map.put("app_url",data.getString("app_url"));
		map.put("start",data.getString("start"));
		map.put("url",data.getString("url"));
		map.put("type",data.getString("type"));
		map.put("password",data.getString("password"));
		map.put("money",data.getString("money"));
		map.put("juxian_phone",data.getString("phone"));
		if(data.has("topic")){
		    map.put("topic",data.getString("topic"));
		}
        TableUtil tu_exist = new TableUtil();
      String sql_exist = "select * from "
                        + CmsCache.getChannel(sourcechannelid).getTableName()
                        + " where   Active=1 and  juxian_liveid="
                        + data.getString("id");
        ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
        ItemUtil it = new ItemUtil();
        if (rs_exist.next()) {
			int active = rs_exist.getInt("active");
			int globalid = rs_exist.getInt("globalid");
            String ModifyDate = rs_exist.getString("ModifyDate");
            if((ModifyDate)==null||"".equals(ModifyDate)){
			    ModifyDate= "0";
			}
			System.out.println("ModifyDate:"+ModifyDate);
            Long ts = new Long(ModifyDate);
            Long tm = new Long(data.getLong("modify_date"));
			System.out.println(ts+"========="+tm);
            if (ts <tm||tm==0){
                map.put("ModifyDate", tm+"");
                it.updateItemByGid(sourcechannelid,map,globalid,0);
                reJson.put("code",200);
                reJson.put("message","更新成功");
                if(rs_exist.getInt("status")==1){
                            //发布
                   Document document = new Document();
                   document.Approve(rs_exist.getString("id"),sourcechannelid);
                 }
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


