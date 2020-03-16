/*
 * Created on 2005-3-22
 *
 */
package tidemedia.cms.system;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.Util;

import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * @author 李永海(xuebaolsh@hotmail.com)
 *
 */
public class ChannelPrivilege extends Table {

	public static final int ListItem = 1;//浏览文档
	public static final int	AddItem = 2;//发表文档
	public static final int	ApproveItem = 3;//审批文档
	public static final int	DeleteItem = 4;//删除文档
	public static final int	IncludeSubChannel = 5;//包括子频道
	public static final int	onlyMe = 12;//只看自己
	public static final int	CreateCategory =11;//创建分类 20180927
	
	public static final int	PageContentEdit = 1;//页面内容维护
	public static final int	PageModuleEdit = 2;//页面模块维护
	public static final int	PageFrameEdit = 3;//页面框架维护
	public static final int	PageSourceEdit = 4;//页面源代码维护
	
	private int 		id;
	private int			UserID;
	private int			ChannelID;
	private int 		PermType;
	//权限
	//1浏览文档	2发表文档		3审批文档		4删除文档		5包括子频道     11 创建分类  12  只看自己
	private int			IsInherit;
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public ChannelPrivilege() throws MessageException, SQLException {
		super();
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "select * from channel_privilege where User=" + UserID + " and Channel=" + ChannelID;
		if(!isExist(Sql))
		{
			Sql = "insert into channel_privilege (";
			
			Sql += "User,Channel,CreateDate";
			Sql += ") values(";
			Sql += "" + UserID + "";
			Sql += "," + ChannelID + "";
			Sql += ",now()";
			
			Sql += ")";
			
			executeUpdate(Sql);					
		}			
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		
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
	 * @return Returns the channelID.
	 */
	public int getChannelID() {
		return ChannelID;
	}
	/**
	 * @param channelID The channelID to set.
	 */
	public void setChannelID(int channelID) {
		ChannelID = channelID;
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
	/**
	 * @return Returns the userID.
	 */
	public int getUserID() {
		return UserID;
	}
	/**
	 * @param userID The userID to set.
	 */
	public void setUserID(int userID) {
		UserID = userID;
	}
	
	public void addUsers(String userid,int channelid) throws MessageException, SQLException
	{
		String[] ids = Util.StringToArray(userid,",");
		if(ids!=null && ids.length>0)
		{
			for(int i=0;i<ids.length;i++)
			{
				ChannelPrivilege cp = new ChannelPrivilege();
			
				cp.setUserID(Integer.parseInt(ids[i]));
				cp.setChannelID(channelid);
				cp.Add();
			}
		}		
	}

	public void deleteUsers(String[] ids,int channelid) throws MessageException, SQLException
	{
		if(ids!=null && ids.length>0)
		{
			for(int i=0;i<ids.length;i++)
			{
				String Sql = "delete from channel_privilege where User=" + (Integer.parseInt(ids[i])) + " and Channel=" + channelid;
				executeUpdate(Sql);
			}
		}		
	}	
	
	public void applyAllChannel(int channelid) throws SQLException, MessageException
	{
		String Sql = "select * from channel_privilege where Channel=" + channelid;
		
		ResultSet Rs = executeQuery(Sql);
		
		while(Rs.next())
		{
			int userid = Rs.getInt("User");
			applyOneUser(userid,channelid);
		}
		closeRs(Rs);
	}
	
	public void applyOneUser(int userid,int channelid) throws SQLException, MessageException
	{
		String Sql = "select * from channel where Parent=" + channelid;
		
		ResultSet Rs = executeQuery(Sql);
		while(Rs.next())
		{
			int childchannelid = Rs.getInt("id");
			
			String Sql2 = "select * from channel_privilege where User=" + userid + " and Channel=" + childchannelid;
			ResultSet rs = executeQuery(Sql2);
			if(rs.next())
			{				
			}
			else
			{
				Sql2 = "insert into channel_privilege (";
				
				Sql2 += "User,Channel,CreateDate";
				Sql2 += ") values(";
				Sql2 += "" + userid + "";
				Sql2 += "," + childchannelid + "";
				Sql2 += ",now()";
				
				Sql2 += ")";
				
				executeUpdate(Sql2);	
			}
			closeRs(rs);
			applyOneUser(userid,childchannelid);
		}
		closeRs(Rs);
	}
	/**
	 * @return Returns the isInherit.
	 */
	public int getIsInherit() {
		return IsInherit;
	}
	/**
	 * @param isInherit The isInherit to set.
	 */
	public void setIsInherit(int isInherit) {
		IsInherit = isInherit;
	}
	/**
	 * @return Returns the permType.
	 */
	public int getPermType() {
		return PermType;
	}
	/**
	 * @param permType The permType to set.
	 */
	public void setPermType(int permType) {
		PermType = permType;
	}
	
	public void addUserPerm(String username,String ChannelList,String PermList) throws SQLException, MessageException
	{
		int userid = 0;
		TableUtil tu_user = new TableUtil("user");
		String Sql = "select * from userinfo where Username='" + SQLQuote(username) + "'";
		
		ResultSet Rs = tu_user.executeQuery(Sql);
		if(Rs.next())
		{
			userid = Rs.getInt("id");
		}
		
		tu_user.closeRs(Rs);
		//print("userid:"+userid+"|"+ChannelList+"|"+PermList);
		if(userid==0)
			return;
		
		//标记旧的权限记录
		Sql = "update channel_privilege set Status=-1 where User="+userid;
		executeUpdate(Sql);
		
		String[] channel_array = Util.StringToArray(ChannelList,",");
		String[] perm_array = Util.StringToArray(PermList,",");
		if(perm_array.length==0)
		{
			Sql = "delete from channel_privilege where Status=-1 and User="+userid;
			executeUpdate(Sql);
		}
		
		//8的倍数
		
		if(perm_array.length==0 || perm_array.length!=channel_array.length*8)
			return;
			
		for(int i = 0;i<perm_array.length;i+=8)
		{
			int channelid = Integer.valueOf(perm_array[i]).intValue();//print("channelid:"+channelid);
			if(Util.StringInArray(channel_array,channelid+""))
			{
				int hasperm = Integer.valueOf(perm_array[i+1]).intValue();
				
				if(hasperm==1)
				{//包括子频道
					//Channel ch = CmsCache.getChannel(channelid);
					//long beginTime = System.currentTimeMillis();
					//ArrayList subchannels = ch.listAllSubChannelIDs();
					//System.out.println("time:"+(System.currentTimeMillis()-beginTime)+"毫秒");
					//System.out.println("size:"+subchannels.size());
					/*
					for(int m=0;m<subchannels.size();m++)
					{//System.out.println("m:"+m);
						int subchannelid = ((Integer)subchannels.get(m)).intValue();
						//long beginTime1 = System.currentTimeMillis();
						Sql = "insert into channel_privilege (";
						
						Sql += "User,Channel,PermType,IsInherit,ParentChannel,CreateDate";
						Sql += ") values";
						String valuesql = "";
						for(int j = 2;j<=5; j++)
						{
							int permtype = j-1;
							hasperm = Integer.valueOf(perm_array[i+j]).intValue();
							
							if(hasperm==1)
							{//System.out.println(((Integer)subchannels.get(m)).intValue());
								//addUserChannelPerm(userid,((Channel)subchannels.get(m)).getId(),permtype,hasperm);
								valuesql += (valuesql.equals("")?"":",") + "(";
								valuesql += "" + userid + "";
								valuesql += "," + subchannelid + "";
								valuesql += "," + permtype + "";
								valuesql += "," + 1 + "";
								valuesql += "," + channelid + "";
								valuesql += ",now()";
								
								valuesql += ")";
								
								//executeUpdate(Sql);
							}
						}
						if(!valuesql.equals("")){Sql += valuesql + ";";executeUpdate(Sql);}
						
						//System.out.println(subchannelid + ":time:"+(System.currentTimeMillis()-beginTime1)+"毫秒");
					}
					*/
				}
				
				boolean hasoneperm = false;
				
				Sql = "insert into channel_privilege (";
				
				Sql += "User,Channel,PermType,IsInherit,ParentChannel,CreateDate";
				Sql += ") values";
				String valuesql = "";
				for(int j = 1;j<=7; j++)
				{
					int permtype = 0;
					if(j==1)
						permtype = 5;//包括子频道
					else if(j==6)
						permtype = 11;//创建分类
					else if(j==7)
						permtype = 12;//只看自己
					else
						permtype = j-1;
					
					hasperm = Integer.valueOf(perm_array[i+j]).intValue();
					
					if(hasperm==1)
					{
						hasoneperm = true;
						valuesql += (valuesql.equals("")?"":",") + "(";
						valuesql += "" + userid + "";
						valuesql += "," + channelid + "";
						valuesql += "," + permtype + "";
						valuesql += "," + 0 + "";
						valuesql += "," + 0 + "";
						valuesql += ",now()";
						
						valuesql += ")";
						
						//executeUpdate(Sql);
					}
				}
				if(!valuesql.equals("")){
				    Sql += valuesql + ";";executeUpdate(Sql);
				}
				//print(Sql);
				//设置父频道权限，使其可见
				if(hasoneperm)
					setPerm_ParentChannel(channelid,userid);
			}
		}
		
		//删除旧的权限记录
		//System.out.println("userid:"+userid);
		Sql = "delete from channel_privilege where Status=-1 and User="+userid;
		executeUpdate(Sql);	
	}

	public void setPerm_ParentChannel(int channelid,int userid) throws SQLException, MessageException
	{
		String Sql = "";
		Sql = "select Parent from channel where id=" + channelid;
		//System.out.println(Sql);
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			channelid = Rs.getInt("Parent");			
		}
		
		closeRs(Rs);
		
		if(channelid!=-1)
		{
			Sql = "select * from channel_privilege where Status!=-1 and User=" + userid + " and Channel=" + channelid;
			Rs = executeQuery(Sql);
			if(!Rs.next())
			{
				Sql = "insert into channel_privilege (";
				
				Sql += "User,Channel,PermType,IsInherit,ParentChannel,CreateDate";
				Sql += ") values(";
				Sql += "" + userid + "";
				Sql += "," + channelid + "";
				Sql += "," + 0 + "";
				Sql += "," + 0 + "";
				Sql += "," + 0 + "";
				Sql += ",now()";
				
				Sql += ")";
				
				executeUpdate(Sql);
			}
			
			closeRs(Rs);
			
			setPerm_ParentChannel(channelid,userid);
		}
	}

	public void setChannelPerm(int ChannelID,String UserList,String PermList) throws SQLException, MessageException
	{
		//标记旧的权限记录
		String Sql = "update channel_privilege set Status=-1 where Channel="+ChannelID;
		executeUpdate(Sql);
		Sql = "update channel_privilege set Status=-1 where IsInherit=1 and ParentChannel="+ChannelID;
		executeUpdate(Sql);
		
		//Channel ch = CmsCache.getChannel(ChannelID);
		//ArrayList subchannels = ch.listAllSubChannelIDs();
		String[] user_array = Util.StringToArray(UserList,",");
		String[] perm_array = Util.StringToArray(PermList,",");
		
		if(perm_array.length==0)
		{
			Sql = "delete from channel_privilege where Status=-1 and Channel="+ChannelID;
			executeUpdate(Sql);	
			Sql = "delete from channel_privilege where Status=-1 and IsInherit=1 and ParentChannel="+ChannelID;
			executeUpdate(Sql);	
		}
		
		if(perm_array.length==0 || perm_array.length!=user_array.length*6)
			return;
			
		for(int i = 0;i<perm_array.length;i+=6)
		{
			int userid = Integer.valueOf(perm_array[i]).intValue();
			if(Util.StringInArray(user_array,userid+""))
			{
				int hasperm = Integer.valueOf(perm_array[i+1]).intValue();
				
				if(hasperm==1)
				{//包括子频道
					/*
					//System.out.println("size:"+subchannels.size());
					for(int m=0;m<subchannels.size();m++)
					{//System.out.println("m:"+m);
						for(int j = 2;j<=5; j++)
						{
							int permtype = j-1;
							hasperm = Integer.valueOf(perm_array[i+j]).intValue();
							
							if(hasperm==1)
							{//System.out.println(((Integer)subchannels.get(m)).intValue());
								//addUserChannelPerm(userid,((Channel)subchannels.get(m)).getId(),permtype,hasperm);
								Sql = "insert into channel_privilege (";
								
								Sql += "User,Channel,PermType,IsInherit,ParentChannel,CreateDate";
								Sql += ") values(";
								Sql += "" + userid + "";
								Sql += "," + ((Integer)subchannels.get(m)).intValue() + "";
								Sql += "," + permtype + "";
								Sql += "," + 1 + "";
								Sql += "," + ChannelID + "";
								Sql += ",now()";
								
								Sql += ")";
								
								executeUpdate(Sql);
							}
						}
					}
					*/
				}
				
				boolean hasoneperm = false;
				for(int j = 1;j<=5; j++)
				{
					int permtype = 0;
					if(j==1)
						permtype = 5;//包括子频道
					else
						permtype = j-1;
					
					hasperm = Integer.valueOf(perm_array[i+j]).intValue();
					
					if(hasperm==1)
					{
						hasoneperm = true;
						
						Sql = "insert into channel_privilege (";
						
						Sql += "User,Channel,PermType,IsInherit,ParentChannel,CreateDate";
						Sql += ") values(";
						Sql += "" + userid + "";
						Sql += "," + ChannelID + "";
						Sql += "," + permtype + "";
						Sql += "," + 0 + "";
						Sql += "," + 0 + "";
						Sql += ",now()";
						
						Sql += ")";
						
						executeUpdate(Sql);
					}
				}
				
				//设置父频道权限，使其可见
				if(hasoneperm)
					setPerm_ParentChannel(ChannelID,userid);
			}
		}
		
		//删除旧的权限记录
		//System.out.println("userid:"+userid);
		Sql = "delete from channel_privilege where Status=-1 and Channel="+ChannelID;
		executeUpdate(Sql);	
		Sql = "delete from channel_privilege where Status=-1 and IsInherit=1 and ParentChannel="+ChannelID;
		executeUpdate(Sql);	
	}

	
	public String getPermString(int userid) throws SQLException, MessageException
	{
		String str = "";
		
		String Sql = "";
		Sql = "select DISTINCT  channel_privilege.Channel,channel.Name from channel_privilege left join channel on channel_privilege.Channel=channel.id where channel_privilege.IsInherit=0 and channel_privilege.PermType!=0 and channel_privilege.User="+userid;
		
		TableUtil tu = new TableUtil();
		
		ResultSet Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			int channelid = Rs.getInt("channel_privilege.Channel");
			Channel channel = CmsCache.getChannel(channelid);
			String channelname = channel.getParentChannelPath();//convertNull(Rs.getString("Channel.Name"));
			
			if(!channelname.equals(""))
			{
				str += (str.equals("")?"":",") + channelid + "," + channelname;
	
				Sql = "select * from channel_privilege where Channel="+channelid+" and User="+userid+" and PermType="+5;
				ResultSet rs = executeQuery(Sql);
				if(rs.next())
					str += ",1";
				else
					str += ",0";
				
				closeRs(rs);

				//6个权限,新增只看自己
				for(int i=1;i<7;i++)
				{
					int PermType = i;
					if(i==5) PermType= ChannelPrivilege.CreateCategory;
					if(i==6) PermType= ChannelPrivilege.onlyMe;
					TableUtil tu2 = new TableUtil();
					Sql = "select * from channel_privilege where Channel="+channelid+" and User="+userid+" and PermType="+PermType;
					ResultSet rs1 = tu2.executeQuery(Sql);
					if(rs1.next())
						str += ",1";
					else
						str += ",0";
					
					tu2.closeRs(rs1);
				}
				
				str += "," + channel.getType();
			}
		}
		
		tu.closeRs(Rs);
		
		return str;
	}

	public String getPermStringByChannel(int channelid) throws SQLException, MessageException
	{
		String str = "";
		
		String Sql = "";
		Sql = "select DISTINCT  channel_privilege.User,userinfo.Name from channel_privilege left join userinfo on channel_privilege.User=userinfo.id where channel_privilege.IsInherit=0 and channel_privilege.PermType!=0 and channel_privilege.Channel="+channelid;
		
		ResultSet Rs = executeQuery(Sql);
		while(Rs.next())
		{
			TableUtil tu = new TableUtil();
			int userid = Rs.getInt("channel_privilege.User");
			str += (str.equals("")?"":",") + userid + "," + convertNull(Rs.getString("userinfo.Name"));

			Sql = "select * from channel_privilege where Channel="+channelid+" and User="+userid+" and PermType="+5;
			ResultSet rs = tu.executeQuery(Sql);
			if(rs.next())
				str += ",1";
			else
				str += ",0";
			
			tu.closeRs(rs);
			
			for(int i=1;i<5;i++)
			{			
				Sql = "select * from channel_privilege where Channel="+channelid+" and User="+userid+" and PermType="+i;
				ResultSet rs1 = tu.executeQuery(Sql);
				if(rs1.next())
					str += ",1";
				else
					str += ",0";
				
				tu.closeRs(rs1);
			}
		}
		
		closeRs(Rs);
		
		return str;
	}
	
	//是否具有指定权限
	public boolean hasRight(UserInfo user, int channelid, int permtype) throws SQLException, MessageException
	{
		return user.hasChannelRight(channelid,permtype);
	}
}
