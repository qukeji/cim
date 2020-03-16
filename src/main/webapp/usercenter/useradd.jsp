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
	     plainText =StringEscapeUtils.escapeHtml(plainText);
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
 * 用途：用户中注册
 * 
 *								
 */      
         System.out.println("进入添加用户=");		
          int ChannelID = 14203;
         String username_ = getParameter(request,"username");	
		        username = StringEscapeUtils.escapeHtml(username_);				
         String password	=	getParameter(request,"password");
		        password = encryption(encryption(password));
         String email	=	getParameter(request,"email");
				System.out.println("去特殊后email="+email);
		 String code =	getParameter(request,"verify");
		  HashMap map = new HashMap();
		  map.put("Title",username);
		  map.put("Password",password);
	      map.put("Email",email);
		  map.put("confirm","0");
		 // map.put("Verify_Time",time());
		  map.put("Status","1");
		 // map.put("Active","1");	
		   JSONObject json = new JSONObject();
		   int id=0;
        try{
		  int globalid = ItemUtil.addItemGetGlobalID(ChannelID,map);
					 Document doc1 = new Document(globalid);
					 id = doc1.getId();
		  System.out.println("保存返回globalid="+globalid);		
		}catch(Exception e){
			e.printStackTrace();
			 json.put("status",2);
			json.put("msg","注册失败");
			out.println(json.toString());	
			return;
		}		  
		    HttpSession session_ = request.getSession();
		    session_.setAttribute("username",username_);  
		    json.put("status",1);
			json.put("msg","../usercenter/page.jsp");
			out.println(json.toString());	
%>
