<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				org.json.JSONObject,
				tidemedia.app.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
    session.removeAttribute("appUserInfo");
    JSONObject json=new JSONObject();
    if (session.getAttribute("appUserInfo")==null){
        json.put("message","注销成功");
    }else {
        json.put("message","注销失败");
    }
    out.println(json);
%>
