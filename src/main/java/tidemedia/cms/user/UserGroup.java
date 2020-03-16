/*
 * Created on 2005-9-26
 *
 */
package tidemedia.cms.user;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.Util;

/**
 * @author Administrator
 *
 */
public class UserGroup extends Table{

	private int		id;
	private String 	Name = "";
	private int 	Parent;
	private int		OrderNumber;
	private int		company;

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public UserGroup() throws MessageException, SQLException {
		super();
	}

	public UserGroup(int id) throws SQLException, MessageException
	{
		String Sql = "";
		TableUtil tu_user = new TableUtil("user");
		Sql = "select * from user_group where id=" + id;
		ResultSet Rs = tu_user.executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setParent(Rs.getInt("Parent"));
			setCompany(Rs.getInt("company"));

			tu_user.closeRs(Rs);
		}
		else
			{tu_user.closeRs(Rs);throw new MessageException("This user group is not exist!");}			
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		TableUtil tu_user = new TableUtil("user");
		if(Name.equals(""))
			throw new MessageException("用户组名称不能为空.");
		
		Sql = "select * from user_group where Name='" + SQLQuote(Name) + "'";
		if(tu_user.isExist(Sql))
		{
			throw new MessageException("此用户组已经存在!",2);
		}

		if(Parent==0)
		{
			Sql = "select * from user_group where Parent=-1";
			ResultSet Rs = tu_user.executeQuery(Sql);
			if(Rs.next())
			{
				Parent = Rs.getInt("id");				
			}
			else
			{
				tu_user.closeRs(Rs);
				throw new MessageException("This Root User Group is not exist!");
			}
			tu_user.closeRs(Rs);
		}
		
		Sql = "insert into user_group (";
		
		Sql += "Name,Parent,CreateDate,Status,company";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += "," + Parent + "";		
		Sql += ",now(),1";
		Sql += "," + company ;
		Sql += ")";
		
		tu_user.executeUpdate(Sql);		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";
		TableUtil tu_user = new TableUtil("user");
		Sql = "select * from userinfo where GroupID=" + id;
		if(tu_user.isExist(Sql))
		{
			throw new MessageException("用户组下还有用户，不能删除!",MessageException.ALERT_HISTORY_BACK);
		}
		
		Sql = "select id from user_group where Parent=" + id;
		ResultSet Rs = tu_user.executeQuery(Sql);
		while(Rs.next())
		{
			int groupid = Rs.getInt("id");		
			Delete(groupid);
		}
		tu_user.closeRs(Rs);

		Sql = "delete from user_group where id=" + id;
		tu_user.executeUpdate(Sql);		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		TableUtil tu_user = new TableUtil("user");
		Sql = "select * from user_group where Name='" + SQLQuote(Name) + "' and id!=" + id;
		if(tu_user.isExist(Sql))
		{
			throw new MessageException("用户组名称已经被使用!",4);
		}
		
		Sql = "update user_group set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		
		Sql += ",company="+company;
		
		Sql += " where id="+id;
		
		tu_user.executeUpdate(Sql);			
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
	public int getCompany() {
		return company;
	}

	public void setCompany(int company) {
		this.company = company;
	}

	/**
	 * @return Returns the parent.
	 */
	public int getParent() {
		return Parent;
	}
	/**
	 * @param parent The parent to set.
	 */
	public void setParent(int parent) {
		Parent = parent;
	}
	/**
	 * @return Returns the parentName.
	 * @throws MessageException
	 * @throws SQLException
	 */
	public String getParentName() throws SQLException, MessageException {
		String parentName = "";
		TableUtil tu_user = new TableUtil("user");
		String Sql = "select * from user_group where id=" + getParent();
		
		ResultSet Rs = tu_user.executeQuery(Sql);
		if(Rs.next())
			parentName = convertNull(Rs.getString("Name"));
		
		tu_user.closeRs(Rs);
		
		return parentName;
			
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
	
	public String listGroup_JS(UserInfo user) throws SQLException, MessageException
	{
		TableUtil tu_user = new TableUtil("user");
		String JS = "";
		int RootGroupID = 0;
		
		String Sql = "select * from user_group where Parent=-1";
		ResultSet Rs = tu_user.executeQuery(Sql);
		if(!Rs.next())
		{
			tu_user.closeRs(Rs);
			return "";
		}
		else
		{
			String RootGroupName = convertNull(Rs.getString("Name"));			
			RootGroupID = Rs.getInt("id");
			
			JS += "	var tree = new WebFXTree('" + Util.JSQuote(RootGroupName) + "','javascript:show(0)\" GroupID=\""+RootGroupID+"');\r\n";
			JS += "	tree.setBehavior('classic');\r\n";
		}
		
		tu_user.closeRs(Rs);
		
		Sql = "select * from user_group where Parent=" + RootGroupID + " order by OrderNumber,id";
		Rs = tu_user.executeQuery(Sql);
		while(Rs.next())
		{
			int groupid = Rs.getInt("id");
			String groupname = convertNull(Rs.getString("Name"));
			
			String varName = "lsh_" + groupid;
			String icon = "";
			icon = ",'','../images/tree/icon_16_user_group.gif','../images/tree/icon_16_user_group.gif'";
	
			JS += "var " + varName + " = new WebFXTreeItem('" + Util.JSQuote(groupname) + "','javascript:show(" + groupid + ");\\\" GroupID=" + groupid + " '" + icon + ");\r\n";
				
			JS += "tree.add(" + varName + ");\r\n";
					
			JS += listGroup_JS(groupid,varName,user);
		}
		tu_user.closeRs(Rs);
		
		return JS; 
	}	

	public String listGroup_JS(int id,String s,UserInfo user) throws SQLException, MessageException
	{
		String JS = "";
		
		TableUtil tu_user = new TableUtil("user");
		String Sql = "select * from user_group where Parent=" + id + " order by OrderNumber,id";
		ResultSet Rs = tu_user.executeQuery(Sql);
		if(Rs.next())
		{
			do
			{
				int groupid = Rs.getInt("id");
				String groupname = convertNull(Rs.getString("Name"));
				
				String varName = "lsh_" + groupid;
				String icon = "";				
				//icon = ",'','../images/icon_16_user_group.gif'";
				icon = ",'','../images/tree/icon_16_user_group.gif','../images/tree/icon_16_user_group.gif'";

				JS += "var " + varName + " = new WebFXTreeItem('" + Util.JSQuote(groupname) + "','javascript:show(" + groupid + ");\\\" GroupID=" + groupid + " '" + icon  + ");\r\n";
				JS += s + ".add(" + varName + ");\r\n";
				JS += listGroup_JS(groupid,varName,user);

			}while(Rs.next());
		}

		
		tu_user.closeRs(Rs);
		
		return JS; 
	}
	
	public List<UserGroup> getGroups() throws SQLException, MessageException{
		List<UserGroup> groups=new ArrayList<UserGroup>();
		TableUtil tu_user = new TableUtil("user");
		String sql="select * from user_group where Status=1";
		ResultSet Rs = tu_user.executeQuery(sql);
		while(Rs.next()){
			groups.add(new UserGroup(Rs.getInt("id")));
		}
		
		tu_user.closeRs(Rs);
		
		return groups;
	}
	
}
