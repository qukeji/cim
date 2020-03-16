<%@ page import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.base.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

int id = getIntParameter(request,"id");
String Action = getParameter(request,"Action");
String field = getParameter(request,"field");

TableUtil tu_user = new TableUtil("user");

Product product = new Product(id);
product.setUserId(userinfo_session.getId());

//开启
if(Action.equals("true"))
{
	if(field.equals("Status")){
		product.Enable();
	}else{
		tu_user.executeUpdate("update tide_products set "+field+"=1 where id="+id);
	}
}
//关闭
if(Action.equals("false"))
{
	if(field.equals("Status")){
		product.Disable();
	}else{
		tu_user.executeUpdate("update tide_products set "+field+"=0 where id="+id);
	}
}

out.println("设置成功");

%>