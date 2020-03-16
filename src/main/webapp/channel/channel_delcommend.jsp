<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,java.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<% 
	int did = getIntParameter(request,"did");
	ChannelRecommend  cr1 = new ChannelRecommend(did);
	int Operationdel = cr1.getType();
	int  RelationIDdel =  cr1.getRelationID();
	Channel channel = CmsCache.getChannel(cr1.getChannelID());
	List<Integer> childChannelIDs = channel.getChildChannelIDs();
	cr1.setActionUser(userinfo_session.getId());
	//cr1.delChannelRecommend(childChannelIDs,RelationIDdel,Operationdel);
	cr1.Delete(did);//删除
	return;
%>