<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%String url = request.getRequestURL()+"";
url = url.replace("tools.jsp","");%>
window.open("http://cms.tidedemo.com/cms_test/content/document.jsp?ItemID=0&ChannelID=221&transfer_article="+document.location.href);