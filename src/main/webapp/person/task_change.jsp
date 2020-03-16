<%@ page import="java.sql.*,
				tidemedia.cms.user.MyTask"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int id = getIntParameter(request,"id");

MyTask task = new MyTask(id);

task.ChangeToComplete();

response.sendRedirect("../close_pop.jsp");
%>
