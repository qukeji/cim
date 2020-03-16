<%@ page import="tidemedia.cms.user.UserInfo,
							     java.net.URLEncoder,java.util.Enumeration,
								 java.sql.SQLException,
								 java.util.ArrayList,
								 java.util.Enumeration,
								 javax.servlet.http.HttpSession,
								 javax.servlet.http.HttpSessionEvent,
								 javax.servlet.http.HttpSessionListener,
								 tidemedia.cms.user.UserInfo"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="config1.jsp"%>
<%!
	
%>
<%
		String UserName=getParameter(request,"username");
		String SessionID=getParameter(request,"sessionid");
		HttpSession currentSession=(HttpSession)this.getServletContext().getAttribute(UserName);
		try{
			//System.out.println(UserName+"---删除----"+currentSession.getId());
			//注销Session
			if(!currentSession.getId().equals(SessionID)){
				tidemedia.cms.util.Util.Logout(currentSession);
			}
		}catch(Exception e){
			//Storagesession.invalidate();
			System.out.println("出现异常");
			e.printStackTrace();
		}

%>