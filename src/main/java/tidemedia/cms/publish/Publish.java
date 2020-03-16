package tidemedia.cms.publish;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.MultiFormatWriter;
import com.google.zxing.WriterException;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.app.VelocityEngine;
import org.apache.velocity.exception.ParseErrorException;
import org.apache.velocity.exception.ResourceNotFoundException;
import org.apache.velocity.exception.VelocityException;
import org.springframework.stereotype.Component;
import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.RedisUtil;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.plugin.CallApi;
import tidemedia.cms.system.*;
import tidemedia.cms.util.Util;

import java.io.*;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Properties;

@Component
public class Publish extends Table {

    private int 	ChannelID;
    private int		User;
    private String 	FileSeparator = "/";//文件名分隔符,unix "/" windows "\"

    //private int		IncludeSubChannel;//为1表示还要发布所有子频道
    private int		PublishAllItems = 0;//发布所有内容,0 只发布还未发布的内容 1 重新发布所有内容

    private int		OnlyCopyFile;//仅仅拷贝文件
    private int		PublishType;//发布类型
    private int		TemplateID;//模板编号

    private boolean publishPrevNextDoc = true;//是否允许触发发布上一个，下一个文章




    //发布类型
    public static final int	FILE_PUBLISH = 0;//文件发布
    public static final int CHANNEL_PUBLISH = 1;//频道发布
    public static final int	APPROVE_DOCUMENT_PUBLISH = 2;//审核文档后发布
    public static final int EDIT_DOCUMENT_PUBLISH = 3;//编辑文档后发布
    public static final int ORDER_DOCUMENT_PUBLISH = 4;//排序文档后发布
    public static final int DELETE_DOCUMENT_PUBLISH = 5;//删除文档后发布   
    public static final int ExtraTemplate_PUBLISH = 6;//只发布附加模板
    public static final int ONLYTHISTemplate_PUBLISH = 7;//只发布指定模板
    public static final int ONLY_DOCUMENT_PUBLISH = 8;//只发布指定文档
    public static final int CHANNEL_PUBLISH_NOCONTENT = 9;//没有内容页的频道发布 发布的时候优先级第一


    public static Publish publish_current;

    private Channel channel;

	private ArrayList<Integer> PublishItems = new ArrayList<Integer>();//要发布的item编号，为空发布全部纪录
    //private ArrayList PublishCategorys = new ArrayList();//要发布的分类编号，为空发布全部纪录

    private String 	ErrorMessage = "";//发生错误时的模板信息

	private int		ErrorChannelID = 0;//发生错误时的频道
	private int		PublishTaskID = 0;
	private PublishTask publishtask = new PublishTask();//2015/10/17 增加publishtask对象，以后可以直接访问

    public long beginTime = 0;
    public long ftp_begintime = 0;
	public int ftp_status = 0;

	VelocityEngine ve = new VelocityEngine();
	VelocityContext context = new VelocityContext();

	private String publishingFileName = "";//正在发布的文件


    public Publish() throws MessageException, SQLException {
		super();
	}

    public Publish (int channelid) throws MessageException,SQLException
    {
    	setChannelID(channelid);
    }

	public Publish (int channelid,int user) throws MessageException,SQLException
	{
		setChannelID(channelid);
		setUser(user);
	}

	public boolean GenerateFile()
	{
		boolean success = true;
		long publishbegin = System.currentTimeMillis();
     	try {
     		FileSeparator = System.getProperty("file.separator");
     		if(FileSeparator.equals(""))
     			FileSeparator = "/";

     		ArrayList<Integer> arraylist = new ArrayList<Integer>();

     		arraylist.add(new Integer(ChannelID));

     		for(int i=0;i<arraylist.size();i++)
     		{
     			int channelid = ((Integer)arraylist.get(i)).intValue();

	     		try{

	     			Channel c = new Channel(channelid);
	     			channel = CmsCache.getChannel(channelid);
	     			if(channel==null)
	     				System.out.println("channel is null");
	     		}catch(Exception e)
	     		{
	     			System.out.println("error:"+e.getMessage());
					e.printStackTrace();
	     		}

	     		setChannelID(channelid);

				init();
				//beginTime = System.currentTimeMillis();
				//System.out.println(tidemedia.cms.util.Util.getCurrentDateTime());

				if(PublishType== Publish.ExtraTemplate_PUBLISH)
				{
					//System.out.println("开始生成附加页面.");
					generateExtraFile();
					//System.out.println("结束生成附加页面.");
				}
				else if(PublishType== Publish.CHANNEL_PUBLISH)
				{
					System.out.println("publishtype:channel,"+publishtask.getChannelTemplateID());
					if(publishtask.getChannelTemplateID()>0)
					{

						ChannelTemplate ct = ChannelUtil.getChannelTemplate(publishtask.getChannelID(), publishtask.getChannelTemplateID());
						System.out.println("publishtype:channel,"+publishtask.getChannelTemplateID()+","+ct.getTemplateFile().getFileName());
						//列表发布
						if(ct.getTemplateType()== ChannelTemplate.ListTemplateType)
							generateIndexFile2(ct);
						//System.out.println("publishtype:channel,"+publishtask.getChannelTemplateID()+","+ct.getTemplateFile().getName());
						//附加发布
						if(ct.getTemplateType()== ChannelTemplate.ExtraTemplateType)
							publishChannelTemplate(publishtask.getChannelTemplateID());
					}
					else
					{
						generateIndexFile();
						generateExtraFile();
					}

					//System.out.println("开始生成附加页面."+channelid);
					if(PublishAllItems==1)
						generateItemFile();
				}
				else if(PublishType== Publish.CHANNEL_PUBLISH_NOCONTENT)
				{
					generateIndexFile();
					generateExtraFile();
				}
				else if(PublishType== Publish.ONLY_DOCUMENT_PUBLISH)
				{
					generateItemFile();
				}
				else
				{
					//System.out.println("开始生成索引页面.");
					//System.out.println("time:"+(System.currentTimeMillis()-beginTime)+"seconds");
		     		generateIndexFile();
		     		//System.out.println("结束生成索引页面.");
		     		//System.out.println("time:"+(System.currentTimeMillis()-beginTime)+"seconds");
		     		//System.out.println("开始生成文档页面.");
					generateItemFile();
					//System.out.println("结束生成文档页面.");
					//System.out.println("time:"+(System.currentTimeMillis()-beginTime)+"seconds");
					//System.out.println("开始生成附加页面.");
					generateExtraFile();
					//System.out.println("结束生成附加页面.");
					//System.out.println("time:"+(System.currentTimeMillis()-beginTime)+"seconds");
				}
				//System.out.println(channel.getName()+",publish time:"+(System.currentTimeMillis()-beginTime)+"seconds");
     		}

     		//System.out.println("generate file end.....");
		}
     	catch(ResourceNotFoundException e)
		{
     		ErrorLog.SaveErrorLog("没有找到模板文件.",ErrorMessage,ErrorChannelID,e);
     		success = true;
		}
     	catch(ParseErrorException e)
		{
     		ErrorLog.SaveErrorLog("模板语言解析错误.",ErrorMessage,ErrorChannelID,e);
     		success = true;//可以关闭该任务
		}
     	catch(VelocityException e)
		{
     		ErrorLog.SaveErrorLog("模板处理错误.",ErrorMessage,ErrorChannelID,e);
     		success = true;//可以关闭该任务
		}
     	catch(IOException e)
		{
     		ErrorLog.SaveErrorLog("IO错误.",ErrorMessage,ErrorChannelID,e);
     		success = true;//可以关闭该任务
		}
     	catch(SQLException e)
		{
     		ErrorLog.SaveErrorLog("SQL错误.",ErrorMessage,ErrorChannelID,e);
     		success = false;
		}
     	catch (Exception e) {
     		ErrorLog.SaveErrorLog("其他错误.",ErrorMessage,ErrorChannelID,e);
     		System.out.println("模板发布其他错误：");
			e.printStackTrace(System.out);
			success = false;
		}finally
		{
			/*
			long publishend = System.currentTimeMillis();
			try {
				TableUtil tu = new TableUtil();
				String sql = "update publish_task set PublishBegin="+publishbegin+",PublishEnd="+publishend+" where id=" + PublishTaskID;
				//System.out.println(sql);
				tu.executeUpdate(sql);
			} catch (MessageException e){
				e.printStackTrace();
			} catch (SQLException e) {
				e.printStackTrace();
			}*/
		}

     	return success;
	}

     //初始化参数
     public void init() throws SQLException, MessageException
     {
     	//Properties props = new Properties();
     	//Props.setProperty("file.resource.loader.path",defaultSite.getTemplateFolder());
     	//props.put("srl.resource.loader.class","com.saro.custom.velocity.StringResourceLoader");

     	Properties p = new Properties();
     	p.setProperty("resource.loader", "test");//给你的加载器随便取个名字
     	p.setProperty("test.resource.loader.class","tidemedia.cms.publish.TideResourceLoader");//配置一下你的加载器实现类
     	p.setProperty(VelocityEngine.RUNTIME_LOG_LOGSYSTEM_CLASS,"org.apache.velocity.runtime.log.NullLogSystem");//关闭日志
     	
     	/*
     	try {
			Velocity.init(p);
		} catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}*/


     	try {
     		ve.init(p);
     	} catch (Exception e) {
     		System.out.println("velocity init error:"+e.getMessage());
     		e.printStackTrace(System.out);
     	}
     }

     public void generateIndexFile() throws MessageException, SQLException
     {
 		ArrayList<ChannelTemplate> templatefiles = new ArrayList<ChannelTemplate>();
     	templatefiles = channel.getChannelTemplates(ChannelTemplate.ListTemplateType);//获取列表页模板列表

		for(int iii = 0;iii<templatefiles.size();iii++)
		{
			ChannelTemplate ct = (ChannelTemplate)templatefiles.get(iii);

     		generateIndexFile2(ct);
     	}
     }

     //发布指定的频道列表页模板
     public void generateIndexFile2(ChannelTemplate ct) throws MessageException, SQLException
     {
    	 if(ct.getActive()==0) return;

     	String FolderName = "";
     	String SiteFolder = channel.getSite().getSiteFolder();
 		FolderName = channel.getFullPath() + "/";
 		TableUtil datasource_tu = channel.getTableUtil();
 		TableUtil tu2 = new TableUtil();

     		int PageNumber = 0;//页数

     		Parameter p_ = CmsCache.getParameter("sys_max_page_number");
     		int MaxPageNumber = 25;
     		if(p_!=null) MaxPageNumber = p_.getIntValue();
     		if(MaxPageNumber<=0) MaxPageNumber = 25;

     		int RowsPerPage  = ct.getRowsPerPage();
     		if(RowsPerPage==0) RowsPerPage = 20;
     		String TemplateName = ct.getTemplateFile().getName();

     		ErrorMessage = "模板：" + TemplateName + "\r\n";
     		ErrorMessage += "频道：" + channel.getParentChannelPath() + " ("+channel.getId()+")"+"\r\n";
     		ErrorChannelID = channel.getId();

     		String Charset = getCharset(ct.getCharset());

     		String CountSql = "";

     		if(ct.getWhereSql().equals(""))
     		{
     			tu2 = new TableUtil();
	     		CountSql = "select count(*) from item_snap use index(index_3) where Status=1 ";//去掉了and Active=1
	//System.out.println("include:" + ct.getIncludeChildChannel());
	     		//计算审核通过的纪录的页数
	     		if(channel.getType()== Channel.MirrorChannel_Type)
				{
	     			if(ct.getIncludeChildChannel()==0)//不包含子频道内容
	     				CountSql += " and ChannelCode='" + channel.getLinkChannel().getChannelCode() + "'";
	     			else
	     				CountSql += " and ChannelCode like '" + channel.getLinkChannel().getChannelCode() + "%'";
				}
	     		else
	     		{
	     			if(ct.getIncludeChildChannel()==0)
	     				CountSql += " and ChannelCode='" + channel.getChannelCode() + "'";
	     			else
	     				CountSql += " and ChannelCode like '" + channel.getChannelCode() + "%'";
	     		}
     		}
     		else
     		{
     			tu2 = datasource_tu;
     			String whereSql = ct.getWhereSql();
     			whereSql = whereSql.trim();
     			if(whereSql.startsWith("and") || whereSql.startsWith("AND"))
     				whereSql = " " + whereSql;
     			else
     				whereSql = " and " + whereSql;//如果不写and，就补充一个
     			CountSql = "select count(*) from " + channel.getTableName();
     			CountSql += " where Status=1 " + whereSql;
     			if(channel.getType()== Channel.Category_Type)
     				CountSql += " and Category=" + channel.getId();
     		}
     		//System.out.println(CountSql);
     		ResultSet rs = tu2.executeQuery(CountSql);
     		int rowsCount = 0;

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

     		//最大发布页数
     		if(PageNumber>=MaxPageNumber){PageNumber = MaxPageNumber;rowsCount = PageNumber*RowsPerPage;}
     		
     		/*
			File file = new File(SiteFolder + "/" + FolderName);
			if(!file.exists())
				file.mkdirs();
			file = null;*/

     		for(int i=1;i<=PageNumber;i++)
     		{
				String FileName = "";
				if(i==1)
					FileName = ((!ct.isAbsolutePath())?FolderName:ct.getFolderOnly())+ct.getIndexFilePrefix()+"." + ct.getIndexFileExt();
				else
					FileName = ((!ct.isAbsolutePath())?FolderName:ct.getFolderOnly())+ct.getIndexFilePrefix()+"_"+i+"." + ct.getIndexFileExt();

				controller.setChannelTemplate(ct);
     			controller.setChannelID(ChannelID);

     			controller.pagecontrol.setCurrentPage(i);
     			controller.pagecontrol.setMaxPages(PageNumber);
     			controller.pagecontrol.setRowsCount(rowsCount);
     			controller.pagecontrol.setRowsPerPage(RowsPerPage);

     			controller.setPublishMode(2);//静态发布
     			controller.setIncludeChildChannel(ct.getIncludeChildChannel());

     			controller.init();
     			context.put("Controller", controller);
				context.put("channel", controller.getChannel());
				context.put("util", new Util());
				context.put("label", ct.getLabel());
				context.put("whereSql",ct.getWhereSql());

				templateMerge(SiteFolder,FileName,ct,Charset,null);
     		}
     }

     public void templateMerge(String SiteFolder, String FileName, ChannelTemplate ct, String Charset, Document item)
     {
    	 	//long t = System.currentTimeMillis()/1000;
			String fullFileName = Util.ClearPath(SiteFolder + "/" + FileName);

			//创建目录 2015/10/19
			File file = new File(Util.getFilePath(fullFileName));
			if(!file.exists())
			{
				file.mkdirs();
				System.out.println("make dirs "+file.getAbsolutePath());
			}
			file = null;

			//System.out.println("fullFileName:"+fullFileName+","+getPublishTaskID());
			//PublishManager.getInstance().waitForPublish(fullFileName);
			waitForPublish(fullFileName,0);
			//System.out.println("fullFileName:"+fullFileName+",waiteFor,"+getPublishTaskID());
 			Template template = null;
 			//template = ve.getTemplate(TemplateName,Charset);
 			try {
 				//System.out.println("getTemplate,"+getPublishTaskID()+","+(System.currentTimeMillis()/1000-t));
 				String templateContent = ct.getTemplateFile().getContent();
 				templateContent = templateContent.replaceFirst("<head>", "<head>\r\n<meta name=\"publisher\" content=\"TideCMS 9.0\">");
 				if(templateContent==null || templateContent.length()==0)
 				{
 					System.out.println("template content error,filename:"+fullFileName+",ct:"+ct.getId());
 				}
				template = ve.getTemplate(templateContent,"utf-8");
	 			Writer writer = new OutputStreamWriter(new FileOutputStream(fullFileName),Charset);
	 			template.setEncoding(Charset);
	 	        template.merge(context, writer);
	 	        writer.flush();
	 	        writer.close();
	 	        //System.out.println("getTemplate close,"+getPublishTaskID()+","+(System.currentTimeMillis()/1000-t));

	 	        //System.out.println("clearFileName,"+getPublishTaskID()+","+(System.currentTimeMillis()/1000-t));
	 	        if(item==null || (item!=null && item.getStatus()==1))
	 	        	InsertToBePublished(FileName,SiteFolder,channel);
	 	        int gid = 0;
	 	        if(item!=null) gid = item.getGlobalID();
	 	        addToGenerateFiles(FileName,gid,ChannelID,ct.getTemplateID(), TemplateFile.ListTemplateType,channel.getSiteID());

 			}catch(ResourceNotFoundException e)
 			{
 				ErrorLog.SaveErrorLog("没有找到模板文件.",ErrorMessage,ErrorChannelID,e);
 			}
 			catch(ParseErrorException e)
 			{
 				ErrorLog.SaveErrorLog("模板语言解析错误.",ErrorMessage,ErrorChannelID,e);
 			}
 			catch(VelocityException e)
 			{
 				ErrorLog.SaveErrorLog("模板处理错误.",ErrorMessage,ErrorChannelID,e);
 			}
 			catch(IOException e)
 			{
 				ErrorLog.SaveErrorLog("IO错误.",ErrorMessage,ErrorChannelID,e);
 			}
 			catch (Exception e) {
 				ErrorLog.SaveErrorLog("其他错误.",ErrorMessage,ErrorChannelID,e);
 				e.printStackTrace(System.out);
 			}
 			PublishManager.getInstance().removePublishingFile(fullFileName);//从正在模板发布队列清除
 			//System.out.println("clearFileName end,"+getPublishTaskID()+","+(System.currentTimeMillis()/1000-t));
    }

     public void generateItemFile() throws Exception, IOException
     {
		//System.out.println(FolderName);
		ArrayList<ChannelTemplate> templatefiles = new ArrayList<ChannelTemplate>();

		templatefiles = channel.getChannelTemplates(2);//获取内容页模板列表

		for(int iii = 0;iii<templatefiles.size();iii++)
		{
			ChannelTemplate ct = (ChannelTemplate)templatefiles.get(iii);
			//System.out.println(ct.getTargetName());
     		generateItemFile2(ct);
		}
		//发布索引页面结束
     }


     //发布内容页
     public void generateItemFile2(ChannelTemplate ct) throws IOException, MessageException, SQLException
     {
    	if(ct.getActive()==0) return;

		//发布内容页面,id=0 发布全部纪录
		String FolderName = "";
		String Charset = "";
		String SiteFolder = channel.getSite().getSiteFolder();
		FolderName = channel.getFullPath() + "/";
		TableUtil datasource_tu = channel.getTableUtil();

     	ErrorMessage = "模板：" + ct.getTemplateFile().getName() + "\r\n<br>";
     	ErrorMessage += "频道：" + channel.getParentChannelPath() + " ("+channel.getId()+")"+"\r\n<br>";
     	ErrorChannelID = channel.getId();

     	Charset = getCharset(ct.getCharset());

		String ListItemsSql = "select id,GlobalID,Title,CreateDate,Category,TotalPage,PublishDate";
		if(ct.getSubFolderType()==5)
			ListItemsSql += ",TideCMS_Path";
		if(ct.getFileNameType()==3)
		{
			if(ct.getFileNameField().equals(""))
				ListItemsSql += ",TideCMS_FileName";
			else
				ListItemsSql += "," + ct.getFileNameField()+" as TideCMS_FileName";
		}

		ListItemsSql += " from " + channel.getTableName() + " where (Status=1 or Status=0) and Active=1 ";


		String whereSql = ct.getWhereSql().trim();
		if(whereSql.length()>0)
		{
			if(whereSql.startsWith("and") || whereSql.startsWith("AND"))
				whereSql = " " + whereSql;
			else
				whereSql = " and " + whereSql;//如果不写and，就补充一个

			ListItemsSql += whereSql;
		}
     	//选择审核通过的纪录

		if(PublishItems.size()>0)//如果单独发布指定文档
		{
			String id_str = " and id in(";
	     	for(int kk = 0;kk<PublishItems.size();kk++)
			{
	     		id_str += (kk==0?"":",") + ((Integer)PublishItems.get(kk)).intValue();
			}
	     	id_str += ")";
			ListItemsSql += id_str;
		}
		else
		{
			if(PublishAllItems==0)
				ListItemsSql += " and id=-1 ";//不做发布 2008.04.08
					//ListItemsSql += " and (GenerateFileDate is null or GenerateFileDate<=ModifiedDate) ";
		}


		 // 发布指定文件的时候不需要限制Category 2010-08-15
		if(PublishItems.size()==0)
		{
			if(channel.getType()== Channel.Category_Type)
				ListItemsSql += " and Category=" + channel.getId();
			else if(channel.getType()== Channel.Channel_Type)
				ListItemsSql += " and Category=0" ;
			else if(channel.getType()== Channel.MirrorChannel_Type)
			{
				if(channel.getLinkChannel().getType()== Channel.Category_Type)
					ListItemsSql += " and Category=" + channel.getLinkChannel().getId();
				else if(channel.getLinkChannel().getType()== Channel.Channel_Type)
					ListItemsSql += " and Category=0" ;
			}
		}
			String f_ = Util.ClearPath(SiteFolder + "/" + FolderName);

			File file = new File(f_);
			if(!file.exists())
			{
				//System.out.println("need mkdir:"+SiteFolder + "/" + FolderName);
				file.mkdirs();
				//System.out.println("need mkdir:"+mkdir);
			}
			else
			{
				//System.out.println("dont need mkdir:"+file.getPath());
			}
			file = null;

			ArrayList<Items> publishitems = new ArrayList<Items>();
			//Category category = new Category();
			String oldFolderName = "";
			//print(ct.getId()+":"+ListItemsSql);
			ResultSet rs = null;

			try{
				rs = datasource_tu.executeQuery(ListItemsSql);
			}catch(SQLException e)
			{
				ErrorLog.SaveErrorLog("SQL错误.","错误的SQL语句：" + ListItemsSql + ","+e.getMessage(),ErrorChannelID,e);
				return;
			}

	     	Calendar publishdate = new java.util.GregorianCalendar();
			while(rs!=null && rs.next())
			{
				Items items = new Items();
				int itemid = rs.getInt("id");
				//print("itemid:"+itemid);
				String title = convertNull(rs.getString("Title"));
				String createDate = convertNull(rs.getString("CreateDate"));
				publishdate.setTimeInMillis(rs.getLong("PublishDate")*1000);
				int totalpage = rs.getInt("TotalPage");
				int publishyear = publishdate.get(Calendar.YEAR);
				int publishmonth = publishdate.get(Calendar.MONTH) + 1;
				int publishday = publishdate.get(Calendar.DATE);

				items.setItemid(itemid);
				items.setTotalpage(totalpage);
				items.setPublishYear(publishyear);
				items.setPublishMonth(publishmonth);
				items.setPublishDay(publishday);
				items.setTitle(title);
				items.setCreateDate(createDate);
				items.setGlobalID(rs.getInt("GlobalID"));

				if(ct.getSubFolderType()==5)
				{
					items.setPath(convertNull(rs.getString("TideCMS_Path")));
				}
				if(ct.getFileNameType()==3)
				{
					items.setFileName(convertNull(rs.getString("TideCMS_FileName")));
				}

				publishitems.add(items);
			}
			datasource_tu.closeRs(rs);
			//print("publishitems size:"+publishitems.size());
			for(int ii = 0;ii<publishitems.size();ii++)
			{
				Items items = (Items)publishitems.get(ii);
				int itemid = items.getItemid();
				int totalpage = items.getTotalpage();
				int PublishYear = items.getPublishYear();
				int PublishMonth = items.getPublishMonth();
				int PublishDay = items.getPublishDay();

				String FileName = "";
				String SubFolder = "";

				String PublishDate_Month_ = "";
				String PublishDate_Day_ = "";

				if(PublishMonth<10)
					PublishDate_Month_ = "0" + PublishMonth;
				else
					PublishDate_Month_ = PublishMonth + "";

				if(PublishDay<10)
					PublishDate_Day_ = "0" +PublishDay;
				else
					PublishDate_Day_ = PublishDay + "";

				if(ct.getSubFolderType()==1)
					SubFolder = PublishYear + "/";
				else if(ct.getSubFolderType()==2)
				{
					SubFolder = PublishYear + "/" + PublishMonth + "/";
				}
				else if(ct.getSubFolderType()==3)
				{
					SubFolder = PublishYear + "/" + PublishMonth + "/" + PublishDay + "/";
				}
				else if(ct.getSubFolderType()==4)
				{
					SubFolder = PublishYear + "-" + PublishMonth + "-" + PublishDay + "/";
				}
				else if(ct.getSubFolderType()==5)
				{
					SubFolder = items.getPath() + "/";
				}
				else if (ct.getSubFolderType() == 6)
				{
					SubFolder = PublishYear + "" + PublishDate_Month_ + "" + PublishDate_Day_ + "/";
				}

				String newFolderName = ((!ct.isAbsolutePath())?FolderName:ct.getFolderOnly()) + SubFolder;
				//print("目录1："+SiteFolder + "/" + newFolderName);
				if(!newFolderName.equals(oldFolderName))
				{
					//如果目录发生变化，则检查一下目录是否存在
					File file1 = new File(SiteFolder + "/" + newFolderName);
					//print("目录："+SiteFolder + "/" + newFolderName);
					if(!file1.exists())
						file1.mkdirs();
					file1 = null;
					oldFolderName = newFolderName;
				}

				Controller controller = new Controller();
				controller.setChannelID(ChannelID);
				controller.setChannel(channel);//设置channel对象，避免在controller中再次初始化
				controller.setItemID(itemid);
     			controller.setPublishMode(2);//静态发布
				Document item = controller.getItem();

				for(int j=1;j<=totalpage;j++)
				{
					controller.setItemPage(j);
					item.setCurrentPage(j);

					String filePreName = "";
					if(ct.getFileNameType()==0)
					{
						if(ct.getItemFilePrefix().equals(""))
							filePreName = itemid + "";
						else
							filePreName = ct.getItemFilePrefix() + "_" + itemid;
					}else if(ct.getFileNameType()==1)
					{
							filePreName = items.getTitle();
					}
					else if(ct.getFileNameType()==2)
					{
						int random= item.getRandom();

						if(random==0)
						{
							random = new java.util.Random().nextInt(999)+1;
							item.updateRandom(random);
							Log.SystemLog("模板发布","随机数为0，已经修正，频道编号："+ChannelID+"，文档编号："+itemid);
						}

						filePreName=(items.getCreateDate())+random;
					}
					else if(ct.getFileNameType()==3)
					{
						filePreName = items.getFileName();
					}
					else if(ct.getFileNameType()==4)
					{
				        try {
					    		Velocity.init();
					    		VelocityContext context = new VelocityContext();
					    		context.put("util", new Util());
					    		context.put("item", item);
					    		StringWriter w = new StringWriter();
					    		String t = CmsCache.getParameterValue("sys_custom_filename");
								Velocity.evaluate(context, w, "mystring", t);
								filePreName = w+"";
							//System.out.println("execute:"+api.getTemplate());
						} catch (Exception e) {
							ErrorLog.SaveErrorLog("定制文件名规则错误.",e.getMessage(),0,e);
						}
					}

					if(j==1)
						FileName = ((!ct.isAbsolutePath())?FolderName:ct.getFolderOnly()) + SubFolder + filePreName+"." + ct.getItemFileExt();
					else
						FileName = ((!ct.isAbsolutePath())?FolderName:ct.getFolderOnly()) + SubFolder + filePreName+"_"+j+"." + ct.getItemFileExt();

	     			//controller.setSubFolderType(ti.SubFolderType);//子目录命名规则

	     			controller.init();
					context.put( "Controller", controller);
					context.put( "channel", controller.getChannel());
					context.put( "util", new Util());

					//是否触发发布上一个，下一个文档
					//System.out.println("itemid:"+item.getId()+",isPublishPrevNextDoc:"+isPublishPrevNextDoc());
					if(isPublishPrevNextDoc())
					{
						context.put("PublishPrevNextDoc", 1);
					}
					else
						context.put("PublishPrevNextDoc", 0);

					//context.put( "category",controller.getCategory());

					int status = 0;

					if(controller.getChannel().getTableName().equals("channel_video"))
					{
					}
					else
					{
						item.setCurrentPage(j);
						status = item.getStatus();

						context.put( "item", item);
						ErrorMessage += "标题：" + item.getTitle() + "(" + itemid + ")\r\n<br>";
					}

					String fullFileName = Util.ClearPath(SiteFolder + "/" + FileName);

					datasource_tu.executeUpdate("update publish_task set Message=Concat(Message,'准备生成文件:"+datasource_tu.SQLQuote(fullFileName)+"r\n') where id="+getPublishTaskID());

					templateMerge(SiteFolder,FileName,ct,Charset,item);

					//2016.11.6 liyonghai 等待发布，如果该文件正在分发，就等待，否则开始发布，并记入文件发布对象
					/*
					PublishManager.getInstance().waitForPublish(fullFileName);								
					
					Template template = new Template();
					//print("template content:"+ct.getTemplateFile().getContent());
					String templateContent = ct.getTemplateFile().getContent();
					if(CmsCache.getConfig().getCustomer().equals("tibet"))
					{
						
					}
					else
					{
						templateContent = templateContent.replaceFirst("<head>", "<head>\r\n<meta name=\"publisher\" content=\"TideCMS 9.0\">");
					}
					template = ve.getTemplate(templateContent,"utf-8");
					//template.setData("a");
					//System.out.println(fullFileName);
					Writer writer = new OutputStreamWriter(new FileOutputStream(fullFileName),Charset);
					template.setEncoding(Charset);
					template.merge(context, writer); 
					writer.flush();
					writer.close();
					
					PublishManager.getInstance().removePublishingFile(fullFileName);
					
					
					//print("itemgid:"+item.getGlobalID()+",status:"+status);
					if(status==1)//审核通过，允许发布出去
						InsertToBePublished(FileName,SiteFolder,channel);
					
					addToGenerateFiles(FileName,item.getGlobalID(),ChannelID,ct.getTemplateID(),TemplateFile.ContentTemplateType,channel.getSiteID());
					*/
					//生成二维码
					String qrcode_template = CmsCache.getParameterValue("qrcode_template");
					if(j==1 && ct.getLabel().equals(qrcode_template))
					{
						String httphref = Util.ClearPath(channel.getSite().getExternalUrl() + "/" + FileName);
						String httphref_ = new String(httphref.getBytes("utf-8"),"iso-8859-1");
						String qrcode_filename = "/qrcode/" + PublishYear + "/" + PublishMonth + "/" + PublishDay + "/" + item.getChannel().getId()+"_"+itemid+".png";
						String qrcode_img = Util.ClearPath(SiteFolder + qrcode_filename);
						//System.out.println(itemid+","+qrcode_img);
						if(!new File(qrcode_img).exists())
						{
							try {
								File f = new File(SiteFolder + "/qrcode/" + PublishYear + "/" + PublishMonth + "/" + PublishDay + "/");
								if(!f.exists()) f.mkdirs();
								BitMatrix byteMatrix = new MultiFormatWriter().encode(httphref_, BarcodeFormat.QR_CODE, 200, 200);
								File qrcode_img_ = new File(qrcode_img);
						        MatrixToImageWriter.writeToFile(byteMatrix, "png", qrcode_img_);

						        InsertToBePublished(qrcode_filename,SiteFolder,channel);
							} catch (WriterException e) {
								System.out.println(e.getMessage());
								e.printStackTrace(System.out);
							}
						}
					}
				}

				/*调用接口*/
				CallApi callapi = new CallApi();
				callapi.setAction(Action.document_publish_item);
				callapi.setItem(item);
				callapi.setGlobalID(items.getGlobalID());
				callapi.setActionUser(getUser());
				callapi.Start();

				String Sql = "update " + channel.getTableName() + " set GenerateFileDate=UNIX_TIMESTAMP() where id=" + itemid;
				datasource_tu.executeUpdate(Sql);
			}
			//System.out.println(TemplateName);
     }

     public void generateExtraFile() throws ResourceNotFoundException, ParseErrorException, SQLException, MessageException, IOException,Exception
     {
    	System.out.println("generateExtraFile begin");
      	String FolderName = "";
     	String Charset = "";
     	Channel channel = CmsCache.getChannel(ChannelID);
     	String SiteFolder = channel.getSite().getSiteFolder();
     	ArrayList<ChannelTemplate> templatefiles = new ArrayList<ChannelTemplate>();
     	templatefiles = channel.getChannelTemplates(3);
     	System.out.println(channel.getName());
		for(int iii = 0;iii<templatefiles.size();iii++)
		{System.out.println("ok");
			ChannelTemplate ct = (ChannelTemplate)templatefiles.get(iii);
			if(ct.getActive()==0) break;//是否允许发布
     		FolderName = channel.getFullPath() + "/";

     		//int PageNumber = 0;//页数
     		//int RowsPerPage  = ct.getRowsPerPage();
     		int Rows = ct.getRows();
     		int TitleWord = ct.getTitleWord();
     		String TemplateName = ct.getTemplateFile().getName();
     		String TargetName = ct.getTargetName();

     		Charset = getCharset(ct.getCharset());

     		ErrorMessage = "模板：" + TemplateName + "\r\n";
     		ErrorMessage += "频道：{parentchannelpath} ("+channel.getId()+")"+"\r\n";
     		ErrorChannelID = channel.getId();
     		System.out.println(TemplateName);

			String FileName = "";//要生成的文件名（带目录）
     		//目标文件以/开头，使用指定的目录
     		if(TargetName.startsWith("/") || TargetName.startsWith("\\"))
     		{//System.out.println(TargetName);
     			FolderName = TargetName.substring(0,TargetName.lastIndexOf("/")) + "/";
     			FileName = TargetName;
     			//System.out.println("FolderName:"+FolderName);
     		}
     		else
     		{
     			FileName = FolderName + TargetName;
     		}

				File file = new File(SiteFolder + "/" + FolderName);
				if(!file.exists())
					file.mkdirs();
				file = null;

     			Controller controller = new Controller();
     			controller.setChannelID(ChannelID);
     			controller.setPublishMode(2);//静态发布

     			//controller.setSubFolderType(SubFolderType);//子目录命名规则

     			controller.init();
     			context.put( "Controller", controller);
     			context.put( "channel", controller.getChannel());
     			context.put( "util", new Util());
     			//if(CategoryID>0)
     			//	context.put( "category", controller.getCategory());//附加模板可以指定分类
     			context.put("Rows",new Integer(Rows));
     			context.put("rows",new Integer(Rows));
     			context.put("label", ct.getLabel());
     			context.put("TitleWord",new Integer(TitleWord));
     			context.put("template", ct.getBean());

				File f1 = new File(SiteFolder + "/" + FileName);
				File f2 = f1.getParentFile();
				if(!f2.exists()) f2.mkdirs();

				String fullFileName = Util.ClearPath(SiteFolder + "/" + FileName);
				System.out.println("waitForPublish "+fullFileName);
				//PublishManager.getInstance().waitForPublish(fullFileName);
				waitForPublish(fullFileName,0);
     			Template template = null;
     			try{
     				String c_ = ct.getTemplateFile().getContent();
     				if(c_.length()==0) {System.out.println("模板内容为空,"+ct.getId());return;}
				template = ve.getTemplate(ct.getTemplateFile().getContent(),"utf-8");
     			}catch(Exception e){System.out.println("发生错误:"+ct.getTemplateFile().getName()+","+e.getMessage());
     			System.out.println(ct.getTemplateFile().getContent());
     			}

				FileOutputStream fo = new FileOutputStream(fullFileName);
     			Writer writer = new OutputStreamWriter(fo,Charset);
     			System.out.println("Charset:"+Charset);
     			template.setEncoding(Charset);
     	        template.merge(context, writer);
     	        writer.flush();
     	        writer.close();

     	       PublishManager.getInstance().removePublishingFile(fullFileName);

     	        if(channel.getIsPublishFile()==0)
     	        	InsertToBePublished(FileName,SiteFolder,channel);

     	        addToGenerateFiles(FileName,0,ChannelID,ct.getTemplateID(), TemplateFile.ExtraTemplateType,channel.getSiteID());
     		System.out.println(FileName);
     	}
     	//发布附加页面结束
     }

     //发布指定的附加模板
     public void publishChannelTemplate(int channelTemplateID) throws MessageException, SQLException
     {
    	 if(channelTemplateID>0)
    		 publishChannelTemplate(new ChannelTemplate(channelTemplateID));
     }

   //发布指定的附加模板
     public void publishChannelTemplate(ChannelTemplate ct) throws MessageException, SQLException
     {
    	if(ct.getId()<=0) return;

     	String FolderName = "";
     	String Charset = "";
     	channel = CmsCache.getChannel(ct.getChannelID());//全局变量
     	String SiteFolder = channel.getSite().getSiteFolder();

     	//System.out.println(channel.getName());
		//for(int iii = 0;iii<templatefiles.size();iii++)
		//{//System.out.println("ok");

     		FolderName = channel.getFullPath() + "/";

     		//int PageNumber = 0;//页数
     		//int RowsPerPage  = ct.getRowsPerPage();
     		int Rows = ct.getRows();
     		int TitleWord = ct.getTitleWord();
     		String TemplateName = ct.getTemplateFile().getName();
     		String TargetName = ct.getTargetName();

     		Charset = getCharset(ct.getCharset());

     		ErrorMessage = "模板：" + TemplateName + "\r\n";
     		ErrorMessage += "频道：" + channel.getParentChannelPath() + " ("+channel.getId()+")"+"\r\n";
     		//System.out.println(TemplateName);

			String FileName = "";//要生成的文件名（带目录）
     		//目标文件以/开头，使用指定的目录
     		if(TargetName.startsWith("/") || TargetName.startsWith("\\"))
     		{//System.out.println(TargetName);
     			FolderName = TargetName.substring(0,TargetName.lastIndexOf("/")) + "/";
     			FileName = TargetName;
     			//System.out.println("FolderName:"+FolderName);
     		}
     		else
     		{
     			FileName = FolderName + TargetName;
     		}

				File file = new File(SiteFolder + "/" + FolderName);
				if(!file.exists())
					file.mkdirs();
				file = null;

     			Controller controller = new Controller();
     			controller.setChannelID(ct.getChannelID());
     			controller.setPublishMode(2);//静态发布

     			//controller.setSubFolderType(SubFolderType);//子目录命名规则

     			controller.init();
     			context.put( "Controller", controller);
     			context.put( "channel", controller.getChannel());
     			context.put( "util", new Util());
     			//if(CategoryID>0)
     			//	context.put( "category", controller.getCategory());//附加模板可以指定分类
     			context.put("Rows",new Integer(Rows));
     			context.put("rows",new Integer(Rows));
     			context.put("TitleWord",new Integer(TitleWord));

				File f1 = new File(SiteFolder + "/" + FileName);
				File f2 = f1.getParentFile();
				if(!f2.exists()) f2.mkdirs();

				templateMerge(SiteFolder,FileName,ct,Charset,null);

     		//System.out.println(FileName);
     	//}
     	//发布附加页面结束
     }

     //在待发布表中插入纪录
     public void InsertToBePublished(String filename, String folder, Channel ch) throws SQLException, MessageException
     {
    	 InsertToBePublished(filename,folder,ch.getSite());
     }

     //在待发布表中插入纪录
     public void InsertToBePublished(String filename, String folder, Site site) throws SQLException, MessageException
     {
	        String Sql = "";
	     	filename = SQLQuote(Util.ClearPath(filename));
	     	folder = SQLQuote(folder);

	     	//文件不存在或文件大小为0，不加入发布队列
	     	if(filename.length()==0) return;
	     	String file = folder + "/" + filename;
	     	File f = new File(file);
	     	if(!f.exists())	return;
	     	if(f.length()==0)	return;

	     	TableUtil tu = new TableUtil();
	        ArrayList<PublishScheme> schemes = site.getPublishSchemes();
	     	//Enumeration en = CmsCache.getPublish_schemes().elements();
	     	for(int i = 0;i<schemes.size();i++)
	     	{
	     		PublishScheme ps = (PublishScheme)schemes.get(i);
	     		if(ps.getId()>0 && ps.canPublish(filename))
	     		{
		     		int Scheme = ps.getId();
		     		int publish_item_status = 0;
		     		String Message = "";

		     		if(ps.getStatus()==2)
		     		{
		     			Message = "发布方案暂停";
		     			publish_item_status = 4;
		     		}

		     		String tofilename = ps.getToFileName(filename);
		     		Sql = "insert into publish_item (";

					Sql += "FileName,ToFileName,TempFolder,PublishScheme,User,Site,CreateDate,Status,";
					Sql += "ErrorNumber,AddTime,CanCopyTime,CopyedTime,Message";
					Sql += ") values(";
					Sql += "'" + filename + "'";
					Sql += ",'" + tofilename + "'";
					Sql += ",'" + folder + "'";
					Sql += "," + Scheme + "";
					Sql += "," + User + "";
					Sql += "," + site.getId() + "";
					Sql += ",now()";
					Sql += "," + publish_item_status + "";
					Sql += ",0";
					Sql += ",UNIX_TIMESTAMP(),UNIX_TIMESTAMP(),0";
					Sql += ",'" + Message + "'";

					Sql += ")";

					int Publish_ItemID=tu.executeUpdate_InsertID(Sql);//待发布记录ID
					/** 2019-07-26 曲科籍  将文件发布任务放置在Redis队列 **/
					PublishItem MessageItem = new PublishItem();
					MessageItem.setId(Publish_ItemID);
					MessageItem.setPublishscheme(Scheme);
					MessageItem.setFileName(filename);
					MessageItem.setToFileName(tofilename);
					MessageItem.setTempFolder(folder);
					MessageItem.setSite(site.getId());

					if(RedisUtil.getInstance().isRedis()) {//如果是Redis队列 才插入任务
						RedisUtil.getInstance().putMessage(MessageItem, RedisUtil.PUBLISH_MESSAGE_KEY);//推送至Redis队列
					}
	     		}
	     	}

	     	//立即分发文件
	     	PublishManager.getInstance().CopyFileNow();
     }

     //在文件生成表中插入纪录
     public void addToGenerateFiles(String filename,int globalid,int channelid,int templateid,int templatetype,int site) throws SQLException, MessageException
     {
	        String Sql = "";
	     	filename = SQLQuote(Util.ClearPath(filename));

	     	boolean exist = false;
	     	TableUtil tu = new TableUtil();

	     	Sql = "select * from generate_files where FileName='" + filename + "' and Site="+site;

	     	ResultSet rs = tu.executeQuery(Sql);
	     	if(rs.next())
	     	{
	     		exist = true;
	     	}
	     	tu.closeRs(rs);

	     	if(exist)
	     	{
	     		Sql = "update generate_files set ";
	     		Sql += "GlobalID=" + globalid;
	     		Sql += ",ChannelID=" + channelid;
	     		Sql += ",Template=" + templateid;
	     		Sql += ",TemplateType=" + templatetype;
	     		Sql += ",CreateDate=UNIX_TIMESTAMP()";
	     		Sql += " where FileName='" + filename + "'";

	     		tu.executeUpdate(Sql);
	     	}
	     	else
	     	{
	     		Sql = "insert into generate_files (";
	     		Sql += "FileName,GlobalID,ChannelID,Template,TemplateType,Site,CreateDate";
	     		Sql += ") values(";
	     		Sql += "'" + filename + "'";
	     		Sql += "," + globalid;
	     		Sql += "," + channelid;
	     		Sql += "," + templateid;
	     		Sql += "," + templatetype;
	     		Sql += "," + site;
	     		Sql += ",UNIX_TIMESTAMP()";
	     		Sql += ")";

	     		tu.executeUpdate(Sql);
	     	}
     }

     public void destroy() {

     }

	/**
	 * @return Returns the channel.
	 */
	public int getChannelID() {
		return ChannelID;
	}
	/**
	 * @param channel The channel to set.
	 */
	public void setChannelID(int channelid) {
		ChannelID = channelid;
	}

	/* (non-Javadoc)
	 * @see tidemedia.cms.base.Table#Add()
	 */
	public void Add() throws SQLException, MessageException {

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

	public int getUser() {
		return User;
	}

	public void setUser(int i) {
		User = i;
	}

	public void addPublishItems(int item)
	{
		for(int i = 0;i<PublishItems.size();i++)
		{
			int j = ((Integer)PublishItems.get(i)).intValue();

			if(item==j)
				return;
		}

		PublishItems.add(new Integer(item));
	}

/*	public void addPublishCategorys(int categoryid)
	{
		for(int i = 0;i<PublishCategorys.size();i++)
		{
			int j = ((Integer)PublishCategorys.get(i)).intValue();
			
			if(categoryid==j)
				return;
		}
		
		PublishCategorys.add(new Integer(categoryid));
	}*/

	public void AddSubChannels(ArrayList<Integer> arraylist,int channelid) throws SQLException, MessageException
	{
		String Sql = "select * from channel where parent=" + channelid;

		ResultSet Rs = executeQuery(Sql);

		while(Rs.next())
		{
			int subchannelid = Rs.getInt("id");

			arraylist.add(new Integer(subchannelid));

			AddSubChannels(arraylist,subchannelid);
		}

		closeRs(Rs);
	}

	public void waitForPublish(String file,int number)
	{
		do
		{
			boolean result = PublishManager.getInstance().checkCando(2, file);
			if(result)
				break;

			if(number>300)
				break;
			number++;

			try {
				Thread.sleep(1000);
			} catch (InterruptedException e) {
				e.printStackTrace(System.out);
			}
		}while(true);
	}


	 public void waitForPublish_(String file,int number)
	 {
		 boolean result = PublishManager.getInstance().checkCando(2, file);
		 if(!result)
		 {
			 do
			 {
				if(number>300)
					break;

				try {
					Thread.sleep(1000);
					//TableUtil tu = new TableUtil();
					//String Sql = "update publish_item set Message='检查允许分发次数："+(number+1)+"' where id=" + getPublish_item_id();
					//tu.executeUpdate(Sql);
					waitForPublish(file,number++);
				} catch (InterruptedException e) {
					e.printStackTrace(System.out);
				}
			 }
			 while(true);
		 }
	 }

	/**
	 * @return Returns the onlyCopyFile.
	 */
	public int getOnlyCopyFile() {
		return OnlyCopyFile;
	}
	/**
	 * @param onlyCopyFile The onlyCopyFile to set.
	 */
	public void setOnlyCopyFile(int onlyCopyFile) {
		OnlyCopyFile = onlyCopyFile;
	}
	/**
	 * @return Returns the fileSeparator.
	 */
	public String getFileSeparator() {
		return FileSeparator;
	}
	/**
	 * @param fileSeparator The fileSeparator to set.
	 */
	public void setFileSeparator(String fileSeparator) {
		FileSeparator = fileSeparator;
	}
	/**
	 * @return Returns the publishType.
	 */
	public int getPublishType() {
		return PublishType;
	}
	/**
	 * @param publishType The publishType to set.
	 */
	public void setPublishType(int publishType) {
		PublishType = publishType;
	}

	/**
	 * @return Returns the templateID.
	 */
	public int getTemplateID() {
		return TemplateID;
	}
	/**
	 * @param templateID The templateID to set.
	 */
	public void setTemplateID(int templateID) {
		TemplateID = templateID;
	}
	/**
	 * @return Returns the publishAllItems.
	 */
	public int getPublishAllItems() {
		return PublishAllItems;
	}
	/**
	 * @param publishAllItems The publishAllItems to set.
	 */
	public void setPublishAllItems(int publishAllItems) {
		PublishAllItems = publishAllItems;
	}

	private class Items{
		private int		globalID = 0;
		public int getGlobalID() {
			return globalID;
		}
		public void setGlobalID(int globalID) {
			this.globalID = globalID;
		}
		private int 	itemid = 0;
		private int 	totalpage = 0;
		private int 	PublishYear = 0;
		private int 	PublishMonth = 0;
		private int 	PublishDay = 0;
		private String 	title = "";
		private String 	createDate = "";
		private String	path = "";//指定目录
		private String	FileName = "";//指定文件名

		/**
		 * @return Returns the itemid.
		 */
		public int getItemid() {
			return itemid;
		}
		/**
		 * @param itemid The itemid to set.
		 */
		public void setItemid(int itemid) {
			this.itemid = itemid;
		}
		/**
		 * @return Returns the totalpage.
		 */
		public int getTotalpage() {
			return totalpage;
		}
		/**
		 * @param totalpage The totalpage to set.
		 */
		public void setTotalpage(int totalpage) {
			this.totalpage = totalpage;
		}
		/**
		 * @return Returns the publishDay.
		 */
		public int getPublishDay() {
			return PublishDay;
		}
		/**
		 * @param publishDay The publishDay to set.
		 */
		public void setPublishDay(int publishDay) {
			PublishDay = publishDay;
		}
		/**
		 * @return Returns the publishMonth.
		 */
		public int getPublishMonth() {
			return PublishMonth;
		}
		/**
		 * @param publishMonth The publishMonth to set.
		 */
		public void setPublishMonth(int publishMonth) {
			PublishMonth = publishMonth;
		}
		/**
		 * @return Returns the publishYear.
		 */
		public int getPublishYear() {
			return PublishYear;
		}
		/**
		 * @param publishYear The publishYear to set.
		 */
		public void setPublishYear(int publishYear) {
			PublishYear = publishYear;
		}
		public void setTitle(String title) {
			this.title = title;
		}
		public String getTitle() {
			return title;
		}
		public void setCreateDate(String createDate) {
			this.createDate = createDate;
		}
		public String getCreateDate() {
			return createDate;
		}
		public String getPath() {
			return path;
		}
		public void setPath(String path) {
			this.path = path;
		}
		public String getFileName() {
			return FileName;
		}
		public void setFileName(String fileName) {
			FileName = fileName;
		}
	}

	public int getFtp_status() {
		return ftp_status;
	}

	public void setFtp_status(int ftp_status) {
		this.ftp_status = ftp_status;
	}

	public void setPublishingFileName(String publishingFileName) {
		this.publishingFileName = publishingFileName;
	}

	public String getPublishingFileName() {
		return publishingFileName;
	}

	public String getCharset(String charset)
	{
		if(charset!=null && !charset.equals(""))
		{
			if(charset.equalsIgnoreCase("gb2312")) return "GBK";
			return charset;
		}
		else
			try {
				charset =  CmsCache.getDefaultSite().getCharset();
			} catch (MessageException e) {
			} catch (SQLException e) {

			}

		if(!charset.equals("")) return charset;

		return "utf-8";
	}

    public Channel getChannel() {
		return channel;
	}

	public void setChannel(Channel channel) {
		setChannelID(channel.getId());
		this.channel = channel;
	}

    public String getErrorMessage() {
		return ErrorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		ErrorMessage = errorMessage;
	}

	public void setPublishTaskID(int publishTaskID) {
		PublishTaskID = publishTaskID;
	}

	public int getPublishTaskID() {
		return PublishTaskID;
	}

	public boolean isPublishPrevNextDoc() {
		return publishPrevNextDoc;
	}

	public void setPublishPrevNextDoc(boolean publishPrevNextDoc) {
		this.publishPrevNextDoc = publishPrevNextDoc;
	}

	public PublishTask getPublishtask() {
		return publishtask;
	}

	public void setPublishtask(PublishTask publishtask) {
		this.publishtask = publishtask;
	}
} 
        
