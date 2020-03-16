<%@ page import="tidemedia.cms.util.Util,tidemedia.cms.system.*,tidemedia.cms.user.*"%><%@ page contentType="text/html;charset=utf-8" %><%response.setContentType("text/xml");%><%response.setHeader("Pragma","No-cache"); response.setHeader("Cache-Control","no-cache"); response.setDateHeader("Expires", 0);%><?xml version="1.0"  encoding="utf-8"?>
<%@ include file="../config1.jsp"%>
<%
//返回资源中心的频道结构XML
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
if(id==0) id = 2;
Tree tree = new Tree();
UserInfo userinfo_session = CmsCache.getUser(9);
%><%=tree.listChannel_JS_xml(id,userinfo_session)%>
