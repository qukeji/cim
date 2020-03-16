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
			String  email_address  =	getParameter(request,"email"); 
            String  password  =	getParameter(request,"password"); 			
		 try{		
			   Channel channel   = CmsCache.getChannel(channelid);		
			   if(!password.equals("")&&password!=null&&!email_address.equals("")&&email_address!=null){
				   password  = encryption(encryption(password));
				   TableUtil tu_ = new TableUtil();			 
				   String sql_ = "update " + channel.getTableName() + " set Password='" + password + "' where Email='" + email_address+"'" ;
				   System.out.println("修改信息语句===="+sql_);
				   tu_.executeUpdate(sql_);
				   json.put("status",1);
			       out.println(json.toString());
				   return;	
			   }			             	  
			  }catch(Exception e){
				e.printStackTrace();
			 	json.put("status",2);
			    out.println(json.toString());	  	
			  } 		
%>
