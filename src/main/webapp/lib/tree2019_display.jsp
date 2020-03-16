<%@ page import="tidemedia.cms.system.*,
				org.json.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.util.*,
				java.sql.*,
				tidemedia.cms.user.UserInfo,
				java.net.URLEncoder"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
long begin_time = System.currentTimeMillis();

Tree2019 tree = new Tree2019();
JSONArray o2 = tree.listChannel_json_display(userinfo_session);

out.println(o2);
%>
