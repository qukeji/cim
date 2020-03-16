<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,java.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<% 	
	int ChannelID = getIntParameter(request,"ChannelID");
	int Operation = getIntParameter(request,"Operation"); 
	int  optype = getIntParameter(request,"optype");
	if(optype == 1){//设置继承上级
		ChannelRecommend  seApply = new ChannelRecommend();
		seApply.setActionUser(userinfo_session.getId());
		String semsg = seApply.changeChannelRelation(ChannelID,Operation);
		out.print(semsg);
		return;
	}

	//设置独立关系
	JSONObject json =  new JSONObject();
	ChannelRecommend  saApply = new ChannelRecommend();
	saApply.setActionUser(userinfo_session.getId());
	saApply.changeChannelAlone(ChannelID,Operation);
	json.put("status", "success");
	json.put("message", "设置成功");
	out.print(json);
	return;

%>