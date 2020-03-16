<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
int action = getIntParameter(request,"action");
String ids = getParameter(request,"id");
String tableprefix = CmsCache.getParameterValue("sns_tableprefix");
TableUtil tu = new TableUtil("sns");

if(action==1 && ids.length()>0)
{
	//删除评论
	String sql = "update "+tableprefix+"_comment set active=0,status=0 where cid in(" + ids + ")";
	//out.println(sql);
	tu.executeUpdate(sql);
}

if(action==2 && ids.length()>0)
{
	//审核评论
	String sql = "update "+tableprefix+"_comment set status=1 where cid in(" + ids + ")";
	//out.println(sql);
	tu.executeUpdate(sql);
}

if(action==3 && ids.length()>0)
{
	//撤搞评论
	String sql = "update "+tableprefix+"_comment set status=0 where cid in(" + ids + ")";
	//out.println(sql);
	tu.executeUpdate(sql);
}
if(action==4 && ids.length()>0)
{
	//恢复评论
	String sql = "update "+tableprefix+"_comment set active=1 where cid in(" + ids + ")";
	//out.println(sql);
	tu.executeUpdate(sql);
}
%>