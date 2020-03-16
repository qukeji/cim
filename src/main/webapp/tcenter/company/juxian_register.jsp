<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

//开通聚现
String	Name		= getParameter(request,"Name");//企业名称
String	phone		= getParameter(request,"phone");//聚现登录手机号

//获取聚融接口
String url = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+"/tcenter/api/jurong/v1.0/";

Company company = new Company();
company.setRequest(request);
JSONObject o = company.Juxian(phone,Name,url);

out.println(o);

%>