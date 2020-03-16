package tidemedia.cms.base;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import tidemedia.tcenter.base.ApplicationContextProvider;

import javax.sql.DataSource;
import java.sql.*;

/**
 * @author Administrator  2003-5-9 14:39:50
 * 
 * */
public class TableUtil extends Table {

	//@Autowired
	//private ApplicationContext applicationContext;

	public TableUtil() throws MessageException,SQLException
	{
	}

	public TableUtil(String dataSource) throws MessageException,SQLException
	{
		super(dataSource);

		/*
		if(applicationContext==null)
			System.out.println("applicationContext is null");
		else
			System.out.println("applicationContext:"+applicationContext);

		DataSource one = (DataSource)ApplicationContextProvider.getBean("one");
		System.out.println("one:"+one);*/
	}
	
	/**
	 * @see
	 */
	public void Add() throws SQLException, MessageException {
	}

	/**
	 * @see
	 */
	public void Delete(int id) throws SQLException, MessageException {
	}

	/**
	 * @see
	 */
	public void Update() throws SQLException, MessageException {
	}

	/**
	 * @see
	 */
	public boolean canAdd() {
		return false;
	}

	/**
	 * @see
	 */
	public boolean canUpdate() {
		return false;
	}

	/**
	 * @see
	 */
	public boolean canDelete() {
		return false;
	}


	public String getSelect(String SelectName,String TableName,String Col1,String Col2,String Value,boolean firstOption) throws SQLException, MessageException
	{
		String Sql = "";
		String HtmlSelect = "";
		Sql = "select "+Col1+","+Col2+" from "+TableName;
		ResultSet Rs = executeQuery(Sql);
		
		
		HtmlSelect = "<select name=\""+SelectName+"\">\n";
		
		if(firstOption)
			HtmlSelect +=  "<option value=\"\">-- Select --</option>\n";
		
		while(Rs.next())
		{
			String a = tidemedia.cms.util.Util.convertNull(Rs.getString(1));
			String b = tidemedia.cms.util.Util.convertNull(Rs.getString(2));
			if(Value==null || Value.equals("") || !Value.equals(a))
				HtmlSelect += "<option value=\""+a+"\">"+b+"</option>\n";
			else
				HtmlSelect += "<option value=\""+a+"\" selected>"+b+"</option>\n";
		}
		HtmlSelect += "</select>\n";
		closeRs(Rs);
		
		return HtmlSelect;
	}

	public String getSelect(String SelectName,String TableName,String Col1,String Col2,String Value,String firstOption) throws SQLException, MessageException
	{
		String Sql = "";
		String HtmlSelect = "";
		Sql = "select "+Col1+","+Col2+" from "+TableName;
		ResultSet Rs = executeQuery(Sql);
		
		HtmlSelect = "<select name=\""+SelectName+"\">\n";
		
		HtmlSelect +=  firstOption + "\n";
		
		while(Rs.next())
		{
			String a = tidemedia.cms.util.Util.convertNull(Rs.getString(1));
			String b = tidemedia.cms.util.Util.convertNull(Rs.getString(2));
			if(Value==null || Value.equals("") || !Value.equals(a))
				HtmlSelect += "<option value=\""+a+"\">"+b+"</option>\n";
			else
				HtmlSelect += "<option value=\""+a+"\" selected>"+b+"</option>\n";
		}
		HtmlSelect += "</select>\n";
		closeRs(Rs);
		
		return HtmlSelect;
	}
		
	public String getSelect(String SelectName,String TableName,String Col1,String Col2,String Value) throws SQLException, MessageException
	{
		return getSelect(SelectName,TableName,Col1,Col2,Value,false);
	}
	
	//获取数量
	public int getNumber(String sql) throws SQLException, MessageException
	{
		int n = 0;
		ResultSet rs = executeQuery(sql);
		if(rs.next())
			n = rs.getInt(1);
		closeRs(rs);
		return n;
	}
}
