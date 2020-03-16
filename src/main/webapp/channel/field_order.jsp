<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");

int ItemID			= getIntParameter(request,"ItemID");
int NextItemID				= getIntParameter(request,"NextItemID");
int	ChannelID			= getIntParameter(request,"ChannelID");

if(ItemID>0)
{
	Field field = new Field(ItemID);//System.out.println(id);
	field.Order(NextItemID);
}
//response.sendRedirect("form_view.jsp?ChannelID="+ChannelID+"&FieldGroupTab="+FieldGroupTab);
%>