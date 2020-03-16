/**
 * author hailong	
 * created on 2016-3-19上午12:03:46
 */
package tidemedia.cms.system;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

/**
 * @author hailong
 *转码水印方案
 */
public class Watermark extends Table 
{
   private int id ;
   private int LogoTop;//
   private int LogoLeft;//
   private int width;//
   private int height;//
   private int dissolve;//透明度
   private int status;//status=1时在上传图片时显示水印方案，默认0
   private String Name ;//水印方案名
   private String Watermark;//水印文件 base64编码
   private Integer companyid;
   private Integer CreateDate;
   public Watermark(int id ) 
   		throws SQLException, MessageException
   {
	   //id为唯一编号 
	    String Sql = "select * from watermark where id=" + id;
	    ResultSet Rs = executeQuery(Sql);
	    if (Rs.next())
	    {
	      setId(Rs.getInt("id"));
	      setName(convertNull(Rs.getString("Name")));
	      setWaterMark(convertNull(Rs.getString("Watermark")));
	      setLogoLeft(Rs.getInt("LogoLeft"));
	      setLogoTop(Rs.getInt("LogoTop"));
	      setCreateDate(Rs.getInt("CreateDate"));
	      setWidth(Rs.getInt("width"));
	      setHeight(Rs.getInt("height"));
	      setDissolve(Rs.getInt("dissolve"));
	      setStatus(Rs.getInt("status"));
	      setCompanyid(Rs.getInt("companyid"));
	    }
	     closeRs(Rs);
   }
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public Watermark()
		throws MessageException, SQLException
	{
		super();
		// TODO Auto-generated constructor stub
	}
	/**
	 * 
	 * @param companyid
	 * @return 根据租户id获取水印方案结果集
	 * @throws MessageException
	 * @throws SQLException
	 */
	public List<Watermark> listAllWaterMark(int companyid)
		throws MessageException,SQLException
	{
		List<Watermark> list = new ArrayList<Watermark>();
		String sql = "select * from watermark where status=1";
		if(companyid!=0){
			sql+=" and companyid in (0,"+companyid+")";
		}
		ResultSet rs = executeQuery(sql);
		while (rs.next()) 
		{
			 Watermark temp = new Watermark();
			 temp.setId(rs.getInt("id"));
			 temp.setName(convertNull(rs.getString("Name")));
			 temp.setLogoLeft(rs.getInt("LogoLeft"));
			 temp.setLogoTop(rs.getInt("LogoTop"));
			 temp.setWaterMark(convertNull(rs.getString("Watermark")));
			 temp.setCreateDate(rs.getInt("CreateDate"));
			 temp.setWidth(rs.getInt("width"));
			 temp.setHeight(rs.getInt("height"));
			 temp.setDissolve(rs.getInt("dissolve"));
			 temp.setStatus(rs.getInt("status"));
			 temp.setCompanyid(rs.getInt("companyid"));
			 list.add(temp);
		}
		closeRs(rs);
		return list;
	}
	public List<Watermark> listAllWaterMark()
			throws MessageException,SQLException
		{
			List<Watermark> list = new ArrayList<Watermark>();
			String sql = "select * from watermark ";
			ResultSet rs = executeQuery(sql);
			while (rs.next()) 
			{
				 Watermark temp = new Watermark();
				 temp.setId(rs.getInt("id"));
				 temp.setName(convertNull(rs.getString("Name")));
				 temp.setLogoLeft(rs.getInt("LogoLeft"));
				 temp.setLogoTop(rs.getInt("LogoTop"));
				 temp.setWaterMark(convertNull(rs.getString("Watermark")));
				 temp.setCreateDate(rs.getInt("CreateDate"));
				 temp.setWidth(rs.getInt("width"));
				 temp.setHeight(rs.getInt("height"));
				 temp.setDissolve(rs.getInt("dissolve"));
				 temp.setStatus(rs.getInt("status"));
				 temp.setCompanyid(rs.getInt("companyid"));
				 list.add(temp);
			}
			closeRs(rs);
			return list;
		}

	

	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	@Override
	public void Add() 
		throws SQLException, MessageException
	{
		  String Sql = "";
			
		   Sql = "insert into watermark (";
		
		   Sql = Sql + "Name,LogoTop,LogoLeft,Watermark,companyid,CreateDate,width,height,dissolve,status";
		   Sql = Sql + ") values(";
		   Sql = Sql + "'" + SQLQuote(this.Name) + "'";
		   //Sql = Sql + ",'" + SQLQuote(this.value) + "'";
		   Sql = Sql + "," + this.LogoTop + "";
		   Sql = Sql + "," + this.LogoLeft + "";
		   Sql = Sql + ",'" + SQLQuote(this.Watermark) + "'";
		   Sql = Sql + "," + this.companyid + "";
		   Sql = Sql + "," + this.CreateDate + "";
		   Sql = Sql + "," + this.width + "";
		   Sql = Sql + "," + this.height + "";
		   Sql = Sql + "," + this.dissolve + "";
		   Sql = Sql + "," + this.status + "";
		   Sql = Sql + ")";
		   int insertid = executeUpdate_InsertID(Sql);
		   setId(insertid);
		 
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	@Override
	public void Delete(int arg0) 
		throws SQLException, MessageException
	{
		  String Sql = "";
		  Sql = "delete from watermark where id=" + arg0;
		  executeUpdate(Sql);
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	@Override
	public void Update() 
		throws SQLException, MessageException
	{
		   String Sql = "update watermark set ";
		   
		   Sql = Sql + "Name='" + SQLQuote(this.Name) + "'";
		   Sql += ",WaterMark='" + SQLQuote(this.Watermark) + "'";
		   Sql += ",LogoTop=" + this.LogoTop + "";
		   Sql += ",LogoLeft=" + this.LogoLeft + "";
		   Sql += ",width=" + this.width + "";
		   Sql += ",height=" + this.height + "";
		   Sql += ",dissolve=" + this.dissolve + "";
		   Sql += ",status=" + this.status + "";
		   Sql += ",companyid=" + this.companyid + "";
		   Sql = Sql + " where id=" + this.id;
		   executeUpdate(Sql);
		
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canAdd()
	 */
	@Override
	public boolean canAdd()
	{
		return false;
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canDelete()
	 */
	@Override
	public boolean canDelete()
	{
		return false;
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#canUpdate()
	 */
	@Override
	public boolean canUpdate() 
	{
		return false;
		
	}
	
	public int getId() 
	{
		return id;
	}
	
	public void setId(int id)
	{
		this.id = id;
	}



	public int getLogoTop() 
	{
		return this.LogoTop;
	}

	public void setLogoTop(int logoTop)
	{
		this.LogoTop = logoTop;
	}

	public int getLogoLeft() 
	{
		return this.LogoLeft;
	}

	public void setLogoLeft(int logoLeft)
	{
		this.LogoLeft = logoLeft;
	}

	public String getName() 
	{
		return this.Name;
	}

	public void setName(String name)
	{
		this.Name = name;
	}

	public String getWaterMark()
	{
		return this.Watermark;
	}

	public void setWaterMark(String watermark) 
	{
		this.Watermark = watermark;
	}

	public Integer getCompanyid() {
		return companyid;
	}

	public void setCompanyid(Integer companyid) {
		this.companyid = companyid;
	}


	public Integer getCreateDate() {
		return CreateDate;
	}

	public void setCreateDate(Integer createDate) {
		CreateDate = createDate;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
	}

	public int getDissolve() {
		return dissolve;
	}

	public void setDissolve(int dissolve) {
		this.dissolve = dissolve;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}
	
	
}
