<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,				 
				java.util.*,
				java.net.URLEncoder,
				java.security.*,
				java.sql.*,
				java.sql.Connection,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
                JSONObject json = new JSONObject();	
	       try{
			   String  email_address  =	getParameter(request,"Email");  
		       int confirm_pass = getIntParameter(request,"confirm_pass");  	  
	           int channelid=14203;
	           Channel channel   = CmsCache.getChannel(channelid);		
			   // int userid = getIntParameter(request,"confirm_pass");   
			   String  title="";   
			   TableUtil tu = new TableUtil();			 
			   String sql = "update "+channel.getTableName()+" set confirm_pass="+confirm_pass+" where Email='" +email_address+"'";
			   tu.executeUpdate(sql);	         
              out.println("确认成功请返回找回密码页面重新输入密码！");	 			  
		   }catch (Exception e) {											
					  e.printStackTrace();					  
                     out.println("确认失败，请重新发送邮件或从新执行找回密码流程！");					  
					}
%>
