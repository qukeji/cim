<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.*,
				org.apache.commons.lang.StringEscapeUtils,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
    TideJson json = CmsCache.getParameter("jixiao_view_userid").getJson();
    String userids = json.getString("user_id");
    String [] uids  =userids.split(",");
    String userList = "";
    for(int i = 0;i< uids.length ;i++){
        int  uid  = Integer.parseInt(uids[i]);
        UserInfo userInfo = new UserInfo(uid);
        String name = userInfo.getName();
        userList += name+",";
    }
    userList = userList.substring(0,userList.length()-1);
    out.println(userList);
%>
