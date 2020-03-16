<%@ page import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.base.*,tidemedia.cms.system.*,java.net.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

int id = getIntParameter(request,"id");
String Action = getParameter(request,"Action");
String field = getParameter(request,"field");

TableUtil tu_user = new TableUtil("user");

Company company = new Company(id);
company.setRequest(request);
company.setUserId(userinfo_session.getId());

//开启
if(Action.equals("true"))
{
	if(field.equals("jurong")){
//		if(company.getCloudId()==0){
//			out.println("false");
//			return ;
//		}
		company.enableJurong(1);

		//开启聚融创建频道
		String token = CmsCache.addToken("channel_add");
		String companyName = company.getName() ;
		companyName = URLEncoder.encode(companyName,"utf-8");

		String scheme = request.getScheme() ;
		String port = ""+request.getLocalPort() ;
		if(scheme.equals("https")) port = "888" ;

		Product product = new Product("TideVMS");
		String url = "http://127.0.0.1:"+port+"/"+product.getUrl()+"/system/company_channel_add.jsp?company="+id+"&token="+token+"&companyName="+companyName;
		Util.connectHttpUrl(url,"utf-8");

		product = new Product("TideCMS");
		url = "http://127.0.0.1:"+port+"/"+product.getUrl()+"/system/company_channel_add.jsp?company="+id+"&token="+token+"&companyName="+companyName;
		Util.connectHttpUrl(url,"utf-8");

	}else{
		company.Enable();
	}
}
//关闭
if(Action.equals("false"))
{
	if(field.equals("jurong")){
		company.enableJurong(2);
	}else{
		company.Disable();
	}
}

out.println("true");
//response.sendRedirect("company_list.jsp");

%>