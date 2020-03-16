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
* 用途：开启禁言,取消禁言,封号功能保存到数据库功能
* 1,胡翔 20190802 创建
*/
	String uri = request.getRequestURI();
	int  id= getIntParameter(request,"id");
	String optype = getParameter(request,"optype");
	String itemid = getParameter(request,"itemid");
	Channel ch = CmsCache.getChannel(id);
	String tablename = ch.getTableName();
	TableUtil tu = ch.getTableUtil();
	java.util.Date date = new java.util.Date();
	JSONObject json = new JSONObject();
	try{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"); 
		String sql = "";
		if(optype.equals("disableAccount"))
		{
			sql = "update "+ tablename+" set Status2=1,sealDate=('"+sdf.format(date)+"') where id in("+itemid+")";
		}
		if(optype.equals("disableSendMsg"))
		{
			sql = "update "+ tablename+" set Banned =1 where id in("+itemid+")";
		}
		if(optype.equals("enableSendMsg"))
		{
			sql = "update "+ tablename+" set Banned=0 where id in("+itemid+")";
		}
		tu.executeUpdate(sql);
		json.put("status","success");
		json.put("message","修改成功");
	}catch(Exception e){
			json.put("status","error");
			json.put("message",e.getMessage());
	}finally {
		out.println(json);
	}
%>