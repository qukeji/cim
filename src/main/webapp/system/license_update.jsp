<%@ page import="java.sql.*,tidemedia.cms.system.*,tidemedia.cms.util.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
String	code	= getParameter(request,"code");
String	license	= getParameter(request,"license");

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String token = CmsCache.addToken("license_update");

if(code.length()>0)
{
	String flag = LicenseU.updateLicense(code,userinfo_session,token);
	if(flag.equals("success")) 
		out.println(JsonUtil.success("许可证设置成功。"));
	else
		out.println(JsonUtil.fail("代码编号无效，请输入正确的代码编号"));

	return;
}

if(license.length()>0)
{
	int flag = CmsCache.setLicense(license,token);
	if(flag==1)
		out.println(JsonUtil.fail("该系统的许可证无效或已经过期，请设置新的许可证代码。"));

	if(flag==2)
		out.println(JsonUtil.success("许可证设置成功。"));
	return;
}

out.println(JsonUtil.fail(""));
%>
