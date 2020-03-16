<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				org.json.*,
				java.io.*,
				java.util.*,
				java.sql.ResultSet,
				java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
/*
删除视频
*/
JSONObject  jsonObject = new JSONObject();
try {
	int id		= getIntParameter(request,"id");//栏目编号
	if(id==0){
		jsonObject.put("code","500");
		jsonObject.put("message","id不能为空");
		out.print(jsonObject.toString());
	}else{
		jsonObject = new JSONObject();
		jsonObject.put("id",id);
		jsonObject = enteringDate(jsonObject);
		out.print(jsonObject.toString());
	}
} catch (Exception e) {
	jsonObject.put("code","500");
	jsonObject.put("message","异常:"+e.toString());
	out.print(jsonObject.toString());
	e.printStackTrace();
}
%>
<%!
public JSONObject enteringDate(JSONObject data)  throws Exception {
	JSONObject reJson = new JSONObject();

	String sys_config = CmsCache.getParameterValue("sync_juxian_live");
	JSONObject ConfigObject = new JSONObject(sys_config);

	//cms多站点
	JSONArray SiteList = ConfigObject.getJSONArray("list");
	if(SiteList.length()==0){
		reJson.put("code",500);
		reJson.put("message","");
		return reJson;
	}
	//获取cms多站点下对应的媒体号频道
	for (int i = 0; i < SiteList.length(); i++) {
		JSONObject SiteObject = SiteList.getJSONObject(i);
		int SiteId = SiteObject.getInt("site");

		// 获取媒体号内容管理频道id
		int sourcechannelid = 0;
		TableUtil tu_source = new TableUtil();
		String sql_source = "select id from channel  where SerialNo='company_s" + SiteId + "_source' ";
		ResultSet rs_source = tu_source.executeQuery(sql_source);
		if(rs_source.next()) {
			sourcechannelid = rs_source.getInt("id");
		}
		tu_source.closeRs(rs_source);

		//获取所有媒体号频道下相同的视频
		TableUtil tu_exist = new TableUtil();
		String sql_exist = "select * from "+CmsCache.getChannel(sourcechannelid).getTableName()+" where juxian_sourceid="+ data.getString("id");
		ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
		ItemUtil it = new ItemUtil();
		if (rs_exist.next()) {
			String id = rs_exist.getString("id");
			Document Doc = new Document();
			Doc.Delete(id,sourcechannelid);
			reJson.put("code",200);
			reJson.put("message","删除成功");
		}else{
			reJson.put("code",500);
			reJson.put("message","id不存在");
		}
		tu_exist.closeRs(rs_exist);
	}
	return reJson;
}
%>