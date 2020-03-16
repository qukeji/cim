/*
 * Created on 2009-7-1
 *
 */
package tidemedia.cms.dict;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.Util;

/**
 * @author Administrator
 *
 */
public class DictGroup extends Table{

	private int		id;
	private String 	Name = "";
	private String	Code = "";

	public DictGroup() throws MessageException, SQLException {
		super();
	}

	public DictGroup(int id) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from dict_group where id=" + id;
		
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setCode(convertNull(Rs.getString("Code")));

			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("This template group is not exist!");}			
	}
	
	public DictGroup(String code) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from dict_group where Code='" + code + "'";
		
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setCode(convertNull(Rs.getString("Code")));
		}
		
		closeRs(Rs);
	}
	
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(Name.equals("") || Code.equals(""))
			throw new MessageException("名称或代码都不能为空.");
		
		Sql = "select * from dict_group where Code='" + SQLQuote(Code) + "'";
		if(isExist(Sql))
		{
			throw new MessageException("此字典组已经存在!",2);
		}
		
		Sql = "insert into dict_group (";
		
		Sql += "Name,Code,CreateDate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Code) + "'";	
		Sql += ",UNIX_TIMESTAMP()";
		
		Sql += ")";
		
		int insertid = executeUpdate_InsertID(Sql);	
		
		setId(insertid);
	}

	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from dict where GroupID=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("该组下还有数据，不能删除!",MessageException.ALERT_HISTORY_BACK);
		}

		Sql = "delete from dict_group where id=" + id;
		executeUpdate(Sql);	
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "select * from dict_group where Code='" + SQLQuote(Code) + "' and id!=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("该代码已经被使用!",4);
		}
		
		Sql = "update dict_group set ";
		
		Sql += "Name='" + SQLQuote(Name) + "',";
		Sql += "Code='" + SQLQuote(Code) + "'";
		
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

	public void setCode(String code) {
		Code = code;
	}

	public String getCode() {
		return Code;
	}

	
	public String listGroup_JS() throws SQLException, MessageException
	{
		String JS = "";
		String Sql = "";

		JS += "	var tree = new WebFXTree('" + Util.JSQuote("字典组") + "','javascript:show(" + 0 + ")\" GroupID=\""+0+"');\r\n";
		JS += "	tree.setBehavior('classic');\r\n";
		
		
		TableUtil tu = new TableUtil();
		Sql = "select * from dict_group order by id";
		ResultSet Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			int groupid = Rs.getInt("id");
			String groupname = convertNull(Rs.getString("Name"));
			
			String varName = "lsh_" + groupid;
			String icon = "";
			icon = ",'','',''";
	
			JS += "var " + varName + " = new WebFXTreeItem('" + Util.JSQuote(groupname) + "','javascript:show(" + groupid + ");\\\" GroupID=" + groupid + " '" + icon + ");\r\n";
				
			JS += "tree.add(" + varName + ");\r\n";
		}
		tu.closeRs(Rs);
		
		return JS; 
	}	
}
