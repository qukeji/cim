<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.util.*,java.net.*,java.io.*,
				java.sql.*,java.util.*,
				java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>

<%
	int globalid=getIntParameter(request,"globalid");
	Document doc=CmsCache.getDocument(globalid);
	int CompanyId=doc.getIntValue("company_id");
	
	TableUtil tu=new TableUtil();
	String Sql="update channel_community_userwatch  set active=0 where becompanyid="+CompanyId+" and bewatchuserid=0 and site="+doc.getChannel().getSiteID()+"";
	System.out.println(Sql);
	//tu.executeUpdate(Sql);
	
%>
