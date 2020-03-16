/*
 * Created on 2018-10-15
 */
package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.util.Util;


/**
 * @author Administrator
 *
 */
public class ApproveScheme extends Table{

	private int		id;
	private String 	Title = "";
	private int Status;//方案是否开启的标识 ，0：启动，1：关闭（默认开启）
	private int UserId=0;
	private ArrayList<ApproveItems> approveitems = new ArrayList<ApproveItems>();
	private int editable=0;//是否开启编辑功能 ,0:未启动 1：启动（默认关闭）
	private int company;	//租户ID

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public ApproveScheme() throws MessageException, SQLException {
		super();
	}

	public ApproveScheme(int id) throws SQLException, MessageException
	{
		String Sql = "";

		Sql = "select * from approve_scheme where id=" + id;

		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setTitle(convertNull(Rs.getString("Title")));
			setStatus(Rs.getInt("Status"));
			setEditable(Rs.getInt("editable"));
			setApproveitems(getApproveItemsList(Rs.getInt("id")));
			closeRs(Rs);
		}
		else{
			closeRs(Rs);
		}
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";

		if(Title.equals(""))
			throw new MessageException("方案名称不能为空.");

		Sql = "select * from approve_scheme where Title='" + SQLQuote(Title) + "'";
		if(isExist(Sql))
		{
			throw new MessageException("此方案已经存在!",2);
		}

		Sql = "insert into approve_scheme (";
		Sql += "Title,Status,editable,company";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Title) + "'";
		Sql += "," + Status;
		Sql += "," + editable;
		Sql += "," + company;
		Sql += ")";

		int insertid = executeUpdate_InsertID(Sql);

		setId(insertid);

		new Log().ApproveSchemeLog(LogAction.approve_scheme_add, SQLQuote(Title), id, UserId);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from channel where ApproveScheme=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("审核方案已经被使用!",4);
		}

		//删除对应的审核环节
		Sql = "select * from approve_items where parent=" + id;
		ResultSet Rs = executeQuery(Sql);
		String itemId = "";
		while(Rs.next())
		{
			if(!itemId.equals("")){
				itemId += ",";
			}
			itemId += Rs.getInt("id");
		}
		closeRs(Rs);

		String[] ids = Util.StringToArray(itemId, ",");
		if (ids != null && ids.length > 0) {
			for (int i = 0; i < ids.length; i++) {
				int id_ = Util.parseInt(ids[i]);
				new ApproveItems().Delete(id_);
			}
		}

		new Log().ApproveSchemeLog(LogAction.approve_scheme_delete, new ApproveScheme(id).getTitle(), id, UserId);
		//删除审核方案
		Sql = "delete from approve_scheme where id=" + id;
		executeUpdate(Sql);

		CmsCache.delApprove(id);
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";

		if(Title.equals(""))
			throw new MessageException("方案名称不能为空.");

		Sql = "select * from approve_scheme where Title='" + SQLQuote(Title) + "' and id!="+id;
		if(isExist(Sql))
		{
			throw new MessageException("此方案已经存在!",2);
		}

		Sql = "update approve_scheme set Title='"+SQLQuote(Title)+"',editable='"+editable+"' where id=" + id;

		executeUpdate(Sql);

		CmsCache.delApprove(id);

		new Log().ApproveSchemeLog(LogAction.approve_scheme_edit, new ApproveScheme(id).getTitle(), id, UserId);
	}

	// 启动此发布任务
	public void Enable() throws SQLException, MessageException {
		String Sql = "";

		Sql = "update approve_scheme set ";
		Sql += "Status=0";
		Sql += " where id=" + id;

		executeUpdate(Sql);

		CmsCache.delApprove(id);

		new Log().ApproveSchemeLog(LogAction.approve_scheme_start, new ApproveScheme(id).getTitle(), id, UserId);
	}

	// 禁止此发布任务
	public void Disable() throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from channel where ApproveScheme=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("审核方案已经被使用!",4);
		}

		Sql = "update approve_scheme set ";
		Sql += "Status=1";
		Sql += " where id=" + id;

		executeUpdate(Sql);

		CmsCache.delApprove(id);

		new Log().ApproveSchemeLog(LogAction.approve_scheme_stop, new ApproveScheme(id).getTitle(), id, UserId);
	}

	//获取方案下所有环节
	public ArrayList<ApproveItems> getApproveItemsList(int id) throws SQLException, MessageException
	{
		ArrayList<ApproveItems> list = new ArrayList<ApproveItems>() ;

		String Sql = "select * from approve_items where parent=" + id + " order by step asc";

		ResultSet Rs = executeQuery(Sql);
		while(Rs.next()){
			int id_ = Rs.getInt("id");
			ApproveItems ai = new ApproveItems(id_);
			list.add(ai);
		}
		closeRs(Rs);

		return list ;
	}

	public ArrayList<ApproveItems> getApproveitems() {
		return approveitems;
	}

	public void setApproveitems(ArrayList<ApproveItems> approveitems) {
		this.approveitems = approveitems;
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

	public int getStatus() {
		return Status;
	}

	public void setStatus(int status) {
		Status = status;
	}

	public int getUserId() {
		return UserId;
	}

	public void setUserId(int userId) {
		UserId = userId;
	}
	public void setEditable(int editable){
		this.editable =editable;
	}
	public int getEditable(){
		return editable;
	}
	public int getCompany() {
		return company;
	}
	public void setCompany(int company) {
		this.company = company;
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
