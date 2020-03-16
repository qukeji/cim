<%@ page import="tidemedia.cms.util.*,
				java.io.File,java.math.*,
				tidemedia.cms.outer.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
String	Name	= getParameter(request,"Name");
String	Content	= getParameter(request,"Content");

HashMap map = new HashMap();
map.put("Title",Name);
map.put("Content",Content);

ItemUtil util = new ItemUtil();
util.addItem(4465,map);
%>