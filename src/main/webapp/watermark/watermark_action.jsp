<%@ page import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.base.*,tidemedia.cms.system.*,java.net.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

int id = getIntParameter(request,"id");
String Action = getParameter(request,"Action");


TableUtil tu= new TableUtil();

Watermark t= new Watermark(id);
String title = t.getName();

//开启
if(Action.equals("true"))
{
	
	tu.executeUpdate("update  watermark set status=1 where id="+id);
	new Log().WatermarkLog(LogAction.watermark_start, title, id, userinfo_session.getId());
}
//关闭
if(Action.equals("false"))
{
	tu.executeUpdate("update watermark set status=0 where id="+id);
	new Log().WatermarkLog(LogAction.watermark_end, title, id, userinfo_session.getId());
}

out.println("true");
//response.sendRedirect("company_list.jsp");

%>