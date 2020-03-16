/*
 * Created on 2004-6-22
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package tidemedia.cms.user;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelPrivilege;
import tidemedia.cms.system.ChannelPrivilegeItem;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Log;
import tidemedia.cms.system.LogAction;
import tidemedia.cms.system.TcenterLog;
import tidemedia.cms.util.Util;


public class UserInfo extends Table implements Serializable{
	
	private int		id;
	private int 	ActionUser = 0;
	private String 	Username = "";
	private String 	Password = "";
	private String 	md5Password="";
	private String  Username2 = "";
	private	String 	Name = "";
	private String 	Email = "";
	private String	Tel = "";
	private String 	Comment = "";	
	private String 	CreateDate = "";
//	private int		Role;//For Login
	private int		Role;//1 系统管理员 4站点管理员 2频道管理员 3编辑
	private String	RoleName = "";
//	private int		Role2;
//	private int		Role3;
	private int 	Status;//1允许登录 0禁止登录
	private String 	ExpireDate = "";//帐号过期时间,到期后不能使用，单位是秒
	private long	ExpireDateL = 0;
	private String 	Token = "";//用户令牌,用于接口等快速登录
	private String  Site = "";//站点编号
	
	private int 	Group;
	private String LastLoginDate;//最后登陆时间
	private int 	company;
	private int 	jurong;
	
	private int	MessageType = 0;
	
	private ArrayList<String[]> PermArray = new ArrayList<String[]>();
	private ArrayList<ChannelPrivilegeItem> ChannelPermArray = new ArrayList<ChannelPrivilegeItem>();
	
	private String ChannelList = "";
	private String PermList = "";
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public UserInfo() throws MessageException, SQLException {
		super();
	}

	public UserInfo(int id) throws SQLException, MessageException
	{
		TableUtil tu = new TableUtil("user");
		String Sql = "select id,Name,Email,Username,Password,Tel,Comment,Token,Role,ExpireDate,LastLoginDate,GroupID,company,jurong,UNIX_TIMESTAMP(ExpireDate) as ExpireDateL from userinfo where id="+id;
		ResultSet Rs = null;
		Rs = tu.executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setName(convertNull(Rs.getString("Name")));
			setEmail(convertNull(Rs.getString("Email")));
			setUsername(convertNull(Rs.getString("Username")));
			setMd5Password(convertNull(Rs.getString("Password")));
			setTel(convertNull(Rs.getString("Tel")));
			setComment(convertNull(Rs.getString("Comment")));
			setToken(convertNull(Rs.getString("Token")));
			setRole(Rs.getInt("Role"));
			//setSite(convertNull(Rs.getString("Site")));
			setExpireDate(convertNull(Rs.getString("ExpireDate")));
			setExpireDateL(Rs.getInt("ExpireDateL"));
			setCompany(Rs.getInt("company"));
			setJurong(Rs.getInt("jurong"));
			setLastLoginDate(convertNull(Rs.getString("LastLoginDate")));
			if(Role==1){
				RoleName = "系统管理员";
				if(company!=0){
					RoleName = "租户管理员";
				}
			}else if(Role==2)
				RoleName = "频道管理员";
			else if(Role==3)
				RoleName = "编辑";
			else if(Role==4)
				RoleName = "记者";
			else if(Role==5)
				RoleName = "视客管理员";
			
			setGroup(Rs.getInt("GroupID"));
			
			
			TableUtil tu2 = new TableUtil();
			String Sql2 = "select * from user_perm where User="+id + " and PermName='Site'";
			ResultSet Rs2 = tu2.executeQuery(Sql2);
			while(Rs2.next())
			{
				int PermValue = Rs2.getInt("PermValue");
				Site += ((Site.length()>0)?",":"") + PermValue;
				//System.out.println("site:"+Site+","+PermValue);
			}
			tu2.closeRs(Rs2);
			
			//20150513 添加，cms和vms才执行initChannelPermArray
			String product = CmsCache.getProduct();
			//System.out.println("product:"+product+",id:"+id);
			if(product.equals("TideCMS") || product.equals("TideVMS"))
				initChannelPermArray();
		}
		
		tu.closeRs(Rs);
	}
	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(Username.equals(""))
			throw new MessageException("登录名不能为空.");
		
		TableUtil tu_user = new TableUtil("user");
		Sql = "select * from userinfo where Username='" + SQLQuote(Username) + "'";
		if(tu_user.isExist(Sql))
		{
			throw new MessageException("此用户已经存在!",2);
		}
		//System.out.println(Role);
		//if(!(Role==1 || Role==2 || Role==3 || Role==4))
		//	throw new MessageException("未知的用户角色.",2);
		Sql = "insert into userinfo (";
		
		Sql += "Username,Password,Name,Email,Tel,Comment,Token,Role,GroupID,company,jurong,ExpireDate,CreateDate,Status";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Username) + "'";
		Sql += ",md5('" + SQLQuote(Password) + "')";
		Sql += ",'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Email) + "'";
		Sql += ",'" + SQLQuote(Tel) + "'";
		Sql += ",'" + SQLQuote(Comment) + "'";
		Sql += ",'" + SQLQuote(Token) + "'";
		Sql += "," + Role + "";
		//Sql += ",'" + SQLQuote(Site) + "'";
		Sql += "," + Group + "";
		Sql += "," + company + "";
		Sql += "," + jurong + "";
		
		if(ExpireDate.length()==0)
			Sql += ",null";
		else
			Sql += ",'" + SQLQuote(ExpireDate) + "'";
		
		Sql += ",now(),1";
		
		Sql += ")";
		
		int insertid = tu_user.executeUpdate_InsertID(Sql);
		
		new Log().UserLog(LogAction.user_add, Username, insertid, ActionUser);
		new TcenterLog().UserLog(LogAction.user_add, Username, insertid, ActionUser);
		
		TableUtil tu2 = new TableUtil();
		int[] sites = Util.StringToIntArray(Site,",");
		for(int i = 0;i<sites.length;i++)
		{
			String Sql2 = "insert into user_perm(User,PermName,PermValue) values(" + insertid + ",'Site'," + sites[i] + ")";
			tu2.executeUpdate(Sql2);
		}
		
		if(Role==1 || Role==5)
			setPermission();
		else
		{
			//print(PermList);
			ChannelPrivilege cp = new ChannelPrivilege();
			cp.addUserPerm(Username,ChannelList,PermList);
		}
	}

	/*
	 * 设置用户权限
	 */
	public void setPermission() throws SQLException, MessageException
	{		
		int userid = 0;
		TableUtil tu_user = new TableUtil("user");
		String Sql = "select * from userinfo where Username='" + SQLQuote(Username) + "'";
		
		ResultSet Rs = tu_user.executeQuery(Sql);
		if(Rs.next())
		{
			userid = Rs.getInt("id");
		}
		
		tu_user.closeRs(Rs);
		
		if(userid>0)
		{
			for(int i = 0;i<PermArray.size();i++)
			{
				String Sql1 = "";
				String PermName = ((String[])PermArray.get(i))[0];
				String PermValue = ((String[])PermArray.get(i))[1];
				if(!PermValue.equals("1"))
					PermValue = "0";
				
				if(!PermName.equals(""))
				{
					Sql = "select * from user_perm where User=" + userid + " and PermName='" + SQLQuote(PermName) + "'";
					
					Rs = executeQuery(Sql);
					if(Rs.next())
					{
						Sql1 = "update user_perm set PermValue=" + PermValue + " where User=" + userid + " and PermName='" + SQLQuote(PermName) + "'";						
					}
					else
						Sql1 = "insert into user_perm(User,PermName,PermValue) values(" + userid + ",'" + SQLQuote(PermName) + "','" + SQLQuote(PermValue) + "')";
					closeRs(Rs);
					
					executeUpdate(Sql1);
				}
			}
		}
	}
	
	public boolean hasPermission(String permname) throws SQLException, MessageException
	{
		boolean hasperm = false;
		
		//从本地库读取，非user库
		TableUtil tu = new TableUtil();
		String Sql = "select * from user_perm where User=" + getId() + " and PermName='" + SQLQuote(permname) + "'";
		//System.out.println("sql:"+Sql);
		ResultSet Rs = tu.executeQuery(Sql);
		
		if(Rs.next())
		{
			if(Rs.getInt("PermValue")==1)
				hasperm = true;
		}
		
		tu.closeRs(Rs);
		
		return hasperm;
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#canAdd()
	 */
	public boolean canAdd() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#canDelete()
	 */
	public boolean canDelete() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#canUpdate()
	 */
	public boolean canUpdate() {
		return false;
	}

	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		UserInfo userinfo = (UserInfo)CmsCache.getUser(id);
		if(userinfo.getUsername().equals("admin"))
		{
			throw new MessageException("系统管理员:admin 不能删除!",MessageType);			
		}
		
		String Sql = "delete from channel_privilege where User="+id;
		executeUpdate(Sql);	
		TableUtil tu_user = new TableUtil("user");
		Sql = "delete from userinfo where id="+id;
		tu_user.executeUpdate(Sql);	
		
		new Log().UserLog(LogAction.user_delete, userinfo.getUsername(), id, ActionUser);
		new TcenterLog().UserLog(LogAction.user_delete, userinfo.getUsername(), id, ActionUser);
		
		CmsCache.delUser(id);
	}

	//允许或禁止
	public void enable(int flag) throws SQLException, MessageException
	{
		if(getUsername().equals("admin"))
		{
			return;			
		}
		
		TableUtil tu_user = new TableUtil("user");
		
		if(flag==1)//允许
		{
			String sql = "update userinfo set Status=1 where id="+getId();
			tu_user.executeUpdate(sql);
			CmsCache.delUser(getId());
		}
		else if(flag==2)//禁止
		{
			String sql = "update userinfo set Status=0 where id="+getId();
			tu_user.executeUpdate(sql);
			CmsCache.delUser(getId());
		}
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.enite.system.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		if(getUsername().equals("admin") & Role!=1)
		{
			throw new MessageException("系统管理员:admin 的角色不能修改!",MessageType);			
		}
		
		TableUtil tu_user = new TableUtil("user");
		String Sql = "";
			
		Sql = "update userinfo set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		if(!Password.equals("") && !Password.equals("GundamsssD"))
			Sql += ",Password=md5('" + SQLQuote(Password) + "')";
		Sql += ",Email='" + SQLQuote(Email) + "'";
		Sql += ",Tel='" + SQLQuote(Tel) + "'";
		Sql += ",Comment='" + SQLQuote(Comment) + "'";
		Sql += ",Token='" + SQLQuote(Token) + "'";
		//Sql += ",Site='" + SQLQuote(Site) + "'";
		Sql += ",GroupID='" + SQLQuote(Group+"") + "'";
		Sql += ",company=" + company;
		Sql += ",jurong=" + jurong;
		
		if(ExpireDate.length()==0)
			Sql += ",ExpireDate=null";
		else
			Sql += ",ExpireDate='" + SQLQuote(ExpireDate) + "'";
		//Sql += ",Role=" + Role + "";
		
		Sql += " where id="+id;
		//System.out.println(Sql);
		tu_user.executeUpdate(Sql);
		
		TableUtil tu2 = new TableUtil();
		int[] sites = Util.StringToIntArray(Site,",");
		tu2.executeUpdate("delete from user_perm where User="+id+" and PermName='Site'");
		for(int i = 0;i<sites.length;i++)
		{
			String Sql2 = "insert into user_perm(User,PermName,PermValue) values(" + id + ",'Site'," + sites[i] + ")";
			tu2.executeUpdate(Sql2);
		}
		
		CmsCache.delUser(id);
		
		new Log().UserLog(LogAction.user_edit, getUsername(), id, ActionUser);
		new TcenterLog().UserLog(LogAction.user_edit, getUsername(), id, ActionUser);
		//if(Role==1)
		//	setPermission();
	}
	
	//是否开启聚融ֹ
	public void enableJurong(int flag) throws SQLException, MessageException
	{		
		TableUtil tu_user = new TableUtil("user");
		
		if(flag==1)//开启
		{
			String sql = "update userinfo set jurong=1 where id="+getId();
			tu_user.executeUpdate(sql);
			new TcenterLog().UserLog(LogAction.user_enable, getUsername(), id, ActionUser);
			CmsCache.delUser(getId());
		}
		else if(flag==2)//关闭ֹ
		{
			String sql = "update userinfo set jurong=0 where id="+getId();
			tu_user.executeUpdate(sql);
			new TcenterLog().UserLog(LogAction.user_close, getUsername(), id, ActionUser);
			CmsCache.delUser(getId());
		}
	}

	public void UpdatePerm() throws SQLException, MessageException
	{
		//print("size:"+PermArray.size());
		if(PermArray.size()>0)
		{
			//print("setPermission");
			setPermission();
		}

		ChannelPrivilege cp = new ChannelPrivilege();
		cp.addUserPerm(Username,ChannelList,PermList);
		
		CmsCache.delUser(id);CmsCache.getUser(id);
		
		new Log().UserLog(LogAction.user_setperm, getUsername(), id, ActionUser);
	}

	/**
	 * @return
	 */
	public String getCreateDate() {
		return CreateDate;
	}

	/**
	 * @return
	 */
	public String getEmail() {
		return Email;
	}

	/**
	 * @return
	 */
	public int getId() {
		return id;
	}

	/**
	 * @return
	 */
	public String getName() {
		return Name;
	}

	/**
	 * @return
	 */
	public String getPassword() {
		return Password;
	}

	/**
	 * @return
	 */
	public int getStatus() {
		return Status;
	}

	/**
	 * @param string
	 */
	public void setCreateDate(String string) {
		CreateDate = string;
	}

	/**
	 * @param string
	 */
	public void setEmail(String string) {
		Email = string;
	}

	/**
	 * @param i
	 */
	public void setId(int i) {
		id = i;
	}

	/**
	 * @param string
	 */
	public void setName(String string) {
		Name = string;
	}

	/**
	 * @param string
	 */
	public void setPassword(String string) {
		Password = string;
	}

	/**
	 * @param i
	 */
	public void setStatus(int i) {
		Status = i;
	}

	public int Authorization(HttpServletRequest request,HttpServletResponse response,String username,String password) throws SQLException, MessageException
	{
		return UserInfoUtil.Authorization(request,response,username, password,false);
	}

	public int Authorization(HttpServletRequest request,HttpServletResponse response,String username,String password,boolean cookie) throws SQLException, MessageException
	{
		return UserInfoUtil.Authorization(request,response,username, password,true);
	}
	
	/**
	 * @return
	 */
	public String getUsername() {
		return Username;
	}

	/**
	 * @param string
	 */
	public void setUsername(String string) {
		Username = string;
	}

	/**
	 * @return
	 */
	public String getComment() {
		return Comment;
	}

	/**
	 * @return
	 */
	public String getTel() {
		return Tel;
	}

	/**
	 * @param string
	 */
	public void setComment(String string) {
		Comment = string;
	}

	/**
	 * @param string
	 */
	public void setTel(String string) {
		Tel = string;
	}

	/**
	 * @return
	 */
	public int getRole() {
		return Role;
	}

	/**
	 * @param i
	 */
	public void setRole(int i) {
		//if(i!=1 && i!=2 && i!=3 && i!=4)
		//	i = 0;
			
		Role = i;
	}

	public boolean isAdministrator()
	{
		if(Role==1)
			return true;
		else
			return false;
	}
	
	public boolean isSiteAdministrator()
	{
		if(Role==4)
			return true;
		else
			return false;
	}
	
	public boolean isSuperEditor()
	{
		if(Role==2)
			return true;
		else
			return false;
	}
	
	public boolean isEditor()
	{
		if(Role==3)
			return true;
		else
			return false;
	}

	public String getRoleName() {
		return RoleName;
	}

	public void setRoleName(String string) {
		RoleName = string;
	}

	public int getMessageType() {
		return MessageType;
	}

	public void setMessageType(int i) {
		MessageType = i;
	}

	public void addPermArray(String permname,int permvalue)
	{
		String[] str = {permname,permvalue+""};
		PermArray.add(str);
	}
	/**
	 * @return Returns the group.
	 */
	public int getGroup() {
		return Group;
	}
	/**
	 * @param group The group to set.
	 */
	public void setGroup(int group) {
		Group = group;
	}
	/**
	 * @param channelList The channelList to set.
	 */
	public void setChannelList(String channelList) {
		ChannelList = channelList;
	}
	/**
	 * @param permList The permList to set.
	 */
	public void setPermList(String permList) {
		PermList = permList;
	}
	
	// 是否具有某个频道的指定权限
	public boolean hasChannelRight(UserInfo user,int channel,int permtype) throws SQLException,MessageException {
		return hasChannelRight(channel,permtype);
	}

	// 是否具有某个频道的指定权限
	public boolean hasChannelRight(int channelid,int permtype) throws SQLException,MessageException {
		
		if(getRole()==1) return true;
		
		return UserInfoUtil.hasChannelRight(channelid, permtype, ChannelPermArray);
	}
	
	// 是否具有某个频道的指定权限 用于页面上的树状频道结构展示
	public boolean hasChannelShowRight(int channelid) throws SQLException,MessageException {
		if(getRole()==1) return true;
		
		if(getRole()==4)
		{
			//站点管理员
			Channel channel = CmsCache.getChannel(channelid);
			if(getSite().equals(channel.getSiteID()+""))
			{
				return true;
			}
			else
				return false;
		}
		
		return UserInfoUtil.hasChannelShowRight(channelid, ChannelPermArray);
	}
	
	public int getActionUser() {
		return ActionUser;
	}

	public void setActionUser(int actionUser) {
		ActionUser = actionUser;
	}

	public ArrayList<ChannelPrivilegeItem> getChannelPermArray() {
		return ChannelPermArray;
	}

	public void setChannelPermArray(ArrayList<ChannelPrivilegeItem> channelPermArray) {
		ChannelPermArray = channelPermArray;
	}
	
	public void initChannelPermArray() throws SQLException, MessageException
	{
		PermArray = new ArrayList<String[]>();
		ChannelPermArray = new ArrayList<ChannelPrivilegeItem>();
		
		String sql = "";
		//TableUtil tu = new TableUtil("user");
		TableUtil tu = new TableUtil();//channel_privilege表放到各自的库中，比如cms的channel_privilege就在cms库 2015/11/19
		sql = "select * from channel_privilege where User=" + getId() ;
		ResultSet rs = tu.executeQuery(sql);
		//System.out.println(sql);
		while(rs.next())
		{
			int channel = rs.getInt("Channel");
			String permtype = rs.getString("PermType");
			int isinherit = rs.getInt("IsInherit");
			
			ChannelPrivilegeItem ci = new ChannelPrivilegeItem(channel,permtype,isinherit);
			
			if(permtype.equals("5")) ci.setIsInherit(1);
			
			boolean hasExist = false;
			
			for(int i = 0;i<ChannelPermArray.size();i++)
			{
				ChannelPrivilegeItem cpi = (ChannelPrivilegeItem)ChannelPermArray.get(i);
				
				if(cpi.getChannel()==channel)
				{
					hasExist = true;
					
					if(permtype.equals("5"))
						cpi.setIsInherit(1);
					else
					{
						cpi.setPermType(cpi.getPermType()+","+permtype);
						cpi.initPermArray();
					}
				}
			}
			
			if(!hasExist)
				ChannelPermArray.add(ci);
		}
		tu.closeRs(rs);
	}
	
	public boolean inChannelPermArray(int channel,int permtype)
	{
		for(int i = 0;i<ChannelPermArray.size();i++)
		{
			ChannelPrivilegeItem ci = (ChannelPrivilegeItem)ChannelPermArray.get(i);
			if(ci.getChannel()==channel && ci.getPermType().equals(permtype+""))
				return true;
		}
		
		return false;
	}

	//判断是否是租户管理员
	public boolean isCompanyAdmin()
	{
		if(Role==1 && company>0)
			return true;
		else
			return false;
	}
	
	//判断是否是平台管理员
	public boolean isPlatformAdmin()
	{
		if(Role==1 && company==0)
			return true;
		else
			return false;
	}
	
	public String getMd5Password() {
		return md5Password;
	}

	public void setMd5Password(String md5Password) {
		this.md5Password = md5Password;
	}

	public void setExpireDate(String expireDate) {
		ExpireDate = expireDate;
	}

	public String getExpireDate() {
		return ExpireDate;
	}

	public void setExpireDateL(long expireDateL) {
		ExpireDateL = expireDateL;
	}

	public long getExpireDateL() {
		return ExpireDateL;
	}

	public String getToken() {
		return Token;
	}

	public void setToken(String token) {
		Token = token;
	}

	public String getUsername2() {
		return Username2;
	}

	public void setUsername2(String username2) {
		Username2 = username2;
	}

	public String getSite() {
		return Site;
	}

	public void setSite(String site) {
		Site = site;
	}
	
	public int getCompany() {
		return company;
	}

	public void setCompany(int company) {
		this.company = company;
	}

	public int getJurong() {
		return jurong;
	}

	public void setJurong(int jurong) {
		this.jurong = jurong;
	}

	public String getLastLoginDate() {
		return LastLoginDate;
	}

	public void setLastLoginDate(String lastLoginDate) {
		LastLoginDate = lastLoginDate;
	}
	
}

