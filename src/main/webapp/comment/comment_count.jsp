<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				java.text.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(userinfo_session.getRole()==4){ response.sendRedirect("../noperm.jsp");return;}

String  ids = getParameter(request,"ids");
String idsArray[]=ids.split(",");
TableUtil tu = new TableUtil("comment");
String json="[";
for(int i=0;i<idsArray.length;i++){
		if(i!=0) json+=",";
		if(!idsArray[i].equals("")){
			int count=0;
			String sql="SELECT count(*) as count FROM comment where itemid='"+idsArray[i]+"'";
			ResultSet Rs = tu.executeQuery(sql);
			if(Rs.next()){
				count = Rs.getInt("count");
			}
			tu.closeRs(Rs);
			json+="{id:'"+idsArray[i]+"',count:'"+count+"'}";
		}
}
json+="]";
	out.println(json);
%>