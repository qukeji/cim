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
			   int item_gid = getIntParameter(request,"item_gid");
			   int type = getIntParameter(request,"type");		
			   JSONObject json = new JSONObject();
			  try{			
			   TableUtil tu_ = new TableUtil();			 
			   String sql_ = "update channel_tidehome_collect set Active=0 where item_gid=" + item_gid + " and type="+type;
			   System.out.println("删除收藏信息语句===="+sql_);
			   tu_.executeUpdate(sql_);				 
			   json.put("status",1);
			   out.println(json.toString());
           	   return;	
			  }catch(Exception e){
				e.printStackTrace();
			   json.put("status",2);
			   out.println(json.toString());  	
			  } 		
%>
