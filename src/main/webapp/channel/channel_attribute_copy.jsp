<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

int id = getIntParameter(request,"id");
String field = getParameter(request,"field");
String value = getParameter(request,"value");

int type = 0;

if(field.equals("Attribute1"))				type = 1;
if(field.equals("Attribute2"))				type = 2;
if(field.equals("RecommendOut"))			type = 3;
if(field.equals("RecommendOutRelation"))	type = 4;
if(field.equals("ListJS"))					type = 5;
if(field.equals("DocumentJS"))				type = 6;
if(field.equals("ListProgram"))				type = 7;
if(field.equals("DocumentProgram"))			type = 8;



if(id>0) ChannelUtil.updateSubChannelsAttribute(id,type,value);
%>