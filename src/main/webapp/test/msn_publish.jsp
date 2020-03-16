<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,tidemedia.cms.publish.*,java.util.*,java.io.*,org.apache.velocity.*,org.apache.velocity.app.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

Channel channel = CmsCache.getChannel(4380);
Publish publish = new Publish();
String ErrorMessage = "";
TableUtil tu = new TableUtil();
VelocityContext context = new VelocityContext(); 
VelocityEngine ve = new VelocityEngine();
		//发布内容页面,id=0 发布全部纪录
		String FolderName = "";
		String Charset = "";
		String SiteFolder = channel.getSite().getSiteFolder();
		FolderName = channel.getFullPath() + "/"; 
		//System.out.println(FolderName);
		ArrayList<ChannelTemplate> templatefiles = new ArrayList<ChannelTemplate>();
		
		templatefiles = channel.getChannelTemplates(2);//获取内容页模板列表
     	
		for(int iii = 0;iii<templatefiles.size();iii++)
		{
			ChannelTemplate ct = (ChannelTemplate)templatefiles.get(iii);
			out.println(ct.getTemplateFile().getId());
			if(ct.getTemplateFile().getId()!=1697)
				continue;
			
     		ErrorMessage = "模板：" + ct.getTemplateFile().getName() + "\r\n<br>";
     		ErrorMessage += "频道：" + channel.getParentChannelPath() + " ("+channel.getId()+")"+"\r\n<br>";
     		
     		Charset = "utf-8";

			String ListItemsSql = "select id,Title,CreateDate,Category,TotalPage,PublishDate from " + channel.getTableName() + " where (Status=1 or Status=0) and Active=1 ";
			
			File file = new File(SiteFolder + "/" + FolderName);
			if(!file.exists())
				file.mkdirs();
			file = null;
					
			ArrayList publishitems = new ArrayList();
			//Category category = new Category();
			String oldFolderName = "";
     		//System.out.println("sql:"+ListItemsSql);
			ResultSet rs = null;
			try{rs = tu.executeQuery(ListItemsSql);}
	     	catch (Exception e) {
	     		ErrorLog.SaveErrorLog("查询错误.",ErrorMessage,e);
				e.printStackTrace(System.out);
			}
	     	java.util.Calendar publishdate = new java.util.GregorianCalendar();
			while(rs!=null && rs.next())
			{
				//Publish.Items items = new Publish.Items();
				int itemid = rs.getInt("id");
				out.println("<br>"+itemid);
				String title = convertNull(rs.getString("Title"));
				String createDate = convertNull(rs.getString("CreateDate"));
				publishdate.setTimeInMillis(rs.getLong("PublishDate")*1000);
				int totalpage = rs.getInt("TotalPage");
				int PublishYear = publishdate.get(Calendar.YEAR);
				int PublishMonth = publishdate.get(Calendar.MONTH) + 1;
				int PublishDay = publishdate.get(Calendar.DATE);
					
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
							
				for(int j=1;j<=totalpage;j++)
				{
					//String itemfileprefix = (ct.getItemFilePrefix().equals("")?"":(ct.getItemFilePrefix()+"_"))+itemid;
					
					Controller controller = new Controller();
					controller.setChannelID(channel.getId());
					controller.setChannel(channel);//设置channel对象，避免在controller中再次初始化
					controller.setItemID(itemid);
					controller.setItemPage(j);
	     			controller.setPublishMode(2);//静态发布

	     			Document item = controller.getItem();
	     			
					String filePreName = "";
					if(ct.getFileNameType()==0)
					{
						if(ct.getItemFilePrefix().equals(""))
							filePreName = itemid + "";
						else
							filePreName = ct.getItemFilePrefix() + "_" + itemid;
					}else if(ct.getFileNameType()==1)
					{
					}
					else if(ct.getFileNameType()==2)
					{	
						int random= item.getRandom();
						
						if(random==0)
						{
							random = new java.util.Random().nextInt(999)+1;
							item.updateRandom(random);
						}

						filePreName=(createDate)+random;
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
					
					Template template = new Template();
					//template = ve.getTemplate(ct.getTemplate(),Charset);
					//Charset = "GB2312";
					
					//print("template content:"+ct.getTemplateFile().getContent());
					String templateContent = ct.getTemplateFile().getContent();
					templateContent = templateContent.replaceFirst("<head>", "<head>\r\n<meta name=\"publisher\" content=\"TideCMS\">");
					template = ve.getTemplate(templateContent,"utf-8");
					//template.setData("a");
					//System.out.println(fullFileName);
					Writer writer = new OutputStreamWriter(new FileOutputStream(fullFileName),Charset);
					template.setEncoding(Charset);
					template.merge(context, writer); 
					writer.flush();
					writer.close();
					
					
					//print("itemgid:"+item.getGlobalID()+",status:"+status);
					if(status==1)//审核通过，允许发布出去
						publish.InsertToBePublished(FileName,SiteFolder,channel);
					
					publish.addToGenerateFiles(FileName,item.getGlobalID(),channel.getId(),ct.getTemplateID(),TemplateFile.ContentTemplateType);
				}
			}
			tu.closeRs(rs);
			//System.out.println(TemplateName);
		} 
%>
<br>Over!