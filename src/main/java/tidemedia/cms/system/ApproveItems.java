/*
 * Created on 2018-10-15
 */
package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.json.JSONException;
import org.json.JSONObject;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.system.CmsCache;


/**审核环节表
 * @author Administrator
 *
 */
public class ApproveItems extends Table{

	private int		id;
	private String 	Title = "";
	private String	users = "";//用户编号
	private int Type;//审核模式 ，1：并签  0：或签
	private int parent;//审核方案编号
	private int step;//审核步骤
	private int editable=0;//是否开启编辑功能 ,0:未启动 1：启动（默认关闭）
	private String url = "";//回调地址

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public ApproveItems() throws MessageException, SQLException {
		super();
	}
	
	public ApproveItems(int id) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from approve_items where id=" + id;
				
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setTitle(convertNull(Rs.getString("Title")));
			setUsers(convertNull(Rs.getString("users")));
			setType(Rs.getInt("Type"));
			setParent(Rs.getInt("parent"));
			setStep(Rs.getInt("step"));
			setEditable(Rs.getInt("editable"));
			setUrl(convertNull(Rs.getString("url")));
			closeRs(Rs);
		}
		else{
			closeRs(Rs);
		}			
	}
	
	//获取下一审核环节名称
	public JSONObject getApproveName(int id) throws SQLException, MessageException, JSONException
	{
		String ApproveName = "";
		int Step = 0;
		int approveItemId = 0;
		int Editable = 0;//0:关闭，1：开启
		JSONObject json = new JSONObject();
		if(id==0){//id!=0,说明是提交审核
			id = parent ;	
		}
		String Sql = "select * from approve_items where parent=" + id +" and step>"+step+" order by step asc limit 1";
				
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			ApproveName = convertNull(Rs.getString("Title"));
			Editable = Rs.getInt("editable");
			approveItemId = Rs.getInt("id");
            Step = Rs.getInt("step");
			json.put("endLink", 0);
			closeRs(Rs);
		}
		else{
			json.put("endLink", 1);
			closeRs(Rs);
		}
		json.put("ApproveName", ApproveName);
		json.put("Editable", Editable);
		json.put("approveItemId",approveItemId);
		json.put("step",Step);
		return json;
	}
	
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(step==0)
			throw new MessageException("审核步骤不能为空.");
		
		Sql = "select * from approve_items where step="+step+" and parent="+parent;
		if(isExist(Sql))
		{
			throw new MessageException("此审核环节已经存在!",2);
		}
		
		Sql = "insert into approve_items (";
		Sql += "Title,users,Type,parent,step,editable,url";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Title) + "'";
		Sql += ",'" + SQLQuote(users) + "'";
		Sql += "," + Type;
		Sql += "," + parent;
		Sql += "," + step;
		Sql += "," + editable;//是否开启编辑
		Sql += ",'" + SQLQuote(url) + "'";
		Sql += ")";
		int insertid = executeUpdate_InsertID(Sql);	
		setId(insertid);
		
		CmsCache.delApprove(parent);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";
		
		int parent = new ApproveItems(id).getParent() ;
		Sql = "select * from channel where ApproveScheme=" + parent;
		if(isExist(Sql))
		{
			throw new MessageException("审核方案已经被使用!",4);
		}
		
//		Sql = "select * from approve_actions where ApproveId=" + id;
//		if(isExist(Sql))
//		{
//			throw new MessageException("审核环节已经被使用!",4);
//		}
		
		Sql = "delete from approve_items where id=" + id;
		executeUpdate(Sql);	
		
		CmsCache.delApprove(parent);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "update approve_items set ";
		Sql += "Title='" + SQLQuote(Title) + "'";
		Sql += ",users='" + SQLQuote(users) + "'";
		Sql += ",Type=" + Type;
		Sql += ",editable=" + editable;//是否开启编辑
		Sql += ",url='" + SQLQuote(url) + "'";
		Sql += " where id=" + id;
		executeUpdate(Sql);
		
		CmsCache.delApprove(parent);
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

	public String getUsers() {
		return users;
	}

	public void setUsers(String users) {
		this.users = users;
	}

	public int getType() {
		return Type;
	}

	public void setType(int type) {
		Type = type;
	}

	public int getParent() {
		return parent;
	}

	public void setParent(int parent) {
		this.parent = parent;
	}

	public int getStep() {
		return step;
	}

	public void setStep(int step) {
		this.step = step;
	}

	public int getEditable() {
		return editable;
	}

	public void setEditable(int editable) {
		this.editable = editable;
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
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

}
