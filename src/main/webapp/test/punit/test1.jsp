<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.test.*,
				org.punit.runner.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../config.jsp"%>
<%
System.out.println("-------------------");
new SoloRunner().run(SimpleTestClass.class);
ConcurrentRunner runner = new ConcurrentRunner(100);
runner.methodRunner().addWatcher(new org.punit.watcher.MemoryWatcher());
runner.run(SimpleTestClass.class);
%>
<br>Over!