/*
 * Created on 2004-8-17
 *
 */
package tidemedia.cms.system;

import java.io.*;
import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.exception.MethodInvocationException;
import org.apache.velocity.exception.ParseErrorException;
import org.apache.velocity.exception.ResourceNotFoundException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.publish.Publish;
import tidemedia.cms.util.Util;

/**
 * @author 李永海(yonghai2008@gmail.com)
 *
 */
public class ChannelTemplate extends Table implements Serializable {
	
	public static final int ListTemplateType = 1;//索引页面模板
	public static final int ContentTemplateType = 2;//内容页面模板
	public static final int ExtraTemplateType = 3;//附加模板
	public static final int AppTemplateType = 5;//应用页面模板
	public static final int RegisterTemplateType = 6;//注册页面模板
	
	private int			id;
	private int			templateID = 0;//模板编号
	private String		TemplateRootPath = "";
	private int			ChannelID;
	private int			TemplateType;
	//TemplateType=1索引页面模板 
	//TemplateType=2内容页面模板 
	//TemplateType=3附加页面模板 
	//TemplateType=4页面框架模板
	private String		TargetName = "";
	//private String		RootPath = "";
	private String		FolderName = "";
	private String		Charset = "";
	private String 		WhereSql = "";//查询条件，适用于索引页模板和内容页模板
	private String 		Label = "";//标签，用于区别多个同类型模板
	private int			rowsPerPage;
	//每页纪录个数
	private int			Rows;
	//列表行数，对列表模板有效
	private int			TitleWord;
	//限制标题字数，对列表模板有效
	private String		Href = "";//链接
	private int			SubFolderType = 0;
	//0	默认，没有子目录
	//1	按年份命名，每年一个目录。如：/2004/
	//2	按年月命名，每月一个目录。如/2004/06/
	//3	按年月日命名，每日一个目录。如/2004/06/07/
	//4	按每天一个目录。如/2004-06-07/
//	private int			Category = 0;//对应分类

	private int			IsInherit = 0;//是否继承上级模板 0 不继承 1 继承
	private int			Parent	= 0;//不为0代表继承
	private int			IncludeChildChannel = 0;//是否包含子频道内容，针对索引页模板
	private int			LinkTemplate = 0;//继承时关联的模板编号

	private String		IndexFileExt = "";//索引模板对应文件的扩展名
	private String		IndexFilePrefix = "";//索引模板对应文件的名称前缀
	
	private String		ItemFileExt = "";//内容模板对应文件的扩展名
	private String		ItemFilePrefix = "";//内容模板对应文件的名称前缀
	private String		FolderOnly = "";//内容页模板对应生成文件的路径,不包括文件名
	private	boolean		IsAbsolutePath = false;//内容页模板对应生成文件是否是绝对路径
	private int			FileNameType;// 0 默认
	private String		FileNameField = "";//指定字段用来做文件名
	private int			Active;//是否允许发布 1允许 0禁止
	private int			PublishInterval = 0;//发布间隔
	private int			AllowPreview = 0;//是否允许预览，针对内容页模板
	
	public ChannelTemplate() throws MessageException, SQLException {
		super();
	}

	public ChannelTemplate(int id) throws SQLException, MessageException
	{
		String Sql = "select * from channel_template where id="+id ;
			
		ResultSet Rs = executeQuery(Sql);
		//System.out.println(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setTemplateID(Rs.getInt("TemplateID"));
			setChannelID(Rs.getInt("Channel"));
			setLinkTemplate(Rs.getInt("LinkTemplate"));
			//setTemplate(convertNull(Rs.getString("Template")));
			setLabel(convertNull(Rs.getString("Lable")));
			setTargetName(convertNull(Rs.getString("TargetName")));
			setCharset(convertNull(Rs.getString("Charset")));
			setWhereSql(convertNull(Rs.getString("WhereSql")));
			setHref(convertNull(Rs.getString("Href")));
			
			TableUtil tu = new TableUtil();
			String sql = "select FolderName from channel where id=" + getChannelID();
			ResultSet rs = tu.executeQuery(sql);
			if(rs.next())
				setFolderName(convertNull(rs.getString("FolderName")));
			tu.closeRs(rs);
			
			setTemplateType(Rs.getInt("TemplateType"));
			setRowsPerPage(Rs.getInt("RowsPerPage"));
			setSubFolderType(Rs.getInt("SubFolderType"));
			//setCategory(Rs.getInt("channel_template.Category"));
			setRows(Rs.getInt("RowsNumber"));
			setTitleWord(Rs.getInt("TitleWord"));
			setIsInherit(Rs.getInt("IsInherit"));
			setActive(Rs.getInt("Active"));
			setParent(Rs.getInt("Parent"));
			setIncludeChildChannel(Rs.getInt("IncludeChildChannel"));
			setFileNameType(Rs.getInt("FileNameType"));
			setPublishInterval(Rs.getInt("PublishInterval"));
			setFileNameField(convertNull(Rs.getString("FileNameField")));
			setAllowPreview(Rs.getInt("AllowPreview"));

			if(TemplateType==1)
			{
				int index = TargetName.lastIndexOf(".");
				String tempFileName = "";
				String itemFileExt = "";
				if(index!=-1)
					tempFileName = TargetName.substring(0,index);
				int index2 = tempFileName.lastIndexOf("/");
				if(index2!=-1)
					tempFileName = tempFileName.substring(index2+1);
				
				if(index!=-1)
					itemFileExt = TargetName.substring(index+1);

				if(index2!=-1)
					setFolderOnly(TargetName.substring(0,index2+1));
				
				if(TargetName.startsWith("/") || TargetName.startsWith("\\"))
					setAbsolutePath(true);
				
				setIndexFileExt(itemFileExt);
				setIndexFilePrefix(tempFileName);
				//System.out.print("id:"+getId()+",tempFileName:"+tempFileName);
			}
			
			if(TemplateType==2)
			{
				int index = TargetName.lastIndexOf(".");
				String tempFileName = "";
				String itemFileExt = "";
				if(index!=-1)
					tempFileName = TargetName.substring(0,index);
				int index2 = tempFileName.lastIndexOf("/");
				if(index2!=-1)
					tempFileName = tempFileName.substring(index2+1);
				
				if(index!=-1)
					itemFileExt = TargetName.substring(index+1);

				if(index2!=-1)
					setFolderOnly(TargetName.substring(0,index2+1));
				
				if(TargetName.startsWith("/") || TargetName.startsWith("\\"))
					setAbsolutePath(true);
				
				setItemFileExt(itemFileExt);
				setItemFilePrefix(tempFileName);
			}
			
			closeRs(Rs);
		}
		else
			{closeRs(Rs);}//throw new MessageException("This template is not exist!");}	
	}
	
	public void Add() throws SQLException, MessageException {
		//print("templateid:"+templateID);
		if(templateID<=0) return;
		
		String Sql = "insert into channel_template (";
		
		Sql += "Channel,LinkTemplate,TemplateID,TargetName,Lable,TemplateType,Charset,WhereSql,RowsPerPage,SubFolderType,";
		Sql += "FileNameType,FileNameField,Category,RowsNumber,TitleWord,Href,PublishInterval,IncludeChildChannel,AllowPreview,IsInherit,Active";
		Sql += ") values(";
		Sql += "" + ChannelID + "";
		Sql += "," + LinkTemplate + "";
		Sql += "," + templateID + "";
		Sql += ",'" + SQLQuote(TargetName.trim()) + "'";
		Sql += ",'" + SQLQuote(Label) + "'";
		Sql += "," + TemplateType + "";
		Sql += ",'" + SQLQuote(Charset) + "'";
		Sql += ",'" + SQLQuote(WhereSql) + "'";
		Sql += "," + rowsPerPage + "";
		Sql += "," + SubFolderType + "";
		Sql += "," + FileNameType + "";
		Sql += ",'" + SQLQuote(FileNameField) + "'";
		Sql += "," + 0 + "";
		Sql += "," + Rows + "";
		Sql += "," + TitleWord + "";
		Sql += ",'" + SQLQuote(Href) + "'";
		Sql += "," + PublishInterval + "";
		Sql += "," + IncludeChildChannel + "";
		Sql += "," + AllowPreview + "";
		Sql += "," + IsInherit + "";
		Sql += "," + 1 + "";
		Sql += "";
		
		Sql += ")";

		//print(Sql);
		int insertid = executeUpdate_InsertID(Sql);
		
		setId(insertid);
		
		//刷新Cache
		ChannelUtil.initChannelTemplates(CmsCache.getChannel(ChannelID));
		CmsCache.delChannel(ChannelID);

		if(TemplateType==1 || TemplateType==2)
			updateChildChannelTemplate(ChannelID,insertid);
		
		if(TemplateType==ChannelTemplate.ExtraTemplateType)
		{
			Publish publish = new Publish();
			try {
				publish.init();
				publish.publishChannelTemplate(insertid);
			} catch (ResourceNotFoundException e) {
				e.printStackTrace();
			} catch (ParseErrorException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public void Delete(int id) throws SQLException, MessageException {

		ChannelTemplate ct = new ChannelTemplate(id);
		
		String Sql = "";
		
		Sql = "delete from channel_template where id=" + id;		
		executeUpdate(Sql);
		
		//刷新Cache
		ChannelUtil.initChannelTemplates(CmsCache.getChannel(ChannelID));
		CmsCache.delChannel(ChannelID);
		
		if(ct.getTemplateType()==ChannelTemplate.ListTemplateType || ct.getTemplateType()==ChannelTemplate.ContentTemplateType)
		{
			deleteChildChannelTemplate(ct.getChannelID(),id);
		}
		
		//刷新Cache
		ChannelUtil.initChannelTemplates(CmsCache.getChannel(ChannelID));
		CmsCache.delChannel(ChannelID);
	}

	public void Update() throws SQLException, MessageException {
		if(templateID<=0) return;
		
		String Sql = "";
		
		Sql = "update channel_template set ";
		
		Sql += "TemplateID=" + templateID + "";
		Sql += ",TargetName='" + SQLQuote(TargetName.trim()) + "'";
		Sql += ",Lable='" + SQLQuote(Label) + "'";
		Sql += ",Charset='" + SQLQuote(Charset) + "'";
		Sql += ",WhereSql='" + SQLQuote(WhereSql) + "'";
		Sql += ",RowsPerPage=" + rowsPerPage + "";
		Sql += ",SubFolderType=" + SubFolderType + "";
		Sql += ",FileNameType=" + FileNameType + "";
		Sql += ",FileNameField='" + SQLQuote(FileNameField) + "'";
		Sql += ",RowsNumber=" + Rows + "";
		Sql += ",LinkTemplate=" + LinkTemplate;
		Sql += ",TitleWord=" + TitleWord + "";
		Sql += ",Href='" + SQLQuote(Href) + "'";
		Sql += ",PublishInterval=" + PublishInterval + "";
		Sql += ",IncludeChildChannel=" + IncludeChildChannel + "";
		Sql += ",AllowPreview=" + AllowPreview + "";
		Sql += ",Parent=0";
		
		Sql += " where id="+id;
		//print(Sql);
		executeUpdate(Sql);

		//刷新Cache
		ChannelUtil.initChannelTemplates(CmsCache.getChannel(ChannelID));
		CmsCache.delChannel(ChannelID);
		
		if(TemplateType==1 || TemplateType==2)
			updateChildChannelTemplate(ChannelID,getId());
		
		if(TemplateType==ChannelTemplate.ExtraTemplateType)
		{
			Publish publish = new Publish();
			try {
				publish.init();
				publish.publishChannelTemplate(id);
			} catch (ResourceNotFoundException e) {
				e.printStackTrace();
			} catch (ParseErrorException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public ChannelTemplateBean getBean()
	{
		ChannelTemplateBean cb = new ChannelTemplateBean();
		cb.setBean(this);
		
		return cb;
	}
	
	public void InheritTemplate() throws SQLException, MessageException 
	{
		InheritTemplate(ChannelID,0);
	}
	
	public boolean canAdd() {

		return false;
	}

	public boolean canUpdate() {

		return false;
	}

	public boolean canDelete() {

		return false;
	}

	public int getChannelID() {
		return ChannelID;
	}

	public int getId() {
		return id;
	}

	public String getTargetName() {
		return TargetName;
	}


	public void setChannelID(int i) {
		ChannelID = i;
	}

	public void setId(int i) {
		id = i;
	}

	public void setTargetName(String string) {
		TargetName = string;
	}

/*	public String getRootPath() {
		return RootPath;
	}

	public void setRootPath(String string) {
		RootPath = string;
	}*/

	public void generateJSPFile(String path,String target) throws MessageException
	{
		File file1 = new File(path);
		if(!file1.exists())
			file1.mkdirs();
		
		path = path + "/" + target;
		File file = new File(path);
		OutputStream fileout = null;
		try {
			fileout = new FileOutputStream(file);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
			throw new MessageException("The file is not exist!");
		} 	
		Properties Props = new Properties();
		VelocityEngine ve = new VelocityEngine();
		try {
			URL classpath=	getClass().getClassLoader().getResource("/");
			//System.out.println("path:"+classpath.getPath()+":"+classpath.getFile());
			Props.setProperty("file.resource.loader.path", classpath.getPath());
			ve.init(Props);
		} catch (Exception e2) {
			e2.printStackTrace();
		}
		VelocityContext context = new VelocityContext();
		//context.put( "templateName", TemplateRootPath+"/"+Template);
		context.put("ChannelID",ChannelID+"");
		
		Template template = null;
		try {
			template = ve.getTemplate("JSPTemplate.vm");
		} catch (ResourceNotFoundException e1) {
			e1.printStackTrace();
		} catch (ParseErrorException e1) {
			e1.printStackTrace();
		} catch (Exception e1) {
			e1.printStackTrace();
		}

		Writer writer = new BufferedWriter(new OutputStreamWriter(fileout));
       
		try {
			template.merge(context, writer);
		} catch (ResourceNotFoundException e3) {
			e3.printStackTrace();
		} catch (ParseErrorException e3) {
			e3.printStackTrace();
		} catch (MethodInvocationException e3) {
			e3.printStackTrace();
		} catch (Exception e3) {
			e3.printStackTrace();
		}

		try {
			writer.flush();
			writer.close();
		} catch (IOException e5) {
			e5.printStackTrace();
		}
	}
	public String getTemplateRootPath() {
		return TemplateRootPath;
	}

	public void setTemplateRootPath(String string) {
		TemplateRootPath = string;
	}

	/**
	 * @return Returns the folderName.
	 */
	public String getFolderName() {
		return FolderName;
	}
	/**
	 * @param folderName The folderName to set.
	 */
	public void setFolderName(String folderName) {
		FolderName = folderName;
	}
	/**
	 * @return Returns the templateType.
	 */
	public int getTemplateType() {
		return TemplateType;
	}
	/**
	 * @param templateType The templateType to set.
	 */
	public void setTemplateType(int templateType) {
		TemplateType = templateType;
	}
	public int getRowsPerPage() {
		return rowsPerPage;
	}

	public void setRowsPerPage(int i) {
		rowsPerPage = i;
	}

	/**
	 * @return Returns the charset.
	 */
	public String getCharset() {
		return Charset;
	}
	/**
	 * @param charset The charset to set.
	 */
	public void setCharset(String charset) {
		Charset = charset;
	}
	/**
	 * @return Returns the subFolderType.
	 */
	public int getSubFolderType() {
		return SubFolderType;
	}
	/**
	 * @param subFolderType The subFolderType to set.
	 */
	public void setSubFolderType(int subFolderType) {
		SubFolderType = subFolderType;
	}
	
	public boolean isExist(int id) throws SQLException, MessageException
	{
		String Sql = "select * from channel_template where id=" + id;
		
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			closeRs(Rs);
			return true;
		}
		
		return false;
	}

	public int getThisTemplateID() throws SQLException, MessageException
	{
		String Sql = "select * from channel_template where TemplateType=" + TemplateType 
		+ " and Channel=" + ChannelID + " and TargetName='" + SQLQuote(TargetName) + "'"; 
		
		//System.out.println(Sql);
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			int templateid = Rs.getInt("id");
			closeRs(Rs);
			return templateid;
		}
		
		return 0;
	}	
	/**
	 * @return Returns the rows.
	 */
	public int getRows() {
		return Rows;
	}
	/**
	 * @param rows The rows to set.
	 */
	public void setRows(int rows) {
		Rows = rows;
	}
	
	public void updateTargetName() throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "update channel_template set ";
		
		Sql += "TargetName='" + SQLQuote(TargetName) + "'";
		
		Sql += " where id="+id;
		
		executeUpdate(Sql);
	}
	
	public void updateChannel() throws SQLException, MessageException
	{
		String Sql = "";
		
		Sql = "update channel_template set ";
		
		Sql += "Channel=" + (ChannelID) + "";
		
		Sql += " where id="+id;
		
		executeUpdate(Sql);
	} 
	/**
	 * @return Returns the isInherit.
	 */
	public int getIsInherit() {
		return IsInherit;
	}
	/**
	 * @param isInherit The isInherit to set.
	 */
	public void setIsInherit(int isInherit) {
		IsInherit = isInherit;
	}
		
	/**
	 * @return Returns the titleWord.
	 */
	public int getTitleWord() {
		return TitleWord;
	}
	/**
	 * @param titleWord The titleWord to set.
	 */
	public void setTitleWord(int titleWord) {
		TitleWord = titleWord;
	}
	
	//获取生成文件的完整路径
	public String getFullTargetName() throws MessageException, SQLException
	{
		return Util.ClearPath((TargetName.startsWith("/")?"/":CmsCache.getChannel(ChannelID).getFullPath()+"/")+TargetName);
	}

	public String getWhereSql() {
		return WhereSql;
	}

	public void setWhereSql(String whereSql) {
		WhereSql = whereSql;
	}

	public int getLinkTemplate() {
		return LinkTemplate;
	}

	public void setLinkTemplate(int linkTemplate) {
		LinkTemplate = linkTemplate;
	}

	public String getLabel() {
		return Label;
	}

	public void setLabel(String lable) {
		Label = lable;
	}

	public String getItemFileExt() {
		return ItemFileExt;
	}

	public void setItemFileExt(String itemFileExt) {
		ItemFileExt = itemFileExt;
	}

	public String getItemFilePrefix() {
		return ItemFilePrefix;
	}

	public void setItemFilePrefix(String itemFilePrefix) {
		ItemFilePrefix = itemFilePrefix;
	}

	public String getFolderOnly() {
		return FolderOnly;
	}

	public void setFolderOnly(String folderOnly) {
		FolderOnly = folderOnly;
	}

	public boolean isAbsolutePath() {
		return IsAbsolutePath;
	}

	public void setAbsolutePath(boolean isAbsolutePath) {
		IsAbsolutePath = isAbsolutePath;
	}

	public String getIndexFileExt() {
		return IndexFileExt;
	}

	public void setIndexFileExt(String indexFileExt) {
		IndexFileExt = indexFileExt;
	}

	public String getIndexFilePrefix() {
		return IndexFilePrefix;
	}

	public void setIndexFilePrefix(String indexFilePrefix) {
		IndexFilePrefix = indexFilePrefix;
	}
	
	public int getIncludeChildChannel() {
		return IncludeChildChannel;
	}

	public void setIncludeChildChannel(int includeChildChannel) {
		IncludeChildChannel = includeChildChannel;
	}

	public void setTemplateID(int templateID) {
		this.templateID = templateID;
	}

	public int getTemplateID() {
		return templateID;
	}
	
	public TemplateFile getTemplateFile() throws SQLException, MessageException
	{
		if(getTemplateID()>0)
			return CmsCache.getTemplate(getTemplateID());//new TemplateFile(getTemplateID());
		else
			return new TemplateFile();
	}

	public int getFileNameType() {
		return FileNameType;
	}

	public void setFileNameType(int fileNameType) {
		FileNameType = fileNameType;
	}
	
	public boolean existTemplate(int channelid,String Target,int type,int templateid) throws SQLException, MessageException
	{
		boolean exist = false;
		String Sql = "select * from channel_template where Channel=" + channelid + " ";
		Sql += " and TargetName='" + SQLQuote(Target) + "' and TemplateType=" + type;
		
		if(templateid>0)
			Sql += " and TemplateID="+templateid;
		
		//System.out.println(Sql);
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			exist = true;
		}
		
		closeRs(Rs);
		
		return exist;
	}

	public void setParent(int parent) {
		Parent = parent;
	}

	public int getParent() {
		return Parent;
	}
	
	public void updateChildChannelTemplate(int channelid,int templateid) throws MessageException, SQLException
	{
		ArrayList<Integer> chs = CmsCache.getChannel(channelid).getAllChildChannelIDs();
		if(chs!=null && chs.size()>0)
		{
			for(int i = 0;i<chs.size();i++)
			{
				Integer in = (Integer)chs.get(i);
				int m = in.intValue();
				Channel ch = CmsCache.getChannel(m);
				if(ch.getType()==Channel.Channel_Type||ch.getType()==Channel.Category_Type)
				{
					InheritTemplate(ch.getId(),templateid);
					
					int newtemplateid = 0;
					
					TableUtil tu = new TableUtil();
					String Sql = "select * from channel_template where Channel=" + ch.getId() + " and Parent=" + templateid;
					
					ResultSet Rs = tu.executeQuery(Sql);
					if(Rs.next())
					{
						newtemplateid = Rs.getInt("id");
					}
					
					tu.closeRs(Rs);
					
					if(newtemplateid>0)
						updateChildChannelTemplate(ch.getId(),newtemplateid);
				}
			}
		}
	}
	
	public void InheritTemplate(int channelid,int templateid) throws SQLException, MessageException {
		String Sql = "";
		TableUtil tu = new TableUtil();

		Channel channel = CmsCache.getChannel(channelid);
		Channel pchannel = CmsCache.getChannel(channel.getParent());
		if(pchannel==null)
			return;
		
		ArrayList<ChannelTemplate> cts = pchannel.getChannelTemplates();

		//System.out.println("pchannel templates:"+cts.size());
		if(cts!=null && cts.size()>0)
		{
			for(int i = 0;i<cts.size();i++)
			{
				ChannelTemplate ct = (ChannelTemplate)cts.get(i);
				//System.out.println("ct id:"+ct.getId()+","+ct.getTemplateType()+","+ct.getTargetName());
				if(ct.getTemplateType()==1 || ct.getTemplateType()==2)
				{
					if(templateid>0)//指定模板
					{
						if(ct.getId()!=templateid)
							continue;
					}
					
					if(templateID>0)//指定继承模板(模板配置中的继承模板选项)
					{
						if(ct.getTemplateID()!=templateID)
							continue;
					}

					//System.out.println("templateid:"+templateid+","+ct.getId());
					
					boolean exist = false;
				
					Sql = "select * from channel_template where Channel=" +channelid + " and Parent=" + ct.getId();
					
					//System.out.println(Sql);
					ResultSet Rs = tu.executeQuery(Sql);
					if(Rs.next())
					{
						exist = true;
					}
					
					tu.closeRs(Rs);
					
					if(exist)
					{
						Sql = "update channel_template set ";

						Sql += "TemplateID=" + ct.getTemplateID();
						Sql += ",Charset='" + SQLQuote(ct.getCharset()) + "'";
						Sql += ",RowsPerPage=" + ct.getRowsPerPage() + "";
						Sql += ",SubFolderType=" + ct.getSubFolderType() + "";
						Sql += ",FileNameType=" + ct.getFileNameType() + "";
						Sql += ",FileNameField='" + SQLQuote(ct.getFileNameField()) + "'";
						Sql += ",RowsNumber=" + ct.getRows() + "";
						Sql += ",WhereSql='" + SQLQuote(ct.getWhereSql()) + "'";
						Sql += ",Lable='" + ct.getLabel() + "'";
						Sql += ",TitleWord=" + ct.getTitleWord() + "";
						Sql += ",PublishInterval=" + ct.getPublishInterval() + "";
						Sql += ",TargetName='" + SQLQuote(ct.getTargetName()) + "'";
						Sql += ",AllowPreview=" + ct.getAllowPreview() + "";
						Sql += ",Active=" + ct.getActive() + "";

						Sql += " where Channel=" + channelid + " and Parent=" + ct.getId();
				
						//System.out.println(Sql);
						tu.executeUpdate(Sql);	
					}
					else
					{
						if(channel.getTemplateInherit()==1)//允许继承频道
						{
						//要考虑到模板目标文件名一样的情况
						if(existTemplate(channelid,ct.getTargetName(),ct.getTemplateType(),ct.getTemplateID()))
						{
							Sql = "update channel_template set ";

							Sql += "TemplateID=" + ct.getTemplateID();
							Sql += ",Charset='" + SQLQuote(ct.getCharset()) + "'";
							Sql += ",RowsPerPage=" + ct.getRowsPerPage() + "";
							Sql += ",SubFolderType=" + ct.getSubFolderType() + "";
							Sql += ",FileNameType=" + ct.getFileNameType() + "";
							Sql += ",FileNameField='" + SQLQuote(ct.getFileNameField()) + "'";
							Sql += ",RowsNumber=" + ct.getRows() + "";
							Sql += ",WhereSql='" + SQLQuote(ct.getWhereSql()) + "'";
							Sql += ",Lable='" + ct.getLabel() + "'";
							Sql += ",TitleWord=" + ct.getTitleWord() + "";
							Sql += ",PublishInterval=" + ct.getPublishInterval() + "";
							//Sql += ",Template='" + SQLQuote(ct.getTemplate()) + "'";
							//Sql += ",TargetName='" + SQLQuote(ct.getTargetName()) + "'";
							Sql += ",AllowPreview=" + ct.getAllowPreview() + "";
							Sql += ",Active=" + ct.getActive() + "";
							Sql += ",Parent=" + ct.getId() + "";

							Sql += " where Channel=" + channelid + " and TargetName='" + SQLQuote(ct.getTargetName()) + "' and TemplateType=" + ct.getTemplateType();
					
							//System.out.println(Sql);
							tu.executeUpdate(Sql);								
						}
						else
						{
						Sql = "insert into channel_template (";
						Sql += "Channel,TemplateID,TargetName,TemplateType,Charset,RowsPerPage,SubFolderType,PublishInterval,";
						Sql += "FileNameType,FileNameField,RowsNumber,WhereSql,Lable,TitleWord,AllowPreview,Active,Parent";
						Sql += ") values(";
						Sql += "" + channelid + "";
						Sql += "," + ct.getTemplateID() + "";
						Sql += ",'" + SQLQuote(ct.getTargetName()) + "'";
						Sql += "," + ct.getTemplateType() + "";
						Sql += ",'" + SQLQuote(ct.getCharset()) + "'";
						Sql += "," + ct.getRowsPerPage() + "";
						Sql += "," + ct.getSubFolderType() + "";
						Sql += "," + ct.getPublishInterval() + "";
						Sql += "," + ct.getFileNameType() + "";
						Sql += ",'" + SQLQuote(ct.getFileNameField()) + "'";
						Sql += "," + ct.getRows() + "";
						Sql += ",'" + SQLQuote(ct.getWhereSql()) + "'";
						Sql += ",'" + ct.getLabel() + "'";
						Sql += "," + ct.getTitleWord() + "";
						Sql += "," + ct.getAllowPreview() + "";
						Sql += ","+ ct.getActive() + "";
						Sql += "," + ct.getId() + "";
						Sql += "";
			
						Sql += ")";
				
						//System.out.println(Sql);
						tu.executeUpdate(Sql);
						}
						}
					}
				}
			}
		}

		ChannelUtil.initChannelTemplates(channel);
		CmsCache.delChannel(channelid);
		
		//if (TemplateType == 1 || TemplateType == 2)
		//	updateChildChannelTemplate(ChannelID);
	}	
	
	public void deleteChildChannelTemplate(int channelid,int templateid) throws MessageException, SQLException
	{
		ArrayList<Integer> chs = CmsCache.getChannel(channelid).getAllChildChannelIDs();
		if(chs!=null && chs.size()>0)
		{
			for(int i = 0;i<chs.size();i++)
			{
				Integer in = (Integer)chs.get(i);
				int m = in.intValue();
				Channel ch = CmsCache.getChannel(m);
				if(ch.getType()==Channel.Channel_Type||ch.getType()==Channel.Category_Type)
				{					
					int newtemplateid = 0;
					
					TableUtil tu = new TableUtil();
					String Sql = "select * from channel_template where Channel=" + ch.getId() + " and Parent=" + templateid;
					
					//print(Sql);
					
					ResultSet Rs = tu.executeQuery(Sql);
					if(Rs.next())
					{
						newtemplateid = Rs.getInt("id");
					}
					
					closeRs(Rs);
					
					if(newtemplateid>0)
					{
						Sql = "delete from channel_template where id=" + newtemplateid;
						tu.executeUpdate(Sql);
						
						ChannelUtil.initChannelTemplates(ch);
						CmsCache.delChannel(m);

						
						deleteChildChannelTemplate(ch.getId(),newtemplateid);
					}
				}
			}
		}
	}

	//允许或禁止
	public void enable(int flag) throws SQLException, MessageException
	{	
		TableUtil tu = new TableUtil();
		if(flag==1)//允许
		{
			String sql = "update channel_template set Active=1 where id="+getId();
			tu.executeUpdate(sql);
		}
		else if(flag==2)//禁止
		{
			String sql = "update channel_template set Active=0 where id="+getId();
			tu.executeUpdate(sql);
		}

		//刷新Cache
		ChannelUtil.initChannelTemplates(CmsCache.getChannel(ChannelID));
		CmsCache.delChannel(ChannelID);

		if (TemplateType == 1 || TemplateType == 2){
			updateChildChannelTemplate(ChannelID,getId());
		}
	}
	
	//获取可发布时间
	public long getCanPublishTime() throws MessageException, SQLException
	{
		if(getPublishInterval()>0)
		{
			TableUtil tu = new TableUtil();
			long time = 0;//时间戳，单位是秒
			time = tu.getNumber("select LastPublishDate from channel_template where id=" + getId());
			if(time==0)
				time = System.currentTimeMillis()/1000;
			time += getPublishInterval()*60;
			return time;
		}
		else
			return 0;
	}
	
	public int getAllowPreview() {
		return AllowPreview;
	}

	public void setAllowPreview(int allowPreview) {
		AllowPreview = allowPreview;
	}

	public void setActive(int active) {
		Active = active;
	}

	public int getActive() {
		return Active;
	}

	public void setHref(String href) {
		Href = href;
	}

	public String getHref() {
		return Href;
	}

	public void setFileNameField(String fileNameField) {
		FileNameField = fileNameField;
	}

	public String getFileNameField() {
		return FileNameField;
	}

	public int getPublishInterval() {
		return PublishInterval;
	}

	public void setPublishInterval(int publishInterval) {
		PublishInterval = publishInterval;
	}	
}