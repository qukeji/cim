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
public class ShortCut extends Table{

	private String Description = "";
	private String Href = "";
	private String Target = "";
	private String Icon = "";
	private int	id;
	private int User;
	private int OrderNumber;
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public ShortCut() throws MessageException, SQLException {
		super();
	}

	public ShortCut(int id) throws SQLException, MessageException
	{
		String Sql = "select * from shortcut where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setDescription(convertNull(Rs.getString("Description")));
			setHref(convertNull(Rs.getString("Href")));
			setIcon(convertNull(Rs.getString("Icon")));			
			setOrderNumber(Rs.getInt("OrderNumber"));
			
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
		
		Sql = "insert into shortcut (";
		
		Sql += "Description,Href,Target,Icon,User,CreateDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Description) + "'";
		Sql += ",'" + SQLQuote(Href) + "'";
		Sql += ",'" + SQLQuote(Target) + "'";
		Sql += ",'" + SQLQuote(Icon) + "'";
		Sql += "," + User + "";
		Sql += ",now()";
		
		Sql += ")";
		
		executeUpdate(Sql);

		Sql = "update shortcut set OrderNumber=id where OrderNumber is null or OrderNumber=0";
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
	 * @return Returns the description.
	 */
	public String getDescription() {
		return Description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		Description = description;
	}
	/**
	 * @return Returns the href.
	 */
	public String getHref() {
		return Href;
	}
	/**
	 * @param href The href to set.
	 */
	public void setHref(String href) {
		Href = href;
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
	 * @return Returns the target.
	 */
	public String getTarget() {
		return Target;
	}
	/**
	 * @param target The target to set.
	 */
	public void setTarget(String target) {
		Target = target;
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
	 * @return Returns the icon.
	 */
	public String getIcon() {
		return Icon;
	}
	/**
	 * @param icon The icon to set.
	 */
	public void setIcon(String icon) {
		Icon = icon;
	}
}
