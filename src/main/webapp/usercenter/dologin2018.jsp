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
<%!
public String encryption(String plainText) {
		String re_md5 = new String();
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(plainText.getBytes());
			byte b[] = md.digest();

			int i;

			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				i = b[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buf.append("0");
				buf.append(Integer.toHexString(i));
			}

			re_md5 = buf.toString();

		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		}
		return re_md5;
	}
%>

<%
/*
 * 用途：用户中心登录
 * 							
 */
          int channelid=14203;
         String username_	=	getParameter(request,"username");
		 String username    =   StringEscapeUtils.escapeHtml(username_);
         String password	=	getParameter(request,"password");
		 String  password2  =   StringEscapeUtils.escapeHtml(password);
         int remember = getIntParameter(request,"remember");
         String Password_	="";           
			Channel channel_login = CmsCache.getChannel(channelid);
			TableUtil tu = new TableUtil();
			String sql = "select Password,Email from " + channel_login.getTableName() + " where Title='" + username + "'";		  			  
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next())
			{
			 Password_	= rs.getString("Password"); 
			 String Email	= rs.getString("Email");    
			}
			tu.closeRs(rs);
		   password2 = encryption(encryption(password2));
         JSONObject json = new JSONObject();
       if(password2.equals(Password_)){
	        json.put("status",1);
			json.put("msg","page.jsp");
		    session.setAttribute("username",username_);        
			if(remember==1){		
			Cookie cookie = new Cookie("user",URLEncoder.encode(username_,"UTF-8"));
		    Cookie cookie_ = new Cookie("pass",password);				
		    cookie.setMaxAge(365*24*60*60);
			cookie_.setMaxAge(365*24*60*60);
		    response.addCookie(cookie);			
            response.addCookie(cookie_);				
			}			
	       out.println(json.toString());		
		   return;
          }else if(!Password_.equals("")&&!password2.equals(Password_)){
			json.put("status",0);
			json.put("msg","账号或密码错误");
			out.println(json.toString());			
			return;
		  }else{
			  json.put("status",3);
			  out.println(json.toString());		
		  }
%>
