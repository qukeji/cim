<%@ page import="tidemedia.cms.system.*,
				org.apache.tools.zip.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.io.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
	//删除记录
	int itemid  = getIntParameter(request,"itemid");

	
	Navigation n = new Navigation();
	n.setUserId(userinfo_session.getId());
	n.Delete(itemid);
	
%>
