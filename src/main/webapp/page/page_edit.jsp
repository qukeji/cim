<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.page.*,
				java.io.*,
				java.net.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}


int id = getIntParameter(request,"id");
int type = getIntParameter(request,"type");

//if(!(userinfo_session.isAdministrator() || userinfo_session.getUsername().equals("liuyun")))
//{type=0;}

//type=0 Ò³ÃæÎ¬»¤ =1  Ä£¿é±à¼­  =2 ¿ò¼Ü£¬·ÖÀ¸±à¼­

Page p = new Page(id);

if(type==0)
{
}
else if(type==1)
{
	if(!new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageModuleEdit))
	{
		response.sendRedirect("../noperm.jsp");return;
	}
}
else if(type==2)
{
	if(!new ChannelPrivilege().hasRight(userinfo_session,id,ChannelPrivilege.PageFrameEdit))
	{
		response.sendRedirect("../noperm.jsp");return;
	}
}

String Content = p.getContent();
String SiteAddress = p.getSite().getUrl();

Channel channel = CmsCache.getChannel(id);
SiteAddress = SiteAddress + "/" + channel.getFullPath();

String Head = "<base href=\"" + SiteAddress + "\">\r\n";
Head += "<link href=\"" + (request.getRequestURL()+"").replace("/page/page_edit.jsp","/style/page.css") + "\" type=\"text/css\" rel=\"stylesheet\" />\r\n";
//Head += "<link href=\"" + (request.getRequestURL()+"").replace("/page/page_edit.jsp","/style/edit-page.css") + "\" type=\"text/css\" rel=\"stylesheet\" />\r\n";
Head += "<script type=\"text/javascript\" src=\"" + (request.getRequestURL()+"").replace("/page/page_edit.jsp","/common/jquery.js") + "\"></script>\r\n<script language=javascript>window.onerror = function(){return true;}</script>";

Content = p.InsertHead(Content,Head);
String Body = "<script type=\"text/javascript\"> var baseUrl = \"" + (request.getRequestURL()+"").replace("/page/page_edit.jsp","") + "\";var pageID="+id+";var edittype="+type+";</script>\r\n";


Body += "<script type=\"text/javascript\" src=\"" + (request.getRequestURL()+"").replace("/page/page_edit.jsp","/common/page_edit.js") + "\"></script>\r\n";


Content = p.InsertBeforeEndBody(Content,Body);

Content = p.IncludeFileContent(Content);

if(type==0 || type==1)
{
	Content = p.ConvertModuleFlag(Content);
}
try{out.println(Content);}catch(Exception e){}
%>