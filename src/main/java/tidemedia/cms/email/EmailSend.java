package tidemedia.cms.email;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.NoSuchProviderException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.util.ByteArrayDataSource;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;

public class EmailSend implements Runnable{

	private Thread 	runner;
	private int 	Email = 0;
	
	public EmailSend()
	{
		Start();
	}

	public EmailSend(int email)
	{
		Email = email;
		Start();
	}
	
	public void Start()
	{
		if(runner==null)
		{
			System.out.println("Send Email Start!");
	        runner = new Thread(this);
	        runner.start();
		}
	}
	
	public void run() {
		if(Email==0)
			return;
		try {
			
		boolean isexist = true;
		String	Sql = "";
		ResultSet Rs;
		ResultSet rs;
		
		TableUtil tu = new TableUtil();
		EmailContent ec = new EmailContent(Email);
		EmailConfig emailconfig = new EmailConfig();

		Properties props = new Properties();
		Session sendMailSession = null;		
		props.put("mail.smtp.host", emailconfig.getServer());
		props.put("mail.smtp.auth","true");
		sendMailSession = Session.getInstance(props, null);
		Transport transport;
		try {
			transport = sendMailSession.getTransport("smtp");
			transport.connect(emailconfig.getServer(), emailconfig.getUsername(),emailconfig.getPassword());
		} catch (NoSuchProviderException e1) {
			e1.printStackTrace();
			return;
		} catch (MessagingException e) {
			e.printStackTrace();
			return;
		}
		//System.out.println(emailconfig.getServer());

		Message msg = new MimeMessage(sendMailSession);
		//Multipart mp = new MimeMultipart();
		
		try {
			msg.setSubject(ec.getTitle());
	        //BodyPart tp = new MimeBodyPart();
	        //tp.setContent(ec.getContent(), "text/html;charset=gb2312");
	        //mp.addBodyPart(tp);
			String mail_begin = "<html><head><title>" +ec.getTitle()+"</title></head>";
			String mail_end = "</body></html>";
			msg.setDataHandler(new DataHandler(new ByteArrayDataSource(mail_begin + ec.getContent()+mail_end, "text/html;charset=gb2312")));
	        InternetAddress from = null;
	        if(ec.getSenderName().equals(""))
	        	from = new InternetAddress(ec.getSender());
	        else
	        	from = new InternetAddress(ec.getSender(),ec.getSenderName());
	        msg.setFrom(from);
		} catch (MessagingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
        while(isexist)
        {
			Sql = "select email_address.EmailAddress,email_address.id from email_address left join email_send_status on email_address.id=email_send_status.EmailAddress where email_send_status.Status is null or (email_send_status.Status!=1 and email_send_status.ErrorNumber<5) limit 0,50";
			
			Rs = tu.executeQuery(Sql);
			
			if(Rs.next())
			{
				do
				{
					boolean success = true;
					int emailadd = Rs.getInt("email_address.id");
			        InternetAddress to;
					try {
					to = new InternetAddress(Rs.getString("email_address.EmailAddress"));
					System.out.println(Rs.getString("email_address.EmailAddress"));
				    msg.setRecipient(Message.RecipientType.TO, to);
				    //System.out.println(to.getAddress());
					transport.sendMessage(msg, msg.getAllRecipients());
					} catch (AddressException e) {
						success = false;
						
						Sql = "update email_address set Status=-1 where id=" + emailadd;						
						tu.executeUpdate(Sql);
						e.printStackTrace();
					}catch(javax.mail.NoSuchProviderException e){						
						e.printStackTrace();
						tu.closeRs(Rs);
						
						ec.setStatus(3);
						ec.UpdateStatus();
						
						return;
					} catch (MessagingException e) {
						success = false;
						e.printStackTrace();
					}
					

					Sql = "select * from email_send_status where Email=" + ec.getId() + " and EmailAddress=" + emailadd;
						
					rs = tu.executeQuery(Sql);
					if(rs.next())
					{
						if(success)
						{
							Sql = "update email_send_status set Status=1 where Email=" + ec.getId() + " and EmailAddress=" + emailadd;
						}
						else
						{
							Sql = "update email_send_status set Status=0,ErrorNumber=ErrorNumber+1 where Email=" + ec.getId() + " and EmailAddress=" + emailadd;
						}
						tu.executeUpdate(Sql);
					}
					else
					{
						if(success)
						{
							Sql = "insert into email_send_status(Email,EmailAddress,Status,ErrorNumber) values(" ;
							Sql += ec.getId() + "," + emailadd + ",1,0)";
						}
						else
						{
							Sql = "insert into email_send_status(Email,EmailAddress,Status,ErrorNumber) values(" ;
							Sql += ec.getId() + "," + emailadd + ",0,1)";							
						}
						tu.executeUpdate(Sql);
					}
					
					tu.closeRs(rs);
					
				}while(Rs.next());
			}
			else
			{
				//发送完毕
				isexist = false;
				
				ec.setStatus(2);
				ec.UpdateStatus();
				
				Sql = "delete from email_send_status where Email=" + ec.getId() ;
				tu.executeUpdate(Sql);
				Sql = "delete from email_address where Status=-1";
				tu.executeUpdate(Sql);
			}
			
			tu.closeRs(Rs);
        }
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (MessageException e) {
			e.printStackTrace();
		} 	
	}

}
