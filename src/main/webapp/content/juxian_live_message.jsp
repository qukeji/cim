<%@ page import="tidemedia.cms.system.*,
				 tidemedia.cms.base.*,
				 tidemedia.cms.util.*,
				 tidemedia.cms.user.*,
				 java.util.*,
				 org.json.*,
				 java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
/*
*获取聚现直播信息
*/
%>
<%!
//判断表中是否存在某数据
public static int exists(String sql){
	int id=0;
	try {
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);			
		if(rs.next()){//数据存在，返回ID
			id = rs.getInt("id");
		}
		tu.closeRs(rs);
	} catch (Exception e) {
		e.printStackTrace();
	}
	return id;
}
%>
<%
String message = "同步完成";
try{

	String   jsontext= CmsCache.getParameterValue("sync_juxian_live");
	JSONObject json = new JSONObject(jsontext);
	String url_ = json.getString("url");//聚现直播列表接口

	JSONArray Siteinfo=json.getJSONArray("list");
	for(int l=0;l<Siteinfo.length();l++){
		JSONObject siteObj=Siteinfo.getJSONObject(l);
		String token = siteObj.getString("token");
		int siteid	 = siteObj.getInt("site");

		int channelId = 0;
		try{
			TableUtil tu_live = new TableUtil();
			String Sql_live = "select id from channel where SerialNo='s"+siteid+"_juxianlive' ";
			ResultSet rs_live=tu_live.executeQuery(Sql_live);
			if(rs_live.next()){
				 channelId=rs_live.getInt("id");
			}
			tu_live.closeRs(rs_live);
		}catch(Exception e){
			Log.SystemLog("获取各个站点下直播库失败", "错误信息:  " + e.toString());
		}

		int activity_id = 0 ;//上次同步直播编号
		String tableName = CmsCache.getChannel(channelId).getTableName();
		TableUtil tu = new TableUtil();
		String sql = "select activity_id from " + tableName + " where Active=1 order by activity_id desc";
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
		{
			activity_id = rs.getInt("activity_id");
		}
		tu.closeRs(rs);

		while(true){
			//获取聚现直播列表
			String url_path = url_+"?access_token="+token+"&id="+activity_id;
			System.out.println(siteid+":"+url_path+"<br>") ;

			String result = Util.connectHttpUrl(url_path);
			JSONObject json_result = new JSONObject(result);
			if(json_result.getInt("code")==200){//请求接口成功

				JSONArray arr = json_result.getJSONArray("result");       
				for(int i=0;i<arr.length();i++){

					JSONObject json_live = (JSONObject) arr.get(i);
					int id = json_live.getInt("id");//活动编号

					String sql1 = "select id from "+tableName+" where Active=1 and activity_id="+id;
					if(exists(sql1)!=0){//说明以获取过此活动
						continue;
					}

					int state     = json_live.getInt("state");//直播状态 0未直播 1直播中 2直播结束
					int views     = json_live.getInt("views");//围观人数
					int start     = json_live.getInt("start");//开始时间
					int end       = json_live.getInt("end");//结束时间
					String title  = json_live.getString("title");//直播名称
					String photo  = json_live.getString("photo");//封面图
					String pc_url = json_live.getString("pc_url");//pc页面地址
					String url    = json_live.getString("url");//分享地址
					String user   = json_live.getString("user");//创建者
					String column = json_live.getString("column");//栏目

					HashMap<String,String> log_ = new HashMap<String,String>();
					log_.put("Title",title);
					log_.put("Photo",photo);
					log_.put("pc_url",pc_url);
					log_.put("url",url);
					log_.put("userName",user);
					log_.put("columns",column);
					log_.put("activity_id",id+"");
					log_.put("start",start+"");
					log_.put("end",end+"");
					ItemUtil.addItemGetGlobalID(channelId,log_);

					activity_id = id ;
				}
				if(arr.length()<10){
					break;
				}
			}else{
				message = json_result.getString("message");
			}
		}
	}		

} catch (Exception e) {
	message = "同步失败";
	e.printStackTrace();
}
out.println(message) ;
%>
