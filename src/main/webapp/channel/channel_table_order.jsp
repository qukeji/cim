<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

	int		ChannelID	= getIntParameter(request,"ChannelID");
	int		Action		= getIntParameter(request,"Action");
	String  FieldName   = getParameter(request,"FieldName");
	//System.out.println("ChannelID="+ChannelID+" Action="+Action+" FieldName="+FieldName);
	
	if(ChannelID!=0)
	{
		Channel channel = CmsCache.getChannel(ChannelID);
		//channel.setSiteID(userinfo_session.getSite());
		channel.Order_Table(Action,FieldName);
		
		//重新调用页面生产程序,产生新的页面;
		if(channel.getType()==3)
		{
			App p = new App(ChannelID);
			p.GenerateFormFile(userinfo_session);
		}
		//生成成功;

		response.sendRedirect("../close_pop.jsp?Type=1");return;
	}
%>
