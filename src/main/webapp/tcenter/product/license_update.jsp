<%@ page import="java.sql.*,tidemedia.cms.system.*,tidemedia.cms.util.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config.jsp"%><%
String	code		= getParameter(request,"code");
String	license		= getParameter(request,"license");
int		productid	= getIntParameter(request,"productid");

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

//System.out.println(request.getScheme()+","+request.getServerName()+","+request.getServerPort()+","+request.getContextPath());
Product product = new Product(productid);
String url = product.getCode();
if("TideVMS".equals(url)){
    url = "vms";
}else if("TideLive".equals(url)){
    url = "live";
}else if("TideTongji".equals(url)){
    url = "tongji";
}else if("TideEncoder".equals(url)){
    url = "encoder";
}else if("TideCMS".equals(url)){
    url = "tcenter";
}
String token = CmsCache.addToken("license_update");
String apiurl = "http://127.0.0.1:"+request.getServerPort()+"/" + url+"/system/license_update_tcenter.jsp?";
apiurl += "&code="+code+"&license="+license+"&token="+token+"&userid="+userinfo_session.getId();
System.out.println("apiurl:"+apiurl);
String result = Util.connectHttpUrl(apiurl,"utf-8");
//System.out.println(result+","+apiurl);
out.println(result);
/*
if(code.length()>0)
{
	String flag = LicenseU.updateLicense(code,userinfo_session,productid);
	if(flag.equals("success")) 
	{
		out.println(JsonUtil.success("许可证设置成功。"));
	}
	else
		out.println(JsonUtil.fail("代码编号无效，请输入正确的代码编号"));

	return;
}

if(license.length()>0)
{
	int flag = CmsCache.setLicense(license,productid);
	if(flag==1)
		out.println(JsonUtil.fail("该系统的许可证无效或已经过期，请设置新的许可证代码。"));

	if(flag==2)
	{
		out.println(JsonUtil.success("许可证设置成功。"));
	}

	return;
}

out.println(JsonUtil.fail(""));
*/
%>
