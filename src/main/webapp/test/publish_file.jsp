<%@ page import="tidemedia.cms.system.*,tidemedia.cms.base.*,tidemedia.cms.publish.*,java.io.*,java.util.*,
org.apache.velocity.*,org.apache.velocity.app.*,
				java.sql.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
     public void generateItemFile2(ChannelTemplate ct,int channelid,int itemid_) throws Exception, IOException
     {
    	if(ct.getActive()==0) return;
		String ErrorMessage = "";
    	Channel channel=CmsCache.getChannel(channelid); 
		//发布内容页面,id=0 发布全部纪录
		String FolderName = "";
		String Charset = "";
		String SiteFolder = channel.getSite().getSiteFolder();
		FolderName = channel.getFullPath() + "/"; 
		TableUtil datasource_tu = channel.getTableUtil();
					
     	ErrorMessage = "模板：" + ct.getTemplateFile().getName() + "\r\n<br>";
     	ErrorMessage += "频道：" + channel.getParentChannelPath() + " ("+channel.getId()+")"+"\r\n<br>";
     	int ErrorChannelID = channel.getId();
     		
     	Charset = "utf-8";

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
			
				
		if(!ct.getWhereSql().equals(""))
			ListItemsSql += " and " + ct.getWhereSql();
     		//选择审核通过的纪录


			String id_str = " and id in("+itemid_+")";

			ListItemsSql += id_str;			
		
				
		
			File file = new File(SiteFolder + "/" + FolderName);
			if(!file.exists())
				file.mkdirs();
			file = null;
					
			ArrayList<Items> publishitems = new ArrayList<Items>();
			//Category category = new Category();
			String oldFolderName = "";
			//print(ct.getId()+":"+ListItemsSql);
			ResultSet rs = null;
			rs = datasource_tu.executeQuery(ListItemsSql);

	     	java.util.Calendar publishdate = new java.util.GregorianCalendar();
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
					PublishManager.getInstance().waitFor(fullFileName, 1);
					
					Template template = new Template();
					//print("template content:"+ct.getTemplateFile().getContent());
					String templateContent = ct.getTemplateFile().getContent();
					templateContent = templateContent.replaceFirst("<head>", "<head>\r\n<meta name=\"publisher\" content=\"TideCMS 8.5\">");
					template = ve.getTemplate(templateContent,"utf-8");
					//template.setData("a");
					//System.out.println(fullFileName);
					Writer writer = new OutputStreamWriter(new FileOutputStream(fullFileName),Charset);
					template.setEncoding(Charset);
					template.merge(context, writer); 
					writer.flush();
					writer.close();
					
					PublishManager.getInstance().clearFileName(1);
					
					//print("itemgid:"+item.getGlobalID()+",status:"+status);
					if(status==1)//审核通过，允许发布出去
						InsertToBePublished(FileName,SiteFolder,channel);
					
					addToGenerateFiles(FileName,item.getGlobalID(),ChannelID,ct.getTemplateID(),TemplateFile.ContentTemplateType,channel.getSiteID());					
				}
				
				
				String Sql = "update " + channel.getTableName() + " set GenerateFileDate=UNIX_TIMESTAMP() where id=" + itemid;
				datasource_tu.executeUpdate(Sql);
			}
			//System.out.println(TemplateName);
     }
%>
<%
int ChannelID = 114;
int ItemID = 25;
			Publish publish = new Publish();
			publish.setPublishType(Publish.ONLY_DOCUMENT_PUBLISH);
			publish.setChannelID(ChannelID);
			publish.setPublishAllItems(0);
			publish.addPublishItems(ItemID);
			publish.GenerateFile();

%>