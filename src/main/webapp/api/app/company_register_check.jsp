<%@ page
	import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8"%>
<%@ include file="../../config1.jsp"%>
<%
/**
* 媒体号注册check
* 
*/
	JSONObject json = new JSONObject();
	int site = getIntParameter(request,"site");
	int userid = getIntParameter(request,"userid");
	if(site==0||userid==0){
		json.put("code",500);
		json.put("message","参数不全");
		out.println(json);
		return;
	}
	String channel_SerialNo = "company_s"+site+"_info";
	Channel channel=CmsCache.getChannel(channel_SerialNo);
	String sql = "select * from " + channel.getTableName() +" where Active=1 and jushi_userid="+userid;	
	TableUtil tu = new TableUtil();
	ResultSet Rs = tu.executeQuery(sql);
	String msg = "";
	int mediaIdState = 0;
	try{
		if(Rs.next()){
			msg = tu.convertNull(Rs.getString("remark"));
			mediaIdState = Rs.getInt("Status1")+1;
			if(mediaIdState==3){
			    json.put("msg",msg);
			}
			json.put("code",200);
			json.put("mediaIdState",mediaIdState);
		}else{
			json.put("code",200);
			json.put("mediaIdState",mediaIdState);
		}
	}catch(Exception e){
		json.put("code",500);
		json.put("msg","接口异常");
		e.printStackTrace();
	}finally{
		out.println(json);
	}
	tu.closeRs(Rs);
%>
