package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.LogAction;
import tidemedia.cms.system.TcenterLog;

/*
 * 通知管理
 * */
public class Notice extends Table{

	private int		id;
	private String 	Title = "";//通知内容
	private String 	StartDate = "";//开始时间，单位是秒
	private long	StartDateL = 0;
	private String 	EndDate = "";//结束时间，单位是秒
	private long	EndDateL = 0;
	private int 	UserId=0; //当前操作用户
	
	public Notice() throws MessageException, SQLException {
		super();
	}

	public Notice(int id) throws SQLException, MessageException
	{
		
		TableUtil tu_user = new TableUtil("user");
		String Sql = "select id,Title,StartDate,UNIX_TIMESTAMP(StartDate) as StartDateL,EndDate,UNIX_TIMESTAMP(EndDate) as EndDateL from notice where id="+id;
		ResultSet Rs = tu_user.executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setTitle(convertNull(Rs.getString("Title")));
			setStartDate(convertNull(Rs.getString("StartDate")));
			setStartDateL(Rs.getInt("StartDateL"));
			setEndDate(convertNull(Rs.getString("EndDate")));
			setEndDateL(Rs.getInt("EndDateL"));
		}
		tu_user.closeRs(Rs);		
	}
	
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(Title.equals(""))
			throw new MessageException("通知内容不能为空.");
		
		TableUtil tu_user = new TableUtil("user");
		
		Sql = "insert into notice (";
		Sql += "Title,StartDate,EndDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Title) + "'";
		
		if(StartDate.length()==0)
			Sql += ",null";
		else
			Sql += ",'" + SQLQuote(StartDate) + "'";
		
		if(EndDate.length()==0)
			Sql += ",null";
		else
			Sql += ",'" + SQLQuote(EndDate) + "'";

		Sql += ")";
		
		int insertid = tu_user.executeUpdate_InsertID(Sql);
		
		setId(insertid);
				
		new TcenterLog().NoticeLog(LogAction.notice_add, SQLQuote(Title), id, UserId);
	}
	
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		if(Title.equals(""))
			throw new MessageException("通知内容不能为空.");
		
		TableUtil tu_user = new TableUtil("user");
		
		Sql = "update notice set ";
		Sql += "Title='" + SQLQuote(Title) + "'";
		
		if(StartDate.length()==0)
			Sql += ",StartDate=null";
		else
			Sql += ",StartDate='" + SQLQuote(StartDate) + "'";
		
		if(EndDate.length()==0)
			Sql += ",EndDate=null";
		else
			Sql += ",EndDate='" + SQLQuote(EndDate) + "'";
		
		Sql += " where id="+id;
		
		tu_user.executeUpdate(Sql);
						
		new TcenterLog().NoticeLog(LogAction.notice_edit, Title, id, UserId);		
	}

	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";
		TableUtil tu_user = new TableUtil("user");
		
		Sql = "delete from notice where id="+id;
		tu_user.executeUpdate(Sql);	
		
		new TcenterLog().NoticeLog(LogAction.notice_delete, Title, id, UserId);
		
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return Title;
	}

	public void setTitle(String title) {
		Title = title;
	}

	public String getStartDate() {
		return StartDate;
	}

	public void setStartDate(String startDate) {
		StartDate = startDate;
	}

	public long getStartDateL() {
		return StartDateL;
	}

	public void setStartDateL(long startDateL) {
		StartDateL = startDateL;
	}

	public String getEndDate() {
		return EndDate;
	}

	public void setEndDate(String endDate) {
		EndDate = endDate;
	}

	public long getEndDateL() {
		return EndDateL;
	}

	public void setEndDateL(long endDateL) {
		EndDateL = endDateL;
	}

	public int getUserId() {
		return UserId;
	}

	public void setUserId(int userId) {
		UserId = userId;
	}

	@Override
	public boolean canAdd() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canDelete() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canUpdate() {
		// TODO Auto-generated method stub
		return false;
	}
}
