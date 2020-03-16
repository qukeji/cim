<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				org.json.*,
				tidemedia.app.system.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>

<%
    appUserInfo appUserInfo=new appUserInfo();
    String servletname = getParameter(request,"servletname");
    String parameter = getParameter(request,"parameter");
    //获取链接
    TideJson appfor_php_url = CmsCache.getParameter("appfor_php_url").getJson();//问政接口信息
    String url = appfor_php_url.getString("url");//问政编号信息
    try{
        String ticket_url =url+servletname+"?"+parameter;
        String text =  Util.postHttpUrl(ticket_url,"","utf-8");
        out.println(text);
    }catch (Exception e){
        out.println("程序异常"+e.toString());
    }
%>


