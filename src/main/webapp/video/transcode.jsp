<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.video.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int ChannelID = getIntParameter(request,"ChannelID");
String ItemID = getParameter(request,"ItemID");


	ChannelPrivilege cp = new ChannelPrivilege();
	if(cp.hasRight(userinfo_session,ChannelID,3))
	{
		TranscodeManager t = TranscodeManager.getInstance();
		t.transcode(ItemID);
		t.Start();
	}
%>