<%@ page import="tidemedia.cms.video.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%
String s2 = "/usr/bin/ffmpeg -i http://10.1.120.243/approve/live?channel=HuangHeNews&type=iptv -c:v copy -c:a libfaac -ar 44100 -ab 48k -f flv rtmp://10.1.120.155/video/sxrtv/news_h";
		 	
StreamAgent stream1 = new StreamAgent();
stream1.setCmd(s2);
stream1.setLog(1);
stream1.start();
%>