/*
 * Created on 2005-9-26
 *
 */
package tidemedia.cms.system;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import tidemedia.cms.base.*;
import tidemedia.cms.user.*;
import tidemedia.cms.util.*;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;

/**
 * @author Administrator
 *
 */
public class FieldGroup extends Table implements Serializable {

	private int		id;
	private String 	Name = "";
	private String	Extra = "";//备注,相关时对应的是频道范围
	private String	Url = "";//对应程序地址
	private int 	Channel;
	private int		LinkChannel;//对应频道编号，给集合分组使用
	private int		OrderNumber;
	private int		Type = 0;// 0为默认分组，1为相关文章，2为相关视频，3为集合分组
	private String Icon="";//增加字段图标
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public FieldGroup() throws MessageException, SQLException {
		super();
	}

	public FieldGroup(int id) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from field_group where id=" + id;
		
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setExtra(convertNull(Rs.getString("Extra")));
			setUrl(convertNull(Rs.getString("Url")));
			setChannel(Rs.getInt("Channel"));
			setLinkChannel(Rs.getInt("LinkChannel"));
			setType(Rs.getInt("Type"));
			setIcon(convertNull(Rs.getString("Icon")));
			//if(Type==3) setUrl("../content/content_gather.jsp?GlobalID=$globalid&ItemID=$itemid&ChannelID=$channelid&LinkChannelID="+LinkChannel);

			closeRs(Rs);
			
		}
		else
			{closeRs(Rs);print(Sql);throw new MessageException("This field group is not exist!");}			
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(Name.equals(""))
			throw new MessageException("表单组名称不能为空.");
		
		Sql = "select * from field_group where Channel=" + Channel + " and Name='" + SQLQuote(Name) + "'";
		if(isExist(Sql))
		{
			throw new MessageException("此表单组已经存在!",2);
		}
		
		Sql = "select * from field_group where Channel=" + Channel + "";
		if(Name.equals("") && !isExist(Sql))
		{
			Sql = "insert into field_group (";
			
			Sql += "Name,Channel,LinkChannel,Type,CreateDate,Icon";
			Sql += ") values(";
			Sql += "'" + SQLQuote("默认") + "'";
			Sql += "," + Channel + "";
			Sql += "," + LinkChannel + "";
			Sql += "," + Type + "";
			Sql += ",now()";
			Sql += ",'" + SQLQuote(Icon) + "'";
			Sql += ")";
			
			int insertid = executeUpdate_InsertID(Sql);
			setId(insertid);

			//更新序数
			Sql = "update field_group set OrderNumber=" + insertid + " where id=" + insertid;
			executeUpdate(Sql);
		}
		
		Sql = "insert into field_group (";
		
		Sql += "Name,Extra,Url,Channel,LinkChannel,Type,CreateDate,Icon";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Extra) + "'";
		Sql += ",'" + SQLQuote(Url) + "'";
		Sql += "," + Channel + "";
		Sql += "," + LinkChannel + "";
		Sql += "," + Type + "";
		Sql += ",now()";
		Sql += ",'" + SQLQuote(Icon) + "'";
		Sql += ")";
		//print(Sql);
		int insertid = executeUpdate_InsertID(Sql);
		setId(insertid);
		
		if(Type==3)
		{
			//集合分组
			Sql = "";
			Sql += "CREATE TABLE relation_" + Channel + "_" + LinkChannel + " (";
			Sql += "  id int(11) NOT NULL auto_increment,";
			Sql += "  GlobalID int(11),";
			Sql += "  ChildGlobalID int(11),";
			Sql += "  OrderNumber int default 0,";
			Sql += "  UNIQUE KEY id (id)";
			Sql += ") ENGINE=InnoDB DEFAULT CHARSET=utf8;";

			//System.out.println(Sql);
			executeUpdate(Sql);
		}
		else
		{
			//检查是否是为一个FieldGroup
			int num = 0;
			TableUtil tu = new TableUtil();
			Sql = "select count(*) from field_group where Channel=" + Channel;
			ResultSet rs = tu.executeQuery(Sql);
			if(rs.next())
			{
				num = rs.getInt(1);
			}
			tu.closeRs(rs);
			
			if(num==1)
			{
				Sql = "update field_desc set GroupID=" + insertid + " where ChannelID = " + Channel;
				tu.executeUpdate(Sql);
			}
		}
		
		//更新序数
		Sql = "update field_group set OrderNumber=" + insertid + " where id=" + insertid;
		executeUpdate(Sql);
		
		//print(Name);
		if(Name.equals("相关文章"))
		{
			Sql = "update field_desc set GroupID=" + insertid + ",IsHide=0 where FieldName='Keyword' and ChannelID=" + Channel;
			//print(Sql);
			executeUpdate(Sql);
		}
		CmsCache.delChannel(Channel);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {

	}

	public void Delete() throws SQLException, MessageException {
		String Sql = "";
		if(Type==3)
		{
			//集合分组，删除对应表
			Sql = "DROP TABLE IF EXISTS relation_" + Channel + "_" + LinkChannel;
			executeUpdate(Sql);			
		}
		Sql = "update field_desc set GroupID=0 where GroupID=" + id;
		executeUpdate(Sql);
		
		Sql = "delete from field_group where id=" + id;
		executeUpdate(Sql);
		ChannelUtil.initFieldInfo(CmsCache.getChannel(Channel));
		ChannelUtil.initFieldGroupInfo(CmsCache.getChannel(Channel));

		CmsCache.delChannel(Channel);
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "select * from field_group where Channel=" + Channel + " and Name='" + SQLQuote(Name) + "' and id!=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("表单组名称已经被使用!",4);
		}
		
		Sql = "update field_group set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		Sql += ",Extra='" + SQLQuote(Extra) + "'";
		Sql += ",Url='" + SQLQuote(Url) + "'";
		Sql += ",Icon='" + SQLQuote(Icon) + "'";
		Sql += " where id="+id;
		//System.out.println(Sql);
		executeUpdate(Sql);	
		ChannelUtil.initFieldGroupInfo(CmsCache.getChannel(Channel));

		CmsCache.delChannel(Channel);
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

	public int getChannel() {
		return Channel;
	}

	public void setChannel(int channel) {
		Channel = channel;
	}

	public String getExtra() {
		return Extra;
	}

	public void setExtra(String extra) {
		Extra = extra;
	}

	public void setType(int type) {
		Type = type;
	}

	public int getType() {
		return Type;
	}

	public void setUrl(String url) {
		Url = url;
	}

	public String getUrl() {
		return Url;
	}

	public int getLinkChannel() {
		return LinkChannel;
	}

	public void setLinkChannel(int linkChannel) {
		LinkChannel = linkChannel;
	}

	public String getIcon() {
		return Icon;
	}

	public void setIcon(String icon) {
		Icon = icon;
	}

}
