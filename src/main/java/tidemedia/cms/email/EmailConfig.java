package tidemedia.cms.email;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

/**
 * @author Administrator
 *
 */
public class EmailConfig extends Table{

	private String Server = "";
	private String Username = "";
	private String Password = "";
	private String Email = "";
	private String Personal = "";	
	private int	id;
	
	public EmailConfig() throws SQLException, MessageException
	{
		String Sql = "select * from email_config";
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setServer(convertNull(Rs.getString("Server")));//字符串要convertNull
			setUsername(convertNull(Rs.getString("Username")));
			setPassword(convertNull(Rs.getString("Password")));
			setEmail(convertNull(Rs.getString("Email")));
			setPersonal(convertNull(Rs.getString("Personal")));
			
			closeRs(Rs);
		}
		closeRs(Rs);
		//else
			//throw new MessageException("该记录不存在!");	
		
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {

		String Sql = "";

		Sql = "delete from email_config";
		executeUpdate(Sql);
		
		Sql = "insert into email_config (";
		
		Sql += "Server,Username,Password,Email,Personal,CreateDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Server) + "'";//字符串要用SQLQuote方法处理一下
		Sql += ",'" + SQLQuote(Username) + "'";
		Sql += ",'" + SQLQuote(Password) + "'";
		Sql += ",'" + SQLQuote(Email) + "'";
		Sql += ",'" + SQLQuote(Personal) + "'";		
		Sql += ",now()";
		
		Sql += ")";//这一行单独出来
		//System.out.println(Sql);
		executeUpdate(Sql);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {	
		//String Sql = "";
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

	public String getEmail() {
		return Email;
	}

	public void setEmail(String email) {
		Email = email;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getPassword() {
		return Password;
	}

	public void setPassword(String password) {
		Password = password;
	}

	public String getServer() {
		return Server;
	}

	public void setServer(String server) {
		Server = server;
	}

	public String getUsername() {
		return Username;
	}

	public void setUsername(String username) {
		Username = username;
	}

	public String getPersonal() {
		return Personal;
	}

	public void setPersonal(String personal) {
		Personal = personal;
	}	
}