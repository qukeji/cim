<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.video.*,
				java.sql.*,
				java.util.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
 
<%
/**
*	用途：CMS导入视频接口
*	1,郭庆光	20140101	创建
*	2,李永海	20150310	增加token验证
*	3,
*	4,
*	5,
*/
	
JSONObject oo = new JSONObject();
try{
	int parent = getIntParameter(request,"parent");
	String token = getParameter(request,"Token");	
	int login = 0;
	if(token.length()>0) login = UserInfoUtil.AuthByToken(token);
    
	if(token.length()==0)
	{
		oo.put("status",0);
		oo.put("message","缺少登录令牌");
	}
	else if(login!=1)
	{
		oo.put("status",0);
		oo.put("message","登录失败");
	}else if(parent==0){
		oo.put("status",0);
		oo.put("message","请检查媒资库文章编号！");
		
	}else{
    
		//转码列表
		ArrayList<Document> tlist = ItemUtil.listItems(4," where Parent="+parent+" and active=1 ");

		JSONArray transcode = new JSONArray();
		for(Document d : tlist)
		{	
			JSONObject o = new JSONObject();

			o.put("id",d.getId());
			o.put("video_dest",d.getValue("Url"));
			o.put("video_type",d.getValue("video_type"));
			o.put("video_desc",d.getValue("video_desc"));

			Document doc = CmsCache.getDocument(parent);
			
			int duration = doc.getIntValue("Duration");
			String Duration = Util.formatDuration(duration,"**时**分**秒");
			if(Duration.startsWith("00时")){
				Duration = Duration.substring(3);
			}
			if(Duration.startsWith("00分")){
				Duration = Duration.substring(3);
			}
			Duration = Duration.replace("时",":").replace("分",":").replace("秒","");
			o.put("duration",duration);
			o.put("duration_desc",Duration);

			transcode.put(o);
		}
	  
	
		if(tlist.size()>0){
			oo.put("status",1);
			oo.put("message","ok");
			oo.put("videos",transcode);
		}else{
			oo.put("status",0);
			oo.put("message","该视频编号不存在！");
		}
	}
}catch(Exception e){
		oo.put("status",0);
		oo.put("message","调用接口失败！");			
}
out.println(oo.toString());	 

%>