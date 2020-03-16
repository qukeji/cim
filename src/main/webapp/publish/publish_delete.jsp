<%@ page import="java.sql.*,
				tidemedia.cms.publish.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.TableUtil,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

String id=Util.getParameter(request,"ItemID");

String Sql = "delete from publish_item where id in(" + id + ")";
TableUtil tu = new TableUtil();
tu.executeUpdate(Sql);
%>