<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,java.io.*,java.net.*,org.apache.commons.io.*,org.dom4j.io.*,org.dom4j.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
String url = "http://vip.bet007.com/xmlvbs/ch_odds.xml";
	String content = "";

	InputStream in = null;

		in = new URL(url).openStream();
		content = IOUtils.toString(in,"utf-8");
		content = content.trim();
		int i = content.indexOf("<?xml");
		out.println("i:"+i);
		content = content.substring(i);
		
StringReader strInStream=new StringReader(content.trim());
			SAXReader reader = new SAXReader(); 
			org.dom4j.Document doc;

							doc = reader.read(strInStream);
				Element root = doc.getRootElement(); 
				Element foo = null; 
	 
	 out.println(content);
%>