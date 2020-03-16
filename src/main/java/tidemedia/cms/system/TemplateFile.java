package tidemedia.cms.system;

import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.util.Util;

/**
 * @author Administrator
 *
 */
public class TemplateFile extends Table{

	public static final int ListTemplateType = 1;//索引页面模板
	public static final int ContentTemplateType = 2;//内容页面模板
	public static final int ExtraTemplateType = 3;//附加模板
	public static final int AppTemplateType = 5;//应用页面模板
	public static final int RegisterTemplateType = 6;//注册页面模板
	
	private String 	Name 		= "";//模板名称
	private String 	FileName 	= "";//模板文件名,用于配置模板时自动生成目标文件名
	private String 	Description 	= "";//模板描述
	private String 	TemplateName = "";//模板原来的文件名，以后作废 2009-01-04
	private String 	Title 		= "";
	private String 	Photo 		= "";//模板图片，图片存放在cms的/images/template目录下
	private String 	CreateDate 	= "";
	private String 	ModifiedDate = "";
	private String 	Content 	= "";
	private int		Type		= 0;//模板类型 0 静态模板 1 动态模板
	private int		id;
	private int		Group			= 0;
	
	private int 	ActionUser 		= 0;
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public TemplateFile() throws MessageException, SQLException {
		super();
	}

	public TemplateFile(int id) throws SQLException, MessageException
	{
		String Sql = "select * from template_files where id="+id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(id);
			setGroup(Rs.getInt("GroupID"));
			setType(Rs.getInt("Type"));
			setName(convertNull(Rs.getString("Name")));
			setFileName(convertNull(Rs.getString("FileName")));
			setContent(convertNull(Rs.getString("Content")));
			setDescription(convertNull(Rs.getString("Description")));
			setTemplateName(convertNull(Rs.getString("TemplateName")));
			setTitle(convertNull(Rs.getString("Title")));
			setPhoto(convertNull(Rs.getString("Photo")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));
			setModifiedDate(convertNull(Rs.getString("ModifiedDate")));
		}
		
		closeRs(Rs);
	}

	public TemplateFile(String name) throws SQLException, MessageException
	{
		name = name.replace("//","/");
		name = name.replace("/", "\\");
		String Sql = "select * from template_files where TemplateName='" + SQLQuote(name) + "'";
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setGroup(Rs.getInt("GroupID"));
			setType(Rs.getInt("Type"));
			setName(convertNull(Rs.getString("Name")));
			setFileName(convertNull(Rs.getString("FileName")));
			setContent(convertNull(Rs.getString("Content")));
			setDescription(convertNull(Rs.getString("Description")));
			setTemplateName(convertNull(Rs.getString("TemplateName")));
			setTitle(convertNull(Rs.getString("Title")));
			setPhoto(convertNull(Rs.getString("Photo")));
			setCreateDate(convertNull(Rs.getString("CreateDate")));	
			setModifiedDate(convertNull(Rs.getString("ModifiedDate")));
		}
		closeRs(Rs);
		
		setTemplateName(name);
		//else
		//	throw new MessageException("该记录不存在!");
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
			String Sql = "";
	
			if(FileName.equals(""))
				throw new MessageException("模板文件名不能为空.");
			
			Sql = "select * from template_files where FileName='" + SQLQuote(FileName) + "' and GroupID=" + Group;
			if(isExist(Sql))
			{
				throw new MessageException("此模板文件名已经存在!",2);
			}
			
			Sql = "insert into template_files (";
			
			Sql += "Description,GroupID,Type,Name,FileName,Content,TemplateName,Title,Photo,CreateDate,ModifiedDate";
			Sql += ") values(";
			Sql += "'" + SQLQuote(Description) + "'";
			Sql += "," + Group + "";
			Sql += "," + Type + "";
			Sql += ",'" + SQLQuote(Name) + "'";
			Sql += ",'" + SQLQuote(FileName) + "'";
			Sql += ",'" + SQLQuote(Content) + "'";
			Sql += ",'" + SQLQuote(TemplateName) + "'";
			Sql += ",'" + SQLQuote(Title) + "'";
			Sql += ",'" + SQLQuote(Photo) + "'";
			Sql += ",now(),now()";
			
			Sql += ")";
			//System.out.println(Sql);
			TableUtil tu = new TableUtil();
			
			int insertid = tu.executeUpdate_InsertID(Sql);
			
			setId(insertid);
			
			Log l = new Log();
			l.setTitle(getGroupTree()+FileName);
			l.setUser(getActionUser());
			l.setItem(insertid);
			l.setLogAction(LogAction.template_add);//l.setLogType("新建模板");
			l.setFromType("template");l.setFromKey("");
			l.Add();	
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		
		String Sql = "";
		
		if(FileName.equals(""))
			throw new MessageException("模板文件名不能为空.");
		
		Sql = "select * from template_files where FileName='" + SQLQuote(FileName) + "' and GroupID=" + Group + " and id!=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("此模板文件名已经存在!",2);
		}
		
		Sql = "update template_files set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		Sql += ",FileName='" + SQLQuote(FileName) + "'";
		Sql += ",Photo='" + SQLQuote(Photo) + "'";
		Sql += ",GroupID=" + Group + "";
		Sql += ",Type=" + Type + "";
		Sql += ",Description='" + SQLQuote(Description) + "'";
		Sql += ",TemplateName='" + SQLQuote(TemplateName) + "'";
		Sql += ",Title='" + SQLQuote(Title) + "'";
		Sql += ",ModifiedDate=now()";
		
		Sql += " where id=" + getId();	
		
		//System.out.println(Sql);
		TableUtil tu = new TableUtil();
		tu.executeUpdate(Sql);
		
		CmsCache.delTemplate(getId());
		
		Log l = new Log();
		l.setTitle(getGroupTree()+FileName);
		l.setUser(getActionUser());
		l.setItem(getId());
		l.setLogAction(LogAction.template_edit);//l.setLogType("编辑模板");
		l.setFromType("template");l.setFromKey("");
		l.Add();	
	}
	
	public void UpdateContent() throws SQLException, MessageException {
		
		String Sql = "update template_files set ";
		
		Sql += "Content='" + SQLQuote(Content) + "'";
		Sql += ",ModifiedDate=now()";
		
		Sql += " where id=" + getId();	
		
		TableUtil tu = new TableUtil();
		tu.executeUpdate(Sql);
		
		CmsCache.delTemplate(getId());
		
		Log l = new Log();
		l.setTitle(getGroupTree()+getFileName());
		l.setUser(getActionUser());
		l.setItem(getId());
		l.setLogAction(LogAction.template_edit_source);//l.setLogType("编辑模板内容");
		l.setFromType("template");l.setFromKey("");
		l.Add();	
	}
	
	public void RenameFile(String oldname,String newname) throws SQLException, MessageException
	{
		String Sql = "";
		oldname = oldname.replace("//","/");
		newname = newname.replace("//","/");
		
		Sql = "update template_files set TemplateName='" + SQLQuote(newname) + "' where TemplateName='" + SQLQuote(oldname) + "'";
		//System.out.println(Sql);
		
		executeUpdate(Sql);
		
		CmsCache.delTemplate(getId());
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		
		TemplateFile tf = CmsCache.getTemplate(id);
		
		Log l = new Log();
		l.setTitle(tf.getGroupTree()+tf.getFileName());
		l.setUser(getActionUser());
		l.setItem(tf.getId());
		l.setLogAction(LogAction.template_delete);//l.setLogType("删除模板");
		l.setFromType("template");l.setFromKey("");
		l.Add();
		
		String Sql = "delete from template_files where id=" + id;
		executeUpdate(Sql);	
		
		CmsCache.delTemplate(id);
	}

	public void Delete(String itemid) throws SQLException, MessageException {

		String[] ids = Util.StringToArray(itemid, ",");
		if (ids != null && ids.length > 0) 
		{
			for (int i = 0; i < ids.length; i++) 
			{
				int id_ = Util.parseInt(ids[i]);
				Delete(id_);
			}
		}
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
	 * @return Returns the description.
	 */
	public String getDescription() {
		return Description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		Description = description;
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
	 * @return Returns the createDate.
	 */
	public String getCreateDate() {
		return CreateDate;
	}
	/**
	 * @param createDate The createDate to set.
	 */
	public void setCreateDate(String createDate) {
		CreateDate = createDate;
	}
	/**
	 * @return Returns the photo.
	 */
	public String getPhoto() {
		return Photo;
	}
	/**
	 * @param photo The photo to set.
	 */
	public void setPhoto(String photo) {
		photo = photo.replace("//","/");
		Photo = photo;
	}
	/**
	 * @return Returns the templateName.
	 */
	public String getTemplateName() {
		return TemplateName;
	}
	/**
	 * @param templateName The templateName to set.
	 */
	public void setTemplateName(String templateName) {
		//处理文件名
		templateName = templateName.replace("//","/");
		TemplateName = templateName;
	}
	/**
	 * @return Returns the title.
	 */
	public String getTitle() {
		return Title;
	}
	/**
	 * @param title The title to set.
	 */
	public void setTitle(String title) {
		Title = title;
	}
	/**
	 * @return Returns the inStream.
	 */
	
	public String listChannelUse() throws SQLException, MessageException
	{
		String str = "";
		
		String Sql = "select channel.Name from channel_template left join channel " +
				"on channel.id=channel_template.Channel where channel_template.TemplateID=" + id + "";
		//System.out.println(Sql);
		ResultSet Rs = executeQuery(Sql);
		
		while(Rs.next())
		{
			String name = convertNull(Rs.getString("channel.Name"));
			if(name.length()>0)	str += (str.equals("")?"":",") +name;
		}
		
		closeRs(Rs);
		
		return str;
	}

	//获取模板使用次数
	public int getUsedNumber() throws SQLException, MessageException
	{	
		int number = 0;
		String Sql = "select count(*) from channel_template  where TemplateID=" + id + "";
		//System.out.println(Sql);
		ResultSet Rs = executeQuery(Sql);
		
		if(Rs.next())
		{
			number = Rs.getInt(1);
		}
		
		closeRs(Rs);
		
		return number;
	}
	
	public void setContent(String text) {
		Content = text;
	}

	public String getContent() {
		return Content;
	}

	public void setModifiedDate(String modifiedDate) {
		ModifiedDate = modifiedDate;
	}

	public String getModifiedDate() {
		return ModifiedDate;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getName() {
		return Name;
	}

	public void setGroup(int group) {
		Group = group;
	}

	public int getGroup() {
		return Group;
	}

	public void setFileName(String fileName) {
		FileName = fileName;
	}

	public String getFileName() {
		return FileName;
	}
	
	//所在的组路径
	public String getGroupTree() throws SQLException, MessageException
	{
		//long a = System.currentTimeMillis();
		String tree = "";
		int i = 0;
		if(getGroup()>0)
		{
			int parent = getGroup();
			while(parent>0 && i <20)
			{
				i++;
				TemplateGroup t = CmsCache.getTemplateGroup(parent);
				parent = t.getParent();
				if(parent>0)
					tree = t.getName() + "/" + tree;
			}
		}
		//long b = System.currentTimeMillis();
		//System.out.println("getGroupTree:"+getId() + "," + (b-a) + "毫秒");
		return "/" + tree;
	}

	public void setActionUser(int actionUser) {
		ActionUser = actionUser;
	}

	public int getActionUser() {
		return ActionUser;
	}

	public int getType() {
		return Type;
	}

	public void setType(int type) {
		Type = type;
	}
}
