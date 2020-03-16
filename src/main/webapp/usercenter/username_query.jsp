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
 * 用途：用户注册用户名重复验证
 * 
 *								
 */
    String username	=	getParameter(request,"username");
    Channel channel_login = CmsCache.getChannel("tidehome_user");
	TableUtil tu = new TableUtil();
	boolean repeat = false;		
	String sql = "select Title from " + channel_login.getTableName() + " where Title='" + username + "'";		  			  
	ResultSet rs = tu.executeQuery(sql);
	if(rs.next())
	{
		repeat = true;	 
	}
	tu.closeRs(rs);
	JSONObject json = new JSONObject();	
	if(repeat){
		json.put("status","success");
	    out.println(json.toString());	
	}else{
		json.put("status","failes");
	    out.println(json.toString());	
	}
%>
