package tidemedia.cms.email;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

/**
 * @author Administrator
 *
 */
public class EmailAddress extends Table{

	private String Name = "";
	private String EmailAddress = "";
	
	private int	id;
	
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public EmailAddress() throws MessageException, SQLException {
		super();
	}
	
	
	public EmailAddress(int id) throws SQLException, MessageException
	{		
		String Sql = "select * from email_address where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setName(convertNull(Rs.getString("Name")));
			setEmailAddress(convertNull(Rs.getString("EmailAddress")));
			//setStatus(Rs.getInt("Status"));
			
			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("该记录不存在!");}
	}
	
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {

		String Sql = "";

		Sql = "select * from email_address where EmailAddress='" + SQLQuote(EmailAddress) + "'";
		if(isExist(Sql))
		{			
			throw new MessageException("此记录已经存在!",2);
		}
		
		Sql = "insert into email_address (";
		
		Sql += "Name,EmailAddress,CreateDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";//字符串要用SQLQuote方法处理一下
		Sql += ",'" + SQLQuote(EmailAddress) + "'";
		//Sql += "," + Status + "";		
		//Sql += "," + User + "";
		Sql += ",now()";
		
		Sql += ")";//这一行单独出来
		
		executeUpdate(Sql);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "delete from email_address where id="+id;
		executeUpdate(Sql);	
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {	
		String Sql = "";
			
		Sql = "update Demo set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		//Sql += ",Content='" + SQLQuote(Content) + "'";
		//Sql += ",Status=" + Status + "";
		
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

	public String getEmailAddress() {
		return EmailAddress;
	}

	public void setEmailAddress(String emailAddress) {
		EmailAddress = emailAddress;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}
	
}