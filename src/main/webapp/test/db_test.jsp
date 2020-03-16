<%@ page import="java.util.*,tidemedia.cms.base.*,tidemedia.cms.system.*,java.sql.*,org.apache.axis.client.*"%>
<%
		String url="jdbc:mysql://192.168.0.185:3306/tidemedia_cms_2?autoReconnect=true&user=root&password=vodone8888";
		TableUtil tu = new TableUtil();
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		Connection connection=(Connection) DriverManager.getConnection(url);
		Statement statement = connection.createStatement();
%>
//for(int i = 0;i<100000;i++)
//{
/*	out.println(CmsCache.getProductEdition());

	java.util.Calendar nowDate = new java.util.GregorianCalendar();
	out.println("<br>"+nowDate.getTimeInMillis()+","+CmsCache.getExpiresDate());
	CmsCache.licensevalid = true;
*/
//}
/*
		Service service = new Service();
		Call call = null;
			
			call = (Call) service.createCall();
			call.setOperationName("synMedia");
			call.setTargetEndpointAddress(new java.net.URL("http://sns.ekaikai.com/services.php"));
			String xmlContent = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><contents><content>";			
			String ret=(String)call.invoke(new Object[]{"","",xmlContent});		
			out.println(ret);
*/
