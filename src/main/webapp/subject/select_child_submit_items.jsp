<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.Util,
				tidemedia.cms.util.StringUtils,
				tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				java.util.ArrayList,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	/*
	  *王海龙 2016/8/19  同一个记录在一篇文章中只添加一次
	  *
	  */
	int		ChannelID				= getIntParameter(request,"ChannelID");
	int		LinkChannelID			= getIntParameter(request,"LinkChannelID");
	int		GlobalID				= getIntParameter(request,"GlobalID");
	String	ChildGlobalID			= getParameter(request,"ChildGlobalID");
	int		fieldgroup				= getIntParameter(request,"fieldgroup");


	ChannelPrivilege cp = new ChannelPrivilege();
	if(!cp.hasRight(userinfo_session,ChannelID,2))
	{
		response.sendRedirect("../close_pop.jsp");return;
	}
	TableUtil tu = new TableUtil();
	ResultSet rs = tu.executeQuery("select * from relation_"+ChannelID+"_"+LinkChannelID+" where  childglobalid in ("+ChildGlobalID+") and globalid="+GlobalID);
	boolean exist = false;
	if(rs.next())
	{
			exist = true;
	%>
	<script>
		alert("请确认是否已添加过选择的记录！");
		history.back();
	</script>
	<%
	}
	else
	{
			new ItemUtil2().selectChildSubmitItems(ChannelID,LinkChannelID,GlobalID,ChildGlobalID,userinfo_session.getId());
			
	%>
	
	<%}

%>
