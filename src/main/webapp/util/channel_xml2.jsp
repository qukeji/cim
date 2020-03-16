<?xml version="1.0" encoding="utf-8"?><%@ page import="tidemedia.cms.system.*,tidemedia.cms.report.*,tidemedia.cms.base.*,tidemedia.cms.util.*,tidemedia.cms.user.*,java.util.*,java.sql.*"%><%@ page contentType="text/xml;charset=utf-8" %><%@ include file="../config.jsp"%>
<%int id = Util.getIntParameter(request,"id");
if(id!=0){
	SystemTools tool=new SystemTools();
	out.println(tool.makeChannelXML(id));
}
%>