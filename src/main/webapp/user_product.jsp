<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				java.text.SimpleDateFormat,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config.jsp"%>
<%
	TableUtil tu_user = new TableUtil("user");
	String updateSql = "update user_product set status=STATUS,modifydate='MODIFYDATE' where productid =PRODUCTID and userid=USERID";
	String insertSql = "insert into user_product(productid,userid,status,modifydate) values(PRODUCTID,USERID,STATUS,'MODIFYDATE')";
	Integer userId = userinfo_session.getId();
	String sql = "select * from user_product where userid !=''";
	//tu_user.executeUpdate("delete from user_product");
	/*ResultSet rs= tu_user.executeQuery(sql);
	System.out.println("userId----------------------------------"+userId);
	while(rs.next()){
	    System.out.println("USERID:"+rs.getString("userId")+"   PRODUCTID:"+rs.getString("PRODUCTID"));
	}
	tu_user.closeRs(rs);*/
	java.util.Date currentTime = new java.util.Date();  
    SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
    String dateString = formatter.format(currentTime);  
	int sum = 0;
	try{
		String ids = getParameter(request,"ids");
		String status = getParameter(request,"status");
		String[] idgroup = ids.split(",");
		String[] statuss = status.split(",");
		for(int i = 0;i<statuss.length;i++){
			String[] id = idgroup[i].split("-");
			String uid = id[0];
			String pid = id[1];
			if(!"".equals(uid)){
			    String executeSQL= updateSql.replace("STATUS",statuss[i]);
				executeSQL = executeSQL.replace("PRODUCTID",pid);
				executeSQL = executeSQL.replace("USERID",uid);
				executeSQL = executeSQL.replace("MODIFYDATE",dateString);
				sum=tu_user.executeUpdate(executeSQL)+sum;	
			}else{
				 String executeSQL= insertSql.replace("STATUS",statuss[i]);
				executeSQL = executeSQL.replace("PRODUCTID",pid);
				executeSQL = executeSQL.replace("USERID",userId+"");
				executeSQL = executeSQL.replace("MODIFYDATE",dateString);
				sum=tu_user.executeUpdate(executeSQL)+sum;
			}
		}
	}catch(Exception e){
		out.print(e);
	}
		out.println(sum);
%>
