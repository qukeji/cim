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
	sql="delete from uchome_thread where tid in (" + ItemID+")";
	tu.executeUpdate(sql);
}
//action==2时审核
//if(action==2){
	//sql="update uchome_blog set hot=1 where blogid in (" + ItemID+")";
	//tu.executeUpdate(sql);
//}
//action==3时撤稿
//if(action==3){
	//sql="update uchome_blog set hot=0 where blogid in (" + ItemID+")";
	//tu.executeUpdate(sql);
//}


%>