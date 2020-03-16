/*
 * Created on 2012-6-2
 *
 */
package tidemedia.cms.spider;

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
public class SpiderGroup extends Table{

	private int		id;
	private String 	Name = "";
	private int 	Parent;
	private int		OrderNumber;

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public SpiderGroup() throws MessageException, SQLException {
		super();
	}

	public SpiderGroup(int id) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from spider_group where id=" + id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setParent(Rs.getInt("Parent"));

			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("This user group is not exist!");}			
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(Name.equals(""))
			throw new MessageException("名称不能为空.");
		
		Sql = "select * from spider_group where Name='" + SQLQuote(Name) + "'";
		if(isExist(Sql))
		{
			throw new MessageException("此组已经存在!",2);
		}

		if(Parent==0)
		{
			Sql = "select * from spider_group where Parent=-1";
			ResultSet Rs = executeQuery(Sql);
			if(Rs.next())
			{
				Parent = Rs.getInt("id");				
			}
			else
				throw new MessageException("This Root Group is not exist!");
		}
		
		Sql = "insert into spider_group (";
		
		Sql += "Name,Parent,CreateDate,Status";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += "," + Parent + "";		
		Sql += ",now(),1";
		
		Sql += ")";
		
		executeUpdate(Sql);		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from spider where GroupID=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("该组下还有采集方案，不能删除!",MessageException.ALERT_HISTORY_BACK);
		}
		
		Sql = "select id from spider_group where Parent=" + id;
		ResultSet Rs = executeQuery(Sql);
		while(Rs.next())
		{
			int groupid = Rs.getInt("id");		
			Delete(groupid);
		}
		closeRs(Rs);

		Sql = "delete from spider_group where id=" + id;
		executeUpdate(Sql);		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "select * from spider_group where Name='" + SQLQuote(Name) + "' and id!=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("用户组名称已经被使用!",4);
		}
		
		Sql = "update spider_group set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		
		Sql += " where id="+id;
		
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
		String Sql = "select * from spider_group where id=" + getParent();
		
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
			parentName = convertNull(Rs.getString("Name"));
		
		closeRs(Rs);
		
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
	
	public String listGroup_JS() throws SQLException, MessageException
	{
		String JS = "";
		int RootGroupID = 0;
		
		String Sql = "select * from spider_group where Parent=-1";
		ResultSet Rs = executeQuery(Sql);
		if(!Rs.next())
		{
			closeRs(Rs);
			return "";
		}
		else
		{
			String RootGroupName = convertNull(Rs.getString("Name"));			
			RootGroupID = Rs.getInt("id");
			
			JS += "	var tree = new WebFXTree('" + Util.JSQuote(RootGroupName) + "','javascript:show(0)\" GroupID=\""+RootGroupID+"');\r\n";
			JS += "	tree.setBehavior('classic');\r\n";
		}
		
		closeRs(Rs);
		
		TableUtil tu = new TableUtil();
		Sql = "select * from spider_group where Parent=" + RootGroupID + " order by OrderNumber,id";
		Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			int groupid = Rs.getInt("id");
			String groupname = convertNull(Rs.getString("Name"));
			
			String varName = "lsh_" + groupid;
			String icon = "";
			icon = ",'','../images/tree/icon_16_user_group.gif','../images/tree/icon_16_user_group.gif'";
	
			JS += "var " + varName + " = new WebFXTreeItem('" + Util.JSQuote(groupname) + "','javascript:show(" + groupid + ");\\\" GroupID=" + groupid + " '" + icon + ");\r\n";
				
			JS += "tree.add(" + varName + ");\r\n";
					
			JS += listGroup_JS(groupid,varName);
		}
		tu.closeRs(Rs);
		
		return JS; 
	}	

	public String listGroup_JS(int id,String s) throws SQLException, MessageException
	{
		String JS = "";
		
		TableUtil tu = new TableUtil();
		String Sql = "select * from spider_group where Parent=" + id + " order by OrderNumber,id";
		ResultSet Rs = tu.executeQuery(Sql);
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
				JS += listGroup_JS(groupid,varName);

			}while(Rs.next());
		}

		
		tu.closeRs(Rs);
		
		return JS; 
	}
	
	public List<SpiderGroup> getGroups() throws SQLException, MessageException{
		List<SpiderGroup> groups=new ArrayList<SpiderGroup>();
		String sql="select * from spider_group where Status=1";
		ResultSet Rs =executeQuery(sql);
		while(Rs.next()){
			groups.add(new SpiderGroup(Rs.getInt("id")));
		}
		return groups;
	}	
}
