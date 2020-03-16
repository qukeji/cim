<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
long begin_time = System.currentTimeMillis();
String Action = getParameter(request,"Action");

Tree tree = new Tree();

String channel_tree_string = "";



%>
