package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;

/**
 * @author Administrator
 *
 * 
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TcenterLog extends Table {

	private int		id;
	private int		User;//操作者
	private int		Item;
	private int		LogAction = 0;//动作编号 参考LogAction.class
	private String  Title = "";	
	private	String 	CreateDate = "";
	private String 	FromType = "";
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public TcenterLog() throws MessageException, SQLException {
		super();
	}

	public TcenterLog(int id) throws SQLException, MessageException
	{
		String Sql = "select * from tcenter_log where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setTitle(convertNull(Rs.getString("Title")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			setUser(Rs.getInt("User"));
			setItem(Rs.getInt("Item"));
			setLogAction(Rs.getInt("LogAction"));
			setFromType(convertNull(Rs.getString("FromType")));
			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("该记录不存在!");}			
	}
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		TableUtil tu = new TableUtil("user");
		String Sql = "";
			
		Sql = "insert into tcenter_log (";
		
		Sql += "User,Item,LogAction,Fromtype,Title,CreateDate";
		Sql += ") values(";
		Sql += "" + User + "";
		Sql += "," + Item + "";
		Sql += "," + LogAction + "";
		Sql += ",'" + SQLQuote(FromType) + "'";
		Sql += ",'" + SQLQuote(Title) + "'";
		Sql += ",now()";
		
		Sql += ")";
		
		tu.executeUpdate(Sql);
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

	public String getCreateDate() {
		return CreateDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(String createDate) {
		CreateDate = createDate;
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

	public String getFromType() {
		return FromType;
	}

	public void setFromType(String fromType) {
		FromType = fromType;
	}

	public String getTitle() {
		return Title;
	}

	public void setTitle(String title) {
		Title = title;
	}

	public int getUser() {
		return User;
	}

	public void setUser(int user) {
		User = user;
	}

	public int getItem() {
		return Item;
	}

	public void setItem(int item) {
		Item = item;
	}
	
	public int getLogAction() {
		return LogAction;
	}

	public void setLogAction(int logAction) {
		LogAction = logAction;
	}
	
	public String getFromDesc(String fromtype)
	{
		String desc = "";
		if(fromtype.equals("company")) desc = "租户管理";
		else if(fromtype.equals("product")) desc = "运营支撑";
		else if(fromtype.equals("notice")) desc = "通知管理";
		else if(fromtype.equals("user")) desc = "用户管理";
		return desc;
	}
	
	public void CompanyLog(int logaction, String title, int userid,int actionuser) throws MessageException, SQLException {
		TcenterLog l = new TcenterLog();
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("company");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}
	
	public void ProductLog(int logaction, String title, int userid,int actionuser) throws MessageException, SQLException {
		TcenterLog l = new TcenterLog();
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("product");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}
	
	public void NoticeLog(int logaction, String title, int userid,int actionuser) throws MessageException, SQLException {
		TcenterLog l = new TcenterLog();
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("notice");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}
	
	public void UserLog(int logaction, String title, int userid,int actionuser) throws MessageException, SQLException {
		TcenterLog l = new TcenterLog();
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("user");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}

}
