/*
 * Created on 2005-8-30
 *
 */
package tidemedia.cms.page;

import java.io.*;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.exception.ParseErrorException;
import org.apache.velocity.exception.ResourceNotFoundException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelTemplate;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.ErrorLog;
import tidemedia.cms.system.Log;
import tidemedia.cms.system.LogAction;
import tidemedia.cms.system.Site;
import tidemedia.cms.system.TemplateFile;
import tidemedia.cms.util.Util;


/**
 * @author Administrator
 *
 */
public class Page extends Table{

	private int id;
	private int ActionUser;
	private int Parent;
	private int Type;
	private int SiteID;
	private int TemplateID = 0;//模板配置编号
	private int	TemplateFileID = 0;//模板编号
	private String Name = "";
	private String Template = "";
	private String TargetName = "";
	private String Charset = "";
	private String RealCharset = "";
	private String ChannelCode = "";
	private String Content = "";
	private int		ModifiedUser = 0;
	private int		CopyFromID = 0;//复制的页面的ID
	private String	ModifiedDate = "";
	
	private String FullPathFile = "";//完整的文件路径
	/**
	 * @throws MessageException
	 * @throws SQLException
	 */
	public Page() throws MessageException, SQLException {
		super();
	}

	public Page(int id) throws MessageException, SQLException
	{
		String Sql = "select * from channel where Type=2 and id=" + id + "";
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			setId(Rs.getInt("id"));
			setName(convertNull(Rs.getString("Name")));
			setParent(Rs.getInt("Parent"));
			setCopyFromID(Rs.getInt("CopyFromID"));
			setSiteID(Rs.getInt("Site"));
			
			closeRs(Rs);
			
			Sql = "select * from channel_template where Channel=" + getId();
			
			ResultSet rs = executeQuery(Sql);
			if(rs.next())
			{
				setTemplateID(rs.getInt("id"));
				setTemplateFileID(rs.getInt("TemplateID"));
				setTargetName(convertNull(rs.getString("TargetName")));
				setCharset(convertNull(rs.getString("Charset")));
				setRealCharset(Charset);
				
				setFullPathFile(CmsCache.getSite(SiteID).getSiteFolder()+getFullTargetName());
			}
			
			closeRs(rs);
			
			Sql = "select * from page_content where Page=" + getId() + " order by id desc limit 0,1";
			TableUtil tu = new TableUtil();
			rs = tu.executeQuery(Sql);
			if(rs.next())
			{
				setContent(convertNull(rs.getString("Content")));
				setModifiedUser(rs.getInt("User"));
				//setModifiedDate(convertNull(rs.getString("CreateDate")));
				setModifiedDate(Util.FormatTimeStamp("",rs.getLong("CreateDate")));
			}
			tu.closeRs(rs);
			
     		if(Charset.equals(""))
     		{
     			setRealCharset(CmsCache.getDefaultSite().getCharset());
     		}
		}
		else
			{closeRs(Rs);throw new MessageException("页面不存在!");}	
	}
	
	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {
		String Sql = "";
		
		/*		
		Sql = "select * from channel where Name='" + SQLQuote(Name) + "'";
		//System.out.println(Sql);
		if(isExist(Sql))
		{
			throw new MessageException("页面名称已经被使用!",4);
		}
		*/
		if(Parent>0)
		{

		}
		else
		{
			Sql = "select * from channel where Parent=-1";
			ResultSet Rs = executeQuery(Sql);
			if(Rs.next())
			{
				Parent = Rs.getInt("id");				
			}
			else
				throw new MessageException("This Root Channel is not exist!");
		}
		
		setParent(Parent);
		Channel parentChannel = CmsCache.getChannel(getParent());
		setSiteID(parentChannel.getSiteID());
		
		Sql = "insert into channel (";
		
		Sql += "Name,FullPath,Parent,CanCategory,Type,Site,CopyFromID,CreateDate,Attribute1,Attribute2,Status";
		Sql += ") values(";
		Sql += "'" + SQLQuote(Name) + "'";
		Sql += ",'" + SQLQuote(getFullTargetName()) + "'";
		Sql += "," + Parent + "";
		Sql += "," + 0 + "";
		Sql += "," + Type + "";
		Sql += "," + SiteID + "";
		Sql += "," + CopyFromID + "";
		Sql += ",now(),'','',0";
		
		Sql += ")";

		int insertid = executeUpdate_InsertID(Sql);
		setId(insertid);
		
		Sql = "update channel set OrderNumber=id where OrderNumber is null or OrderNumber=0";
		executeUpdate(Sql);
		
		String code = getParentChannel().getChannelCode();
		ChannelCode = ((code.length()>0)?(code+ "_"):"") + insertid;
		
		Sql = "update channel set ChannelCode = '" + ChannelCode + "' where id=" + insertid;
		executeUpdate(Sql);
		
		
		if(Type==2)
		{
			ChannelTemplate ct = new ChannelTemplate();
			
			ct.setChannelID(insertid);
			ct.setTargetName(TargetName);
			ct.setCharset(Charset);
			ct.setTemplateType(4);
			ct.setTemplateID(TemplateID);

			ct.Add();
		}
		
		CmsCache.delChannel(Parent);
		new Log().ChannelLog(LogAction.page_add, insertid, ActionUser,SiteID);
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Delete(int)
	 */
	public void Delete(int id) throws SQLException, MessageException {
		
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Update()
	 */
	public void Update() throws SQLException, MessageException {
		String Sql = "";

		/*
		Sql = "select * from channel where Name='" + SQLQuote(Name) + "' and id!=" + id;
		if(isExist(Sql))
		{
			throw new MessageException("页面名称已经被使用!",4);
		}
		*/
		Sql = "update channel set ";
		
		Sql += "Name='" + SQLQuote(Name) + "'";
		Sql += ",FullPath='" + SQLQuote(getFullTargetName()) + "'";
		
		Sql += " where id="+id;
		
		executeUpdate(Sql);		

		Sql = "update channel_template set ";
		
		Sql += "Template='" + SQLQuote(Template) + "'";
		Sql += ",TemplateID=" + (TemplateID) + "";
		Sql += ",TargetName='" + SQLQuote(TargetName) + "'";
		Sql += ",Charset='" + SQLQuote(Charset) + "'";
		
		Sql += " where Channel="+id;
		
		executeUpdate(Sql);		
		
		new Log().ChannelLog(LogAction.page_edit, id, ActionUser,SiteID);
		
		CmsCache.delChannel(id);
	}

	public void GenerateTargetFile() throws MessageException, SQLException, IOException 
	{
		Properties p = new Properties();
     	p.setProperty("resource.loader", "test");//给你的加载器随便取个名字   
     	p.setProperty("test.resource.loader.class","tidemedia.cms.publish.TideResourceLoader");//配置一下你的加载器实现类 

		VelocityEngine ve = new VelocityEngine();
		try {
			ve.init(p);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		VelocityContext context = new VelocityContext();

		try{
		String FolderOnly = TargetName.substring(0,TargetName.lastIndexOf("/")+1);
		File file = new File(getSite().getSiteFolder() + "/" + FolderOnly);
		if(!file.exists())
			file.mkdirs();
		file = null;
		
		//print("TemplateID:"+TemplateID);
		TemplateFile tf = new TemplateFile(TemplateID);
		String template_content = tf.getContent();
		String content = "";
		//print(tf.getContent());
		
		if(template_content.length()>0)
		{
			Template template = null;
			//System.out.println("getCharsetForUse():"+getCharsetForUse());
			//System.out.println("template_content:"+template_content);
			template = ve.getTemplate(template_content, getCharsetForUse());
			StringWriter writer = new StringWriter();
			template.merge(context, writer);
			content = writer.toString();
		}
		
		setContent(content);
		
		savePage();
		
		}catch(Exception e)
		{
			ErrorLog errorlog;
			try {
				errorlog = new ErrorLog();
				errorlog.setName("页面模板错误");
				errorlog.setMessage(e.getMessage());
				errorlog.setContent(StackToString(e));
				errorlog.Add();
			} catch (MessageException e1) {
				e1.printStackTrace();
			} catch (SQLException e1) {
				e1.printStackTrace();
			}
			
			e.printStackTrace();
			throw new MessageException("模板解析错误,目标页面没有生成!");
		}

	}

	//把页面的内容保存起来，同时生成一份文件
	public void savePage() throws MessageException, SQLException
	{
		String sql = "insert into page_content(Page,Content,User,CreateDate) values(";
		sql += getId() + ",'" + SQLQuote(Content) + "'," + ActionUser + ",UNIX_TIMESTAMP())";
		
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
		
		new Log().ChannelLog(LogAction.page_save, id, ActionUser,SiteID);
		
		String realPath = getSite().getSiteFolder() + "/" + getFullTargetName();

		realPath = realPath.replace('\\', '/');
		String FolderName = realPath.substring(0,realPath.lastIndexOf("/")) + "/";
		
		BufferedWriter ot;
		try {
			
			File file = new File(FolderName);
			if(!file.exists())
				file.mkdirs();
			file = null;
			
			String content = Content;
			content = content.replace("<!-- TideCMS Module -->", "");
			
			sql = "select * from page_module where Page=" + getId();
			ResultSet rs = tu.executeQuery(sql);
			while(rs.next())
			{
				int moduleid = rs.getInt("id");
				//int moduletype = rs.getInt("ModuleType");
				
				String s1 = "<!-- TideCMS Module " + moduleid + " begin -->";
				String s2 = "<!-- TideCMS Module " + moduleid + " end   -->";
				
				content = content.replace(s1, "");
				content = content.replace(s2, "");
			}
			
			tu.closeRs(rs);
			content = content.replaceFirst("<head>", "<head>\r\n<meta name=\"publisher\" content=\"TideCMS 8.5\">");
			//System.out.println("savepage:"+realPath+",Content:"+Content);
			ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(realPath,false),getCharsetForUse()));
			ot.write(content,0,content.length());
			ot.close();	
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}	
	}
	
	public void addFrame(int frameTemplateID,int frameID) throws MessageException, SQLException
	{
		String frameStr = "";
		
		String content = "";
	    String content2 = getContent();
	    String flag = "</div>";
	    if(frameID>0)
	    	flag = "<!-- TideCMS Module " + frameID + " end   -->";
	    
		int i = content2.lastIndexOf(flag);
		if(frameID==0 && i==-1)
		{
			content2 = content2.replace("<body>", "<body>\r\n<div class=\"tide_main\">");
			content2 = content2.replace("</body>", "\r\n</div>\r\n</body>");
			i = content2.lastIndexOf(flag);
		}
		if(i==-1) return;
		
		TemplateFile tf = CmsCache.getTemplate(frameTemplateID);
		
		Properties p = new Properties();
     	p.setProperty("resource.loader", "test");//给你的加载器随便取个名字   
     	p.setProperty("test.resource.loader.class","tidemedia.cms.publish.TideResourceLoader");//配置一下你的加载器实现类 

		VelocityEngine ve = new VelocityEngine();
		try {
			ve.init(p);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		VelocityContext context = new VelocityContext();
		
		String template_content = tf.getContent();
		
		if(template_content.length()>0)
		{
			Template template = null;
			try {
				context.put( "page", new Page(getId()));
				template = ve.getTemplate(template_content,"utf-8");
			StringWriter writer = new StringWriter();
			template.merge(context, writer);
			frameStr = writer.toString();
			
			} catch (ResourceNotFoundException e) {
				e.printStackTrace();
			} catch (ParseErrorException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if(i!=-1)
		{
			if(frameID>0)
				i = i + flag.length();
			
			content = content2.substring(0,i) + frameStr + content2.substring(i);
		}
		
	    //String content = InsertBeforeEndBody(getContent(),frameStr);
	    
	    setContent(content);
	    
	    savePage();
	}
	
	public int getNextFrameID() throws SQLException, MessageException
	{
		int fid = 0;
		
		String Sql = "insert into page_module (";
		
		Sql += "Page,Template,ModuleType";
		Sql += ") values(";
		Sql += "" + getId() + "";
		Sql += "," + 0 + "";
		Sql += "," + PageModule.ModuleFrame + "";
		
		Sql += ")";
		
		fid = executeUpdate_InsertID(Sql);	
		
		return fid;
	}
	
	public int getNextColumnID() throws SQLException, MessageException
	{
		int fid = 0;
		
		String Sql = "insert into page_module (";
		
		Sql += "Page,Template,ModuleType";
		Sql += ") values(";
		Sql += "" + getId() + "";
		Sql += "," + 0 + "";
		Sql += "," + PageModule.ModuleColumn + "";
		
		Sql += ")";
		
		fid = executeUpdate_InsertID(Sql);	
		
		return fid;
	}
	
	public int getNextModuleID(int type) throws SQLException, MessageException
	{
		int fid = 0;
		
		String Sql = "insert into page_module (";
		
		Sql += "Page,Template,ModuleType";
		Sql += ") values(";
		Sql += "" + getId() + "";
		Sql += "," + 0 + "";
		Sql += "," + type + "";
		
		Sql += ")";
		
		fid = executeUpdate_InsertID(Sql);	
		
		return fid;
	}
	
	//删除框架
	public void delFrame(int fid) throws MessageException, SQLException
	{
		String s1 = "<!-- TideCMS Module " + fid + " begin -->";
		String s2 = "<!-- TideCMS Module " + fid + " end   -->";

		String content = "";
		int index1 = Content.indexOf(s1);
		int index2 = Content.indexOf(s2);
		if(index1!=-1 && index2!=-1)
			content = Content.substring(0,index1) + Content.substring(index2+s2.length());
		
		setContent(content);
		
		savePage();
	}
	
	//移动框架
	public void moveFrame(int fid,int fid2) throws MessageException, SQLException
	{
		//print("s1:"+fid+",s2:"+fid2);
		String s1 = "<!-- TideCMS Module " + fid + " begin -->";
		String s2 = "<!-- TideCMS Module " + fid + " end   -->";

		String content1 = "";
		String content2 = "";
		int index1 = Content.indexOf(s1);
		int index2 = Content.indexOf(s2);
		if(index1!=-1 && index2!=-1)
			content1 = Content.substring(index1,index2+s2.length());
		//print("c1:"+content1);
		String s3 = "<!-- TideCMS Module " + fid2 + " begin -->";
		String s4 = "<!-- TideCMS Module " + fid2 + " end   -->";
		int index3 = Content.indexOf(s3);
		int index4 = Content.indexOf(s4);
		if(index3!=-1 && index4!=-1)
			content2 = Content.substring(index3,index4+s4.length());
		if(index1!=-1 && index2!=-1 && index3!=-1 && index4!=-1)
		{
			String s5 = "<!-- TideCMS Module temp1 -->";
			String s6 = "<!-- TideCMS Module temp2 -->";
			Content = Content.replace(content1, s5);
			Content = Content.replace(content2, s6);
			Content = Content.replace(s5, content2);
			Content = Content.replace(s6, content1);
			//content = Content.substring(0,index1) + content2 + Content.substring(index2+s2.length());
			//content = Content.substring(0,index3) + content1 + Content.substring(index4+s4.length());
			
			//setContent(content);
			
			savePage();
		}
	}
	
	//移动模块
	public void moveModule(int mid,int mid2) throws MessageException, SQLException
	{
		//print("s1:"+fid+",s2:"+fid2);
		String s1 = "<!-- TideCMS Module " + mid + " begin -->";
		String s2 = "<!-- TideCMS Module " + mid + " end   -->";

		String content1 = "";
		String content2 = "";
		int index1 = Content.indexOf(s1);
		int index2 = Content.indexOf(s2);
		if(index1!=-1 && index2!=-1)
			content1 = Content.substring(index1,index2+s2.length());
		//print("c1:"+content1);
		String s3 = "<!-- TideCMS Module " + mid2 + " begin -->";
		String s4 = "<!-- TideCMS Module " + mid2 + " end   -->";
		int index3 = Content.indexOf(s3);
		int index4 = Content.indexOf(s4);
		if(index3!=-1 && index4!=-1)
			content2 = Content.substring(index3,index4+s4.length());
		if(index1!=-1 && index2!=-1 && index3!=-1 && index4!=-1)
		{
			String s5 = "<!-- TideCMS Module temp1 -->";
			String s6 = "<!-- TideCMS Module temp2 -->";
			Content = Content.replace(content1, s5);
			Content = Content.replace(content2, s6);
			Content = Content.replace(s5, content2);
			Content = Content.replace(s6, content1);
			//content = Content.substring(0,index1) + content2 + Content.substring(index2+s2.length());
			//content = Content.substring(0,index3) + content1 + Content.substring(index4+s4.length());
			
			//setContent(content);
			
			savePage();
		}
	}
	
	//把包含文件的内容填充过来
	public String IncludeFileContent(String content) throws MessageException, SQLException
	{	
		TableUtil tu = new TableUtil();
		String sql = "select * from page_module where Page=" + getId() ;
		sql += " and (ModuleType=" + PageModule.ModuleChannelTemplate + ")";
		ResultSet rs = tu.executeQuery(sql);
		
		while(rs.next())
		{
			int mid = rs.getInt("id");

			PageModule pm = new PageModule(mid);
			ChannelTemplate ct = new ChannelTemplate(pm.getTemplate());
			String Path	= getSite().getSiteFolder() + "/" + ct.getFullTargetName();
			String LineString = "";
			String TotalString = "";
			String pmContent = "";
			try {
				pmContent = pm.getContent();
			} catch (IOException e1) {
				e1.printStackTrace();
			}
			int i = content.indexOf(pmContent);
			
			if(pmContent.length()>0 && i!=-1)
			{
				if(!Path.equals("")){
					BufferedReader in;
					try {
						String charset = ct.getCharset();
						if(charset.length()==0)
							charset = CmsCache.getDefaultSite().getCharset();
						if(charset.length()==0)
							charset = "gb2312";
	
						in = new BufferedReader(new InputStreamReader(new FileInputStream(Path),charset));
						while ((LineString = in .readLine())!=null)
						{
							TotalString += LineString+"\r\n";
						}
						in.close();
					} catch (UnsupportedEncodingException e) {
						e.printStackTrace();
					} catch (FileNotFoundException e) {
						//e.printStackTrace();
					} catch (IOException e) {
						e.printStackTrace();
					}
	
				}
				
				try {
					content = content.replace(pm.getContent(), TotalString);
					
					//兼容大写的Include
					String c = pm.getContent();
					int index = c.indexOf("include");
					if(index!=-1)
					{
						c = c.replace("include","Include");
						content = content.replace(c, TotalString);
					}
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		
		tu.closeRs(rs);
		
		//处理不是模块中的include file
		String s1 = "<!--#include virtual=\"";
		int s1_len = s1.length();
		String s2 = "\" -->";
		String s3 = "\"-->";
		int s2_len = s2.length();
		int from = 0;
		int index = content.indexOf(s1, from);
		while(index!=-1)
		{
			//System.out.println("============");
			//System.out.println(content);
			int index2 = content.indexOf(s2,from);
			int index3 = content.indexOf(s3,from);
			if(index3<index2 && index3!=-1)
			{
				index2 = index3;
				s2_len = s3.length();
			}
			else
			{
				s2_len = s2.length();
			}
			
			/*if(index2==-1)
			{
				s2 = "\"-->";
				index2 = content.indexOf(s2,from);
			}*/
			if(index2!=-1)
			{
				int iii = index+s1_len;
				//System.out.println("len:"+content.length()+",1:"+iii+",2:"+index2);
				String path = content.substring(iii,index2);
				//System.out.println("p:"+path);
				if(!path.equals(""))
				{
				String fileContent = getContentFromFile(path,"");
				//System.out.println("============");
				//System.out.println(content);
				//System.out.println("============");
				//System.out.println(fileContent);
				content = content.substring(0,index) + fileContent + content.substring(index2+s2_len);
				//System.out.println("============");
				//System.out.println(content);
				}
			}
			
			//from = index + s1_len;
			from = index;
			//System.out.println("newlen:"+content.length()+",from:"+from);
			//index = content.indexOf(s1, from);
			index = content.indexOf(s1, from);
			if(index==from) break;
			//System.out.println("newindex:"+index);
		}
		
		return content;	
	}
	
	//从文件中获取内容
	public String getContentFromFile(String path,String charset) throws MessageException, SQLException
	{
		String TotalString = "";
		if(path.endsWith(".php") || path.endsWith(".jsp"))
		{
			//动态程序
			String url = getSite().getUrl() + path;
			//System.out.println("url:"+url);
			TotalString = Util.connectHttpUrl(url, CmsCache.getDefaultSite().getCharset());
		}
		else
		{	
			path = getSite().getSiteFolder() + path;
			//静态文件
		BufferedReader in;
		try {
			//String charset = ct.getCharset();
			if(charset.length()==0)
				charset = CmsCache.getDefaultSite().getCharset();
			if(charset.length()==0)
				charset = "gb2312";
			String LineString = "";
			//System.out.println("charset:"+charset);
			in = new BufferedReader(new InputStreamReader(new FileInputStream(path),charset));
			while ((LineString = in .readLine())!=null)
			{//System.out.println("----------");
			//System.out.println(LineString);
				TotalString += LineString+"\r\n";
			}
			in.close();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			//e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}	
		}
		return TotalString;
	}
	
	//把模块管理注释标记转换成模块管理按纽，用于维护使用
	public String ConvertModuleFlag(String content) throws MessageException, SQLException
	{
		String newcontent = "";
		String s1 = "<!-- TideCMS Module -->";
		int i = 1;

		int index = content.indexOf(s1);
		while(index!=-1)
		{
			String s2 = "<div class=\"tideframe_block_tools\" tidecms_id=\"-"+i+"\" type=\"0\"></div>";
			content = content.substring(0,index) + s2 + content.substring(index+s1.length());
			index = content.indexOf(s1);
			i++;
		}
		
		newcontent = content;
		
		TableUtil tu = new TableUtil();
		String sql = "select * from page_module where Page=" + getId() ;
		sql += " and (ModuleType=" + PageModule.ModuleDirectEdit + " or ModuleType=" + PageModule.ModuleChannelTemplate + ")";
		ResultSet rs = tu.executeQuery(sql);
		
		while(rs.next())
		{
			int mid = rs.getInt("id");
			int moduleType = rs.getInt("ModuleType");
			String s = "<!-- TideCMS Module " + mid + " begin -->";
			String s2 = "<div class=\"tideframe_block_tools\" tidecms_id=\""+mid+"\" type=\"" + moduleType + "\"></div>";
			newcontent = newcontent.replace(s, s2+s);
		}
		
		tu.closeRs(rs);
		
		return newcontent;
	}
	
	//删除模块内容
	public void delModuleContent(int mid) throws MessageException, SQLException
	{
		if(mid>0)
		{
			String content = Content;
			String s1 = "<!-- TideCMS Module -->";
			String s2 = "<!-- TideCMS Module " + mid + " begin -->";
			String s3 = "<!-- TideCMS Module " + mid + " end   -->";
			int index2 = content.indexOf(s2);
			int index3 = content.indexOf(s3);
			
			if(index2!=-1 && index3!=-1)
			{
				PageModule pm = new PageModule(mid);
				if(pm.getType()==PageModule.ModuleChannelTemplate)
				{
					ChannelTemplate ct = new ChannelTemplate(pm.getTemplate());
					ct.Delete(ct.getId());
					pm.Delete();
				}
				
				content = content.substring(0,index2) + s1 + content.substring(index3+s3.length());
				setContent(content);
				savePage();
			}
		}
	}
	
	//删除模块
	public void delModule(int mid) throws MessageException, SQLException
	{
		if(mid<0)
		{
			String newcontent = "";
			String content = Content;
			String s1 = "<!-- TideCMS Module -->";
			int i = 1;

			int index = content.indexOf(s1);
			while(index!=-1)
			{
				if(("-"+i).endsWith(mid+""))
				{
					newcontent = content.substring(0,index) + "" + content.substring(index+s1.length());
					setContent(newcontent);
					savePage();
					
					break;
				}
				
				index = content.indexOf(s1,index+s1.length());
				i++;
			}
		}
		else
		{
			String content = Content;
			String s2 = "<!-- TideCMS Module " + mid + " begin -->";
			String s3 = "<!-- TideCMS Module " + mid + " end   -->";
			int index2 = content.indexOf(s2);
			int index3 = content.indexOf(s3);
			
			if(index2!=-1 && index3!=-1)
			{
				content = content.substring(0,index2) + content.substring(index3+s3.length());
				setContent(content);
				savePage();
			}
		}
	}
	
	//增加模块标记
	public void addModule(int mid) throws MessageException, SQLException
	{
		String s1 = "<!-- TideCMS Module -->";
		
		if(mid<0)
		{
			String newcontent = "";
			String content = Content;
			
			int i = 1;

			int index = content.indexOf(s1);
			while(index!=-1)
			{
				if(("-"+i).endsWith(mid+""))
				{
					newcontent = content.substring(0,index) + s1 + s1 + content.substring(index+s1.length());
					setContent(newcontent);
					savePage();
					
					break;
				}
				
				index = content.indexOf(s1,index+s1.length());
				i++;
			}
		}
		else
		{
			String content = Content;
			String s3 = "<!-- TideCMS Module " + mid + " end   -->";
			int index3 = content.indexOf(s3);
			
			if(index3!=-1)
			{
				content = content.substring(0,index3+s3.length()) + s1 + content.substring(index3+s3.length());
				
				setContent(content);
				savePage();
			}
		}
	}
	
	//更新模块内容 直接内容维护
	public void updateModule(int mid,String text) throws MessageException, SQLException
	{
		if(mid<0)
		{
			String newcontent = "";
			String content = Content;
			String s1 = "<!-- TideCMS Module -->";
			int i = 1;

			int index = content.indexOf(s1);
			while(index!=-1)
			{
				if(("-"+i).endsWith(mid+""))
				{
					int mid2 = getNextModuleID(PageModule.ModuleDirectEdit);
					String s2 = "<!-- TideCMS Module " + mid2 + " begin -->";
					String s3 = "<!-- TideCMS Module " + mid2 + " end   -->";
					
					PageModule pm = new PageModule(mid2);
					pm.setContent(text);
					pm.Update();
					
					newcontent = content.substring(0,index) + s2 + text + s3 + content.substring(index+s1.length());
					setContent(newcontent);
					savePage();
					
					break;
				}
				
				index = content.indexOf(s1,index+s1.length());
				i++;
			}
		}
		else
		{
			String content = Content;
			
			PageModule pm = new PageModule(mid);
			pm.setContent(text);
			pm.Update();
			
			String s2 = "<!-- TideCMS Module " + mid + " begin -->";
			String s3 = "<!-- TideCMS Module " + mid + " end   -->";
			int index2 = content.indexOf(s2);
			int index3 = content.indexOf(s3);
			
			if(index2!=-1 && index3!=-1)
			{
				content = content.substring(0,index2+s2.length()) + text + content.substring(index3);
				
				setContent(content);
				savePage();
			}
		}
	}
	
	//更新模块内容 从频道生产内容
	public void updateModule(int mid,int channelTemplateID) throws MessageException, SQLException, IOException
	{
		if(mid<0)
		{
			String newcontent = "";
			String content = Content;
			String s1 = "<!-- TideCMS Module -->";
			int i = 1;

			int index = content.indexOf(s1);
			while(index!=-1)
			{
				if(("-"+i).endsWith(mid+""))
				{
					int mid2 = getNextModuleID(PageModule.ModuleChannelTemplate);
					String s2 = "<!-- TideCMS Module " + mid2 + " begin -->";
					String s3 = "<!-- TideCMS Module " + mid2 + " end   -->";
					
					PageModule pm = new PageModule(mid2);
					pm.setTemplate(channelTemplateID);
					pm.Update();
					
					newcontent = content.substring(0,index) + s2 + pm.getContent() + s3 + content.substring(index+s1.length());
					setContent(newcontent);
					savePage();
					
					break;
				}
				
				index = content.indexOf(s1,index+s1.length());
				i++;
			}
		}
		else
		{
			String content = Content;
			
			PageModule pm = new PageModule(mid);
			pm.setTemplate(channelTemplateID);
			pm.Update();
			
			String s2 = "<!-- TideCMS Module " + mid + " begin -->";
			String s3 = "<!-- TideCMS Module " + mid + " end   -->";
			int index2 = content.indexOf(s2);
			int index3 = content.indexOf(s3);
			
			if(index2!=-1 && index3!=-1)
			{
				content = content.substring(0,index2+s2.length()) + pm.getContent() + content.substring(index3);
				
				setContent(content);
				savePage();
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
	 * @return Returns the parent.
	 */
	public int getParent() {
		return Parent;
	}
	/**
	 * @param parent The parent to set.
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
	 * @param templateFileName The templateFileName to set.
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
	 * @param type The type to set.
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
	 * @param targetName The targetName to set.
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
	 * @param charset The charset to set.
	 */
	public void setCharset(String charset) {
		Charset = charset;
	}
	
	//第一步转换，把在dw中添加的页面模块标记转换成注释标记
	public void ConvertContent1(File file) throws IOException
	{
		
		String newcontent = "";
		String s1 = "<input type=\"button\" value=\"模块管理\">";
		String s2 = "<!-- TideCMS Module -->";
		
		BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file),RealCharset));
		String LineString;
		String content = "";
		while ((LineString = in .readLine())!=null)
		{
			content += LineString+"\r\n";
		}
		
		in.close();
		
		newcontent = content.replace(s1,s2);

		if(!newcontent.equals(content))
		{
			//内容改变，则保存文件
			BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false),RealCharset));

			ot.write(newcontent,0,newcontent.length());
			ot.close();			
		}
	}

	//第二步转换，把用http协议获取的内容中的模块管理注释标记转换成模块管理按纽，用于维护使用
	public String ConvertContent2(String content)
	{
		String newcontent = "";
		String s1 = "<!-- TideCMS Module -->";
		int i = 1;

		int index = content.indexOf(s1);
		while(index!=-1)
		{
			//String s2 = "<input type=\"button\" onClick=\"module(" + id + ",0," + i + ");\" value=\"模块管理\">";			
			String s2 = "<input name=\"tidecms_list\" onClick=\"cms_module(" + id + ",0," + i + ");\" type=\"image\" title='管理模块内容' src=\"/images/page_edit_menu_manage.gif\">";
			s2 += "<input name=\"tidecms_add\" onClick=\"cms_module_add(" + id + ",0," + i + ");\" type=\"image\" title='添加模块' src=\"/images/page_edit_menu_append.gif\">";
			//s2 += "<input name=\"tidecms_del\" onClick=\"module_del(" + id + ",0," + i + ");\" type=\"image\" src=\"/images/page_edit_menu_delete.gif\">";
			content = content.substring(0,index) + s2 + content.substring(index+s1.length());
			index = content.indexOf(s1);
			i++;
		}
		
		newcontent = content;
		
		return newcontent;
	}

	//暂时作废
	//第三步转换，管理员用，把用http协议获取的内容中的模块管理标记转换成模块管理按纽，用于维护使用
	public String ConvertContent3(String content) throws SQLException, MessageException
	{
		String newcontent = "";
		//String s1 = "<!-- TideCMS Module -->";
		
		String Sql = "select * from page_module where Page=" + id;
		ResultSet Rs = executeQuery(Sql);
		while(Rs.next())
		{
			int moduleid = Rs.getInt("id");
			String s2 = "<!-- TideCMS Module " + moduleid + " begin -->";
			String s3 = "<!-- TideCMS Module " + moduleid + " end   -->";
			
			String s4 = "";
			String s5 = "";
			
			s4 += "<div class=\"tidecms_edit_menu\">";
			//s4 += "<input type=\"button\" onClick=\"module(" + id + "," + moduleid + ",0);\" value=\"模块管理\">";
			s4 += "<input name=\"tidecms_list\" onClick=\"cms_module(" + id + "," + moduleid + ",0);\" type=\"image\" title='管理模块内容' src=\"/images/page_edit_menu_manage.gif\">";
			s4 += "<input name=\"tidecms_add\" onClick=\"cms_module_add(" + id+"," + moduleid + ",0);\" type=\"image\" title='添加模块' src=\"/images/page_edit_menu_append.gif\">";
			s4 += "<input name=\"tidecms_del\" onClick=\"cms_module_del(" + moduleid + ");\" type=\"image\" title='删除模块' src=\"/images/page_edit_menu_delete.gif\">";
			s4 += "</div>";
			s4 += s2 + "\r\n" + "<div class=\"tidecms_edit\" onMouseOver=\"className='tidecms_edit_s'\" onMouseOut=\"className='tidecms_edit'\">";
			s5 += "</div>" + "\r\n" + s3;
			
			if(content.indexOf(s2)!=-1 && content.indexOf(s3)!=-1)
			{
				content = content.replace(s2,s4);
				content = content.replace(s3,s5);
			}
		}
		closeRs(Rs);
		
		newcontent = content;
		
		return newcontent;
	}

	//暂时作废
	//第三步转换，编辑用，把用http协议获取的内容中的模块管理标记转换成模块管理按纽，用于维护使用
	public String ConvertContent4(String content) throws SQLException, MessageException
	{
		String newcontent = "";
		//String s1 = "<!-- TideCMS Module -->";
		
		String Sql = "select * from page_module where Page=" + id;
		ResultSet Rs = executeQuery(Sql);
		while(Rs.next())
		{
			int moduleid = Rs.getInt("id");
			
			PageModule pm = new PageModule(moduleid);
			
			String s2 = "<!-- TideCMS Module " + moduleid + " begin -->";
			String s3 = "<!-- TideCMS Module " + moduleid + " end   -->";
			
			String s4 = "";
			String s5 = "";
			
			s4 += "<div class=\"tidecms_edit_menu\">";
			if(pm.getType()==1)
			{			
				s4 += "<input name=\"tidecms_list\" onClick=\"cms_module_content_list(" + moduleid + ",1);\" type=\"image\" title='管理模块内容' src=\"/images/page_edit_menu_manage.gif\">";
				s4 += "<input name=\"tidecms_add\" onClick=\"cms_module_content_add(" + moduleid + ");\" type=\"image\" title='添加模块' src=\"/images/page_edit_menu_append.gif\">";
			}
			else
			{
				s4 += "<input name=\"tidecms_list\" onClick=\"cms_module_content_list(" + moduleid + ",2);\" type=\"image\" title='管理模块内容' src=\"/images/page_edit_menu_manage.gif\">";
			}
			s4 += "</div>";
			
			s4 += s2 + "\r\n" + "<div class=\"tidecms_edit\" onMouseOver=\"className='tidecms_edit_s'\" onMouseOut=\"className='tidecms_edit'\">";
			s5 += "</div>" + "\r\n" + s3;
			
			if(content.indexOf(s2)!=-1 && content.indexOf(s3)!=-1)
			{
				content = content.replace(s2,s4);
				content = content.replace(s3,s5);
			}
		}
		closeRs(Rs);
		
		newcontent = content;
		
		return newcontent;
	}

	//在页面文件中添加模块代码
	public void AddModuleCode(PageModule pm,int moduleindex) throws IOException, MessageException, SQLException
	{
		pm.setCharset(getRealCharset());
		File file = new File(getFullPathFile());
		String newcontent = "";
		String s1 = "<!-- TideCMS Module -->";
		
		BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file),RealCharset));
		String LineString;
		String content = "";
		while ((LineString = in .readLine())!=null)
		{
			content += LineString+"\r\n";
		}

		in.close();
		
		newcontent = content;
		
		int i = 1;

		int index = newcontent.indexOf(s1);
		while(index!=-1)
		{//System.out.println("i:" + i + ",index:" + moduleindex);
			if(i==moduleindex)
			{
				String s2 = "";
				String pmcontent = pm.getContent();
				if(pmcontent.indexOf("<!-- TideCMS Module " + pm.getId() + " end   -->")!=-1)
					throw new MessageException("the module content is wrong!");
				
				s2 += "<!-- TideCMS Module " + pm.getId() + " begin -->";
				s2 += pmcontent + "";
				s2 += "<!-- TideCMS Module " + pm.getId() + " end   -->";

				newcontent = newcontent.substring(0,index) + s2 + newcontent.substring(index+s1.length());
				break;
			}
			index = newcontent.indexOf(s1,index+s1.length());
			i++;
		}

		if(!newcontent.equals(content))
		{
			//内容改变，则保存文件
			BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false),RealCharset));

			ot.write(newcontent,0,newcontent.length());
			ot.close();			
		}
	}
	
	//在页面文件中修改模块代码
	public void EditModuleCode(PageModule pm) throws IOException, MessageException, SQLException
	{
		pm.setCharset(getRealCharset());
		File file = new File(getFullPathFile());
		String newcontent = "";
		
		BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file),RealCharset));
		String LineString;
		String content = "";
		while ((LineString = in .readLine())!=null)
		{
			content += LineString+"\r\n";
		}

		in.close();
		
		newcontent = content;
		
		String s1 = "<!-- TideCMS Module " + pm.getId() + " begin -->";
		String s2 = "<!-- TideCMS Module " + pm.getId() + " end   -->";
		String s3 = pm.getContent() + "";
		
		if(s3.indexOf(s2)!=-1)
			throw new MessageException("the module content is wrong!");
		
		int index1 = newcontent.indexOf(s1);
		int index2 = newcontent.indexOf(s2);
		if(index1!=-1 && index2!=-1)
			newcontent = newcontent.substring(0,index1+s1.length()) + s3 + newcontent.substring(index2);

		if(!newcontent.equals(content))
		{
			//内容改变，则保存文件
			try
			{
				BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false),RealCharset));
	
				ot.write(newcontent,0,newcontent.length());
				ot.close();
			}
			catch(FileNotFoundException e)
			{
				throw new MessageException("文件写入失败，请重新尝试或联系系统管理员.");
			}
		}
	}	
	
	//在页面文件中清除模块内容
	public void ClearModuleContent(int moduleid) throws IOException, MessageException, SQLException
	{
		File file = new File(getFullPathFile());
		String newcontent = "";
		
		BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file),RealCharset));
		String LineString;
		String content = "";
		while ((LineString = in .readLine())!=null)
		{
			content += LineString+"\r\n";
		}

		in.close();
		
		newcontent = content;
		
		String s1 = "<!-- TideCMS Module " + moduleid + " begin -->";
		String s2 = "<!-- TideCMS Module " + moduleid + " end   -->";
		String s3 = "<!-- TideCMS Module -->";

		int index1 = newcontent.indexOf(s1);
		int index2 = newcontent.indexOf(s2);
		if(index1!=-1 && index2!=-1)
			newcontent = newcontent.substring(0,index1) + s3 + newcontent.substring(index2+s2.length());

		if(!newcontent.equals(content))
		{
			//内容改变，则保存文件
			BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false),RealCharset));

			ot.write(newcontent,0,newcontent.length());
			ot.close();			
		}
	}	

	//在页面文件中清除模块标记
	public void ClearModuleCode(int moduleid) throws IOException, MessageException, SQLException
	{
		File file = new File(getFullPathFile());
		String newcontent = "";
		
		BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file),RealCharset));
		String LineString;
		String content = "";
		while ((LineString = in .readLine())!=null)
		{
			content += LineString+"\r\n";
		}

		in.close();
		
		newcontent = content;
		
		String s1 = "<!-- TideCMS Module " + moduleid + " begin -->";
		String s2 = "<!-- TideCMS Module " + moduleid + " end   -->";
		//String s3 = "<!-- TideCMS Module -->";

		int index1 = newcontent.indexOf(s1);
		int index2 = newcontent.indexOf(s2);
		if(index1!=-1 && index2!=-1)
			newcontent = newcontent.substring(0,index1) + newcontent.substring(index2+s2.length());
		
		if(!newcontent.equals(content))
		{
			//内容改变，则保存文件
			BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false),RealCharset));

			ot.write(newcontent,0,newcontent.length());
			ot.close();			
		}
	}	

	//在页面文件中添加新的模块标记
	public void CopyModuleCode(int moduleid,int moduleindex) throws IOException, MessageException, SQLException
	{
		File file = new File(getFullPathFile());
		String newcontent = "";
		String s1 = "<!-- TideCMS Module -->";
		
		BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(file),RealCharset));
		String LineString;
		String content = "";
		while ((LineString = in .readLine())!=null)
		{
			content += LineString+"\r\n";
		}

		in.close();
		
		newcontent = content;
		
		int i = 1;
		int index = 0;
		
		if(moduleindex>0)
		{
			index = newcontent.indexOf(s1);
			while(index!=-1)
			{//System.out.println("i:" + i + ",index:" + moduleindex);
				if(i==moduleindex)
				{
					String s2 = "<!-- TideCMS Module -->";
	
					newcontent = newcontent.substring(0,index+s1.length()) + s2 + newcontent.substring(index+s1.length());					
					break;
				}
				index = newcontent.indexOf(s1,index+s1.length());
				i++;
			}
		}

		if(moduleid>0)
		{
			String s2 = "<!-- TideCMS Module -->";
			String s3 = "<!-- TideCMS Module " + moduleid + " end   -->";
			index = newcontent.indexOf(s3);
			if(index!=-1)
			{
				newcontent = newcontent.substring(0,index+s3.length()) + s2 + newcontent.substring(index+s3.length());
			}
		}
		
		if(!newcontent.equals(content))
		{
			//内容改变，则保存文件
			BufferedWriter ot = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false),RealCharset));

			ot.write(newcontent,0,newcontent.length());
			ot.close();			
		}
	}
	
	public boolean TargetFileExist() throws IOException, MessageException, SQLException
	{
		String TargetName = getTargetName();
		if(TargetName.startsWith("/") || TargetName.startsWith("\\"))
 		{					
 		}
		else
		{
			Channel channel = CmsCache.getChannel(getParent());
			TargetName = channel.getFullPath() + "/" + TargetName;
		}
		
		File file = new File(CmsCache.getSite(SiteID).getSiteFolder() + "/" + TargetName);
		
		if(file.exists())
			return true;
		else
			return false;
	}
	
	public String getCharsetForUse() throws MessageException, SQLException
	{
		String charset = "";
 		if(Charset.equals(""))
 		{
 			charset = CmsCache.getDefaultSite().getCharset();
 		}
 		
 		if(charset.equals(""))
 			charset = "gb2312";
 		
 		return charset;
	}
	
	public String StackToString(Exception e) {
		  try {
		    java.io.StringWriter sw = new java.io.StringWriter();
		    java.io.PrintWriter pw = new java.io.PrintWriter(sw);
		    e.printStackTrace(pw);
		    return "" + sw.toString() + "";
		    }
		  catch(Exception e2) {
		    return "bad stack2string";
		    }
	}
	
	/**
	 * @return Returns the realCharset.
	 */
	public String getRealCharset() {
		return RealCharset;
	}
	/**
	 * @param realCharset The realCharset to set.
	 */
	public void setRealCharset(String realCharset) {
		RealCharset = realCharset;
	}
	
	public String getFullTargetName() throws MessageException, SQLException
	{
		String targetname = getTargetName();
		if(targetname.startsWith("/") || targetname.startsWith("\\"))
 		{					
 		}
		else
		{
			Channel channel = CmsCache.getChannel(getParent());
			targetname = channel.getFullPath() + "/" + targetname;
		}
		
		return Util.ClearPath(targetname);
	}
	
	public int getPageByFilename(String str) throws SQLException, MessageException
	{
		int pageid = 0;
		String Sql = "";
		
		Sql = "select * from channel where FullPath='" + str + "'";
		
		ResultSet Rs = executeQuery(Sql);
		if(Rs.next())
		{
			pageid = Rs.getInt("id");
		}
		
		closeRs(Rs);
		
		return pageid;
	}
	
	public String InsertHead(String Content,String Head)
	{
		int i = Content.toLowerCase().indexOf("<head>");
		if(i==-1)
			return Head + Content;
		else
			return Content.substring(0,i) + "\r\n" + Head + Content.substring(i);
	}
	
	public String InsertBeforeEndBody(String Content,String Str)
	{
		int i = Content.toLowerCase().indexOf("</body>");
		if(i==-1)
			return Content + Str;
		else
			return Content.substring(0,i) + Str + Content.substring(i);
	}

	public String getFullPathFile() {
		return FullPathFile;
	}

	public void setFullPathFile(String fullPathFile) {
		FullPathFile = fullPathFile;
	}

	public int getSiteID() {
		return SiteID;
	}

	public void setSiteID(int siteID) {
		SiteID = siteID;
	}	
	
	public Site getSite() throws MessageException, SQLException {
		return CmsCache.getSite(SiteID);
	}

	public void setTemplateID(int templateID) {
		TemplateID = templateID;
	}

	public int getTemplateID() {
		return TemplateID;
	}

	public int getActionUser() {
		return ActionUser;
	}

	public void setActionUser(int actionUser) {
		ActionUser = actionUser;
	}	
	
	public Channel getParentChannel() throws MessageException, SQLException {
		return CmsCache.getChannel(getParent());
	}

	public void setContent(String content) {
		Content = content;
	}

	public String getContent() {
		return Content;
	}

	public void setModifiedUser(int modifiedUser) {
		ModifiedUser = modifiedUser;
	}

	public int getModifiedUser() {
		return ModifiedUser;
	}

	public void setModifiedDate(String modifiedDate) {
		ModifiedDate = modifiedDate;
	}

	public String getModifiedDate() {
		return ModifiedDate;
	}	
	
	public String getPageTitle()
	{
		String title = "";
		
		int i = Content.indexOf("<title>");
		int j = Content.indexOf("</title>");
		
		if(i!=-1 && j!=-1)
		{
			title = Content.substring(i+7,j);
		}
		
		return title;
	}
	
	public void updatePageTitle(String title) throws MessageException, SQLException
	{
		int i = Content.indexOf("<title>");
		int j = Content.indexOf("</title>");
		
		if(i!=-1 && j!=-1)
		{
			Content = Content.substring(0,i+7) + title + Content.substring(j);
			
			savePage();
		}		
	}
	
	public String getPageStyle()
	{
		String style = "";
		
		int i = Content.indexOf("<!-- TideCMS Module -1 begin -->");
		int j = Content.indexOf("<!-- TideCMS Module -1 end   -->");
		
		if(i!=-1 && j!=-1)
		{
			String str = Content.substring(i,j);
			int m = str.indexOf("href=\"");
			int n = str.indexOf("\"", m+6);
			if(m!=-1 && n!=-1)
			{
				style = str.substring(m+6,n);
			}
		}
		
		return style;
	}
	
	public void updatePageStyle(String style) throws MessageException, SQLException
	{
		String flag1 = "<!-- TideCMS Module -1 begin -->";
		int i = Content.indexOf(flag1);
		int j = Content.indexOf("<!-- TideCMS Module -1 end   -->");
		
		if(i!=-1 && j!=-1)
		{
			String str = "<link href=\""+style+"\" type=\"text/css\" rel=\"stylesheet\" />";
			Content = Content.substring(0,i+flag1.length()) + str + Content.substring(j);
			
			savePage();
		}			
	}

	public void setCopyFromID(int copyFromID) {
		CopyFromID = copyFromID;
	}

	public int getCopyFromID() {
		return CopyFromID;
	}

	public int getTemplateFileID() {
		return TemplateFileID;
	}

	public void setTemplateFileID(int templateFileID) {
		TemplateFileID = templateFileID;
	}
}
