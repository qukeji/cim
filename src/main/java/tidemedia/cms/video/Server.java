/*
 * Created on 2011-3-27
 *
 */
package tidemedia.cms.video;

import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;

/**
 * @author Administrator
 *
 */
public class Server extends Table{

	private int	id = 0;
	private int Status = 0;
	private String Name = "";
	private String Url = "";
	private String SourceUrl = "";//访问视频源文件的方式，可以是http，也可以是本地目录（需要挂载）
	private String Destfolder = "";//转码后的文件存放位置，必须是本地目录，根据需要，文件可能会再次挪到最终地方
	private String ffmpeg	= "";//ffmpeg程序路径
	private String flvmdi = "";//flv封装工具路径
	private String mp4box = "";//mp4封装工具路径
	private String CreateDate = "";
	private String	   PublishScheme = "";//转码后发布方案编号，可以填写多个
	private int	   Number = 0;//线程数量
	private int    UsedNumber = 0;//正在使用的线程数量
	

	public Server() throws MessageException, SQLException {
		super();
	}

	public Server(int id) throws SQLException, MessageException
	{
		String Sql = "select * from transcode_server where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setStatus(Rs.getInt("Status"));
			setNumber(Rs.getInt("Number"));
			setPublishScheme(convertNull(Rs.getString("PublishScheme")));
			setName(Rs.getString("Name"));
			setUrl(convertNull(Rs.getString("Url")));
			setSourceUrl(convertNull(Rs.getString("SourceUrl")));
			setDestfolder(convertNull(Rs.getString("Destfolder")));
			setFfmpeg(convertNull(Rs.getString("ffmpeg")));
			setFlvmdi(convertNull(Rs.getString("flvmdi")));
			setMp4box(convertNull(Rs.getString("mp4box")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("该记录不存在!");}			
	}
	
	public void Add() throws SQLException, MessageException {
		
		
		String Sql = "";
		Sql = "insert into transcode_server (";
		
		Sql += "Status,Name,Url,SourceUrl,Destfolder,ffmpeg,flvmdi,mp4box,PublishScheme,Number,CreateDate";
		Sql += ") values(";
		Sql += Status + "";
		Sql += ",'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Url) + "'";
		Sql += ",'" + SQLQuote(SourceUrl) + "'";
		Sql += ",'" + SQLQuote(Destfolder) + "'";
		Sql += ",'" + SQLQuote(ffmpeg) + "'";
		Sql += ",'" + SQLQuote(flvmdi) + "'";
		Sql += ",'" + SQLQuote(mp4box) + "'";
		Sql += ",'" + SQLQuote(PublishScheme) + "'";
		Sql += "," + Number + "";
		Sql += ",now()";	
		Sql += ")";
		//System.out.println(Sql);
		executeUpdate(Sql);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "delete from transcode_server where id="+id;
		executeUpdate(Sql);			
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
			
		Sql = "update transcode_server set ";
		
		Sql += "Name='" + Name+"'";
		Sql += ",Url='" + SQLQuote(Url) + "'";
		Sql += ",SourceUrl='" + SQLQuote(SourceUrl) + "'";
		Sql += ",Destfolder='" + SQLQuote(Destfolder) + "'";
		Sql += ",ffmpeg='" + SQLQuote(ffmpeg) + "'";
		Sql += ",flvmdi='" + SQLQuote(flvmdi) + "'";
		Sql += ",mp4box='" + SQLQuote(mp4box) + "'";
		Sql += ",Status=" + Status;
		Sql += ",PublishScheme='" + SQLQuote(PublishScheme) + "'";
		Sql += ",Number=" + Number;
		Sql += ",CreateDate ='" + SQLQuote(CreateDate) + "'";		
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

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getStatus() {
		return Status;
	}

	public void setStatus(int status) {
		Status = status;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getUrl() {
		return Url;
	}

	public void setUrl(String url) {
		Url = url;
	}

	public String getCreateDate() {
		return CreateDate;
	}

	public void setCreateDate(String createDate) {
		CreateDate = createDate;
	}

	public String getSourceUrl() {
		return SourceUrl;
	}

	public void setSourceUrl(String sourceUrl) {
		SourceUrl = sourceUrl;
	}

	public String getDestfolder() {
		return Destfolder;
	}

	public void setDestfolder(String destfolder) {
		Destfolder = destfolder;
	}

	public String getFfmpeg() {
		return ffmpeg;
	}

	public void setFfmpeg(String ffmpeg) {
		this.ffmpeg = ffmpeg;
	}

	public String getFlvmdi() {
		return flvmdi;
	}

	public void setFlvmdi(String flvmdi) {
		this.flvmdi = flvmdi;
	}

	public String getMp4box() {
		return mp4box;
	}

	public void setMp4box(String mp4box) {
		this.mp4box = mp4box;
	}

	public String getPublishScheme() {
		return PublishScheme;
	}

	public void setPublishScheme(String publishScheme) {
		PublishScheme = publishScheme;
	}

	public int getNumber() {
		return Number;
	}

	public void setNumber(int number) {
		Number = number;
	}

	public int getUsedNumber() {
		return UsedNumber;
	}

	public void setUsedNumber(int usedNumber) {
		UsedNumber = usedNumber;
	}
	

}
