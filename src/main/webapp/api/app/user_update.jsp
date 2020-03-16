<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.text.SimpleDateFormat,
				org.json.JSONObject,
				java.text.ParseException,
				java.util.regex.Pattern,
				 java.util.regex.Matcher,
				java.sql.*"%>
<%@ page import="tidemedia.app.system.appUserInfo" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config1.jsp"%>
<%@ include file="config.jsp"%>
<%
    //APP 用户信心修改
%>
<%
    String phone = getParameter(request,"username");
    String password = getParameter(request,"password");
    String code = getParameter(request,"code");//验证码
    int site = getIntParameter(request,"site");//站点名称
%>