<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");
//System.setProperty("file.encoding","gb2312");

String SerialNo			=	getParameter(request,"SerialNo");

Channel ch = new Channel();
if(ch.checkSerialNo(SerialNo)){
%>
alert('标识名已经被使用!请重新输入！');
document.form.SerialNo.focus();
<%}%>
