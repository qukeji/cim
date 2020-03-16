package tidemedia.cms.system;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.user.UserInfo;

/**
 * @author Administrator
 * @see App
 */
public class App extends Table {

	private int id;

	private int Parent;

	private int Type;

	private String Name = "";

	private String Template = "";

	private String TargetName = "";

	private String Charset = "";

	private String RealCharset = "";

	private String ErrorMessage = "";// 发生错误时的模板信息

	private String TableString = "<table>\r\n";

	private int ChannelID;

	private String Site;

	// leener add 2007-03-01
	private Field field;
    
	private int SiteID;
	// end;

	public int getSiteID() {
		return SiteID;
	}

	public void setSiteID(int siteID) {
		SiteID = siteID;
	}

	// 无参构造器；
	public App() throws MessageException, SQLException {
		super();
	}

	// 带参数的构造器(id为channelID);
	public App(int id) throws MessageException, SQLException, IOException {

		String Sql = "select * from channel where Type=3 and id=" + id + "";

		setChannelID(id);
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setParent(Rs.getInt("Parent"));

			closeRs(Rs);

			Sql = "select * from channel_template where Channel=" + getId()
					+ " and TemplateType=5";
			//
			//System.out.println(Sql);
			//
			ResultSet rs = executeQuery(Sql);
			if (rs.next()) {
				setTemplate(convertNull(rs.getString("Template")));
				setTargetName(convertNull(rs.getString("TargetName")));
				setCharset(convertNull(rs.getString("Charset")));
				setRealCharset(Charset);
			}

			closeRs(rs);

			String Charset_ = CmsCache.getDefaultSite().getCharset();//getConfig().Charset;
			if (Charset.equals("")) {
				Charset = Charset_;
			}
			//System.out.println("gouzao="+Charset);
			//end;
		} else
			{closeRs(Rs);throw new MessageException("This App is not exist!");}
	}

	// leener add 2007-03-01;
	public Field getField() {
		return field;
	}

	public void setField(Field field) {
		this.field = field;
	}

	// end;

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

	/**
	 * @return Returns the parent.
	 */
	public int getParent() {
		return Parent;
	}

	/**
	 * @param parent
	 *            The parent to set.
	 */
	public void setParent(int parent) {
		Parent = parent;
	}

	/**
	 * @return Returns the templateFileName.
	 */
	public String getTemplate() {
		return Template;
	}

	/**
	 * @param templateFileName
	 *            The templateFileName to set.
	 */
	public void setTemplate(String templateFileName) {
		Template = templateFileName;
	}

	/**
	 * @return Returns the type.
	 */
	public int getType() {
		return Type;
	}

	/**
	 * @param type
	 *            The type to set.
	 */
	public void setType(int type) {
		Type = type;
	}

	/**
	 * @return Returns the targetName.
	 */
	public String getTargetName() {
		return TargetName;
	}

	/**
	 * @param targetName
	 *            The targetName to set.
	 */
	public void setTargetName(String targetName) {
		TargetName = targetName;
	}

	/**
	 * @return Returns the charset.
	 */
	public String getCharset() {
		return Charset;
	}

	/**
	 * @param charset
	 *            The charset to set.
	 */
	public void setCharset(String charset) {
		Charset = charset;
	}

	public String getTableString() {
		return TableString;
	}

	public void setTableString(String tableString) {
		TableString = tableString;
	}

	public int getChannelID() {
		return ChannelID;
	}

	public void setChannelID(int channelID) {
		ChannelID = channelID;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Add()
	 */
	// leener add;
	public void Add(int ChannelID) throws SQLException, MessageException {
		String Sql = "";
		setId(ChannelID);

		Sql = "update channel set OrderNumber=id where OrderNumber is null or OrderNumber=0";
		executeUpdate(Sql);

		ChannelTemplate ct = new ChannelTemplate();

		ct.setChannelID(ChannelID);
		ct.setTargetName(TargetName);
		ct.setCharset(Charset);
		ct.setTemplateType(5);

		ct.Add();
	}

	// end;

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {

	}
	
	public void DeleteTable(int id,String Table) throws SQLException, MessageException{
		String Sql = "delete from "+Table+" where id="+id;
		//System.out.println(Sql);
		executeUpdate(Sql);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";

		Sql = "update channel set ";

		Sql += "Name='" + SQLQuote(Name) + "'";

		Sql += " where id=" + id;

		executeUpdate(Sql);

		Sql = "update channel_template set ";

		Sql += "Template='" + SQLQuote(Template) + "'";
		Sql += ",TargetName='" + SQLQuote(TargetName) + "'";
		Sql += ",Charset='" + SQLQuote(Charset) + "'";

		Sql += " where Channel=" + id;

		executeUpdate(Sql);
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
	 * @return Returns the realCharset.
	 */
	public String getRealCharset() {
		return RealCharset;
	}

	/**
	 * @param realCharset
	 *            The realCharset to set.
	 */
	public void setRealCharset(String realCharset) {
		RealCharset = realCharset;
	}

	// leener add;
	public void GenerateFormFile(UserInfo user) throws MessageException,
			SQLException, IOException {
		//System.out.println(getTemplate()+":");
		if(getTemplate().equals("")) return;
		Channel channel=CmsCache.getChannel(id);
		Site site=CmsCache.getSite(channel.getSiteID());
		Site defaultSite = CmsCache.getDefaultSite();

		String TargetName = getTargetName();
		//System.out.println("TargetName="+TargetName);
		//System.out.println("siteforder="+site.getSiteFolder() + "/" + TargetName);
		
		if (TargetName.startsWith("/") || TargetName.startsWith("\\")) {
		} else {
			 channel = CmsCache.getChannel(getParent());
			TargetName = channel.getFullPath() + "/" + TargetName;
		}

		Properties Props = new Properties();
		Props.setProperty("file.resource.loader.path", defaultSite.getTemplateFolder());

		VelocityEngine ve = new VelocityEngine();
		try {
			ve.init(Props);
		} catch (Exception e1) {
			e1.printStackTrace();
		}

		VelocityContext context = new VelocityContext();
		try {
			String FolderOnly = TargetName.substring(0, TargetName
					.lastIndexOf("/") + 1);
			File file = new File(site.getSiteFolder() + "/" + FolderOnly);

			if (!file.exists())
				file.mkdirs();
			file = null;
//System.out.println("ChannelID="+ChannelID);
			App app = new App(ChannelID);

			context.put("app", app);

			Template template = null;
			//leener add
			String Charset_ = CmsCache.getDefaultSite().getCharset();//.getConfig().Charset;
			if (Charset.equals("")) {
				Charset = Charset_;
			}
			//end
			template = ve.getTemplate(getTemplate(), Charset);
		
			Writer writer = new OutputStreamWriter(new FileOutputStream(
					site.getSiteFolder() + "/" + TargetName), Charset);

			template.merge(context, writer);
			writer.flush();
			writer.close();
			//System.out.println("Generate Form File Success!");
		} catch (Exception e) {
			ErrorLog errorlog;
			try {
				errorlog = new ErrorLog();
				errorlog.setName("页面模板错误");
				errorlog.setMessage(e.getMessage());
				errorlog.setContent(StackToString(e));
				//errorlog.setWebSiteId(user.getSite());
				errorlog.Add();
			} catch (MessageException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			throw new MessageException("模板解析错误,目标页面没有生成!");
		}

	}

	public String StackToString(Exception e) {
		try {
			java.io.StringWriter sw = new java.io.StringWriter();
			java.io.PrintWriter pw = new java.io.PrintWriter(sw);
			e.printStackTrace(pw);
			return "" + sw.toString() + "";
		} catch (Exception e2) {
			return "bad stack2string";
		}
	}

	// leener add in 2007-03-01;
	public ArrayList getFieldValues() throws MessageException, SQLException {
		Channel channel = CmsCache.getChannel(ChannelID);
		Field field = new Field();

		ResultSetMetaData rsmd = channel.getColumn();
		ArrayList arraylist = channel.getFieldInfo();
		ArrayList FieldValues = new ArrayList();// 返回的数组；
		String Charset = "utf-8";
      
		int cols = rsmd.getColumnCount();
		System.out.println("cols="+cols);
		if (cols > 0) {
			for (int i = 1; i <= cols; i++) {
				System.out.println("FieldNamef");
				String FieldName = rsmd.getColumnName(i);
				System.out.println("FieldName="+FieldName);
				if (!FieldName.equalsIgnoreCase("id")) {
					Field fv = channel.getFieldByFieldName(FieldName);
					// leener add ;
					if (fv.getFieldType().equalsIgnoreCase("select")) {
						ArrayList fieldoptions = new ArrayList();
						if (fv != null)
							fieldoptions = fv.getFieldOptions();
						String select = "<select name=\"" + fv.getName()
								+ "\">";
						for (int j = 0; j < fieldoptions.size(); j++) {
							select += "<option>" + (String) fieldoptions.get(j)
									+ "</option>";
						}
						//fv.setSelect(select);
					}
					// end;
					System.out.println("fv="+fv.getName());
					FieldValues.add(fv);
				}
			}
		}
		return FieldValues;
	}

	// end;

	public String getFormHtml(int ChannelID) throws MessageException,
			SQLException {
		Channel channel = new Channel(ChannelID);
		Field field = new Field();

		ResultSetMetaData rsmd = channel.getColumn();
		ArrayList arraylist = channel.getFieldInfo();

		String Charset = "utf-8";

		int cols = rsmd.getColumnCount();
		if (cols > 0) {
			for (int i = 1; i <= cols; i++) {
				String FieldName = rsmd.getColumnName(i);
				Field fv = channel.getFieldByFieldName(FieldName);
				// 初始化变量；
				String Description = "";
				String FieldType = "";
				String table = "";
				// String FieldName="";
				// 初始化结束；
				int FieldLevel = 0;
				int IsHide = 0;
				if (fv != null) {
					Description = fv.getDescription();
					FieldType = fv.getFieldType();
					FieldLevel = fv.getFieldLevel();
					IsHide = fv.getIsHide();
				}
				if (FieldLevel != 0) {
					if (FieldType.equalsIgnoreCase("text")
							|| FieldType.equals("")) {
						TableString += "<tr>\r\n<td align=\"right\">"
								+ Description
								+ "：</td><td><input type=\"text\" size=\"53\" "
								+ "name=\"" + FieldName
								+ "\" class=\"textfield\"></td>\r\n</tr>";
					}

					else if (FieldType.equalsIgnoreCase("textarea")) {
						TableString += "<tr>\r\n<td align=\"right\">"
								+ Description
								+ "：</td><td><textarea cols=55 rows=6 "
								+ "class=\"textfield\" name=\"" + FieldName
								+ "\"></textarea></td>\r\n</tr>";
					}

					else if (FieldType.equalsIgnoreCase("select")) {
						ArrayList fieldoptions = new ArrayList();
						if (fv != null)
							fieldoptions = fv.getFieldOptions();

						TableString += "<tr>\r\n<td align=\"right\">"
								+ Description + "：</td><td><select name=\""
								+ FieldName + "\">";
						for (int j = 0; j < fieldoptions.size(); j++) {
							TableString += "<option>"
									+ (String) fieldoptions.get(j)
									+ "</option>";
						}
						TableString += "</select></td>\r\n</tr>";

					}

					else if (FieldType.equalsIgnoreCase("file")) {
						TableString += "<tr>\r\n<td align=\"right\">"
								+ Description
								+ "：</td><td><input type=\"text\" size=\"53\" "
								+ "name=\""
								+ FieldName
								+ "\" class=\"textfield\"><input type=\"button\" value=\"...\" class=\"textfield\"></td>\r\n</tr>";

					}

					else if (FieldType.equalsIgnoreCase("image")) {
						TableString += "<tr>\r\n<td align=\"right\">"
								+ Description
								+ "：</td><td><input type=\"text\" size=\"53\" "
								+ "name=\""
								+ FieldName
								+ "\" class=\"textfield\"><input type=\"button\" value=\"选择\" onClick=\"selectFile(\'"
								// );
								+ FieldName + "\');\"></td>\r\n</tr>";

					}

					else if (FieldType.equalsIgnoreCase("datetime")) {
						TableString += "<tr>\r\n<td align=\"right\">"
								+ Description
								+ "：</td><td><input type=\"text\" class=\"textfield\" size=\"21\" name=\""
								+ FieldName
								+ "\">"
								+ "<img src=\"../images/icon/26.png\" onclick=\"selectdate('"
								+ FieldName + "');\"></td>\r\n</tr>";

					}
				}
			}
		}
		TableString += "\r\n</table>";

		return TableString;
	}

	public String getFieldValue(String Table, int id, String FieldName)
			throws SQLException, MessageException {
		String Sql = "select " + FieldName + " from " + Table + " where id="
				+ id;
		String Value = "";
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			Value = convertNull(Rs.getString(FieldName));
		}

		return Value;
	}

	public void Add() throws SQLException, MessageException {
	}

	public String getFullTargetName() throws MessageException, SQLException {
		String targetname = getTargetName();
		if (targetname.startsWith("/") || targetname.startsWith("\\")) {
		} else {
			Channel channel = CmsCache.getChannel(getParent());
			targetname = channel.getFullPath() + "/" + targetname;
		}

		return targetname;
	}

	public String getErrorMessage() {
		return ErrorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		ErrorMessage = errorMessage;
	}

	public String getSite() {
		return Site;
	}

	public void setSite(String site) {
		Site = site;
	}
}
