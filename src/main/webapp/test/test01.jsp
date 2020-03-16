<%@ page import="tidemedia.cms.base.*,tidemedia.cms.system.*,tidemedia.cms.publish.*,java.sql.*,javax.sql.*,javax.naming.*,org.apache.axis.client.*"%>
<%
TideFtpClient tideftp = FtpManager.getFtp(2);
if(tideftp.getFtp()!=null) 
{
	out.println("1");
}
else
{
	out.println("2");
}
%>