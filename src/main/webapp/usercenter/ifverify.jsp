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
              JSONObject json = new JSONObject();	
     	 try{
			  String email = (String)session.getAttribute("Email"); 
			  System.out.println("存入的email===="+email);
			  int channelid=14203;			  			
			   Channel channel   = CmsCache.getChannel(channelid);		
			   // int userid = getIntParameter(request,"userid");   
			   String  title=""; 
               int confirm_pass=0;			   
			   TableUtil tu = new TableUtil();			 
			   String sql = "select Title,confirm_pass from " + channel.getTableName() + " where Email='" +email+"'";
			   ResultSet rs = tu.executeQuery(sql);
			   if(rs.next())
			   {
			     title	= rs.getString("Title");	
                 confirm_pass	= rs.getInt("confirm_pass");				 
			   }
			  tu.closeRs(rs);
			  if(confirm_pass==1){
				 session.setAttribute("username",title);
				  TableUtil tu_ = new TableUtil();			 
			      String sql_ = "update "+channel.getTableName()+" set confirm_pass=0 where Email='" +email+"'";
			      tu_.executeUpdate(sql_);	 
				  json.put("status",1);				  
				  out.println(json.toString());				  
                  return;					   
			  }else{
				   json.put("status",2);
				   out.println(json.toString());
                   return;						  
			  }
              }catch(Exception e){
				e.printStackTrace();			   
			    out.println("数据处理异常，请稍后再试");	  	
			  } 		
%>
