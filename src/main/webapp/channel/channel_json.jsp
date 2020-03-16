<%@ page import="tidemedia.cms.util.Util,tidemedia.cms.system.*,org.json.*"%><%@ page contentType="text/html;charset=utf-8" %><%response.setHeader("Pragma","No-cache"); response.setHeader("Cache-Control","no-cache"); response.setDateHeader("Expires", 0);%>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"ChannelID");

Tree2019 tree = new Tree2019();

JSONArray o = tree.listChannel_json(id,"",userinfo_session,1000);
out.println(o);
%>
