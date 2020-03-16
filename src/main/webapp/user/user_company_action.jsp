<%@page import="tidemedia.cms.user.UserInfo"%>
<%@ page import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.base.*,tidemedia.cms.system.*,java.net.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{out.close();return;}
int actionuser = userinfo_session.getId();
int company = getIntParameter(request,"company");//租户
int userid = getIntParameter(request,"userid");//用户
int type = getIntParameter(request,"type");//1.关联  2.解绑
Company comp = new Company(company);//用户选择绑定租户
String compName = comp.getName();
UserInfo userinfo = new UserInfo(userid);
String userName = userinfo.getName();
int userCompany = userinfo.getCompany();
Company comp1 = new Company(userCompany);//用户原绑定租户
String compName1 = comp1.getName();
TableUtil tu_user = new TableUtil("user");
String sql = "";
if(type==1){
	sql = "update userinfo set company="+company+" where id="+userid;
	new Log().UserCompanyLog(LogAction.user_company_add, userName + "绑定" + compName, userid, actionuser);
}else{
	sql = "update userinfo set company=0 where id="+userid;
	new Log().UserCompanyLog(LogAction.user_company_delete, userName + "解绑于" + compName1, userid, actionuser);
}	
tu_user.executeUpdate(sql);
out.println("true");
%>