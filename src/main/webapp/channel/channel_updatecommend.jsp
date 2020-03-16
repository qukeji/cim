<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,java.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<% 
	int ChannelID = getIntParameter(request,"ChannelID");
	int Operation = getIntParameter(request,"Operation"); 
	String[] selRecommendArray  = request.getParameterValues("selRecommendArray[]");
	JSONObject json = new JSONObject();
	if(selRecommendArray  == null ||  selRecommendArray.length == 0){
		json.put("status", "error");
		json.put("message", "没有选择需要配置的频道");
		out.println(json);return;
	}
	for(int i=0; i<selRecommendArray.length; i++){
		String param = selRecommendArray[i];
		String[]   updateparam = param.split(",");
		int RelationID = Integer.parseInt(updateparam[0]);
		String Relationship = updateparam[1];
		int RelationchannelType = Integer.parseInt(updateparam[2]);
		//查询是否有该栏目的关联存在,如果存在,则不能添加  isExist
		String sql = "select * from channel_recommend where ChannelID=" + ChannelID + " and RelationID=" + RelationID+ " and Type=" + Operation;
		ChannelRecommend cr=  new ChannelRecommend();
		boolean  isExit =  cr.isExist(sql);
		if(isExit){//存在 编辑
			int  id  = 0;//推荐频道的id
			TableUtil tu = 	new TableUtil();
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next()){
				id = rs.getInt("id");
			}
			ChannelRecommend cr1=  new ChannelRecommend(id);
			cr.setActionUser(userinfo_session.getId());
			cr.setChannelID(ChannelID);
			cr1.UpdateChannelRecommend(id, RelationchannelType, Relationship);
		}else{
		//不存在 添加
			cr.setChannelID(ChannelID);
			cr.setRelationID(RelationID);
			cr.setRelationchannelType(RelationchannelType);
			cr.setType(Operation);
			cr.setRelationship(convertNull(Relationship));
			cr.setActionUser(userinfo_session.getId());
			cr.Add();
			Channel channel = CmsCache.getChannel(ChannelID);
			List<Integer> childChannelIDs = channel.getChildChannelIDs();
			cr.addChannelRecommend(childChannelIDs,RelationID,Operation,cr);
		}
	}
	json.put("status", "success");
	json.put("message", "配置成功");
	out.println(json);return;
%>