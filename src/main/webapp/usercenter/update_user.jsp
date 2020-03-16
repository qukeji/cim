<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,				 
				java.util.*,
				java.net.URLEncoder,
				java.security.*,
				java.sql.*,
				org.apache.commons.lang.StringEscapeUtils,
				java.sql.Connection,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%  
			   int channelid=14203;
			   Channel channel = CmsCache.getChannel(channelid);		
			   String title  =	getParameter(request,"username");	
               HttpSession session_ = request.getSession();
		       session_.setAttribute("username",title);        			   
			   int id = getIntParameter(request,"uid");
			   HttpSession session_id = request.getSession();
		       session_id.setAttribute("userid",id);        		
			   String province  =	getParameter(request,"province");	  
			   String city  =	getParameter(request,"city");	  
			   String truename  =	getParameter(request,"truename");	  
			   String phone  =	getParameter(request,"phone");	 
			   String address  =	getParameter(request,"address");
			   String saytext  =	getParameter(request,"saytext");
			  try{			
			   TableUtil tu_ = new TableUtil();			 
			   String sql_ = "update " + channel.getTableName() + " set Title='" + title + "',Province='"+province+"',City='"+ city +"',Truename ='"+truename+"',Phone ='"+phone+"',Address ='"+address+"',Summary ='"+saytext+"' where Title='" + title + "'";
			   System.out.println("修改信息语句===="+sql_);
			   tu_.executeUpdate(sql_);				 
			   out.println("{\"status\":1}");
           	   return;	
			  }catch(Exception e){
				e.printStackTrace();
			    out.println("{\"status\":2}");	  	
			  } 		
%>
