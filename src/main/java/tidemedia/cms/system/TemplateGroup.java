/*
 * Created on 2005-9-26
 *
 */
package tidemedia.cms.system;

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
public class TemplateGroup extends Table{

	private int		id;
	private String 	Name = "";
	private int 	Parent;
	private int		OrderNumber;
	private int		Type = 0;// 0 默认模板 1 特殊模板
	private String	SerialNo = "";

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public TemplateGroup() throws MessageException, SQLException {
		super();
	}
	//设置ordernumber的值
	public TemplateGroup(int id) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from template_group where id=" + id;
		
		if(id==0)
			Sql = "select * from template_group where Parent=-1";
		
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setSerialNo(convertNull(Rs.getString("SerialNo")));
			setParent(Rs.getInt("Parent"));
			setType(Rs.getInt("Type"));
			setOrderNumber(Rs.getInt("OrderNumber"));
			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("This template group is not exist!");}			
	}
	
	//根据serialno初始化group
	public TemplateGroup(String serialno) throws SQLException, MessageException
	{
		TableUtil tu = new TableUtil();
		
		String Sql = "";
		Sql = "select * from template_group where SerialNo='" + tu.convertNull(serialno) + "'";
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setSerialNo(convertNull(Rs.getString("SerialNo")));
			setParent(Rs.getInt("Parent"));
			setType(Rs.getInt("Type"));

			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("This template group is not exist!");}			
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(Name.equals(""))
			throw new MessageException("模板组名称不能为空.");
		
		if(Parent==0)
		{
			Sql = "select * from template_group where Parent=-1";
			ResultSet Rs = executeQuery(Sql);
			if(Rs.next())
			{
				Parent = Rs.getInt("id");				
			}
			else
				throw new MessageException("This Root Template Group is not exist!");
		}
		
		Sql = "select * from template_group where Name='" + SQLQuote(Name) + "' and Parent=" + Parent;
		if(isExist(Sql))
		{
			throw new MessageException("此模板组已经存在!",2);
		}
		
		Sql = "insert into template_group (";
		
		Sql += "Name,Parent,CreateDate,Status";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += "," + Parent + "";		
		Sql += ",now(),1";
		
		Sql += ")";
		
		int insertid = executeUpdate_InsertID(Sql);	
		
		setId(insertid);
		Sql = "update template_group set OrderNumber="+insertid+" where id="+insertid+" and OrderNumber is null or OrderNumber=0";
		executeUpdate(Sql);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from template_files where GroupID=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("模板组下还有模板，不能删除!",MessageException.ALERT_HISTORY_BACK);
		}
		
		Sql = "select id from template_group where Parent=" + id;
		ResultSet Rs = executeQuery(Sql);
		while(Rs.next())
		{
			int groupid = Rs.getInt("id");
			Delete(groupid);
		}
		closeRs(Rs);

		Sql = "delete from template_group where id=" + id;
		executeUpdate(Sql);	
		
		CmsCache.delTemplateGroup(id);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "select * from template_group where Name='" + SQLQuote(Name) + "' and id!=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("模板组名称已经被使用!",4);
		}
		
		Sql = "update template_group set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		
		Sql += " where id="+id;
		
		executeUpdate(Sql);	
		
		CmsCache.delTemplateGroup(id);
	}
	
	public ArrayList<TemplateGroup> listChildGroup() throws MessageException, SQLException
	{
		ArrayList<TemplateGroup> arr = new ArrayList<TemplateGroup>();
		String sql = "select * from template_group where Parent=" + id;
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		while(rs.next())
		{
			int id = rs.getInt("id");
			TemplateGroup tg = new TemplateGroup(id);
			arr.add(tg);
		}
		tu.closeRs(rs);
		
		return arr;
	}

	public void updateSerialNo() throws SQLException, MessageException
	{
		String sql = "";
		sql = "update template_group set ";
		sql += "SerialNo='" + SQLQuote(SerialNo) + "'";
		sql += ",Type=" + Type + "";
		
		sql += " where id=" + id;
		
		executeUpdate(sql);
		CmsCache.delTemplateGroup(id);
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
		String Sql = "select * from template_group where id=" + getParent();
		
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
		return listGroup_JS("");
	}
	
	public String listGroup_JS(String serialNo) throws SQLException, MessageException
	{
		String JS = "";
		int RootGroupID = 0;
		
		String Sql = "select * from template_group where Parent=-1";
		
		if(serialNo.length()>0)
			Sql = "select * from template_group where SerialNo='" + serialNo + "'";
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
			
			JS += "	var tree = new WebFXTree('" + Util.JSQuote(RootGroupName) + "','javascript:show(" + RootGroupID + ")\" GroupID=\""+RootGroupID+"');\r\n";
			JS += "	tree.setBehavior('classic');\r\n";
		}
		
		closeRs(Rs);
		
		TableUtil tu = new TableUtil();
		Sql = "select * from template_group where Parent=" + RootGroupID + " order by OrderNumber,id";
		Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			int groupid = Rs.getInt("id");
			String groupname = convertNull(Rs.getString("Name"));
			
			String varName = "lsh_" + groupid;
			String icon = "";
			icon = ",'','',''";
	
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
		String Sql = "select * from template_group where Parent=" + id + " order by OrderNumber,id";
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
				icon = ",'','',''";

				JS += "var " + varName + " = new WebFXTreeItem('" + Util.JSQuote(groupname) + "','javascript:show(" + groupid + ");\\\" GroupID=" + groupid + " '" + icon  + ");\r\n";
				JS += s + ".add(" + varName + ");\r\n";
				JS += listGroup_JS(groupid,varName);

			}while(Rs.next());
		}

		
		tu.closeRs(Rs);
		
		return JS; 
	}
	
	public List<TemplateGroup> getGroups() throws SQLException, MessageException{
		List<TemplateGroup> groups=new ArrayList<TemplateGroup>();
		String sql="select * from user_group where Status=1";
		ResultSet Rs =executeQuery(sql);
		while(Rs.next()){
			groups.add(new TemplateGroup(Rs.getInt("id")));
		}
		return groups;
	}

	public void setSerialNo(String serialNo) {
		SerialNo = serialNo;
	}

	public String getSerialNo() {
		return SerialNo;
	}

	public void setType(int type) {
		Type = type;
	}

	public int getType() {
		return Type;
	}
}
