<%@ page language="java" import="java.util.*,tidemedia.cms.base.TableUtil,tidemedia.cms.user.*" pageEncoding="utf-8"%>
<%@page import="java.sql.ResultSet"%>
<%@ include file="../config1.jsp"%>
<%
 String username2 = getParameter(request,"userkey");
 String op = getParameter(request,"op");
 String sql = "select * from userinfo";
 String xml = "<root><done>ok</done>";
 TableUtil tu = new TableUtil("user"); 
 ResultSet set = null;
 if(op.equals("getUserList")){
 set = tu.executeQuery(sql);
 xml += "<userList>";
  while(set.next()){
        if(set.getInt("role")!=1)
 	 xml +="<userName>"+set.getString("Username")+"</userName>";
 }
 xml +="</userList>";
// tu.closeRs(set);  
 }
 if(!username2.equals("")){
 String password = "";
 String[] values = UserInfoUtil.decodePasswordCookie(username2, new String(new char[] { '\023', 'C', 'i' }));
      if (values == null) {
        password = "";
      }
      else {
        password = values[1];
      }
      
//  sql += " where Password=md5('" + tu.SQLQuote(password) + "')";
  sql += " where Password='" + tu.SQLQuote(password) + "'";
//System.out.println("sql=="+sql);
 set = tu.executeQuery(sql);
  int userType =2;
  if(set.next()){
 	if(set.getInt("role")==1)
 	   userType = 1;
       xml +="<userType>"+userType+"</userType>";
       xml +="<userName>"+set.getString("Username")+"</userName>";
  } 
 
 }
tu.closeRs(set); 
 xml +="</root>";
 out.println(xml);
%>
