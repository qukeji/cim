package tidemedia.cms.dict;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

/**
 * @author Administrator
 *
 */
public class Dict extends Table{

	private String Name 		= "";//名称
	private int	id;
	private int	Group			= 0;
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public Dict() throws MessageException, SQLException {
		super();
	}

	public Dict(int id) throws SQLException, MessageException
	{
		String Sql = "select * from dict where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setName(convertNull(Rs.getString("Name")));
			setGroup(Rs.getInt("GroupID"));
		}
		
		closeRs(Rs);
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";

		if(Name.equals(""))
			throw new MessageException("名称不能为空.");

		Sql = "select * from dict where Name='" + SQLQuote(Name) + "' and GroupID=" + Group;
		if(isExist(Sql))
		{
			throw new MessageException("该名称已经存在!",2);
		}

		Sql = "insert into dict (";

		Sql += "GroupID,Name,CreateDate";
		Sql += ") values(";
		Sql += "" + Group + "";
		Sql += ",'" + SQLQuote(Name) + "'";
		Sql += ",now()";

		Sql += ")";
		//System.out.println(Sql);

		int insertid = executeUpdate_InsertID(Sql);	
		setId(insertid);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		
		String Sql = "";
		
		if(Name.equals(""))
			throw new MessageException("名称不能为空.");
		
		Sql = "select * from dict where Name='" + SQLQuote(Name) + "' and GroupID=" + Group + " and id!=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("该名称已经存在!",2);
		}
		
		Sql = "update dict set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		Sql += ",Name='" + SQLQuote(Name) + "'";
		
		Sql += " where id=" + getId();	
		
		executeUpdate(Sql);	
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "delete from dict where id=" + id;
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

	public void setName(String name) {
		Name = name;
	}

	public String getName() {
		return Name;
	}

	public void setGroup(int group) {
		Group = group;
	}

	public int getGroup() {
		return Group;
	}
}
