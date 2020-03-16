<%@ page import="java.sql.*,tidemedia.cms.system.*,tidemedia.cms.util.*,tidemedia.cms.user.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config1.jsp"%><%
String	code	= getParameter(request,"code");
String	license	= getParameter(request,"license");
String	token	= getParameter(request,"token");//用于校验
int		userid	= getIntParameter(request,"userid");

UserInfo user = CmsCache.getUser(userid);

if(!user.isAdministrator())
{ out.println(JsonUtil.fail(""));return;}

if(code.length()>0)
{
	String flag = LicenseU.updateLicense(code,user,token);
	if(flag.equals("success")) 
		out.println(JsonUtil.success("许可证设置成功。"));
	else
		out.println(JsonUtil.fail("代码编号无效，请输入正确的代码编号"));

	return;
}

if(license.length()>0)
{
	//System.out.println("token:"+token);
	int flag = CmsCache.setLicense(license,token);
	if(flag==1)
		out.println(JsonUtil.fail("该系统的许可证无效或已经过期，请设置新的许可证代码。"));

	if(flag==2)
		out.println(JsonUtil.success("许可证设置成功。"));
	return;
}

out.println(JsonUtil.fail(""));
%>
