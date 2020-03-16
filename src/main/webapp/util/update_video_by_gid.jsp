<%@ page import="java.io.*,tidemedia.cms.util.*,tidemedia.cms.system.*,tidemedia.cms.base.*,java.sql.*"%><%@ page contentType="text/html;charset=utf-8" %><%@ include file="../config1.jsp"%><%
int		gid				= getIntParameter(request,"globalid");
String  coverhref		= getParameter(request,"coverhref");
String		vid			= getParameter(request,"videoid");
int		status			= getIntParameter(request,"status");
String  result			= "false";

if(gid>0)
{
Document document = new Document(gid);

if(document.getId()>0&&document.getChannel().getChannelCode().startsWith("4024_4347"))
	{
		TableUtil tu = new TableUtil();

		String statusdesc = "";
		if(status==1) statusdesc = "处理失败";
		else if(status==2) statusdesc = "处理中";
		else if(status==3) statusdesc = "处理完成";

		String sql = "update " + document.getChannel().getTableName() + " set ";
		sql += "videoid='" + vid + "',";
		sql += "videostatus='" + tu.SQLQuote(statusdesc) + "',";
		sql += "coverhref='"+tu.SQLQuote(coverhref)+"' where id="+document.getId();
		//out.println(sql);
		tu.executeUpdate(sql);
		//new ItemSnap().Update(document);//加入全局库
		result = "true";
	}
}
out.println(result);
%>