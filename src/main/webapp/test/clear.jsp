<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

	TableUtil tu = new TableUtil();

	out.println("清空操作日志<br>");
	tu.executeUpdate("truncate table tidecms_log");

	out.println("清空登录日志<br>");
	tu.executeUpdate("truncate table login_log");

	out.println("清空系统日志<br>");
	tu.executeUpdate("truncate table tidecms_system_log");

	out.println("禁用采集<br>");
	tu.executeUpdate("update spider set Status=0");

	TableUtil tu_user = new TableUtil("user");
	tu_user.executeUpdate("update parameter set Content='0' where id=1");
	//CmsCache.delParameter("media_ronghe");

%>
