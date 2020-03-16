<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int companyid = getIntParameter(request,"cid");//租户编号
String ids = getParameter(request,"ids");//租户有权限的产品id

//获取当前时间
java.util.Date currentTime = new java.util.Date();  
SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
String dateString = formatter.format(currentTime);

TableUtil tu_user = new TableUtil("user");
String sql = "";
//先查询租户产品权限表是否已存在当前租户的记录
boolean flag = false;
sql = "select id from company_product where companyId="+companyid;
ResultSet Rs = tu_user.executeQuery(sql);
if(Rs.next()){
	flag = true ;
}
tu_user.closeRs(Rs);

if(flag){//记录已存在，修改记录
	sql = "update company_product set productIds='"+ids+"',ModifyDate='"+dateString+"' where companyId="+companyid;
}else{//不存在，新建
	sql = "insert into company_product(productIds,companyId,ModifyDate) values('"+ids+"',"+companyid+",'"+dateString+"')";
}
tu_user.executeUpdate(sql);

out.println(1);
%>
