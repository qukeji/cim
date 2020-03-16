package tidemedia.cms.system;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.Util;

/**
 * @author Administrator
 * 
 * 
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class Log extends Table {

	private int id;
	private int Site;// 网站
	private int User;// 操作者
	private int Item;
	private int LogAction = 0;// 动作编号 参考LogAction.class
	private String LogType = "";// LogType可以作废了 2013-12-29
	private String Title = "";
	private String Key1 = "";
	private String Key2 = "";
	private String Key3 = "";

	private String FromType = "";
	private String FromKey = "";
	private String Content = "";
	private String CreateDate = "";
	private int IsRead = 0;

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public Log() throws MessageException, SQLException {
		super();
	}

	public Log(int id) throws SQLException, MessageException {
		String Sql = "select * from tidecms_log where id=" + id;
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			setId(id);
			setLogType(convertNull(Rs.getString("LogType")));
			setTitle(convertNull(Rs.getString("Title")));
			setKey1(convertNull(Rs.getString("Key1")));
			setKey2(convertNull(Rs.getString("Key2")));
			setKey3(convertNull(Rs.getString("Key3")));

			setFromType(convertNull(Rs.getString("FromType")));
			setFromKey(convertNull(Rs.getString("FromKey")));
			setContent(convertNull(Rs.getString("Content")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			// setIsRead(Rs.getInt("IsRead"));
			setUser(Rs.getInt("User"));
			setItem(Rs.getInt("Item"));
			setSite(Rs.getInt("Site"));
			setLogAction(Rs.getInt("LogAction"));

			closeRs(Rs);
		} else {
			closeRs(Rs);
			throw new MessageException("该记录不存在!");
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		TableUtil tu = new TableUtil();
		String Sql = "";

		Sql = "insert into tidecms_log (";

		Sql += "User,Site,Item,LogAction,Fromtype,FromKey,LogType,Title,Content,Key1,Key2,Key3,CreateDate";
		Sql += ") values(";
		Sql += "" + User + "";
		Sql += "," + Site + "";
		Sql += "," + Item + "";
		Sql += "," + LogAction + "";// LogType可以作废了 2013-12-29
		Sql += ",'" + SQLQuote(FromType) + "'";
		Sql += ",'" + SQLQuote(FromKey) + "'";
		Sql += ",'" + SQLQuote(LogType) + "'";
		Sql += ",'" + SQLQuote(Title) + "'";
		Sql += ",'" + SQLQuote(Content) + "'";
		Sql += ",'" + SQLQuote(Key1) + "'";
		Sql += ",'" + SQLQuote(Key2) + "'";
		Sql += ",'" + SQLQuote(Key3) + "'";

		Sql += ",now()";

		Sql += ")";
		// System.out.println(Sql);
		tu.executeUpdate(Sql);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#canAdd()
	 */
	public boolean canAdd() {
		return false;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#canUpdate()
	 */
	public boolean canUpdate() {
		return false;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#canDelete()
	 */
	public boolean canDelete() {
		return false;
	}

	/**
	 * @return Returns the content.
	 */
	public String getContent() {
		return Content;
	}

	/**
	 * @param content
	 *            The content to set.
	 */
	public void setContent(String content) {
		Content = content;
	}

	/**
	 * @return Returns the createDate.
	 */
	public String getCreateDate() {
		return CreateDate;
	}

	/**
	 * @param createDate
	 *            The createDate to set.
	 */
	public void setCreateDate(String createDate) {
		CreateDate = createDate;
	}

	/**
	 * @return Returns the id.
	 */
	public int getId() {
		return id;
	}

	/**
	 * @param id
	 *            The id to set.
	 */
	public void setId(int id) {
		this.id = id;
	}

	/**
	 * @return Returns the isRead.
	 */
	public int getIsRead() {
		return IsRead;
	}

	/**
	 * @param isRead
	 *            The isRead to set.
	 */
	public void setIsRead(int isRead) {
		IsRead = isRead;
	}

	public String getKey1() {
		return Key1;
	}

	public void setKey1(String key1) {
		Key1 = key1;
	}

	public String getKey2() {
		return Key2;
	}

	public void setKey2(String key2) {
		Key2 = key2;
	}

	public String getKey3() {
		return Key3;
	}

	public void setKey3(String key3) {
		Key3 = key3;
	}

	public String getLogType() {
		return LogType;
	}

	public void setLogType(String logType) {
		LogType = logType;
	}

	public String getTitle() {
		return Title;
	}

	public void setTitle(String title) {
		Title = title;
	}

	public int getUser() {
		return User;
	}

	public void setUser(int user) {
		User = user;
	}

	public int getItem() {
		return Item;
	}

	public void setItem(int item) {
		Item = item;
	}

	public String getFromKey() {
		return FromKey;
	}

	public void setFromKey(String fromKey) {
		FromKey = fromKey;
	}

	public String getFromType() {
		return FromType;
	}

	public void setFromType(String fromType) {
		FromType = fromType;
	}

	/**
	 * 
	 * @param fromtype
	 * @return
	 * @modifyuser whl
	 * @modifydate 20140505
	 * @info 模板判断、备份中心
	 * 
	 */
	public String getFromDesc(String fromtype) {
		String desc = "";
		if (fromtype.equals("user"))
			desc = "用户";
		else if (fromtype.equals("video"))
			desc = "视频";
		else if (fromtype.equals("vblog"))
			desc = "视客";
		else if (fromtype.equals("channel"))
			desc = "频道";
		else if (fromtype.equals("file"))
			desc = "文件";
		else if (fromtype.equals("site"))
			desc = "站点";
		else if (fromtype.equals("template"))
			desc = "模板";
		else if (fromtype.equals("backup"))
			desc = "备份中心";
		else if (fromtype.equals("publishscheme"))
			desc = "发布方案";
		else if (fromtype.equals("approvescheme"))
			desc = "审核方案";
		else if (fromtype.equals("schedule"))
			desc = "调度";
		else if (fromtype.equals("watermark"))
			desc = "水印";
		else if (fromtype.equals("parameter"))
			desc = "系统参数";
		else if (fromtype.equals("user_company"))
			desc = "租户";
		else if (fromtype.equals("product"))
			desc = "产品";
		else if (fromtype.equals("navigation"))
			desc = "导航";
		return desc;
	}

	public void UserLog(int logaction, String title, int userid, int actionuser)
			throws MessageException, SQLException {
		Log l = new Log();
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("user");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}
	
	public void ScheduleLog(int logaction, String title, int userid, int actionuser)
			throws MessageException, SQLException {
		Log l = new Log();
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("schedule");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}
	//系统参数
	public void ParameterLog(int logaction, String title, int userid, int actionuser)
			throws MessageException, SQLException {
		Log l = new Log();
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("parameter");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}
	
	//租户绑定解绑
	public void UserCompanyLog(int logaction, String title, int userid, int actionuser)
			throws MessageException, SQLException {
		Log l = new Log();
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("user_company");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}
	
	public void WatermarkLog(int logaction, String title, int userid, int actionuser)
			throws MessageException, SQLException {
		Log l = new Log();
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("watermark");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}

	public void ProductLog(int logaction, String title, int userid, int actionuser)
			throws MessageException, SQLException {
		Log l = new Log();
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("product");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}

	public void NavigationLog(int logaction, String title, int userid, int actionuser)
			throws MessageException, SQLException {
		Log l = new Log();
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("navigation");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}

	public void CompanyLog(int logaction, String title, int userid,int actionuser) throws MessageException, SQLException {
		Log l = new Log();
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("company");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}

	public void PublishSchemeLog(int logaction, String title, int userid,
			int actionuser) throws MessageException, SQLException {
		Log l = new Log();
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("publishscheme");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}
	
	public void ApproveSchemeLog(int logaction, String title, int userid,
			int actionuser) throws MessageException, SQLException {
		Log l = new Log();
		l.setLogAction(logaction);
		l.setTitle(title);
		l.setFromType("approvescheme");
		l.setItem(userid);
		l.setUser(actionuser);
		l.Add();
	}

	public void ChannelLog(int logaction, int channelid, int actionuser,
			int site) throws MessageException, SQLException {
		Log l = new Log();
		Channel ch = CmsCache.getChannel(channelid);
		l.setLogAction(logaction);
		// l.setLogType(logtype);
		// l.setTitle(ch.getName());
		l.setTitle(ch.getParentChannelPath());
		l.setFromType("channel");
		l.setItem(channelid);
		l.setUser(actionuser);
		l.setSite(site);
		l.Add();
	}

	public void SiteLog(int logaction, int actionuser, int siteid)
			throws MessageException, SQLException {
		Log l = new Log();
		Site site = CmsCache.getSite(siteid);
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(site.getName());
		l.setFromType("site");
		l.setUser(actionuser);
		l.setSite(siteid);
		l.Add();
	}

	public void FileLog(int logaction, String FileName, int actionuser, int site)
			throws MessageException, SQLException {
		Log l = new Log();
		FileName = Util.ClearPath(FileName);
		// l.setLogType(logtype);
		l.setLogAction(logaction);
		l.setTitle(FileName);
		l.setFromType("file");
		l.setUser(actionuser);
		l.setSite(site);
		l.Add();
	}

	public static void SystemLog(String source, String content) {
		TableUtil tu;
		try {
			tu = new TableUtil();
			String Sql = "insert into tidecms_system_log (";

			Sql += "Source,Content,CreateDate";
			Sql += ") values(";
			Sql += "'" + tu.SQLQuote(source) + "'";
			Sql += ",'" + tu.SQLQuote(content) + "'";
			Sql += ",now()";

			Sql += ")";

			tu.executeUpdate(Sql);
		} catch (MessageException e) {
			e.printStackTrace(System.out);
		} catch (SQLException e) {
			e.printStackTrace(System.out);
		}
	}

	// 2014-1-2增加
	public static void SystemLog(int sourcetype, String content) {
		TableUtil tu;
		try {
			tu = new TableUtil();
			String Sql = "insert into tidecms_system_log (";

			Sql += "SourceType,Content,CreateDate";
			Sql += ") values(";
			Sql += "" + (sourcetype) + "";
			Sql += ",'" + tu.SQLQuote(content) + "'";
			Sql += ",now()";

			Sql += ")";

			tu.executeUpdate(Sql);
		} catch (MessageException e) {
			e.printStackTrace(System.out);
		} catch (SQLException e) {
			e.printStackTrace(System.out);
		}
	}

	public int getSite() {
		return Site;
	}

	public void setSite(int site) {
		Site = site;
	}

	public int getLogAction() {
		return LogAction;
	}

	public void setLogAction(int logAction) {
		LogAction = logAction;
	}
}
