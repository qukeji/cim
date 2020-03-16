<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,
				java.sql.*,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
/*
 * 用途：用户注册邮箱验证
 * 
 *								
 */
    String email	=	getParameter(request,"email");
    Channel channel_login = CmsCache.getChannel("tidehome_user");
	TableUtil tu = new TableUtil();
	boolean repeat = false;		
	String sql = "select Title from " + channel_login.getTableName() + " where Email='" + email + "'";		  			  
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		repeat = true;	 
	}
	tu.closeRs(rs);
	TableUtil tu_ = new TableUtil();
	String sql_ = "select * from " + channel_login.getTableName();		  			  
	ResultSet rs_ = tu_.executeQuery(sql_);
	if(rs_.next())
	{
		 String	 Password_	= rs_.getString("Password"); 
		 String Email	= rs_.getString("Email");  
         String title	= rs_.getString("Title"); 		 
		 System.out.println("取出的Password_==="+Password_);
		  System.out.println("取出的Email==="+Email);
		   System.out.println("取出的title==="+title);	 
	}
	tu_.closeRs(rs_);
	JSONObject json = new JSONObject();	
	if(repeat){
		json.put("status","success");
	    out.println(json.toString());	
	}else{
		json.put("status","failes");
	    out.println(json.toString());	
	}
%>
