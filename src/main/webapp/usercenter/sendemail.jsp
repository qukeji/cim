<%@ page import="tidemedia.cms.system.*,
                tidemedia.cms.user.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,				 
				java.util.*,
				java.net.URLEncoder,
				java.security.*,
				java.sql.*,
				java.sql.Connection,
				 java.util.ArrayList,
				 java.util.List,
				 java.util.Properties,
				 javax.mail.MessagingException,
				 javax.mail.Session,
				 javax.mail.Transport,
				 javax.mail.internet.InternetAddress,
				 javax.mail.internet.MimeMessage,
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
public void SentEmail(String Topic,String Content,String ReceivePerson) throws MessagingException{			 
			List list = new ArrayList();//不能使用string类型的类型，这样只能发送一个收件人
			String []ReceivePersonGroup=ReceivePerson.split(",");
			 for(int i=0;i<ReceivePersonGroup.length;i++){
	                     System.out.println(ReceivePersonGroup[i]+" 邮件接收端");
			     list.add(new InternetAddress(ReceivePersonGroup[i]));
			 }
			 InternetAddress[] Receiveaddress =(InternetAddress[])list.toArray(new InternetAddress[list.size()]);
			Properties props = new Properties();
			props.setProperty("mail.smtp.host", "smtp.mxhichina.com");
			props.setProperty("mail.transport.protocol", "smtp");
			props.setProperty("mail.smtp.auth", "true");
			Session session = Session.getInstance(props);
			MimeMessage msg = new MimeMessage(session);
			//InternetAddress[] toList = InternetAddress.parse(ReceivePerson, false);
			msg.addRecipients(MimeMessage.RecipientType.TO, Receiveaddress);
			InternetAddress fromAddress = new InternetAddress(
					"tidemedia@tidemedia.com");
			msg.setFrom(fromAddress);
			msg.setSentDate(new java.util.Date());			
			msg.setSubject(Topic, "utf-8"); // 设置标题
			String text =Content ;
			//SimpleDateFormat formatter = new SimpleDateFormat("HH:mm:ss");
			//msg.setText(text, "utf-8");
			msg.setContent(text, "text/html;charset=utf-8");
			msg.saveChanges();
			Transport transport = session.getTransport();
			transport.connect("smtp.mxhichina.com", "tidemedia@tidemedia.com","ojFNFFwpbFYCw+lN+d5S2LCs");
			transport.sendMessage(msg, msg.getAllRecipients());						
		}
%>
<%  
		       String  email_address  =	getParameter(request,"email");   			
 		       int channelid=14203;
			   JSONObject json = new JSONObject();
		 try{		
			   Channel channel   = CmsCache.getChannel(channelid);		
			   // int userid = getIntParameter(request,"userid");   
			   String  title="";             
			   TableUtil tu = new TableUtil();			 
			   String sql = "select Title from " + channel.getTableName() + " where Email='" +email_address+"'";
			   ResultSet rs = tu.executeQuery(sql);
			   if(rs.next())
			   {
			     title	= rs.getString("Title");				   
			   }
			  tu.closeRs(rs);
			  if(!title.equals("")&&title!=null){						
					String Topic="用户中心---找回密码";				
					String Content="此邮件为找回密码专用邮件!请在30分钟内<br>"
							+ "<br><a href='http://123.56.71.230:889/cms2018/usercenter/disposeemail.jsp?Email="+email_address+"&confirm_pass=1"
							+ "'>点击此处进行身份确定<a>或点击下方链接进行身份确定:<br>http://123.56.71.230:889/cms2018/usercenter/disposeemail.jsp?Email="+email_address+"&confirm_pass=1";
		            System.out.println("联系人邮件"+email_address+"-----------------------------");
					try {
						SentEmail(Topic,Content,email_address);
					} catch (MessagingException e) {					
						 json.put("message","邮件发送失败，请稍后再试");
						 e.printStackTrace();
						 out.println(json.toString());
					}
					   json.put("status",1);
					   session.setAttribute("Email",email_address);  
			           out.println(json.toString());					             		  
                       return;					   
				   }else{
					     json.put("message","用户信息异常请重新注册！");
						 out.println(json.toString());	 
						 return;	 
			       }					   		  
			  }catch(Exception e){
				e.printStackTrace();
			    json.put("message","数据处理异常，请稍后再试");
			    out.println(json.toString());	  	
			  } 		
%>
