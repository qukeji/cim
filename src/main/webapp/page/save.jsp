<%@ page import="java.io.*,tidemedia.cms.util.Util,
				tidemedia.cms.util.FileUtil,
				tidemedia.cms.page.*,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String	Content		= getParameter(request,"Content");
int		id			= getIntParameter(request,"id");

Page p = new Page(id);

if(!new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageSourceEdit))
{
	out.println("没有权限.");return;
}

p.setActionUser(userinfo_session.getId());
p.setContent(Content);
p.savePage();


Page p2 = new Page(id);
String username = CmsCache.getUser(p2.getModifiedUser()).getName();
out.println(p2.getModifiedDate()+"&"+username);
%>