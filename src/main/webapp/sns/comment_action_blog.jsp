<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String ItemID = getParameter(request,"id");
int action = getIntParameter(request,"action");
TableUtil tu = new TableUtil("sns");

String sql = "";
//action==1时删除
if(action==1){
	sql="delete from uchome_blog where blogid in (" + ItemID+")";
	tu.executeUpdate(sql);
}
%>