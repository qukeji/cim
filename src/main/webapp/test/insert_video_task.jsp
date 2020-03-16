<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.page.*,tidemedia.cms.video.*,
				tidemedia.cms.util.*,tidemedia.cms.publish.*,java.util.concurrent.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
TableUtil tu = new TableUtil();

int type = getIntParameter(request,"type");
if(type==1)
{
	String sql = "update video_task set Status2=0";
	tu.executeUpdate(sql);
	TranscodeManager m = TranscodeManager.getInstance();
	m.Start();
	out.println("start");
}
else
{
		String sql="insert into video_task(Title,video_source,video_dest,SubTitle,Summary,keyword,Tag,CreateDate,ModifiedDate,PublishDate,Active,Status,Status2,Category) values('a.avi','a.avi','a.flv','','','','',UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),1,1,0,0)";
				out.println(sql);
	int insertid = tu.executeUpdate_InsertID(sql);
}
%>