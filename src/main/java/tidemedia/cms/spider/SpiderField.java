/*
 * Created on 2011-3-27
 *
 */
package tidemedia.cms.spider;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

/**
 * @author Administrator
 *
 */
public class SpiderField extends Table{

	private int	id = 0;
	private int Parent = 0;
	private String Name = "";
	private String Field = "";
	private String CodeStart = "";
	private String CodeEnd = "";
	private String CodeReg = "";	
	
	//一键转载
	private String rule = "";//匹配规则，类似jquery选择器

	public SpiderField() throws MessageException, SQLException {
		super();
	}

	public SpiderField(int id) throws SQLException, MessageException
	{
		String Sql = "select * from spider_field where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setParent(Rs.getInt("Parent"));
			setName(convertNull(Rs.getString("Name")));
			setField(convertNull(Rs.getString("Field")));
			setCodeStart(convertNull(Rs.getString("CodeStart")));
			setCodeEnd(convertNull(Rs.getString("CodeEnd")));			
			setCodeReg(convertNull(Rs.getString("CodeReg")));
			
			setRule(convertNull(Rs.getString("rule")));
			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("该记录不存在!");}			
	}
	
	public void Add() throws SQLException, MessageException {
		if(Parent<=0) return;
		
		String Sql = "";
		
		Sql = "insert into spider_field (";
		
		Sql += "Parent,Name,Field,CodeStart,CodeEnd,CodeReg,CreateDate,rule";
		Sql += ") values(";
		Sql += Parent + "";
		Sql += ",'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Field) + "'";
		Sql += ",'" + SQLQuote(CodeStart) + "'";
		Sql += ",'" + SQLQuote(CodeEnd) + "'";
		Sql += ",'" + SQLQuote(CodeReg) + "'";
		Sql += ",now()";
		
		Sql +=",'"+rule+"'";
		
		Sql += ")";
		//System.out.println(Sql);
		executeUpdate(Sql);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "delete from spider_field where id="+id;
		executeUpdate(Sql);			
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
			
		Sql = "update spider_field set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		Sql += ",Field='" + SQLQuote(Field) + "'";
		Sql += ",CodeStart='" + SQLQuote(CodeStart) + "'";
		Sql += ",CodeEnd='" + SQLQuote(CodeEnd) + "'";
		Sql += ",CodeReg='" + SQLQuote(CodeReg) + "'";
		
		Sql += ",rule='" + SQLQuote(rule) + "'";
		
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

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getCodeStart() {
		return CodeStart;
	}

	public void setCodeStart(String listStart) {
		CodeStart = listStart;
	}

	public String getCodeEnd() {
		return CodeEnd;
	}

	public void setCodeEnd(String listEnd) {
		CodeEnd = listEnd;
	}

	public String getCodeReg() {
		return CodeReg;
	}

	public void setCodeReg(String listReg) {
		CodeReg = listReg;
	}

	public void setParent(int parent) {
		Parent = parent;
	}

	public int getParent() {
		return Parent;
	}

	public void setField(String field) {
		Field = field;
	}

	public String getField() {
		return Field;
	}

	/**
	 * @param rule the rule to set
	 */
	public void setRule(String rule) {
		this.rule = rule;
	}

	/**
	 * @return the rule
	 */
	public String getRule() {
		return rule;
	}
}
