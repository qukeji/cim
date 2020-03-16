package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.Util;

/**
 * @author Administrator
 *
 * 
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ErrorLog extends Table {

	private int		id;
	private String 	Name = "";
	private int 	Type = 0;//1 错误日志 2普通信息
	private String	Message = "";
	private String 	Content = "";
	private	String 	CreateDate = "";
	private int		IsRead = 0;
	
	public static int	Number1 = 0;//错误日志数量
	public static int	Number2 = 0;//普通日志数量
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public ErrorLog() throws MessageException, SQLException {
		super();
	}

	public ErrorLog(int id) throws SQLException, MessageException
	{
		String Sql = "select * from system_log where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setName(convertNull(Rs.getString("Name")));
			setType(Rs.getInt("Type"));
			setMessage(convertNull(Rs.getString("Message")));
			setContent(convertNull(Rs.getString("Content")));
			setCreateDate(convertNull(Rs.getString("Date")));
			setIsRead(Rs.getInt("IsRead"));
			
			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("该记录不存在!");}			
	}
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException 
	{
		String Sql = "";
		if(Type==1)
		{
			ErrorLog.Number1 ++;
			if(ErrorLog.Number1>20000)
			{
				AutoDelete(1,10000);
				ErrorLog.Number1 = 10000;
			}
		}
		if(Type==2)
		{
			ErrorLog.Number2 ++;
			if(ErrorLog.Number2>20000)
			{
				AutoDelete(2,10000);
				ErrorLog.Number2 = 10000;
			}
		}
		
		int len = 500;		
		if(Message==null) Message = "";
		if(Message.length()>len)
			Message = Util.substring(Message, len);
		
			
		Sql = "insert into system_log (";
		
		Sql += "Name,Type,Message,Content,Date,IsRead";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += "," + Type + "";
		Sql += ",'" + SQLQuote(Message) + "'";
		Sql += ",'" + SQLQuote(Content) + "'";
		Sql += ",now(),0";
		
		Sql += ")";
		
		executeUpdate(Sql);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		
	}

	//自动删除
	public void AutoDelete(int type,int number) throws MessageException, SQLException
	{
		int logid = 0;
		String sql = "select id from system_log where Type=" + type+ " limit " + number + ",1";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
		{
			logid = rs.getInt("id");
		}
		tu.closeRs(rs);
		
		sql = "delete from system_log where Type=" + type+ " and id<=" + logid;
		tu.executeUpdate(sql);
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
	 * @return Returns the createDate.
	 */
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
	 * @return Returns the message.
	 */
	public String getMessage() {
		return Message;
	}
	/**
	 * @param message The message to set.
	 */
	public void setMessage(String message) {
		Message = message;
	}
	/**
	 * @return Returns the isRead.
	 */
	public int getIsRead() {
		return IsRead;
	}
	/**
	 * @param isRead The isRead to set.
	 */
	public void setIsRead(int isRead) {
		IsRead = isRead;
	}
	
	public static String StackToString(Exception e) {
		  try {
		    java.io.StringWriter sw = new java.io.StringWriter();
		    java.io.PrintWriter pw = new java.io.PrintWriter(sw);
		    e.printStackTrace(pw);
		    return "" + sw.toString() + "";
		    }
		  catch(Exception e2) {
		    return "bad stack2string";
		    }
	}
	
	public static void SaveErrorLog(String Message,String ErrorMessage,int channelid,Exception e)
	{
		ErrorLog errorlog;
		try {
			if(channelid>0)
			{
				Channel channel = CmsCache.getChannel(channelid);
				String fullpath = channel.getParentChannelPath();
				Message = Message.replace("{parentchannelpath}", fullpath);
			}
			else if(channelid==0)
			{
				Message = Message.replace("{parentchannelpath}", "");
			}
			
			errorlog = new ErrorLog();
			errorlog.setType(1);
			errorlog.setName(Message);
			errorlog.setMessage(ErrorMessage + "\r\n错误信息:" + e.getMessage());
			errorlog.setContent(ErrorMessage + "\r\n\r\n" + StackToString(e));
			errorlog.Add();
		} catch (MessageException e1) {
			e1.printStackTrace();
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	}

	public static void Log(String name,String message,String content)
	{
		ErrorLog errorlog;
		try {
			errorlog = new ErrorLog();
			errorlog.setType(2);
			errorlog.setName(name);
			errorlog.setMessage(message);
			errorlog.setContent(content);
			errorlog.Add();
		} catch (MessageException e1) {
			e1.printStackTrace();
		} catch (SQLException e1) {
			e1.printStackTrace();
		}
	}
	
	public void setType(int type) {
		Type = type;
	}

	public int getType() {
		return Type;
	}	
}
