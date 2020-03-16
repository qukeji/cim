<%@ page import="tidemedia.cms.system.*,
				java.io.*,
				java.net.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");

int pageid = 0;

Channel channel = CmsCache.getChannel(id);

ArrayList arraylist = channel.listSubChannels();
for(int i = 0;i<arraylist.size();i++)
{
	Channel subch = (Channel)arraylist.get(i);
	if(subch.getType()==Channel.Page_Type)
	{
		pageid = subch.getId();
		response.sendRedirect("../page/page.jsp?id="+pageid+"&Type=1");
	}
}
%>
