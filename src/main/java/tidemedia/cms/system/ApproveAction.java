package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.*;

public class ApproveAction extends Table{
	
	private int		id;
	private String 	Title = "";//审核文章名称
	private int 	parent ;//审核文章编号globalid
	private int		userid ;//审核人编号
	private int 	Action;//是否通过 ，1：不通过 0：通过
	private int 	ApproveId;//审核环节编号
	private String 	ApproveName = "";//审核环节名称
	private int  	endApprove;//是否终审 0：否 1：是
	private String	ActionMessage = "";//审核信息
	private String 	CreateDate = "";// 创建时间

	public ApproveAction() throws MessageException, SQLException {
		super();
	}
	
	public ApproveAction(int id) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from approve_actions where id=" + id;
				
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setTitle(convertNull(Rs.getString("Title")));
			setParent(Rs.getInt("parent"));
			setUserid(Rs.getInt("userid"));
			setAction(Rs.getInt("Action"));
			setApproveId(Rs.getInt("ApproveId"));
			setApproveName(convertNull(Rs.getString("ApproveName")));
			setEndApprove(Rs.getInt("endApprove"));
			setActionMessage(convertNull(Rs.getString("ActionMessage")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			closeRs(Rs);
		}
		else{
			closeRs(Rs);
		}			
	}
	//获取最近的一次审核操作
	public ApproveAction(int parent,int type) throws SQLException, MessageException
	{
		
		String Sql = "select * from approve_actions where parent=" + parent + " order by id desc limit 1";
				
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setTitle(convertNull(Rs.getString("Title")));
			setParent(Rs.getInt("parent"));
			setUserid(Rs.getInt("userid"));
			setAction(Rs.getInt("Action"));
			setApproveId(Rs.getInt("ApproveId"));
			setApproveName(convertNull(Rs.getString("ApproveName")));
			setEndApprove(Rs.getInt("endApprove"));
			setActionMessage(convertNull(Rs.getString("ActionMessage")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			closeRs(Rs);
		}
		else{
			closeRs(Rs);
		}
	}

	@Override
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		Sql = "insert into approve_actions (";

		Sql += "Title,parent,userid,Action,ApproveId,ApproveName,endApprove,ActionMessage,CreateDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Title) + "'";
		Sql += "," + parent + "";
		Sql += "," + userid + "";
		Sql += "," + Action + "";
		Sql += "," + ApproveId + "";
		Sql += ",'" + SQLQuote(ApproveName) + "'";
		Sql += "," + endApprove + "";
		Sql += ",'" + SQLQuote(ActionMessage) + "'";
		Sql += ",now()";

		Sql += ")";
		int insertId = executeUpdate_InsertID(Sql);
		if(insertId > 0){
			ApproveItems approveItems = new ApproveItems(ApproveId);
			String url = approveItems.getUrl();
			if(url.length()>0){
				url = url+"?insertId="+insertId;
				url = Util.ClearPath(url);
		  		Util.connectHttpUrl(url);
			}
		}
	}

	@Override
	public void Delete(int gid) throws SQLException, MessageException {
		
		String Sql = "";
		Sql = "delete from approve_actions where parent=" + gid;
		
		TableUtil tu = new TableUtil();
		tu.executeUpdate(Sql);
	}

	@Override
	public void Update() throws SQLException, MessageException {
		// TODO Auto-generated method stub
		
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

	public int getParent() {
		return parent;
	}

	public void setParent(int parent) {
		this.parent = parent;
	}

	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}

	public int getAction() {
		return Action;
	}

	public void setAction(int action) {
		Action = action;
	}

	public int getApproveId() {
		return ApproveId;
	}

	public void setApproveId(int approveId) {
		ApproveId = approveId;
	}

	public int getEndApprove() {
		return endApprove;
	}

	public void setEndApprove(int endApprove) {
		this.endApprove = endApprove;
	}

	public String getActionMessage() {
		return ActionMessage;
	}

	public void setActionMessage(String actionMessage) {
		ActionMessage = actionMessage;
	}

	public String getCreateDate() {
		return CreateDate;
	}

	public void setCreateDate(String createDate) {
		CreateDate = createDate;
	}

	public String getApproveName() {
		return ApproveName;
	}

	public void setApproveName(String approveName) {
		ApproveName = approveName;
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
