package tidemedia.cms.system;
import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.util.StringUtils;
public class BackupConfig  extends Table{
	private int id;

	private String includeFolders;

	private String excludeFolders;
 
	private String includeFileTypes;

	private String excludeFileTypes;

	private int siteId;
	   
	public BackupConfig() throws MessageException, SQLException {
		super();
	}
	
	public BackupConfig(int id) throws MessageException, SQLException{	
	  String sql="SELECT * FROM backup_config where id="+id;
	  ResultSet Rs = executeQuery(sql);
	  if(Rs.next()){
		setId(id);
	    setIncludeFolders(convertNull(Rs.getString("includeFolders")));
	    setExcludeFolders(convertNull(Rs.getString("excludeFolders")));
	    setIncludeFileTypes(convertNull(Rs.getString("includeFileTypes")));
	    setExcludeFileTypes(convertNull(Rs.getString("excludeFileTypes")));
	    setSiteId(Rs.getInt("siteId"));
		closeRs(Rs);
	  }else{
			closeRs(Rs);
			throw new MessageException("该记录不存在!");
	  }
	}
	
	public String getExcludeFileTypes() {
		return excludeFileTypes;
	}

	public void setExcludeFileTypes(String excludeFileTypes) {
		this.excludeFileTypes = excludeFileTypes;
	}

	public String getExcludeFolders() {
		return excludeFolders;
	}

	public void setExcludeFolders(String excludeFolders) {
		this.excludeFolders = excludeFolders;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getIncludeFileTypes() {
		return includeFileTypes;
	}

	public void setIncludeFileTypes(String includeFileTypes) {
		this.includeFileTypes = includeFileTypes;
	}

	public String getIncludeFolders() {
		return includeFolders;
	}

	public void setIncludeFolders(String includeFolders) {
		this.includeFolders = includeFolders;
	}

	public int getSiteId() {
		return siteId;
	}

	public void setSiteId(int siteId) {
		this.siteId = siteId;
	}
	
    public String convertString(String input){
    	input = input.trim();
    	input = StringUtils.replace(input, "\r\n", ",");
    	input = StringUtils.replace(input, "\r", ",");
    	input = StringUtils.replace(input, "\n", ",");
    	input = StringUtils.replace(input, " ", ",");
    	return input;
    }
	public  BackupConfig getBackupConfig() throws MessageException, SQLException{
		 String sql="SELECT * FROM backup_config";
		 ResultSet Rs =executeQuery(sql);
		 BackupConfig backupConfig; 
		 if(Rs.next()){
			 backupConfig =new BackupConfig(Rs.getInt("id"));

		  }else{

			  backupConfig=new BackupConfig();
		  }
			return backupConfig;
	}
	
	@Override
	public void Add() throws SQLException, MessageException {
		// TODO Auto-generated method stub
		String Sql = "";
		Sql = "insert into backup_config (";

		Sql += "IncludeFolders, ExcludeFolders, IncludeFileTypes, ExcludeFileTypes, Siteid";
		Sql += ") values(";
		Sql += "'" + convertString(SQLQuote(includeFolders)) + "'";
		Sql += ",'" + convertString(SQLQuote(excludeFolders))+"'";
		Sql += ",'" + convertString(SQLQuote(includeFileTypes))+"'";
		Sql += ",'" + convertString(SQLQuote(excludeFileTypes))+"'";
		Sql += "," +siteId;
		Sql += ")";
		executeUpdate(Sql);
	}

	@Override
	public void Delete(int id) throws SQLException, MessageException {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		Sql = "update backup_config set ";
		Sql += "IncludeFolders='" +convertString(includeFolders) + "',";
		Sql += "ExcludeFolders='" +convertString(excludeFolders) + "',";
		Sql += "IncludeFileTypes='" +convertString(includeFileTypes) + "',";
		Sql += "ExcludeFileTypes='" + convertString(excludeFileTypes) + "',";
		Sql += "Siteid=" + siteId;
		Sql += " where id=" + id;
		executeUpdate(Sql);
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


}
