/**
 * author hailong	
 * created on 2015-7-8下午08:04:38
 */
package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

 
public class PhotoScheme extends Table
{

	private String Name ;
	private int Width ;
	private int Height ;
	private String summary ;
	private int Type ;
	private int id ; 
	
	public PhotoScheme()
	{
		
	}
	public PhotoScheme(int id) 
		throws SQLException, MessageException
	{
		String sql = "select * from photo_scheme where id ="+id;
		ResultSet rs = executeQuery(sql);
		if(rs.next())
		{
			setId(rs.getInt("id"));
			setHeight(rs.getInt("Height"));
			setWidth(rs.getInt("Width"));
			setName(rs.getString("Name"));
			setSummary(rs.getString("summary"));
			setType(rs.getInt("Type"));
		}
		closeRs(rs);
	}
	
	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public int getWidth() {
		return Width;
	}

	public void setWidth(int width) {
		Width = width;
	}

	public int getHeight() {
		return Height;
	}

	public void setHeight(int height) {
		Height = height;
	}

	public String getSummary() {
		return summary;
	}

	public void setSummary(String describe) {
		summary = describe;
	}

	public int getType() {
		return Type;
	}

	public void setType(int type) {
		Type = type;
	}

	@Override
	public void Add() 
		throws SQLException, MessageException
	{
		String sql = "insert into photo_scheme (Name,Width,Height,summary,Type) values(";
			   sql +="'"+Name+"',"+Width+","+Height+",'"+summary+"',"+Type+")";
		int id = executeUpdate_InsertID(sql);
		setId(id);
	}

	@Override
	public void Delete(int arg0) 
		throws SQLException, MessageException 
	{
		String sql = "delete from photo_scheme where id="+id;
		executeUpdate(sql);
		
	}

	@Override
	public void Update() 
		throws SQLException, MessageException
	{
		String sql = "update photo_scheme set Name='"+Name+"',Width="+Width+",Height="+Height +",summary='"+summary+"' where id="+id;
		executeUpdate(sql);
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


	/**
	 * @param id the id to set
	 */
	public void setId(int id) {
		this.id = id;
	}


	/**
	 * @return the id
	 */
	public int getId() {
		return id;
	}
	
}
