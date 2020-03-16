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

TableUtil tu = new TableUtil("sns");

if(action==1 && ids.length()>0)
{
	//删除视频
	String sql = "delete from uchome_video where picid in(" + ids + ")";
	//out.println(sql);
	tu.executeUpdate(sql);
}

if(action==2 && ids.length()>0)
{
	//审核视频
	String sql = "update uchome_video set status2=1 where picid in(" + ids + ")";
	//out.println(sql);
	tu.executeUpdate(sql);
}

if(action==3 && ids.length()>0)
{
	//撤搞视频
	String sql = "update uchome_video set status2=0 where picid in(" + ids + ")";
	//out.println(sql);
	tu.executeUpdate(sql);
}
%>