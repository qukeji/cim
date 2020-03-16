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
//选题提交接口
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
	int userid = userinfo_session.getId();//当前登录用户id	
	int column_id		= getIntParameter(request,"column_id");//栏目编号
	int start			= getIntParameter(request,"start");//选题时间
	int user_id			= getIntParameter(request,"user_id");//选题发起人编号
	String user_name	= getParameter(request,"user_name");//选题发起人
	String users_id		= getParameter(request,"users_id");//选题参与人编号
	String users		= getParameter(request,"users");//选题参与人
	String desc			= getParameter(request,"desc");//任务描述
	String bespeak		= getParameter(request,"bespeak");//预约车辆
	String name			= getParameter(request,"name");//任务名称
	String device		= getParameter(request,"device");//预约设备


	try {

		if(column_id==0||start==0||user_id==0||user_name.equals("")||users_id.equals("")||users.equals("")||desc.equals("")||name.equals("")){

			json.put("status",501);
			json.put("message","参数缺少");

		}else{
			HashMap map_doc = new HashMap();
			map_doc.put("start",start+"");
			map_doc.put("publisher",user_id+"");
			map_doc.put("publisher_name",user_name);
			map_doc.put("users_id",users_id);
			map_doc.put("users",users);
			map_doc.put("Summary",desc);
			map_doc.put("Title",name);
			map_doc.put("bespeak",bespeak);
			map_doc.put("task_status","0");
			map_doc.put("User",userid+"");
			map_doc.put("device",device);

			int gid = ItemUtil.addItemGetGlobalID(column_id, map_doc);
			if(gid!=0){
			    Document document = new Document(gid);
	            document.Approve(document.getId()+"",column_id);
	
				json.put("id",gid);
				json.put("status",200);
				json.put("message","成功");

				//小米推送
				TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
				String push_url = jurong.getString("push_url");
				if(!push_url.equals("")){
					push_url = push_url+"?type=1&id="+gid;
					push_url = Util.ClearPath(push_url);
					Util.connectHttpUrl(push_url);
				}
			}else{
				json.put("id",0);
				json.put("status",500);
				json.put("message","创建失败");
			}
		}
		out.print(json);

	}catch (Exception e) {
        json.put("code","500");
        json.put("message","异常:"+e.toString());
        out.print(json);
        e.printStackTrace();
    }
%>
