<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.StringUtils,
				tidemedia.cms.user.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	int		ChannelID				= getIntParameter(request,"ChannelID");
	String	RecommendItemID			= getParameter(request,"RecommendItemID");
	int		RecommendChannelID		= getIntParameter(request,"RecommendChannelID");

	int GlobalID					= 0;

	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}

	new ItemUtil().recommendInItems(ChannelID,RecommendItemID,RecommendChannelID,userinfo_session.getId());

	response.sendRedirect("../close_pop.jsp?Type=1");
%>