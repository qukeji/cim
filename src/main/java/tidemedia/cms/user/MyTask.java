/*
 * Created on 2005-6-23
 *
 */
package tidemedia.cms.user;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

/**
 * @author Administrator
 *
 */
public class MyTask extends Table{

	private String Name = "";
	private String Content = "";
	private int	id;
	private int User;
	private int OrderNumber;
	private int Status;	
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public MyTask() throws MessageException, SQLException {
		super();
	}

	public MyTask(int id) throws SQLException, MessageException
	{
		String Sql = "select * from mytask where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setName(convertNull(Rs.getString("Name")));
			setContent(convertNull(Rs.getString("Content")));
			setOrderNumber(Rs.getInt("OrderNumber"));
			setStatus(Rs.getInt("Status"));
			
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
		
		Sql = "insert into mytask (";
		
		Sql += "Name,Content,Status,User,CreateDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Content) + "'";
		Sql += "," + Status + "";		
		Sql += "," + User + "";
		Sql += ",now()";
		
		Sql += ")";
		
		executeUpdate(Sql);

		Sql = "update mytask set OrderNumber=id where OrderNumber is null or OrderNumber=0";
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

	/**
	 * @return Returns the id.
	 */
	public int getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(int id) {
		this.id = id;
	}
	/**
	 * @return Returns the orderNumber.
	 */
	public int getOrderNumber() {
		return OrderNumber;
	}
	/**
	 * @param orderNumber The orderNumber to set.
	 */
	public void setOrderNumber(int orderNumber) {
		OrderNumber = orderNumber;
	}
	/**
	 * @return Returns the user.
	 */
	public int getUser() {
		return User;
	}
	/**
	 * @param user The user to set.
	 */
	public void setUser(int user) {
		User = user;
	}
	/**
	 * @return Returns the content.
	 */
	public String getContent() {
		return Content;
	}
	/**
	 * @param content The content to set.
	 */
	public void setContent(String content) {
		Content = content;
	}
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return Name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		Name = name;
	}
	/**
	 * @return Returns the status.
	 */
	public int getStatus() {
		return Status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(int status) {
		Status = status;
	}
	
	public void ChangeToComplete() throws SQLException, MessageException
	{
		String Sql = "update mytask set Status=2 where id=" + getId();
		
		executeUpdate(Sql);
	}
}
