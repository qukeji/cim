 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config1.jsp"%>
<%
//选题详情接口
%>
<%!
 public HashMap<String, Object> getInfo(int gid,int userId,int data_type){

	HashMap<String, Object> map = new HashMap<String, Object>() ;

	try{		

		if(gid==0||data_type==0){

			map.put("status",501);
			map.put("message","参数缺少");

		}else{
			TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
			int channelid_reason = jurong.getInt("review_reason");
			int channelid_device = jurong.getInt("device");

			Document doc = new Document(gid);
			String url = doc.getHttpHref();//稿件地址
			int status = doc.getIntValue("task_status");
			int publisher = doc.getIntValue("publisher");

			if(data_type==1){
				//稿件
				if(url.equals("")||url.equals("/")){
					url = "";
				}
				status = doc.getStatus();
				publisher = doc.getModifiedUser();
			}
						
			String status_ = "";
			if(status==0){
				status_ = "未审核";
			}else if(status==1){
				status_ = "审核通过";
			}else if(status==2){
				status_ = "毙稿";
			}else if(status==3){
				status_ = "已完成";
			}
			
			String channelName = CmsCache.getChannel(doc.getChannelID()).getName();//选题频道名
			String carId = "";//车辆编号
			String carName = "";//车辆名称
			String deviceId = "";//设备编号
			String deviceName = "";//设备名称

			String bespeakIds = doc.getValue("bespeak");//车辆
			if(!bespeakIds.equals("")){
				String[] bespeak = bespeakIds.split(",");
				for(int i=0;i<bespeak.length;i++){
					int bespeakId = Integer.parseInt(bespeak[i]);
					Document doc_bespeak = CmsCache.getDocument(bespeakId,channelid_device);
					if(!carId.equals("")){
						carId += ",";
						carName += ",";
					}
					carId += bespeakId ;
					carName += doc_bespeak.getTitle();
				}
			}

			String deviceIds = doc.getValue("device");//设备
			if(!deviceIds.equals("")){
				String[] device = deviceIds.split(",");
				for(int i=0;i<device.length;i++){
					int id_ = Integer.parseInt(device[i]);
					Document doc_device = CmsCache.getDocument(id_,channelid_device);
					if(!deviceId.equals("")){
						deviceId += ",";
						deviceName += ",";
					}
					deviceId += id_ ;
					deviceName += doc_device.getTitle();
				}
			}

			JSONObject o = new JSONObject();
			o.put("id",gid);
			o.put("publisher",doc.getValue("publisher_name"));//选题人（作者）
			o.put("publish_date",doc.getCreateDate());//选题时间（创建时间）
			o.put("name",doc.getTitle());
			o.put("phone","");
			o.put("summary",doc.getSummary());//选题简介
			o.put("url",url);//稿件预览地址（如果是稿件此值非空）
			o.put("content",doc.getContent());//稿件内容（如果是稿件此值非空）
			o.put("status",status_);//任务状态
			o.put("task_type",doc.getChannelID());//栏目编号
			o.put("is_publisher",publisher);//发布人是否为当前用户
			o.put("users",doc.getValue("users"));//参与人姓名
			o.put("users_list",doc.getValue("users_id"));//参与人id
			o.put("tip",channelName);
			o.put("carId",carId);
			o.put("carName",carName);
			o.put("deviceId",deviceId);
			o.put("deviceName",deviceName);

			//审核结果
			String tableName1 = CmsCache.getChannel(channelid_reason).getTableName();
			TableUtil tu1 = new TableUtil();
			String sql1 = "select * from "+tableName1+" where Active=1 and parent="+gid;
			ResultSet rs1 = tu1.executeQuery(sql1);
			JSONArray arr = new JSONArray();
			while(rs1.next()){
				int task_status_3 = rs1.getInt("task_status_3");
				String task_status_ = "";
				if(task_status_3==0){
					task_status_ = "申请审核";
				}else if(task_status_3==1){
					task_status_ = "审核通过";
				}else if(task_status_3==2){
					task_status_ = "毙稿";
				}else if(task_status_3==3){
					task_status_ = "完成";
				}else if(task_status_3==4){
					task_status_ = "重新申请";
				}

				JSONObject o1 = new JSONObject();
				o1.put("reviewer",convertNull(rs1.getString("username")));
				o1.put("task_status",task_status_);
				o1.put("photo",convertNull(rs1.getString("Photo")));
				o1.put("review_date",Util.FormatTimeStamp("", rs1.getLong("review_date")));
				o1.put("finish_date","");
				o1.put("reason",convertNull(rs1.getString("reason")));
				arr.put(o1);
			}
			tu1.closeRs(rs1);

			o.put("result", arr);
			map.put("result", o);
			map.put("status",200);
			map.put("message","成功");
		}
	}catch(Exception e){
		map.put("status",500);
		map.put("message","程序异常");
		e.printStackTrace();
	} 
	return map ;
}
%>

<%
	JSONObject json = new JSONObject();
	//判断用户是否登录
	tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
	if(session.getAttribute("CMSUserInfo")!=null)
	{
		userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
	}
	if(userinfo_session==null || userinfo_session.getId()==0)
	{
		json.put("status",500);
		json.put("message","请先登录");
		out.println(json);
		return ;
	}
	
	int id = getIntParameter(request,"id");//选题编号
	int data_type = getIntParameter(request,"data_type");//数据类型 1稿件/2选题
	int userid = userinfo_session.getId();//当前登录用户id
	if(data_type==0) data_type=2 ;

	HashMap<String, Object> map = getInfo(id,userid,data_type);
	json = new JSONObject(map);
	//System.out.println(json);
	out.println(json);

%>
