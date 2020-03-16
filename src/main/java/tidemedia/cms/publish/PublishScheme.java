package tidemedia.cms.publish;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Log;
import tidemedia.cms.system.LogAction;
import tidemedia.cms.util.Util;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 * @author Administrator
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class PublishScheme extends Table implements Serializable {

	private int id;
	private int CopyMode;
	private int Status; // 0 关闭 1 开启 2 暂停 发布任务关闭后，文件不会进入待发布列表，暂停的时候，文件会进入文件失败列表
	private String Name = "";// 方案名称
	private String Server = "";
	private String Port = "";
	private String Username = "";
	private String Password = "";
	private String RemoteFolder = "";
	private String DestFolder = "";
	private int FtpMode = 0;// 0 主动模式，1被动模式
	private String ExcludeFolders = "";
	private String IncludeFolders = "";
	private int UserId=0;
	

	// s3 网宿参数
	private String accessKeyID = "";// "JYWWJF0GBSLBFHOGEG87";
	private String secretKey = "";// "HYaKB6ioMe0j4hycAJsbTaxgYM4c7a7GmNrGtGst";
	private String bucketName = "";// "tmzskj";
	private String endPoint = "";// "s3.bj.xs3cnc.com";
	private String videoHttpHead = "";

	// openstack 惠普参数
	private String TenantName = "";// 2106
	private String CredentialsUserName = "";// 1601
	private String CredentialsPassword = "";// tianmawangshi
	private String TokenUrl = "";// https://keystone.hpurcloud.com/v2.0/tokens

	// 阿里云Oss 参数
	private String Ossendpoint = ""; // http://oss-cn-hangzhou.aliyuncs.com
	private String OssLocalenpoint = ""; // http://vpc100-oss-cn-hangzhou.aliyuncs.com
	private String OssaccessKeyId = ""; // kw8DOMb9sJKWNKuh
	private String OssaccessKeySecret = ""; // FCnlHBMGjb6IjdwSMkMQC0UsC1iday
	private String OSSbucketName = ""; // lzy-communicat
	private String Ossdomain = "";

	// Ossendpoint,OssLocalenpoint,OssaccessKeyId,OssaccessKeySecret,OSSbucketName
	// 百度云
	private String BosaccessKeyId = "";
	private String BosaccessKeySecret = "";
	private String BosbucketName = "";
	private String Bosdomain = "";// 百度CDN域名
	//  七牛云
	private String QiniuAccessKey="";
	private String QiniuSecrectKey="";
	private String 	QiniubucketName="";


	private int Site;

	private ArrayList<String> ExcludeFoldersArray = new ArrayList<String>();

	private ArrayList<String[]> IncludeFoldersArray = new ArrayList<String[]>();

	private int MessageType = 0;

	public PublishScheme(int id) throws SQLException, MessageException {
		String Sql = "select * from publish_scheme where id=" + id;
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			setId(id);
			setCopyMode(Rs.getInt("CopyMode"));
			setStatus(Rs.getInt("Status"));
			setFtpMode(Rs.getInt("FtpMode"));
			setName(convertNull(Rs.getString("Name")));
			setServer(convertNull(Rs.getString("Server")));
			setPort(convertNull(Rs.getString("Port")));
			setUsername(convertNull(Rs.getString("Username")));
			setPassword(convertNull(Rs.getString("Password")));
			setRemoteFolder(convertNull(Rs.getString("RemoteFolder")));
			setDestFolder(convertNull(Rs.getString("DestFolder")));
			setIncludeFolders(convertNull(Rs.getString("IncludeFolders")));
			setExcludeFolders(convertNull(Rs.getString("ExcludeFolders")));
			setSite(Rs.getInt("Site"));
			setAccessKeyID(convertNull(Rs.getString("accessKeyID")));
			setSecretKey(convertNull(Rs.getString("secretKey")));
			setBucketName(convertNull(Rs.getString("bucketName")));
			setEndPoint(convertNull(Rs.getString("endPoint")));
			setTenantName(convertNull(Rs.getString("TenantName")));
			setCredentialsUserName(convertNull(Rs
					.getString("CredentialsUserName")));
			setCredentialsPassword(convertNull(Rs
					.getString("CredentialsPassword")));
			setTokenUrl(convertNull(Rs.getString("TokenUrl")));
			setVideoHttpHead(convertNull(Rs.getString("videoHttpHead")));
			
			//阿里云OSS
			setOssendpoint(Rs.getString("Ossendpoint"));
			setOssLocalenpoint(Rs.getString("OssLocalenpoint"));
			setOssaccessKeyId(Rs.getString("OssaccessKeyId"));
			setOssaccessKeySecret(Rs.getString("OssaccessKeySecret"));
			setOSSbucketName(Rs.getString("OSSbucketName"));
			setOssdomain(Rs.getString("Ossdomain"));
			
			//百度云
			setBosaccessKeyId(Rs.getString("BosaccessKeyId"));
			setBosaccessKeySecret(Rs.getString("BosaccessKeySecret"));
			setBosbucketName(Rs.getString("BosbucketName"));
			setBosdomain(Rs.getString("Bosdomain"));

			//七牛云
			setQiniuAccessKey(Rs.getString("QiniuAccessKey"));
			setQiniuSecrectKey(Rs.getString("QiniuSecrectKey"));
			setQiniubucketName(Rs.getString("QiniubucketName"));
			init();

			closeRs(Rs);
		} else {
			closeRs(Rs);
		}// throw new MessageException("该纪录不存在!");}
	}

	private void init() {
		String str = IncludeFolders;
		str = str.replace("\r\n", ",");
		str = str.replace("\r", ",");
		str = str.replace("\n", ",");
		str = str.replace(" ", ",");
		StringTokenizer st = new StringTokenizer(str, ",");
		while (st.hasMoreTokens()) {
			// IncludeFoldersArray.add(st.nextToken());
			String folder = st.nextToken();
			if (!folder.equals("")) {
				String folder2 = "";
				int index = folder.indexOf("=>");
				if (index != -1) {
					folder2 = folder.substring(index + 2);
					folder = folder.substring(0, index);
				}
				// System.out.println(folder+","+folder2);
				IncludeFoldersArray.add(new String[] { folder, folder2 });
			}
		}

		str = ExcludeFolders;
		str = str.replace("\r\n", ",");
		str = str.replace("\r", ",");
		str = str.replace("\n", ",");
		str = str.replace(" ", ",");
		st = new StringTokenizer(str, ",");
		while (st.hasMoreTokens()) {
			String folder = st.nextToken();
			if (!folder.equals(""))
				ExcludeFoldersArray.add(folder);
		}
	}

	
	public boolean canPublish(String FileName) {

		if (Status == 0)
			return false;

		FileName = Util.ClearPath(FileName);
		if (!FileName.startsWith("/"))
			FileName = "/" + FileName;
		for (int i = 0; i < ExcludeFoldersArray.size(); i++) {
			String folder = (String) ExcludeFoldersArray.get(i);
			folder = Util.ClearPath(folder);
			if (FileName.startsWith(folder))
				return false;
		}

		if (IncludeFoldersArray == null || IncludeFoldersArray.size() == 0) {
			return true;
		} else {
			for (int i = 0; i < IncludeFoldersArray.size(); i++) {
				String folder = (String) IncludeFoldersArray.get(i)[0];
				// System.out.println("canpublish:"+folder);
				folder = Util.ClearPath(folder);
				if (FileName.startsWith(folder))
					return true;
			}

			return false;
		}
	}

	public String getToFileName(String FileName) {

		if (IncludeFoldersArray == null || IncludeFoldersArray.size() == 0) {
			return "";
		} else {
			for (int i = 0; i < IncludeFoldersArray.size(); i++) {
				String folder = (String) IncludeFoldersArray.get(i)[0];
				String folder2 = (String) IncludeFoldersArray.get(i)[1];
				// System.out.println("canpublish2:"+folder);
				folder = Util.ClearPath(folder);
				if (FileName.startsWith(folder)) {
					if (folder2.length() == 0)
						return "";
					return FileName.replace(folder, folder2);
				}
			}

			return "";
		}
	}

	/**
	 * @return Returns the copyMode.
	 */
	public int getCopyMode() {
		return CopyMode;
	}

	/**
	 * @param copyMode
	 *            The copyMode to set.
	 */
	public void setCopyMode(int copyMode) {
		CopyMode = copyMode;
	}

	/**
	 * @return Returns the destFolder.
	 */
	public String getDestFolder() {
		return DestFolder;
	}

	/**
	 * @param destFolder
	 *            The destFolder to set.
	 */
	public void setDestFolder(String destFolder) {
		DestFolder = destFolder;
	}

	/**
	 * @return Returns the password.
	 */
	public String getPassword() {
		return Password;
	}

	/**
	 * @param password
	 *            The password to set.
	 */
	public void setPassword(String password) {
		Password = password;
	}

	/**
	 * @return Returns the port.
	 */
	public String getPort() {
		return Port;
	}

	/**
	 * @param port
	 *            The port to set.
	 */
	public void setPort(String port) {
		Port = port;
	}

	/**
	 * @return Returns the remoteFolder.
	 */
	public String getRemoteFolder() {
		return RemoteFolder;
	}

	/**
	 * @param remoteFolder
	 *            The remoteFolder to set.
	 */
	public void setRemoteFolder(String remoteFolder) {
		// Ftp 远程目录使用/分隔符
		if (!remoteFolder.equals(""))
			remoteFolder.replace("\\", "/");

		RemoteFolder = remoteFolder;
	}

	/**
	 * @return Returns the server.
	 */
	public String getServer() {
		return Server;
	}

	/**
	 * @param server
	 *            The server to set.
	 */
	public void setServer(String server) {
		Server = server;
	}

	/**
	 * @return Returns the username.
	 */
	public String getUsername() {
		return Username;
	}

	/**
	 * @param username
	 *            The username to set.
	 */
	public void setUsername(String username) {
		Username = username;
	}

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public PublishScheme() throws MessageException, SQLException {
		super();
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";


		Sql = "insert into publish_scheme (";

		Sql += "CopyMode,Server,Name,Port,Username,Password,FtpMode,RemoteFolder,DestFolder,IncludeFolders,ExcludeFolders,CreateDate,Status,Site";
		Sql += ",accessKeyID,secretKey,bucketName,endPoint,TenantName,CredentialsUserName,CredentialsPassword,TokenUrl,videoHttpHead,Ossendpoint,OssLocalenpoint,OssaccessKeyId,OssaccessKeySecret,OSSbucketName,Ossdomain,BosaccessKeyId,BosaccessKeySecret,BosbucketName,Bosdomain";
		Sql +=", QiniuAccessKey,QiniuSecrectKey,QiniubucketName";
		Sql += ") values(";
		Sql += "" + CopyMode + "";
		Sql += ",'" + SQLQuote(Server) + "'";
		Sql += ",'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Port) + "'";
		Sql += ",'" + SQLQuote(Username) + "'";
		Sql += ",'" + SQLQuote(Password) + "'";
		Sql += "," + FtpMode + "";
		Sql += ",'" + SQLQuote(RemoteFolder) + "'";
		Sql += ",'" + SQLQuote(DestFolder) + "'";
		Sql += ",'" + SQLQuote(IncludeFolders) + "'";
		Sql += ",'" + SQLQuote(ExcludeFolders) + "'";
		Sql += ",now(),1";
		Sql += "," + Site + "";
		Sql += ",'" + SQLQuote(accessKeyID) + "'";
		Sql += ",'" + SQLQuote(secretKey) + "'";
		Sql += ",'" + SQLQuote(bucketName) + "'";
		Sql += ",'" + SQLQuote(endPoint) + "'";
		Sql += ",'" + SQLQuote(TenantName) + "'";
		Sql += ",'" + SQLQuote(CredentialsUserName) + "'";
		Sql += ",'" + SQLQuote(CredentialsPassword) + "'";
		Sql += ",'" + SQLQuote(TokenUrl) + "'";
		Sql += ",'" + SQLQuote(videoHttpHead) + "'";
		//Ossendpoint,OssLocalenpoint,OssaccessKeyId,OssaccessKeySecret,OSSbucketName
		Sql += ",'" + SQLQuote(Ossendpoint) + "'";
		Sql += ",'" + SQLQuote(OssLocalenpoint) + "'";
		Sql += ",'" + SQLQuote(OssaccessKeyId) + "'";
		Sql += ",'" + SQLQuote(OssaccessKeySecret) + "'";
		Sql += ",'" + SQLQuote(OSSbucketName) + "'";
		Sql += ",'" + SQLQuote(Ossdomain) + "'";
		Sql += ",'" + SQLQuote(BosaccessKeyId) + "'";
		Sql += ",'" + SQLQuote(BosaccessKeySecret) + "'";
		Sql += ",'" + SQLQuote(BosbucketName) + "'";
		Sql += ",'" + SQLQuote(Bosdomain) + "'";
		Sql += ",'" + SQLQuote(QiniuAccessKey) + "'";
		Sql += ",'" + SQLQuote(QiniuSecrectKey) + "'";
		Sql += ",'" + SQLQuote(QiniubucketName) + "'";
		Sql += ")";
		// executeUpdate(Sql);
		id = executeUpdate_InsertID(Sql);
		
		new Log().PublishSchemeLog(LogAction.publish_scheme_add, SQLQuote(Name), id, UserId);
		
		CmsCache.InitPublishScheme();

		Site = CmsCache.getPublishScheme(id).getSite();
		CmsCache.getSite(Site).clearPublishSchemes();

		CmsCache.delSite(Site);

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		Site = CmsCache.getPublishScheme(id).getSite();

		new Log().PublishSchemeLog(LogAction.publish_scheme_delete, CmsCache.getPublishScheme(id).getName(), id, UserId);
		
		String Sql = "delete from publish_scheme where id=" + id;
		executeUpdate(Sql);
		
		
		
		CmsCache.InitPublishScheme();

		CmsCache.getSite(Site).clearPublishSchemes();

		CmsCache.delSite(Site);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";

		Sql = "update publish_scheme set ";

		Sql += "CopyMode=" + CopyMode + "";
		Sql += ",Server='" + SQLQuote(Server) + "'";
		Sql += ",Name='" + SQLQuote(Name) + "'";
		Sql += ",Port='" + SQLQuote(Port) + "'";
		Sql += ",Username='" + SQLQuote(Username) + "'";
		Sql += ",Password='" + SQLQuote(Password) + "'";
		Sql += ",FtpMode=" + FtpMode + "";
		Sql += ",RemoteFolder='" + SQLQuote(RemoteFolder) + "'";
		Sql += ",DestFolder='" + SQLQuote(DestFolder) + "'";
		Sql += ",IncludeFolders='" + SQLQuote(IncludeFolders) + "'";
		Sql += ",ExcludeFolders='" + SQLQuote(ExcludeFolders) + "'";
		Sql += ",accessKeyID='" + SQLQuote(accessKeyID) + "'";
		Sql += ",secretKey='" + SQLQuote(secretKey) + "'";
		Sql += ",bucketName='" + SQLQuote(bucketName) + "'";
		Sql += ",endPoint='" + SQLQuote(endPoint) + "'";
		Sql += ",TenantName='" + SQLQuote(TenantName) + "'";
		Sql += ",CredentialsUserName='" + SQLQuote(CredentialsUserName) + "'";
		Sql += ",CredentialsPassword='" + SQLQuote(CredentialsPassword) + "'";
		Sql += ",TokenUrl='" + SQLQuote(TokenUrl) + "'";
		Sql += ",videoHttpHead='" + SQLQuote(videoHttpHead) + "'";
		//Ossendpoint,OssLocalenpoint,OssaccessKeyId,OssaccessKeySecret,OSSbucketName
		Sql += ",Ossendpoint='" + SQLQuote(Ossendpoint) + "'";
		Sql += ",OssLocalenpoint='" + SQLQuote(OssLocalenpoint) + "'";
		Sql += ",OssaccessKeyId='" + SQLQuote(OssaccessKeyId) + "'";
		Sql += ",OssaccessKeySecret='" + SQLQuote(OssaccessKeySecret) + "'";
		Sql += ",OSSbucketName='" + SQLQuote(OSSbucketName) + "'";
		Sql += ",Ossdomain='" + SQLQuote(Ossdomain) + "'";
		
		Sql += ",BosaccessKeyId='" + SQLQuote(BosaccessKeyId) + "'";
		Sql += ",BosaccessKeySecret='" + SQLQuote(BosaccessKeySecret) + "'";
		Sql += ",BosbucketName='" + SQLQuote(BosbucketName) + "'";
		Sql += ",Bosdomain='" + SQLQuote(Bosdomain) + "'";

		Sql += ",QiniuAccessKey='" + SQLQuote(QiniuAccessKey) + "'";
		Sql += ",QiniuSecrectKey='" + SQLQuote(QiniuSecrectKey) + "'";
		Sql += ",QiniubucketName='" + SQLQuote(QiniubucketName) + "'";
		Sql += " where id=" + id;

		executeUpdate(Sql);

		new Log().PublishSchemeLog(LogAction.publish_scheme_edit, CmsCache.getPublishScheme(id).getName(), id, UserId);
		
		CmsCache.InitPublishScheme();
		Site = CmsCache.getPublishScheme(id).getSite();
		CmsCache.delSite(Site);//清理缓存，
		CmsCache.delPublishScheme(id);
		CmsCache.getSite(Site).clearPublishSchemes();
	}

	// 启动此发布任务
	public void Enable() throws SQLException, MessageException {
		String Sql = "";

		Sql = "update publish_scheme set ";
		Sql += "Status=1";

		Sql += " where id=" + id;

		executeUpdate(Sql);
		new Log().PublishSchemeLog(LogAction.publish_scheme_start, CmsCache.getPublishScheme(id).getName(), id, UserId);
		CmsCache.InitPublishScheme();

		Site = CmsCache.getPublishScheme(id).getSite();
		CmsCache.getSite(Site).clearPublishSchemes();

		CmsCache.delSite(Site);

	}

	// 禁止此发布任务
	public void Disable() throws SQLException, MessageException {
		String Sql = "";

		Sql = "update publish_scheme set ";
		Sql += "Status=0";

		Sql += " where id=" + id;

		executeUpdate(Sql);
		new Log().PublishSchemeLog(LogAction.publish_scheme_stop, CmsCache.getPublishScheme(id).getName(), id, UserId);
		CmsCache.InitPublishScheme();

		Site = CmsCache.getPublishScheme(id).getSite();
		CmsCache.getSite(Site).clearPublishSchemes();

		CmsCache.delSite(Site);
	}

	// 暂停发布任务
	public void Pause() throws SQLException, MessageException {
		String Sql = "";

		Sql = "update publish_scheme set ";
		Sql += "Status=2";

		Sql += " where id=" + id;

		executeUpdate(Sql);

		CmsCache.InitPublishScheme();

		Site = CmsCache.getPublishScheme(id).getSite();
		CmsCache.getSite(Site).clearPublishSchemes();

		CmsCache.delSite(Site);
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
	 * @return Returns the messageType.
	 */
	public int getMessageType() {
		return MessageType;
	}

	/**
	 * @param messageType
	 *            The messageType to set.
	 */
	public void setMessageType(int messageType) {
		MessageType = messageType;
	}

	/**
	 * @return Returns the status.
	 */
	public int getStatus() {
		return Status;
	}

	/**
	 * @param status
	 *            The status to set.
	 */
	public void setStatus(int status) {
		Status = status;
	}

	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return Name;
	}

	/**
	 * @param name
	 *            The name to set.
	 */
	public void setName(String name) {
		Name = name;
	}

	public ArrayList<String> getExcludeFoldersArray() {
		return ExcludeFoldersArray;
	}

	public void setExcludeFoldersArray(ArrayList<String> excludeFoldersArray) {
		ExcludeFoldersArray = excludeFoldersArray;
	}

	public ArrayList<String[]> getIncludeFoldersArray() {
		return IncludeFoldersArray;
	}

	public void setIncludeFoldersArray(ArrayList<String[]> includeFoldersArray) {
		IncludeFoldersArray = includeFoldersArray;
	}

	public String getExcludeFolders() {
		return ExcludeFolders;
	}

	public void setExcludeFolders(String excludeFolders) {
		ExcludeFolders = excludeFolders;
	}

	public String getIncludeFolders() {
		return IncludeFolders;
	}

	public void setIncludeFolders(String includeFolders) {
		IncludeFolders = includeFolders;
	}

	public int getSite() {
		return Site;
	}

	public void setSite(int site) {
		Site = site;
	}

	public void setFtpMode(int ftpMode) {
		FtpMode = ftpMode;
	}

	public int getFtpMode() {
		return FtpMode;
	}

	public String getAccessKeyID() {
		return accessKeyID;
	}

	public void setAccessKeyID(String accessKeyID) {
		this.accessKeyID = accessKeyID;
	}

	public String getSecretKey() {
		return secretKey;
	}

	public void setSecretKey(String secretKey) {
		this.secretKey = secretKey;
	}

	public String getBucketName() {
		return bucketName;
	}

	public void setBucketName(String bucketName) {
		this.bucketName = bucketName;
	}

	public String getEndPoint() {
		return endPoint;
	}

	public void setEndPoint(String endPoint) {
		this.endPoint = endPoint;
	}

	public String getTenantName() {
		return TenantName;
	}

	public void setTenantName(String tenantName) {
		TenantName = tenantName;
	}

	public String getCredentialsUserName() {
		return CredentialsUserName;
	}

	public void setCredentialsUserName(String credentialsUserName) {
		CredentialsUserName = credentialsUserName;
	}

	public String getCredentialsPassword() {
		return CredentialsPassword;
	}

	public void setCredentialsPassword(String credentialsPassword) {
		CredentialsPassword = credentialsPassword;
	}

	public String getTokenUrl() {
		return TokenUrl;
	}

	public void setTokenUrl(String tokenUrl) {
		TokenUrl = tokenUrl;
	}

	public String getVideoHttpHead() {
		return videoHttpHead;
	}

	public void setVideoHttpHead(String videoHttpHead) {
		this.videoHttpHead = videoHttpHead;
	}

	public String getOssendpoint() {
		return Ossendpoint;
	}

	public void setOssendpoint(String ossendpoint) {
		Ossendpoint = ossendpoint;
	}

	public String getOssLocalenpoint() {
		return OssLocalenpoint;
	}

	public void setOssLocalenpoint(String ossLocalenpoint) {
		OssLocalenpoint = ossLocalenpoint;
	}

	public String getOssaccessKeyId() {
		return OssaccessKeyId;
	}

	public void setOssaccessKeyId(String ossaccessKeyId) {
		OssaccessKeyId = ossaccessKeyId;
	}

	public String getOssaccessKeySecret() {
		return OssaccessKeySecret;
	}

	public void setOssaccessKeySecret(String ossaccessKeySecret) {
		OssaccessKeySecret = ossaccessKeySecret;
	}

	public String getOSSbucketName() {
		return OSSbucketName;
	}

	public void setOSSbucketName(String oSSbucketName) {
		OSSbucketName = oSSbucketName;
	}

	public String getOssdomain() {
		return Ossdomain;
	}

	public void setOssdomain(String ossdomain) {
		Ossdomain = ossdomain;
	}

	public String getBosaccessKeyId() {
		return BosaccessKeyId;
	}

	public void setBosaccessKeyId(String bosaccessKeyId) {
		BosaccessKeyId = bosaccessKeyId;
	}

	public String getBosaccessKeySecret() {
		return BosaccessKeySecret;
	}

	public void setBosaccessKeySecret(String bosaccessKeySecret) {
		BosaccessKeySecret = bosaccessKeySecret;
	}

	public String getBosbucketName() {
		return BosbucketName;
	}

	public void setBosbucketName(String bosbucketName) {
		BosbucketName = bosbucketName;
	}

	public String getBosdomain() {
		return Bosdomain;
	}

	public void setBosdomain(String bosdomain) {
		Bosdomain = bosdomain;
	}

	public String getQiniuAccessKey() {
		return QiniuAccessKey;
	}

	public void setQiniuAccessKey(String qiniuAccessKey) {
		QiniuAccessKey = qiniuAccessKey;
	}

	public String getQiniuSecrectKey() {
		return QiniuSecrectKey;
	}

	public void setQiniuSecrectKey(String qiniuSecrectKey) {
		QiniuSecrectKey = qiniuSecrectKey;
	}

	public String getQiniubucketName() {
		return QiniubucketName;
	}

	public void setQiniubucketName(String qiniubucketName) {
		QiniubucketName = qiniubucketName;
	}

	public int getUserId() {
		return UserId;
	}

	public void setUserId(int userId) {
		UserId = userId;
	}

	public static void main(String[] args) {
		System.out.println("----");
	}
}
