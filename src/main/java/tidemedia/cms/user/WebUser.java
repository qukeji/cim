package tidemedia.cms.user;

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
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Field;

public class WebUser extends Table {

	private int id;

	private String Name;

	private String Username;

	private String Password;

	private String Email;

	private int ChannelID;

	private int Parent;

	private int Type;

	private String Site;

	private String Template = "";

	private String TargetName = "";

	private String Charset = "";

	private String RealCharset = "";

	private int MessageType = 0;

	public WebUser() throws MessageException, SQLException {
		super();
	}

	public WebUser(int id) throws MessageException, SQLException, IOException {
		String Sql = "select * from channel where Type=4 and id=" + id + "";

		setChannelID(id);
		ResultSet Rs = executeQuery(Sql);
		if (Rs.next()) {
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setParent(Rs.getInt("Parent"));
			//setSite(convertNull(Rs.getString("siteid")));

			closeRs(Rs);

			Sql = "select * from channel_template where Channel=" + getId()
					+ " and TemplateType=6";
			//
			// System.out.println(Sql);
			//
			ResultSet rs = executeQuery(Sql);
			if (rs.next()) {
				setTemplate(convertNull(rs.getString("Template")));
				setTargetName(convertNull(rs.getString("Template")));
				setCharset(convertNull(rs.getString("Charset")));
				setRealCharset(Charset);
			}

			closeRs(rs);

			String Charset_ = CmsCache.getDefaultSite().getCharset();
			if (Charset.equals("")) {
				Charset = Charset_;
			}
			// end;
		} else
			{closeRs(Rs);throw new MessageException("This page is not exist!");}
	}

	public void Add() throws SQLException, MessageException {

	}

	public boolean canAdd() {
		return false;
	}

	public boolean canDelete() {
		return false;
	}

	public boolean canUpdate() {
		return false;
	}

	public void Delete(int id) throws SQLException,
			tidemedia.cms.base.MessageException {
	}

	public void Delete(int id,String Table) throws SQLException,
			tidemedia.cms.base.MessageException {
		String Sql = "delete from "+Table+" where id="+id;
		executeUpdate(Sql);
	}

	public void Update() throws SQLException, MessageException {

	}

	public String getEmail() {
		return Email;
	}

	public void setEmail(String email) {
		Email = email;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return Name;
	}

	public void setName(String name) {
		Name = name;
	}

	public String getPassword() {
		return Password;
	}

	public void setPassword(String password) {
		Password = password;
	}

	public String getUsername() {
		return Username;
	}

	public void setUsername(String username) {
		Username = username;
	}

	public int getChannelID() {
		return ChannelID;
	}

	public void setChannelID(int channelID) {
		ChannelID = channelID;
	}

	public int getParent() {
		return Parent;
	}

	public void setParent(int parent) {
		Parent = parent;
	}

	public String getSite() {
		return Site;
	}

	public void setSite(String site) {
		Site = site;
	}

	public int getType() {
		return Type;
	}

	public void setType(int type) {
		Type = type;
	}

	public String getCharset() {
		return Charset;
	}

	public void setCharset(String charset) {
		Charset = charset;
	}

	public String getRealCharset() {
		return RealCharset;
	}

	public void setRealCharset(String realCharset) {
		RealCharset = realCharset;
	}

	public String getTargetName() {
		return TargetName;
	}

	public void setTargetName(String targetName) {
		TargetName = targetName;
	}

	public String getTemplate() {
		return Template;
	}

	public void setTemplate(String template) {
		Template = template;
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

	public void GenerateFormFile(UserInfo user) throws MessageException,
			SQLException, IOException {
		if (getTemplate().equals(""))
			return;

		String TargetName = getTargetName();

		if (TargetName.startsWith("/") || TargetName.startsWith("\\")) {
		} else {
			Channel channel = CmsCache.getChannel(getParent());
			TargetName = channel.getFullPath() + "/" + TargetName;
		}

		Properties Props = new Properties();
		Props.setProperty("file.resource.loader.path", CmsCache.getDefaultSite().getTemplateFolder());

		VelocityEngine ve = new VelocityEngine();
		try {
			ve.init(Props);
		} catch (Exception e1) {
			e1.printStackTrace();
		}

		String SiteFolder = "";
		VelocityContext context = new VelocityContext();
		try {
			String FolderOnly = TargetName.substring(0, TargetName
					.lastIndexOf("/") + 1);
			File file = new File(SiteFolder + "/" + FolderOnly);

			if (!file.exists())
				file.mkdirs();
			file = null;

			WebUser webuser = new WebUser(ChannelID);

			context.put("webuser", webuser);

			Template template = null;

			template = ve.getTemplate(getTemplate(), Charset);
			Writer writer = new OutputStreamWriter(new FileOutputStream(
					SiteFolder + "/" + TargetName), Charset);

			template.merge(context, writer);
			writer.flush();
			writer.close();
			System.out.println("Generate Form File Success!");
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

	public ArrayList getFieldValues() throws MessageException, SQLException {
		Channel channel = new Channel(ChannelID);
		Field field = new Field();

		ResultSetMetaData rsmd = channel.getColumn();
		ArrayList arraylist = channel.getFieldInfo();
		ArrayList FieldValues = new ArrayList();// 返回的数组；
		String Charset = "utf-8";

		int cols = rsmd.getColumnCount();
		if (cols > 0) {
			for (int i = 1; i <= cols; i++) {
				String FieldName = rsmd.getColumnName(i);
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
					FieldValues.add(fv);
				}
			}
		}
		return FieldValues;
	}

}
