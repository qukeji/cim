<%@ page import="javax.naming.*,java.sql.*,javax.sql.*"%>
<%
			    Context initctx=new InitialContext();
		        Context envCtx=(Context) initctx.lookup("java:comp/env");
		        Connection connection = ((DataSource)envCtx.lookup("jdbc/mysql")).getConnection();
%>