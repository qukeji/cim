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
JSONArray array = new JSONArray();

JSONObject o1 = new JSONObject();
o1.put("name", "个人发稿量");
o1.put("icon", "../images/report_1.png");
o1.put("id", 3625);
o1.put("type",1);
array.put(o1);

JSONObject o2 = new JSONObject();
o2.put("name", "部门发稿量");
o2.put("icon", "../images/report_1.png");
o2.put("id", 3625);
o2.put("type",2);
array.put(o2);

JSONObject o3 = new JSONObject();
o3.put("name", "频道发稿量");
o3.put("icon", "../images/report_1.png");
o3.put("id", 3625);
o3.put("type",3);
array.put(o3);

JSONObject o4 = new JSONObject();
o4.put("name", "站点发稿量");
o4.put("icon", "../images/report_1.png");
o4.put("id", 3625);
o4.put("type",4);
array.put(o4);

JSONObject o5 = new JSONObject();
o5.put("name", "工作量统计");
o5.put("icon", "../images/report_1.png");
o5.put("id", 3625);
o5.put("type",5);
array.put(o5);

JSONObject o6 = new JSONObject();
o6.put("name", "报表");
o6.put("icon", "../images/report_1.png");
o6.put("id", 3625);
o6.put("type",6);
array.put(o6);

JSONObject o7 = new JSONObject();
o7.put("name", "月报表");
o7.put("icon", "../images/report_1.png");
o7.put("id", 3625);
o7.put("type",7);
array.put(o7);

out.println(array);
%>
