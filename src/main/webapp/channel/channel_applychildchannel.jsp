<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.base.*,java.sql.*,java.util.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<% 
int ChannelID = getIntParameter(request,"ChannelID");
int Operation = getIntParameter(request,"Operation");
ChannelRecommend  crApply = new ChannelRecommend();
crApply.setActionUser(userinfo_session.getId());
String msg = crApply.ApplyToSubchannels(ChannelID,Operation);
out.print(msg);
return;
%>