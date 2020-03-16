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
               java.text.SimpleDateFormat


"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
    /*

               编辑新建视频


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
%>
<%!
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
    /*{
        "id": 2804,
            "company_id": 4,
            "modify_date": 1522233333,
            "uid": 4,
            "user": "聚现",
            "title": "【一不小心上了镜】中加柏仁学校特约",
            "photo": "http://video.juyun.tv/image/02804742/live_02804742_1499418431756.jpg",
            "url": "http://juxian.juyun.tv/live.php?id=2804",
            "cloumn": "一不小心上了镜子",
            "position":"北京市朝阳区",
            "tag": "中国，china",
            "desc": "我的视频"
    }*/
    public JSONObject enteringDate(JSONObject data) throws Exception {
        JSONObject reJson = new JSONObject();
		//获取该系统是否开启多租户 1开启 0未开启
		String zuhu = CmsCache.getParameterValue("zuhu");
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
		channelSql = "select * from channel where application = 'pgc_video'";
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
			sourcechannelid = createChannel(columnname,pgcGraphicChannelid,1,"","",ex1.toString());
		}
        HashMap map = new HashMap();
        map.put("Title", data.getString("title"));
        map.put("juxian_companyid", data.getString("company_id"));
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        long lt = new Long(data.getString("modify_date"));
        //Date date = new Date(lt*1000);
        //String dateStr = simpleDateFormat.format(date);
        //System.out.println("dateStr==========="+dateStr);
        map.put("ModifyDate", lt+"");
        map.put("juxian_user", data.getString("uid"));
		map.put("juxian_username", data.getString("user"));
        map.put("Photo", data.getString("photo"));
        map.put("url",  data.getString("url"));
        map.put("juxian_sourceid",data.getString("id"));
        map.put("Summary",data.getString("desc"));
		map.put("position",data.getString("position"));
		map.put("tag",data.getString("tag"));
		map.put("juxian_phone",data.getString("phone"));
        TableUtil tu_exist = new TableUtil();
        String sql_exist = "select * from "
                        + CmsCache.getChannel(sourcechannelid).getTableName()
                        + " where Active=1 and juxian_sourceid="
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
             Long ts = new Long(ModifyDate);
             Long tm = new Long(data.getLong("modify_date"));
             if (ts <tm||tm==0){
                 System.out.println("ts ======="+ts);
                 System.out.println("tm ======="+tm);
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
                     reJson.put("code",500);
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

	public int createChannel(String Name,int parent,int Type,String SerialNo,String FolderName,String Extra1) throws MessageException, SQLException{
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
		channel.Add();
		channelId = channel.getId();
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
		return channelId ;
	}
%>