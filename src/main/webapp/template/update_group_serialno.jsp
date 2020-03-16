<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
TemplateGroup group;

/*
group = new TemplateGroup(5);
group.setSerialNo("page_frame_template");//框架模板
group.setType(1);
group.updateSerialNo();
*/

/*
group = new TemplateGroup(81);
group.setSerialNo("page_style");
group.setType(1);
group.updateSerialNo();
*/

/*
group = new TemplateGroup(4);
group.setSerialNo("page_sub_system");//子系统模板
group.setType(1);
group.updateSerialNo();
*/


group = new TemplateGroup(131);
group.setSerialNo("page_content_template");//页面模板
group.setType(1);
group.updateSerialNo();

%>