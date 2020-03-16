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
	    plainText  =   StringEscapeUtils.escapeHtml(plainText);	
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
		
 		    int channelid=14203;
			JSONObject json = new JSONObject();
		 try{		
			   Channel channel   = CmsCache.getChannel(channelid);		
			   String  password  =	getParameter(request,"password");   
			   // int userid = getIntParameter(request,"userid");   
			   String  userid  =	getParameter(request,"userid");   
			   int userid_  =Integer.valueOf(userid);
               System.out.println("修改信userid==="+userid);			   
			   String password_new  =	getParameter(request,"password_new");	  
			   password  = encryption(encryption(password));
			   System.out.println("修改信password_new=="+password_new);
			   String password_="";	   	
			   TableUtil tu = new TableUtil();			 
			   String sql = "select Password from " + channel.getTableName() + " where id=" +userid_;
			   ResultSet rs = tu.executeQuery(sql);
			   if(rs.next())
			   {
			     password_	= rs.getString("Password"); 
			   }
			   tu.closeRs(rs);
			   if(password.equals(password_)){
				   password_new  = encryption(encryption(password_new));
				   TableUtil tu_ = new TableUtil();			 
				   String sql_ = "update " + channel.getTableName() + " set Password='" + password_new + "' where id=" + userid_ ;
				   System.out.println("修改信息语句===="+sql_);
				   tu_.executeUpdate(sql_);	
                   Cookie[] cookies = request.getCookies();
                   Cookie cookie = null;
                   if (cookies != null && cookies.length > 0) {
                       for (int i = 0; i < cookies.length; i++) {
                       cookie = cookies[i];
                       if (cookie.getName().equals("pass")) {
                           cookie.setMaxAge(0);
						   System.out.println(cookie.getName()+"进入到cookie");
						   response.addCookie(cookie);
						   json.put("status",1);
			           out.println(json.toString());	
					   }					   
			      }
			   }
			   }
			  
           	   return;	
			  }catch(Exception e){
				e.printStackTrace();
			 	json.put("status",2);
			    out.println(json.toString());	  	
			  } 		
%>
