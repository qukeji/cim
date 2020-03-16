/*
 * Created on 2005-9-3
 *
 */
package tidemedia.cms.page;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.sql.ResultSet;
import java.sql.SQLException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.publish.Publish;
import tidemedia.cms.system.ChannelTemplate;
import tidemedia.cms.system.CmsCache;

/**
 * @author Administrator
 *
 */
public class PageModule extends Table{

	public static final int ModuleFrame = 4;//框架模块
	public static final int ModuleColumn = 5;//框架中的栏目模块
	public static final int ModuleDirectEdit = 2;//直接编辑内容的模块
	public static final int ModuleChannelTemplate = 1;//从频道生成内容的模块
	
	private int id;
	private int ActionUser = 0;
	private int Page;//页面编号
	private int Module;//页面中的模块编号
	private int Template;//对应的附加模板编号
	private int Type;
	//Type=1 对应频道或分类数据，使用附加发布 Type=2 直接维护数据  Type=3 从模板导入数据
	
	private String TemplateFile = "";//模块内容
	private String Content = "";//模块内容
	
	private String Charset = "utf-8";//模块内容
	
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public PageModule() throws MessageException, SQLException {
		super();
	}

	public PageModule(int id) throws MessageException, SQLException
	{
		String Sql = "select * from page_module where id=" + id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setPage(Rs.getInt("Page"));
			//setModule(Rs.getInt("Module"));
			setTemplate(Rs.getInt("Template"));
			setType(Rs.getInt("ModuleType"));
			setContent(convertNull(Rs.getString("Content")));
			//setTemplateFile(convertNull(Rs.getString("TemplateFile")));

			closeRs(Rs);
		}
		else
			{closeRs(Rs);throw new MessageException("This page module is not exist!");}	
		
		//页面直接维护
		if(Type==2)
		{
			Sql = "select * from page_module_content where Page=" + Page + " and Module=" + id + " order by id desc";
			Rs = executeQuery(Sql);
			if(Rs.next())
			{
				setContent(convertNull(Rs.getString("Content")));
			}
			closeRs(Rs);
		}
	}
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "insert into page_module (";
		
		Sql += "Page,Template,TemplateFile,ModuleType";
		Sql += ") values(";
		Sql += "" + Page + "";
		Sql += "," + Template + "";
		Sql += ",'" + SQLQuote(TemplateFile) + "'";
		Sql += "," + Type + "";
		
		Sql += ")";
		
		int insertid = executeUpdate_InsertID(Sql);	
		
		setId(insertid);
				
		if(Type==1)
		{
			ChannelTemplate ct = new ChannelTemplate(Template);
			//System.out.println(":" + ct.getTargetName() + ":");
			if(ct.getTargetName().equals(""))
			{
				ct.setTargetName("include_" + ct.getId()+".html");
				ct.updateTargetName();
			}
			
			Publish publish = new Publish();
			publish.setPublishType(Publish.ONLYTHISTemplate_PUBLISH);
			publish.setChannelID(ct.getChannelID());
			publish.setTemplateID(Template);
			publish.GenerateFile();
			//System.out.println(":" + ct.getTargetName() + ":");
		}
		else if(Type==2)//页面直接维护
			AddModuleContent();
	}

	public void AddModuleContent() throws SQLException, MessageException {
		String Sql = "insert into page_module_content (";
		
		Sql += "Page,Module,Content,User,CreateDate";
		Sql += ") values(";
		Sql += "" + Page + "";
		Sql += "," + getId() + "";
		Sql += ",'" + SQLQuote(Content) + "'";
		Sql += "," + ActionUser + "";
		Sql += ",now()";
		
		Sql += ")";
		
		executeUpdate(Sql);	
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete() throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "delete from page_module_content where Module=" + id;
		executeUpdate(Sql);
		
		Sql = "delete from page_module where id=" + id;
		executeUpdate(Sql);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {		
		if(Type==1)
		{
			String Sql = "";
			
			Sql = "update page_module set ";
			
			Sql += "Template=" + Template + "";
			
			Sql += " where id="+id;
			
			executeUpdate(Sql);	
			
			ChannelTemplate ct = new ChannelTemplate(Template);

			if(ct.getTargetName().equals(""))
			{
				ct.setTargetName("include_" + ct.getId()+".html");
				ct.updateTargetName();
			}
			
			Publish publish = new Publish();
			publish.setPublishType(Publish.ONLYTHISTemplate_PUBLISH);
			publish.setChannelID(ct.getChannelID());
			publish.setTemplateID(Template);
			publish.GenerateFile();
		}
		else if(Type==2)//页面直接维护
			AddModuleContent();
		else if(Type==3)
		{
			String Sql = "";
			
			Sql = "update page_module set ";
			Sql += "TemplateFile='" + SQLQuote(TemplateFile) + "'";
			Sql += " where id="+id;
			
			executeUpdate(Sql);				
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
	 * @return Returns the index.
	 */
	public int getModule() {
		return Module;
	}
	/**
	 * @param index The index to set.
	 */
	public void setModule(int index) {
		Module = index;
	}
	/**
	 * @return Returns the page.
	 */
	public int getPage() {
		return Page;
	}
	/**
	 * @param page The page to set.
	 */
	public void setPage(int page) {
		Page = page;
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
	 * @return Returns the template.
	 */
	public int getTemplate() {
		return Template;
	}
	/**
	 * @param template The template to set.
	 */
	public void setTemplate(int template) {
		Template = template;
	}
	/**
	 * @return Returns the Type.
	 */
	public int getType() {
		return Type;
	}
	/**
	 * @param Type The Type to set.
	 */
	public void setType(int type) {
		Type = type;
	}

	//获取该模块的内容，为页面中模块标记间的内容
	public String getContent() throws MessageException, SQLException, IOException
	{
		if(Type==1)
		{
			String content = "";
			ChannelTemplate ct = new ChannelTemplate(getTemplate());
			
			if(ct.getTemplateFile().getType()==1)
				content = "#include_tidecms(\"/extra/"+ct.getChannelID()+"/"+ct.getId()+"\")";
			else
				content = "<!--#include virtual=\"" + ct.getFullTargetName() + "\" -->";
			return content;	
		}
		else if(Type==2)	return Content;
		else if(Type==3)
		{
			String content = "";
			File file = new File(CmsCache.getDefaultSite().getTemplateFolder() + "/" + getTemplateFile());
			
			BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file),Charset));
			String LineString;
			while ((LineString = in .readLine())!=null)
			{
				content += LineString+"\r\n";
			}

			in.close();	
			return content;
		}
		
		return "";
	}
	/**
	 * @param content The content to set.
	 */
	public void setContent(String content) {
		Content = content;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {

	}

	public String getTemplateFile() {
		return TemplateFile;
	}

	public void setTemplateFile(String templateFile) {
		TemplateFile = templateFile;
	}

	public String getCharset() {
		return Charset;
	}

	public void setCharset(String charset) {
		Charset = charset;
	}

	public int getActionUser() {
		return ActionUser;
	}

	public void setActionUser(int actionUser) {
		ActionUser = actionUser;
	}
}
