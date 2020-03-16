<%@ page pageEncoding="utf-8" import="java.util.*,
								  tidemedia.cms.base.TableUtil,
								  tidemedia.cms.user.*,
								  java.sql.ResultSet"%>
<%@ include file="../config1.jsp"%>
<%
	/**
		*拆条整合cms系统用户
		*
		*
		*/
	  String username2 = getParameter(request,"userkey");
	  Cookie[] cookies = request.getCookies();
	 if(cookies!=null&&username2.length()==0)
	{ 
		for(int i=0;i<cookies.length;i++)
		{
			if(cookies[i].getName().equals("Username2"))			 
				 username2 = cookies[i].getValue();
		}
	}
	 String op = getParameter(request,"op");
	 String sql = "select * from userinfo";
	 String xml = "";
	 TableUtil tu = new TableUtil("user"); 
	 ResultSet set = null;
  
	 if(op.equals("getUserList"))
	{
			 set = tu.executeQuery(sql);
			 xml += "<root><done>ok</done><userList>";
			 while(set.next())
			{
				if(set.getInt("role")!=1)
					 xml +="<userName>"+set.getString("Username")+"</userName>";
			}
			 xml +="</userList></root>";
 	 }
	else if(!username2.equals(""))
	{ 
		 xml += "<root><done>ok</done>";	
		 String password = "";
		 String[] values = UserInfoUtil.decodePasswordCookie(username2, new String(new char[] { '\023', 'C', 'i' }));
		 if (values != null) 
		{
			password = values[1];
		 }
		// sql += " where Password='" + tu.SQLQuote(password) + "'";
		 sql += " where Password='" + tu.SQLQuote(password) + "' and username='"+values[0]+"'";
		 set = tu.executeQuery(sql);
		 int userType =2;
		 if(set.next())
		{
				if(set.getInt("role")==1)
				   userType = 1;
				xml +="<userType>"+userType+"</userType>";
				xml +="<userName>"+set.getString("Username")+"</userName>";
		 } 
		  xml +="</root>";
	 }
	 tu.closeRs(set); 
	
	 out.println(xml);
	%>
