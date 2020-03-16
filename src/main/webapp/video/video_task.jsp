<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.page.*,tidemedia.cms.video.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
TableUtil tu = new TableUtil();

String title = getParameter(request,"title");
String video_source = getParameter(request,"video_source");
String video_dest = getParameter(request,"video_dest");
int	   itemid	= getIntParameter(request,"itemid");

System.out.println("接口调用:"+title+","+video_source+","+video_dest);

int type = getIntParameter(request,"type");
if(type==1)
{
	TranscodeManager m = TranscodeManager.getInstance();
	m.Start();
	out.println("start");
}
else
{
	String sql="insert into channel_transcode(Title,video_source,video_dest,itemid,SubTitle,Summary,keyword,Tag,CreateDate,ModifiedDate,PublishDate,Active,Status,Status2,Category) values(";
	sql += "'"+tu.SQLQuote(title)+"','"+tu.SQLQuote(video_source)+"','"+tu.SQLQuote(video_dest)+"',";
	sql += itemid+",";
	sql += "'','','','',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),1,0,0,0)";

	if(video_source.length()>0 && video_dest.length()>0)
		tu.executeUpdate(sql);

	TranscodeManager m = TranscodeManager.getInstance();
	m.Start();
}
%>