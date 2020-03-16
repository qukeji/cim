<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,				 
				java.util.*,
				java.net.URLEncoder,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%  		
			JSONObject json = new JSONObject();
		    session.removeAttribute("username");
			session.removeAttribute("userid");
			json.put("status",1);
			out.println(json.toString());	  		
%>
