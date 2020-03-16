/*
 * Created on 2005-9-26
 *
 */
package tidemedia.cms.system;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.ESUtil2019;
import tidemedia.cms.util.TideJson;
import tidemedia.cms.util.Util;

import java.io.Serializable;
import java.io.StringWriter;
import java.sql.ResultSet;
import java.sql.SQLException;


/**
 * @author Administrator
 *
 */
public class Parameter extends Table implements Serializable {

	private int		id;
	private String 	Name = "";
	private String 	Code = "";
	private String  Content = "";
	private String 	Comment = "";
	private String 	SystemContent = "";
	private int		IntValue = 0;
	private int		Type = 0;// 0用户参数 1系统参数
	private int		Type2 = 0;// 0 字符 1 布尔 2数字
	private int 	isTemplate = 0;//是否是模板
	private int		isJson = 0;//是否是json
	private int		actionuser = 0;
	private TideJson json = null;

	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public Parameter() throws MessageException, SQLException {
		super();
	}

	public Parameter(int id) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from parameter where id=" + id;
				
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setCode(convertNull(Rs.getString("Code")));
			setContent(convertNull(Rs.getString("Content")).trim());//去除前后空格和换行
			setSystemContent(convertNull(Rs.getString("SystemContent")));
			setType(Rs.getInt("Type"));
			setType2(Rs.getInt("Type2"));
			setIntValue(Rs.getInt("IntValue"));
			setIsTemplate(Rs.getInt("IsTemplate"));
			setIsJson(Rs.getInt("IsJson"));
			setComment(convertNull(Rs.getString("Comment")));
			
			if(isJson==1) json = new TideJson(Content);

			closeRs(Rs);
		}
		else
			{closeRs(Rs);}			
	}
	
	public Parameter(String code) throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "select * from parameter where Code='" + SQLQuote(code) + "'";
		//System.out.println(Sql);		
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setCode(convertNull(Rs.getString("Code")));
			setContent(convertNull(Rs.getString("Content")).trim());//去除前后空格和换行
			setSystemContent(convertNull(Rs.getString("SystemContent")));
			setType(Rs.getInt("Type"));
			setType2(Rs.getInt("Type2"));
			setIntValue(Rs.getInt("IntValue"));
			setIsTemplate(Rs.getInt("IsTemplate"));
			setIsJson(Rs.getInt("IsJson"));
			setComment(convertNull(Rs.getString("Comment")));
			
			if(isJson==1) json = new TideJson(Content);
			
			closeRs(Rs);
		}
		else
			{closeRs(Rs);}			
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		if(Code.equals(""))
			throw new MessageException("代码不能为空.");
		
		Sql = "select * from parameter where Code='" + SQLQuote(Code) + "'";
		if(isExist(Sql))
		{
			throw new MessageException("此代码已经存在!",2);
		}
		
		Sql = "insert into parameter (";
		
		Sql += "Name,Code,Content,Comment,SystemContent,CreateDate,Type,Type2,IntValue,IsJson,IsTemplate";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(Code) + "'";
		Sql += ",'" + SQLQuote(Content) + "'";
		Sql += ",'" + SQLQuote(Comment) + "'";
		Sql += ",'" + SQLQuote(SystemContent) + "'";
		Sql += ",now()," + Type + "," + Type2 + "," + IntValue;
		Sql += "," + isJson;
		Sql += "," + isTemplate;
		
		Sql += ")";
		
		int insertid = executeUpdate_InsertID(Sql);	
		new Log().ParameterLog(LogAction.parameter_add, Name, insertid, actionuser);
		setId(insertid);

		if(Code.equals("ES_Config")){//初始化ES
			ESUtil2019 es = ESUtil2019.getInstance();
			es.newClient();
		}
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		String Sql = "";

		Sql = "select * from parameter where Type=1 and id=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("系统参数，不能删除!", MessageException.ALERT_HISTORY_BACK);
		}
		Sql = "select * from parameter where  id=" + id;
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			Name = convertNull(Rs.getString("Name"));
		}
		closeRs(Rs);
		Sql = "delete from parameter where id=" + id;
		executeUpdate(Sql);
		new Log().ParameterLog(LogAction.parameter_delete, Name, id, actionuser);
		if(Code.equals("ES_Config")){//初始化ES
			ESUtil2019 es = ESUtil2019.getInstance();
			es.newClient();
		}
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";
		
		/*
		Sql = "select * from parameter where Code='" + SQLQuote(Code) + "' and id!=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("代码已经被使用!",4);
		}*/
		
		Sql = "update parameter set ";
		
		//Sql += "Code='" + SQLQuote(Code) + "'";
		Sql += "Content='" + SQLQuote(Content) + "'";
		Sql += ",Comment='" + SQLQuote(Comment) + "'";
		Sql += ",IntValue=" + IntValue;
		Sql += ",IsJson=" + isJson;
		Sql += ",IsTemplate=" + isTemplate;
		Sql += ",Name='" + SQLQuote(Name) + "'";
		
		Sql += " where id="+id;
		
		//System.out.println(Sql);
		executeUpdate(Sql);
		new Log().ParameterLog(LogAction.parameter_edit, Name, id, actionuser);
		CmsCache.delParameter(Code);
		
		if(Code.equals("ES_Config")){//初始化ES
			ESUtil2019 es = ESUtil2019.getInstance();
			es.newClient();
		}
	}

	public void UpdateSystemContent() throws SQLException, MessageException {
		String Sql = "";
		
		Sql = "update parameter set ";
		Sql += "IsTemplate=" + isTemplate;		
		Sql += ",SystemContent='" + SQLQuote(SystemContent) + "'";
		
		Sql += " where id="+id;
		
		executeUpdate(Sql);	
		
		CmsCache.delParameter(Code);

		if(Code.equals("ES_Config")){//初始化ES
			ESUtil2019 es = ESUtil2019.getInstance();
			es.newClient();
		}
	}
	
	public static String getParameterValue(String code, UserInfo user) throws MessageException, SQLException
	{
		Parameter p = CmsCache.getParameter(code);
		if(p.getIsTemplate()==0)
			return p.getContent();
		else
		{
			StringWriter w = new StringWriter();
	        try {
	        	//System.out.println("execute:"+api.getTemplate());
		    		Velocity.init();
		    		VelocityContext context = new VelocityContext();
		    		context.put("util", new Util());
		    		context.put("user", user);		    		
					Velocity.evaluate(context, w, "mystring", p.getContent());
			} catch (Exception e) {
				ErrorLog.SaveErrorLog("参数模板错误.","参数code:,"+code+","+e.getMessage(),0,e);
			}
			
			return w+"";
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
	 * @return Returns the name.
	 */
	public String getName() {
		return Name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		Name = name;
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

	public void setType(int type) {
		Type = type;
	}

	public int getType() {
		return Type;
	}

	public void setCode(String code) {
		Code = code;
	}

	public String getCode() {
		return Code;
	}

	public void setContent(String content) {
		Content = content;
	}

	public String getContent() {
		return Content;
	}

	public void setSystemContent(String systemContent) {
		SystemContent = systemContent;
	}

	public String getSystemContent() {
		return SystemContent;
	}

	public void setType2(int type2) {
		Type2 = type2;
	}

	public int getType2() {
		return Type2;
	}

	public void setIntValue(int intValue) {
		IntValue = intValue;
	}

	public int getIntValue() {
		return IntValue;
	}

	public void setIsTemplate(int isTemplate) {
		this.isTemplate = isTemplate;
	}

	public int getIsTemplate() {
		return isTemplate;
	}

	public String getComment() {
		return Comment;
	}

	public void setComment(String comment) {
		Comment = comment;
	}

	public TideJson getJson() {
		return json;
	}

	public void setJson(TideJson json) {
		this.json = json;
	}

	public int getIsJson() {
		return isJson;
	}

	public void setIsJson(int isJson) {
		this.isJson = isJson;
	}


	public int getActionuser() {
		return actionuser;
	}

	public void setActionuser(int actionuser) {
		this.actionuser = actionuser;
	}
	
}
