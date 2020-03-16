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
String table = getParameter(request,"table");
String c_id = getParameter(request,"c_id");
TableUtil tu = new TableUtil("sns");

String sql = "";
//action==1时删除
if(action==1){
	sql="delete from "+ table + " where " +  c_id + " in (" + ItemID+")";
	tu.executeUpdate(sql);
}
//action==2时审核
if(action==2){
	sql="update " + table +" set status=1 where " +  c_id + " in (" + ItemID+")";
	tu.executeUpdate(sql);
}
//action==3时撤稿
if(action==3){
	sql="update " + table +" set status=0 where " +  c_id + " in (" + ItemID+")";
	tu.executeUpdate(sql);
}

%>