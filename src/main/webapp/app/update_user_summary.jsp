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
* 用户头像审核更新到数据库
* 
*/
    String channel_SerialNo = "register";//注册用户信息频道标识
    Channel ch = CmsCache.getChannel(channel_SerialNo);
	int id = getIntParameter(request,"id");//频道id
	String itemid = getParameter(request,"itemid");//itemid
	String[] itemid_ = itemid.split(",");
	String optype = getParameter(request,"optype");
	
	Channel channel = CmsCache.getChannel(id);
	String tablename = ch.getTableName();
	String tablename1 = channel.getTableName();
	TableUtil tu = ch.getTableUtil();
	JSONObject json = new JSONObject();
	String sql = "";
	String sql1 ="";
	try{
		if(optype.equals("agree"))
		{
			for(int i = 0;i<itemid_.length;i++){
				Document doc = CmsCache.getDocument(Integer.parseInt(itemid_[i]),id);
				String Userid = doc.getValue("userId");
				String Summary = doc.getValue("Summary");
				sql = "update "+ tablename+" set Summary='"+Summary+"' where id =" + Userid;
				sql1 = "update "+ tablename1+" set Status1=1 where Userid =" + Userid + " and Status1=0";
				tu.executeUpdate(sql);
				tu.executeUpdate(sql1);
				json.put("status","success");
				json.put("message","审核成功");
			}
		}
		if(optype.equals("refuse"))
		{
			for(int i = 0;i<itemid_.length;i++){
				Document doc = CmsCache.getDocument(Integer.parseInt(itemid_[i]),id);
				String Userid = doc.getValue("userId");
				sql1 = "update "+ tablename1+" set Status1=2 where Userid =" + Userid + " and Status1=0";
				tu.executeUpdate(sql1);
				json.put("status","success");
				json.put("message","驳回成功");
			}
		}
		
		
	}catch(Exception e){
			json.put("status","error");
			json.put("message",e.getMessage());
	}finally {
		out.println(json);
	}
%>
