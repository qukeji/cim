package tidemedia.cms.email;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

/**
 * @author Administrator
 *
 */
public class EmailContent extends Table{

	private String Title = "";
	private String Content = "";
	private String Sender = "";
	private String SenderName = "";
	private String CreateDate = "";
	private int    Status=0;
	private int	id;
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public EmailContent() throws MessageException, SQLException {
		super();
	}

	public EmailContent(int id) throws SQLException, MessageException
	{
		String Sql = "select * from email_content where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setTitle(convertNull(Rs.getString("Title")));
			setContent(convertNull(Rs.getString("Content")));
			setSender(convertNull(Rs.getString("Sender")));
			setSenderName(convertNull(Rs.getString("SenderName")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			setStatus(Rs.getInt("Status"));
			
			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("该记录不存在!");}
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public int Add_GetID() throws SQLException, MessageException {

		String Sql = "";
	
		Sql = "insert into email_content (";
		
		Sql += "Title,Content,Sender,SenderName,Status,CreateDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Title) + "'";//字符串要用SQLQuote方法处理一下
		Sql += ",'" + SQLQuote(Content) + "'";
		Sql += ",'" + SQLQuote(Sender) + "'";
		Sql += ",'" + SQLQuote(SenderName) + "'";		
		Sql += "," + Status + "";		
		//Sql += "," + User + "";
		Sql += ",now()";
		
		Sql += ")";//这一行单独出来
		
		return executeUpdate_InsertID(Sql);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "delete from email_content where id=" + id;
		
		executeQuery(Sql);
	}

	public void Delete() throws SQLException, MessageException {
		if(getStatus()==1)
			return;
		
		String Sql = "";
		
		Sql = "delete from email_send_status where Email=" + id;
		executeUpdate(Sql);
		
		Sql = "delete from email_content where id=" + id;		
		executeUpdate(Sql);
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {	
		String Sql = "";
			
		Sql = "update email_content set ";
		
		Sql += "Title='" + SQLQuote(Title) + "'";
		Sql += ",Content='" + SQLQuote(Content) + "'";
		Sql += ",Sender='" + SQLQuote(Sender) + "'";
		Sql += ",SenderName='" + SQLQuote(SenderName) + "'";		
		Sql += ",Status=" + Status + "";
		
		Sql += " where id="+id;
		
		executeUpdate(Sql);
	}

	public void UpdateStatus() throws SQLException, MessageException {	
		String Sql = "";
			
		Sql = "update email_content set ";
		
		Sql += "Status=" + Status + "";
		
		Sql += " where id="+id;
		
		executeUpdate(Sql);
	}	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canAdd()
	 */
	public boolean canAdd() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canUpdate()
	 */
	public boolean canUpdate() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canDelete()
	 */
	public boolean canDelete() {
		return false;
	}

	public String getContent() {
		return Content;
	}

	public void setContent(String content) {
		Content = content;
	}

	public String getCreateDate() {
		return CreateDate;
	}

	public void setCreateDate(String createDate) {
		CreateDate = createDate;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getSender() {
		return Sender;
	}

	public void setSender(String sender) {
		Sender = sender;
	}

	public String getTitle() {
		return Title;
	}

	public void setTitle(String title) {
		Title = title;
	}

	public void Add() throws SQLException, MessageException {
		
	}

	public int getStatus() {
		return Status;
	}

	public void setStatus(int status) {
		Status = status;
	}

	public String getSenderName() {
		return SenderName;
	}

	public void setSenderName(String senderName) {
		SenderName = senderName;
	}
	
}