<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
* 删除图片
* 
*/

	TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
	int id = photo_config.getInt("channelid");
    Channel channel = CmsCache.getChannel(id);
	String tablename = channel.getTableName();
	String itemid = getParameter(request,"itemid");//itemid
	TableUtil tu = new TableUtil();
	JSONObject json = new JSONObject();
	String sql = "";
	try{
		sql = "update "+ tablename+" set parent=0 where id in (" + itemid+")";
		System.out.println("picture  sql==========="+sql);
		tu.executeUpdate(sql);
		json.put("status","success");
		json.put("message","删除成功");
		
	}catch(Exception e){
			json.put("status","error");
			json.put("message",e.getMessage());
	}finally {
		out.println(json);
	}
%>
