<%@ page import="tidemedia.cms.util.*,
				tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				org.json.*,
				java.io.*,
				java.util.*,
				java.sql.ResultSet,
				java.text.SimpleDateFormat"%>
<%@ include file="../../../../config1.jsp"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
/*
更改活动状态
*/
// out.print(request.getMethod());
JSONObject  jsonObject = new JSONObject();
try {
	int id		= getIntParameter(request,"id");//栏目编号
	int action		= getIntParameter(request,"action");//栏目编号
	if(id==0||action==0){
		jsonObject.put("code","500");
		jsonObject.put("message","参数不全");
		out.print(jsonObject.toString());

	}else{
		jsonObject = new JSONObject();
		jsonObject.put("id",id);
		jsonObject.put("action",action);
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
    public JSONObject enteringDate(JSONObject data) throws Exception{
        JSONObject reJson = new JSONObject();
        String sys_config = CmsCache.getParameterValue("sync_juxian_live");
        JSONObject ConfigObject = new JSONObject(sys_config);
        JSONArray SiteList = ConfigObject.getJSONArray("list");
        if(SiteList.length()==0){
            reJson.put("code",500);
            reJson.put("message","同步库不存在");
            return reJson;
        }
        for (int i = 0; i < SiteList.length(); i++) {
            JSONObject SiteObject = SiteList.getJSONObject(i);
            int SiteId = SiteObject.getInt("site");
            boolean company_exist = false;
            TableUtil tu_company = new TableUtil();
            int sourcechannelid = 0;
            TableUtil tu_source = new TableUtil();
            // 判断该文章所属校园号是否有通过审核
            String sql_source = "select id from channel  where SerialNo='company_s"
                    + SiteId + "_source' ";
            ResultSet rs_source = tu_source.executeQuery(sql_source);
            if (rs_source.next()) {
                sourcechannelid = rs_source.getInt("id");
            }
            tu_source.closeRs(rs_source);


            //获取企业对应的内容稿池频道
            Channel ch = CmsCache.getChannel(sourcechannelid);
            int CurrentSourceChannel = sourcechannelid;
            HashMap map = new HashMap();
            map.put("state", data.getString("action")); //未直播(0)  直播中(1) 直播结束(2) 直播关闭(3)
            map.put("juxian_type",3+"");//非聚现资源(0)  图文(1) 短视频(2) 直播活动(3)
            TableUtil tu_exist = new TableUtil();
            String sql_exist = "select * from "
                    + CmsCache.getChannel(CurrentSourceChannel)
                    .getTableName()
                    + " where  juxian_liveid="
                    + data.getString("id") + " ";
            ResultSet rs_exist = tu_exist.executeQuery(sql_exist);
            ItemUtil it = new ItemUtil();
            while (rs_exist.next()) {
				int globalid = rs_exist.getInt("globalid");
                it.updateItemByGid(CurrentSourceChannel,map,globalid,0);
				if(rs_exist.getInt("status")==1){
					//发布
					Document document = new Document();
					document.Approve(rs_exist.getString("id"),CurrentSourceChannel);
				}
				reJson.put("code",200);
				reJson.put("message","活动状态更改");
            }
            tu_exist.closeRs(rs_exist);
        }
        return reJson;
    }
%>