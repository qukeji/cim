package tidemedia.cms.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringWriter;
import java.io.Writer;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Properties;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.exception.ParseErrorException;
import org.apache.velocity.exception.ResourceNotFoundException;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.page.Page;
import tidemedia.cms.publish.PublishManager;
import tidemedia.cms.system.Channel;
import tidemedia.cms.system.ChannelTemplate;
import tidemedia.cms.system.CmsCache;
import tidemedia.cms.system.Controller;
import tidemedia.cms.system.Document;
import tidemedia.cms.system.TemplateFile;
import tidemedia.cms.user.UserInfo;
import tidemedia.cms.util.Util;

public class Web {

	public int userid = 0;

	public Web()
	{
		
	}
	
	public Web(int userid)
	{
		setUserid(userid);
	}
	
	public String getContent(int channelid,int itemid) throws MessageException, SQLException
	{
		ArrayList<ChannelTemplate> templatefiles = new ArrayList<ChannelTemplate>();
		Channel channel = CmsCache.getChannel(channelid);
		templatefiles = channel.getChannelTemplates(2);//获取内容页模板列表

		if(templatefiles.size()>0)
		{
			ChannelTemplate ct = (ChannelTemplate)templatefiles.get(0);
			VelocityEngine ve = new VelocityEngine();
			VelocityContext context = new VelocityContext(); 
	     	Properties p = new Properties();   
	     	p.setProperty("resource.loader", "test");
	     	p.setProperty("test.resource.loader.class","tidemedia.cms.publish.TideResourceLoader");//配置一下你的加载器实现类 
	     	
	     	try {
	     		ve.init(p);
	     	} catch (Exception e) {
	     		e.printStackTrace();
	     	} 
			Controller controller = new Controller();
			controller.setChannelID(channelid);
			controller.setChannel(channel);//设置channel对象，避免在controller中再次初始化
			controller.setItemID(itemid);
 			controller.setPublishMode(2);//静态发布
			Document item = new Document(itemid,channelid);
			controller.init();
			context.put( "Controller", controller);
			context.put( "channel", controller.getChannel());
			context.put( "util", new Util());
			context.put( "item", item);
			Template template = new Template();
			//print("template content:"+ct.getTemplateFile().getContent());
			String templateContent = ct.getTemplateFile().getContent();
			templateContent = templateContent.replace("#include(\"","#include(\""+channel.getSite().getSiteFolder());
			templateContent = templateContent.replace("#include_tidecms(\"/extra/","#include(\"/extra/"+userid+"/");
			
			templateContent = templateContent.replaceFirst("<head>", "<head>\r\n<meta name=\"publisher\" content=\"TideCMS 8.5\">");
			try {
				template = ve.getTemplate(templateContent,"utf-8");
				StringWriter sw = new StringWriter();
			    template.merge(context, sw); 
			    sw.flush(); 
			    return sw.toString();
			} catch (ResourceNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseErrorException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		
		return "";
	}
	
	public String getList(int channelid,int page) throws MessageException, SQLException
	{			
		ArrayList<ChannelTemplate> templatefiles = new ArrayList<ChannelTemplate>();
		Channel channel = CmsCache.getChannel(channelid);
		System.out.println("list channelid:"+channelid+",page:"+page);
		if(userid>0)
		{
			UserInfo user = CmsCache.getUser(userid);
			if(!channel.hasRight(user,1))
			{
				System.out.println("no right");
				return "";
			}
		}
		
		templatefiles = channel.getChannelTemplates(1);//获取列表页模板列表

		System.out.println("size:"+templatefiles.size()+",channel:"+channelid);
		
		if(templatefiles.size()>0)
		{
			ChannelTemplate ct = (ChannelTemplate)templatefiles.get(0);
			VelocityEngine ve = new VelocityEngine();
			VelocityContext context = new VelocityContext(); 
	     	Properties p = new Properties();   
	     	p.setProperty("resource.loader", "test");
	     	p.setProperty("test.resource.loader.class","tidemedia.cms.publish.TideResourceLoader");//配置一下你的加载器实现类 
	     	
	     	try {
	     		ve.init(p);
	     	} catch (Exception e) {
	     		e.printStackTrace();
	     	} 
	     	
	     	String CountSql = "";
     		
	     	TableUtil tu2 = null;
	     	
     		if(ct.getWhereSql().equals(""))
     		{
     			tu2 = new TableUtil();
	     		CountSql = "select count(*) from item_snap use index(index_3) where Status=1 and Active=1 ";

	     		if(ct.getIncludeChildChannel()==0)
	     			CountSql += " and ChannelCode='" + channel.getChannelCode() + "'";
	     		else
	     			CountSql += " and ChannelCode like '" + channel.getChannelCode() + "%'";	     		
     		}
     		else
     		{
     			tu2 = channel.getTableUtil();
     			CountSql = "select count(*) from " + channel.getTableName();
     			CountSql += " where Status=1 and Active=1 " + ct.getWhereSql();
     			if(channel.getType()==Channel.Category_Type)
     				CountSql += " and Category=" + channel.getId();
     		}
     		System.out.println(CountSql);
     		ResultSet rs = tu2.executeQuery(CountSql);
     		int rowsCount = 0;
     		
     		int PageNumber = 0;//页数
     		int RowsPerPage  = ct.getRowsPerPage();
     		if(RowsPerPage==0) RowsPerPage = 20;
     		
     		if(rs.next())
     		{
     			rowsCount = rs.getInt(1);
     			PageNumber = Math.round(rowsCount/RowsPerPage);
     			if(rowsCount>PageNumber*RowsPerPage)
     				PageNumber ++;
     		}
     		tu2.closeRs(rs);
     		
     		//没有记录的情况下，也要发布文件
     		if(PageNumber==0)
     			PageNumber = 1;
     		
			Controller controller = new Controller();
			controller.setChannelID(channelid);
			controller.setChannel(channel);//设置channel对象，避免在controller中再次初始化
 			controller.setPublishMode(2);//静态发布
 			
 			controller.pagecontrol.setCurrentPage(page);
 			controller.pagecontrol.setMaxPages(PageNumber);
 			controller.pagecontrol.setRowsCount(rowsCount);
 			controller.pagecontrol.setRowsPerPage(RowsPerPage);
 			
			controller.init();
			
			context.put( "Controller", controller);
			context.put( "channel", controller.getChannel());
			context.put( "util", new Util());
			Template template = new Template();
			//print("template content:"+ct.getTemplateFile().getContent());
			String templateContent = ct.getTemplateFile().getContent();
			templateContent = templateContent.replace("#include(\"","#include(\""+channel.getSite().getSiteFolder());
			templateContent = templateContent.replace("#include_tidecms(\"/extra/","#include(\"/extra/"+userid+"/");
			
			templateContent = templateContent.replaceFirst("<head>", "<head>\r\n<meta name=\"publisher\" content=\"TideCMS 8.5\">");
			try {
				template = ve.getTemplate(templateContent,"utf-8");
				StringWriter sw = new StringWriter();
			    template.merge(context, sw); 
			    sw.flush(); 
			    return sw.toString();
			} catch (ResourceNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ParseErrorException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}			
		}
		
		return "";		
	}
	
    public String getExtra(int channelid,int channeltemplateid) throws MessageException, SQLException
    {
    	//System.out.println("channelid:"+channelid+",ctid:"+channeltemplateid);
     	String FolderName = "";
    	String Charset = "";
    	Channel channel = CmsCache.getChannel(channelid);
    	
		if(userid>0)
		{
			UserInfo user = CmsCache.getUser(userid);
			if(!channel.hasRight(user,1))
			{
				return "";
			}
		}
		
    	ArrayList<ChannelTemplate> templatefiles = new ArrayList<ChannelTemplate>();
    	templatefiles = channel.getChannelTemplates(3);
    	//System.out.println(channel.getName());
		for(int iii = 0;iii<templatefiles.size();iii++)
		{ 
			ChannelTemplate ct = (ChannelTemplate)templatefiles.get(iii);
			if(ct.getId()!=channeltemplateid) continue;
			
			VelocityEngine ve = new VelocityEngine();
			VelocityContext context = new VelocityContext(); 
	     	Properties p = new Properties();   
	     	p.setProperty("resource.loader", "test");
	     	p.setProperty("test.resource.loader.class","tidemedia.cms.publish.TideResourceLoader");//配置一下你的加载器实现类 
	     	
	     	try {
	     		ve.init(p);
	     	} catch (Exception e) {
	     		e.printStackTrace();
	     	} 
	     	
    		FolderName = channel.getFullPath() + "/"; 
    		
    		//int PageNumber = 0;//页数
    		//int RowsPerPage  = ct.getRowsPerPage();
    		int Rows = ct.getRows();
    		int TitleWord = ct.getTitleWord();
    		String TemplateName = ct.getTemplateFile().getName();
    		String TargetName = ct.getTargetName();

				
    			Controller controller = new Controller();
    			controller.setChannelID(channelid);
    			controller.setPublishMode(2);//静态发布

    			//controller.setSubFolderType(SubFolderType);//子目录命名规则
    			
    			
    			controller.init();
    			System.out.println("controller.getChannel():"+channel.getId()+","+channel.getName());
    			context.put( "Controller", controller);
    			context.put( "channel",channel);
    			context.put( "util", new Util());
    			//if(CategoryID>0)
    			//	context.put( "category", controller.getCategory());//附加模板可以指定分类     			     			
    			context.put("Rows",new Integer(Rows));
    			context.put("rows",new Integer(Rows));
    			context.put("label", ct.getLabel());
    			context.put("TitleWord",new Integer(TitleWord));
    			context.put("template", ct.getBean());

				
    			Template template = null;
				
				String templateContent = ct.getTemplateFile().getContent();
				
				try {
					template = ve.getTemplate(templateContent,"utf-8");
					StringWriter sw = new StringWriter();
				    template.merge(context, sw); 
				    sw.flush(); 
				    //System.out.println("====="+sw.toString()+"========");
				    return sw.toString();				    
				} catch (ResourceNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (ParseErrorException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				
    	}     	
		return "";
    	//发布附加页面结束    	
    } 
    
    public String getPage(int pageid) throws MessageException, SQLException
    {
			VelocityEngine ve = new VelocityEngine();
			VelocityContext context = new VelocityContext(); 
	     	Properties p = new Properties();   
	     	p.setProperty("resource.loader", "test");
	     	p.setProperty("test.resource.loader.class","tidemedia.cms.publish.TideResourceLoader");//配置一下你的加载器实现类 
	     	
	     	try {
	     		ve.init(p);
	     	} catch (Exception e) {
	     		e.printStackTrace();
	     	} 
	     	
	     	Page page = new Page(pageid);
	     	Channel channel = CmsCache.getChannel(pageid);
    		
    		context.put( "channel",channel);
    		context.put( "util", new Util());

				
    			Template template = null;
				
				String templateContent = page.getContent();
				templateContent = templateContent.replace("#include(\"","#include(\""+channel.getSite().getSiteFolder());
				templateContent = templateContent.replace("#include_tidecms(\"/extra/","#include(\"/extra/"+userid+"/");
				
				try {
					template = ve.getTemplate(templateContent,"utf-8");
					StringWriter sw = new StringWriter();
				    template.merge(context, sw); 
				    sw.flush(); 
				    return sw.toString();
				} catch (ResourceNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (ParseErrorException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
		return "";	
    } 	   
    
	public int getUserid() {
		return userid;
	}

	public void setUserid(int userid) {
		this.userid = userid;
	}    
}
