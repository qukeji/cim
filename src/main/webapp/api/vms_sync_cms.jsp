<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.util.*,
				tidemedia.cms.user.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<% 

	String Token=getParameter(request,"Token");
	int login = 0;
	JSONObject o=new JSONObject();
	if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token); 
	
	if(Token.length()==0)
	{
		o.put("status",0);
		o.put("message","缺少登录令牌");
		Log.SystemLog("同步vms视频","缺少登录令牌，请检查Token");
	}
	else if(login!=1)
	{
		o.put("status",0);
		o.put("message","登录失败");
		Log.SystemLog("同步vms视频","登录失败，请检查Token");
	}else{

	
		int globalid = getIntParameter(request,"globalid");
		int action  = getIntParameter(request,"action");

		TideJson json = CmsCache.getParameter("vms_sync_cms").getJson();
		String info_url = json.getString("info_url");
		String channel_url = json.getString("channel_url"); 
		int cms = json.getInt("cms");
		int vms = json.getInt("vms");
		String token = json.getString("token");
		String url = info_url+"?globalid="+globalid+"&vms="+vms+"&token="+token;
		String result = Util.connectHttpUrl(url,"utf-8");
	 
		String parent = "";
		JSONObject object = null;
		try{
			object = new JSONObject(result);

			String status = object.getString("status");
			String message = object.getString("message");
			if(status.equals("0"))
			{
				//发生错误
//				Log.SystemLog("同步vms视频","接口错误，"+message);
//				return;
			}
			parent = object.getString("parent");
		} catch (JSONException e) {
				e.printStackTrace(System.out);
				Log.SystemLog("同步vms视频","接口返回数据错误，接口地址："+url);
				return;
		}
		//判断该频道是否存在
		 String[] parents = parent.split(",");
		 if(action==5||action==4||action==1||action==3){
			VmsToCms.addNewChannel(cms,parent,channel_url,token);
			//VmsToCms.addField(cms,object);  //此处频道字段都手工添加
			VmsToCms.addVideo(action,cms,object,token); 
		  }else if(action==6){
			VmsToCms.DeleteVideo(cms,object); 
		  }
	}
	out.println(o);
 %>
