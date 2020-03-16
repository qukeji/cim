<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
int action = getIntParameter(request,"action");
if(action==1)
{
	TableUtil tu = new TableUtil();
	out.println("设置本地站点目录：D:/work/cms/CMS安装包/TideCMS_9.0_安装/html<br>");
	tu.executeUpdate("update site set SiteFolder='D:/work/cms/CMS安装包/TideCMS_9.0_安装/html'");
	CmsCache.delSite(3);CmsCache.delSite(4);CmsCache.delSite(8);CmsCache.delSite(18);CmsCache.delSite(19);

	return;
}

if(action==2)
{
	TableUtil tu = new TableUtil();
	out.println("设置本地站点目录：/web/html<br>");
	tu.executeUpdate("update site set SiteFolder='/web/html'");
	CmsCache.delSite(3);CmsCache.delSite(4);CmsCache.delSite(8);CmsCache.delSite(18);CmsCache.delSite(19);

	out.println("清空操作日志<br>");
	tu.executeUpdate("truncate table tidecms_log");

	out.println("清空登录日志<br>");
	tu.executeUpdate("truncate table login_log");

	out.println("清空系统日志<br>");
	tu.executeUpdate("truncate table tidecms_system_log");

	out.println("设置im4java的cmd路径<br>");
	tu.executeUpdate("update parameter set Content='/usr/bin/' where id=35");
	CmsCache.delParameter("sys_im4java_path");

	out.println("禁用采集<br>");
	tu.executeUpdate("update spider set Status=0");

	return;
}
%>
<a href="init.jsp?action=1">windows初始化</a>

<br>

<a href="init.jsp?action=2">centos初始化</a>