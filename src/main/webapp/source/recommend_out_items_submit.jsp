<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.StringUtils,
				tidemedia.cms.user.*,
				tidemedia.cms.source.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	int		ChannelID				= getIntParameter(request,"ChannelID");//推荐到的频道编号
	String	SourceItemID			= getParameter(request,"RecommendItemID");//推荐出去的文档编号
	int		SourceChannelID		= getIntParameter(request,"RecommendChannelID");//推荐出去的文档来自的频道编号
	//int		SourceChannelID			= getIntParameter(request,"fromchannelid");
	//RecommendChannelID = fromchannelid;
	//System.out.println("推荐到的频道编号:"+ChannelID+"  推出去的文档编号:"+RecommendItemID+"  出自哪个频道："+RecommendChannelID);
	//System.out.println("SourceChannelID:"+SourceChannelID+"  SourceItemID:"+SourceItemID);
	int GlobalID					= 0;

	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}

	Source.RecommendToChannel(SourceChannelID,SourceItemID,ChannelID,userinfo_session.getId());
%>
采用成功
<script>
setTimeout("top.TideDialogClose('')",2000);
</script>
