package tidemedia.cms.util;

import java.io.IOException;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.mail.Address;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.util.ByteArrayDataSource;

import tidemedia.cms.system.Log;

public class Email {

	public Email()
	{
		
	}
	
	public static boolean send(String server,String username,String password,String title,String content,String from,String to)
	{
		Properties props = new Properties();
		Session sendMailSession = null;		
		props.put("mail.smtp.host", server);
		props.put("mail.smtp.auth","true");
		sendMailSession = Session.getInstance(props, null);
		Transport transport;
		try {
			transport = sendMailSession.getTransport("smtp");
			transport.connect(server, username,password);
		} catch (NoSuchProviderException e1) {
			e1.printStackTrace(System.out);
			return false;
		} catch (MessagingException e) {
			Log.SystemLog("邮件发送", "连接不上SMTP服务器，"+e.getMessage());			
			return false;
		}
		
		InternetAddress fromAdd = null;
		try {
			fromAdd = new InternetAddress(from);
		} catch (AddressException e) {
			Log.SystemLog("邮件发送", "邮件发送人地址不正确，"+e.getMessage());	
			return false;
		}
		
		String[] to_ = Util.StringToArray(to, ";");
		Address[] tos = null;
		
        try {
        	tos = new InternetAddress[to_.length];
            
            for (int i=0; i<to_.length; i++){
                tos[i] = new InternetAddress(to_[i]);
            }
		} catch (AddressException e) {
			Log.SystemLog("邮件发送", "邮件接收人地址不正确，"+e.getMessage());	
			return false;
		}
        
		Message msg = new MimeMessage(sendMailSession);
		try {
			msg.setSubject(title);
			msg.setDataHandler(new DataHandler(new ByteArrayDataSource(content, "text/html;charset=gb2312")));
			
	        msg.setFrom(fromAdd);
	        
	        msg.addRecipients(Message.RecipientType.TO, tos);
	        transport.sendMessage(msg, msg.getAllRecipients());
		}catch (IOException e) {
			Log.SystemLog("邮件发送", "邮件发送没有成功，"+e.getMessage());	
			return false;
		} catch (MessagingException e) {
			Log.SystemLog("邮件发送", "邮件发送没有成功，"+e.getMessage());	
			return false;
		}
		
		return true;
		
	}
}
