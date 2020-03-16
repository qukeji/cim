<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.text.DecimalFormat,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%
    //广告下线时间到期后，使用调度功能将状态改为草稿状态
%>

<%
	UserInfo user = new UserInfo(1);
	JSONArray arr = ChannelUtil.getApplicationChannel("app_advert",0,1,user);
	for(int i=0;i<arr.length();i++){
		JSONObject json = arr.getJSONObject(i);
		int channelid = json.getInt("channelid");
		String table = CmsCache.getChannel(channelid).getTableName();

		String sql = "select id,Title from "+table+" where Status=1 and Revoketime<now()";
		
		String ids = "";
		String Title = "";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next()){
			if(!ids.equals("")){
				ids += ",";
				Title += ",";
			}
			ids += rs.getInt("id");
			Title += convertNull(rs.getString("Title"));
		}
		tu.closeRs(rs);
		
		if(!ids.equals("")){//对已下线的广告进行撤稿操作
			Document document = new Document();
			document.setUser(user.getId());
			document.Delete2(ids,channelid);
			Log.SystemLog("清理已下线的广告", Title);
		}
	}
   

%>