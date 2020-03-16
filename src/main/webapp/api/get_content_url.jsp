<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*"%><%@ page contentType="application/json;charset=utf-8" %><%@ include file="../config1.jsp"%><%
 int gid  = getIntParameter(request,"globalid");
 String tag = getParameter(request,"tag");
Document doc = new Document(gid);
//各个频道的链接字段都不一样，疯了
//每次新增，都在这里配置一个取链接的字段
 
String resulthref=doc.getChannel().getSite().getExternalUrl2()+doc.getFullHref(tag);


  // resulthref=doc.getChannel().getSite().getExternalUrl2()+Apphref;

out.print("{\"href\":\""+resulthref+"\"}");%>
