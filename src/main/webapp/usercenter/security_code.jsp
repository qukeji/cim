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
 * 用途：用户登录注册验证码验证
 * 
 *								
 */
    String verify	=	getParameter(request,"verify");
    String security_code = (String)session.getAttribute("security_code");
	System.out.println("取出的验证码==="+security_code);
    JSONObject json = new JSONObject();
    if(verify.equals(security_code)){
    //out.println("{"message":\"good\"}");	
	json.put("message","good");
	out.println(json.toString());
   }else{
	json.put("message","error");
    out.println(json.toString());	
}
%>
