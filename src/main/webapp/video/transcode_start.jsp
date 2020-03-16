<%@ page import="tidemedia.cms.video.*,
				java.util.*,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
TranscodeManager tm = TranscodeManager.getInstance();
tm.Start();
%>