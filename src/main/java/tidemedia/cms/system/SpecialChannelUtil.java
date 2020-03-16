package tidemedia.cms.system;

import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import tidemedia.cms.base.MessageException;
import tidemedia.cms.base.Table;
import tidemedia.cms.base.TableUtil;
import tidemedia.cms.page.Page;
import tidemedia.cms.page.PageModule;
import tidemedia.cms.util.Util;

public class SpecialChannelUtil extends Table{
	
	public int			SourceChannelID = 0;
	public String		NewChannelName = "";
	private String		NewFolder = "";
	public int			NewChannelParentID = 0;
	public int			newSpecialParentID = 0;//新的专题频道编号
	public int			actionUser = 0;//操作用户
	private boolean		newTemplateFile = false; //true 复制的时候创建新模板文件
	private String		keyword = "";//关键词
	private String		Description = "";//描述
	
	public ArrayList<int[]>	TempTemplates = new ArrayList<int[]>();
	
	public SpecialChannelUtil() throws MessageException, SQLException {
		super();
	}

	public void generateSpecial() throws MessageException, SQLException
	{
		int Parent = NewChannelParentID;
		int SpecialTemplate = SourceChannelID;
		
		if(Parent<=0 || SpecialTemplate<=0)
			return;
		
		Channel sChannel = CmsCache.getChannel(SpecialTemplate);
		Log l = new Log();
		l.setTitle(sChannel.getName());
		l.setUser(actionUser);
		l.setItem(Parent);
		//l.setLogType("审核通过");
		 l.setLogAction(LogAction.special_add);
		l.setFromType("channel");
		l.setFromKey(Parent + "");
		l.Add();
		
		TempTemplates = new ArrayList<int[]>();
		int newchanndlid = copyChannelIncludeChild(Parent,SpecialTemplate);
		copyPageIncludeChild(newSpecialParentID,SpecialTemplate);
		
		//审核发布
		if(newchanndlid>0)
		{
			TableUtil tu = new TableUtil();
			//System.out.println("new:"+newchanndlid);
			Channel newchannel = CmsCache.getChannel(newchanndlid);
			ArrayList cs = newchannel.listAllSubChannels();
			for(int i = 0;i<cs.size();i++)
			{
				Channel c = (Channel)cs.get(i);
				//System.out.println("::"+c.getId()+","+c.getName());
				
				String sql = "select id from " + c.getTableName() + " where Active=1";
				if(c.getType()==Channel.Channel_Type)
					sql += " and Category = 0";
				else if(c.getType()==Channel.Category_Type)
					sql += " and Category = " + c.getId();
				else
					continue;//直接跳出
				
				sql += " limit 20";//只发布20条
				
				//System.out.println(sql);

				ResultSet rs = tu.executeQuery(sql);
				String itemid = "";
				while(rs.next())
				{
					itemid += (itemid.length()>0?",":"")+rs.getInt("id");
				}
				tu.closeRs(rs);
				
				Document d = new Document();
				d.setUser(getActionUser());
				//System.out.println("docuent user:"+getActionUser());
				d.Approve(itemid, c.getId());
				
			}
		}
		
		CmsCache.delUser(actionUser);
	}

	
	//复制页面
	public void copyPageIncludeChild(int Parent,int SourceChannel) throws MessageException, SQLException
	{
		Channel parentChannel = CmsCache.getChannel(Parent);
		Channel sChannel = CmsCache.getChannel(SourceChannel);
		
		ArrayList<Integer> array = sChannel.getChildChannelIDs();
		if(array!=null && array.size()>0)
		{
			for(int i = 0;i<array.size();i++)
			{
				int sourcePageID = (Integer)array.get(i);
				Channel ch = CmsCache.getChannel(sourcePageID);
				
				if(ch.getType()==Channel.Page_Type)
				{
					int newPageID = 0;
					TableUtil tu = new TableUtil();
					String sql = "select id from channel where CopyFromID=" + sourcePageID + " and ChannelCode like '" + parentChannel.getChannelCode() + "%'";
					ResultSet rs = tu.executeQuery(sql);
					if(rs.next())
					{
						newPageID = rs.getInt("id");
					}
					tu.closeRs(rs);
					
					if(newPageID>0)
						copyOnePage(Parent,sourcePageID,newPageID);					
				}
				//2016.3.8  王海龙
				//比如 根是独立频道A，独立频道B是A的子频道，页面C在B下 ，此时如果不使用递归就会导致C的内容不能复制到新的专题中
				copyPageIncludeChild(Parent,sourcePageID);
			}
		}
	}
	
	//复制频道结构，包括子频道
	public int copyChannelIncludeChild(int Parent,int SourceChannel) throws MessageException, SQLException
	{
		Channel sChannel = CmsCache.getChannel(SourceChannel);
		int newParent = 0;
		if(sChannel.getType()==Channel.Channel_Type || sChannel.getType()==Channel.Category_Type)
		{
			//System.out.println("copyChannelIncludeChild:"+Parent+","+sChannel.getId());
			newParent = copyOneChannel(Parent,sChannel);
			if(SourceChannel==SourceChannelID)
			{
				newSpecialParentID = newParent;
				//print("newSpecialParentID:"+newSpecialParentID);
				
				//自动加上权限
				String sql = "insert into channel_privilege (User,Channel,PermType,IsInherit,ParentChannel,CreateDate) values(";
				sql += actionUser + ","+newSpecialParentID+",5,0,0,now()),("+actionUser+","+newSpecialParentID+",1,0,0,now()),";
				sql += "("+actionUser+","+newSpecialParentID+",2,0,0,now()),("+actionUser+","+newSpecialParentID+",3,0,0,now()),";
				sql += "("+actionUser+","+newSpecialParentID+",4,0,0,now())";
				TableUtil tu = new TableUtil();
				tu.executeUpdate(sql);
			}
			//读取全部子频道
			ArrayList<Integer> array = sChannel.getAllChildChannelIDs();
			if(array!=null && array.size()>0)
			{
				//System.out.println(sChannel.getId()+",size:"+array.size());
				for(int i = 0;i<array.size();i++)
				{
					int newSourceChannelID = (Integer)array.get(i);
					//System.out.println(sChannel.getId()+","+i+":"+newParent+","+newSourceChannelID);
					copyChannelIncludeChild(newParent,newSourceChannelID);
				}
			}
		}
		else if(sChannel.getType()==Channel.Page_Type)
		{
			Page sPage = new Page(sChannel.getId());
			Page newPage = new Page();
			
			newPage.setCopyFromID(sChannel.getId());
			newPage.setName(sPage.getName());
			newPage.setParent(Parent);
			newPage.setType(2);
			newPage.setTemplate(sPage.getTemplate());
			newPage.setTargetName(sPage.getTargetName());
			newPage.setCharset(sPage.getCharset());
			newPage.setTemplateID(sPage.getTemplateID());
			newPage.setActionUser(getActionUser());
			
			newPage.Add();
			int id2 = newPage.getId();
			//自动加上权限
			String sql = "insert into channel_privilege (User,Channel,PermType,IsInherit,ParentChannel,CreateDate) values(";
			sql += actionUser + ","+id2+",1,0,0,now()),("+actionUser+","+id2+",2,0,0,now()),("+actionUser+","+id2+",3,0,0,now()),("+actionUser+","+id2+",4,0,0,now());";
			TableUtil tu = new TableUtil();
			tu.executeUpdate(sql);
		}
		return newParent;
	}
	
	public int copyOneChannel(int Parent,Channel sChannel) throws MessageException, SQLException
	{
		if(Parent<=0 || sChannel.getId()<=0)
			return 0;
		
		//Channel sChannel = CmsCache.getChannel(SourceChannelID);
		Channel parent	= CmsCache.getChannel(Parent);
		
		Channel channel = new Channel();
		
		channel.setName(sChannel.getName());
		channel.setFolderName(sChannel.getFolderName());
		
		if(sChannel.getId()==SourceChannelID)
		{
			//是源频道,不是其下面的子频道
			if(NewChannelName.length()>0)
				channel.setName(NewChannelName);
			
			if(NewFolder.length()>0)
				channel.setFolderName(NewFolder);
			//channel.setType2(Channel.ChannelSpecial);
			//System.out.println(channel.getType2());
		}
		
		channel.setParent(Parent);
		channel.setCopyFromID(sChannel.getId());
		channel.setImageFolderName(sChannel.getImageFolderName());
		channel.setSerialNo(parent.getAutoSerialNo());
		channel.setIsDisplay(sChannel.getIsDisplay());
		channel.setIsWeight(sChannel.getIsWeight());
		channel.setIsComment(sChannel.getIsComment());
		channel.setIsClick(sChannel.getIsClick());
		channel.setIsShowDraftNumber(sChannel.getIsShowDraftNumber());

		channel.setType(sChannel.getType());
		channel.setHref(sChannel.getHref());
		channel.setAttribute1(sChannel.getAttribute1());
		channel.setAttribute2(sChannel.getAttribute2());
		channel.setRecommendOut(sChannel.getRecommendOut());
		channel.setRecommendOutRelation(sChannel.getRecommendOutRelation());
		channel.setExtra1(sChannel.getExtra1());
		channel.setExtra2(sChannel.getExtra2());
		channel.setListJS(sChannel.getListJS());
		channel.setDocumentJS(sChannel.getDocumentJS());
		channel.setListProgram(sChannel.getListProgram());
		channel.setDocumentProgram(sChannel.getDocumentProgram());
		channel.setTemplateInherit(sChannel.getTemplateInherit());
		
		channel.setActionUser(getActionUser());
		//System.out.println("serial:"+channel.getSerialNo());
		channel.Add();
		
		if(sChannel.getId()==SourceChannelID)
		{
			channel.updateType2(Channel.ChannelSpecial);
		}
		
		TableUtil tutu = new TableUtil();
		tutu.executeUpdate("delete from channel_template where Channel="+channel.getId());
		
		if(channel.getType()==Channel.Channel_Type)
		{
			//复制表单组,先删除字段组和字段描述
			tutu.executeUpdate("delete from field_group where Channel="+channel.getId());
			//tutu.executeUpdate("delete from field_desc where ChannelID="+channel.getId());
			
			ArrayList<FieldGroup> fieldGroups = sChannel.getFieldGroupInfo();
			for(int i = 0;i<fieldGroups.size();i++)
			{
				FieldGroup fieldGroup = (FieldGroup)fieldGroups.get(i);
				
				FieldGroup newgroup = new FieldGroup(fieldGroup.getId());
				newgroup.setChannel(channel.getId());
				//print("fieldGroup:"+fieldGroup.getId()+","+fieldGroup.getName()+",parent:"+Parent);
				//if(!isExist("select id from field_group where Channel="+channel.getId()+" and Name='" + SQLQuote(fieldGroup.getName()) + "'"))
				newgroup.Add();
			}
			
			//复制表单
			ArrayList<Field> fieldInfo = sChannel.getFieldInfo();
			for(int i = 0;i<fieldInfo.size();i++)
			{
				Field field = (Field)fieldInfo.get(i);				
				
				int oldGroupID = field.getGroupID();
				int newGroupID = 0;
				int newfieldid = 0;
				String sql = "";
				TableUtil tu = new TableUtil();
				ResultSet rs = null;
				try{
				//print("oldGroupID:"+oldGroupID);
				
				if(oldGroupID>0)
				{
					FieldGroup fieldGroup = new FieldGroup(oldGroupID);
					sql = "select id from field_group where Channel="+channel.getId()+" and Name='" + SQLQuote(fieldGroup.getName()) + "'";
					//print(sql);
					
					rs = tu.executeQuery(sql);
					if(rs.next())
						newGroupID = rs.getInt("id");
					tu.closeRs(rs);
				}
				
				
				
				//print("field:"+field.getName()+","+channel.getId());
				//System.out.println("channelid_"+channel.getId());
				
				sql = "select id from field_desc where ChannelID="+channel.getId()+" and FieldName='"+ field.getName() + "'";
				rs = tu.executeQuery(sql);
				if(rs.next())
				{
					newfieldid = rs.getInt("id");
				}
				tu.closeRs(rs);
				
				
				Field newf = new Field(field.getId());
				newf.setGroupID(newGroupID);
				newf.setChannelID(channel.getId());
				
				
				if(newfieldid>0)
				{
					//System.out.println("select id from field_desc where ChannelID="+channel.getId()+" and FieldName='"+ field.getName() + "'");
					//System.out.println("channelid:"+channel.getId()+",s channelid:"+sChannel.getId());	
					newf.setId(newfieldid);
					newf.Update();
				}
				else
					newf.Add();
				
				}catch(Exception e){
					//print("newGroupID:"+newGroupID);
					ErrorLog.Log("专题","创建专题复制表单出错",e.getMessage());
					//e.printStackTrace(System.out);
				}
			}
		}
		
		int groupid = 0;
		String sql = "select id from template_group where SerialNo='copy_template'";
		TableUtil tu = new TableUtil();
		ResultSet rs = tu.executeQuery(sql);
		if(rs.next())
			groupid = rs.getInt("id");
		tu.closeRs(rs);
		
		//复制模板
		ArrayList<ChannelTemplate> templates = sChannel.getChannelTemplates();
		for(int i = 0;i<templates.size();i++)
		{			
			ChannelTemplate ct1 = (ChannelTemplate)templates.get(i);
			//System.out.println("ct1:"+ct1.getFullTargetName()+","+ct1.getId());
			int new_templateid = 0;
			
			//模板文件也重新拷贝一份
			if(newTemplateFile)
			{
				//System.out.println("size:"+TempTemplates.size());
				for(int j = 0;j<TempTemplates.size();j++)
				{
					int j1[] = (int[])TempTemplates.get(j);
					//System.out.println(ct1.getTemplateID()+","+j1[0]+","+j1[1]);
					if(j1[0]==ct1.getTemplateID())
					{
						new_templateid = j1[1];
						break;
					}
				}
				
				if(new_templateid==0)
				{
					/*复制模板文件*/
					TemplateFile tf1 = ct1.getTemplateFile();
		
					TemplateFile tf = new TemplateFile();
					tf.setGroup(groupid);
					tf.setContent(tf1.getContent());
					tf.setName(tf1.getName());
					tf.setTitle(tf1.getTitle());
					tf.setFileName(System.currentTimeMillis()+"_"+tf1.getFileName());
					tf.Add();
					new_templateid = tf.getId();
					//System.out.println(ct1.getTemplateID()+","+new_templateid);
					int[] o = {ct1.getTemplateID(),new_templateid};
					TempTemplates.add(o);
				}
			}
			else
				new_templateid = ct1.getTemplateID();
			
			//System.out.println("new_templateid:"+new_templateid);
			ChannelTemplate ct = new ChannelTemplate();
			ct.setTemplateID(new_templateid);			
			ct.setChannelID(channel.getId());
			ct.setLinkTemplate(0);
			ct.setTargetName(ct1.getTargetName());
			ct.setLabel(ct1.getLabel());
			ct.setTemplateType(ct1.getTemplateType());
			ct.setCharset(ct1.getCharset());
			ct.setRowsPerPage(ct1.getRowsPerPage());
			ct.setSubFolderType(ct1.getSubFolderType());
			ct.setFileNameType(ct1.getFileNameType());
			ct.setRows(ct1.getRows());
			ct.setTitleWord(ct1.getTitleWord());

			ct.Add();
		}
		
		//复制内容
		sql = "select id from " + sChannel.getTableName() + " where Status=1 and Active=1";
		if(sChannel.getType()==Channel.Channel_Type)
			sql += " and Category = 0";
		else if(sChannel.getType()==Channel.Category_Type)
			sql += " and Category = " + sChannel.getId();
			
		sql += " order by OrderNumber asc limit 20";
		//System.out.println("copy:"+sql);
		rs = tu.executeQuery(sql);
		while(rs.next())
		{
			int itemid = rs.getInt("id");
			ItemUtil.CopyDocuments(itemid+"", sChannel.getId(),channel.getId(),0,channel.getId(),getActionUser());
		}
		tu.closeRs(rs);
		
		return channel.getId();
	}
	
	public int copyOnePage(int parent,int sourcePageID,int newPageID) throws MessageException, SQLException
	{
		print("sourcePageID:"+sourcePageID+",new:"+newPageID);
		if(sourcePageID<=0 || newPageID<=0)
			return 0;
		
		Channel parentChannel = CmsCache.getChannel(parent);
		Page newPage = new Page(newPageID);
		Page sPage = new Page(sourcePageID);
		//拷贝文件
		
		String sFilePath = sPage.getFullPathFile();
		String newFilePath = newPage.getFullPathFile();
		String charset = sPage.getCharset();
 		if(charset.equals(""))
 		{
 			if(sPage.getSite().getCharset().equals(""))
 				charset = "utf-8";
 			else
 				charset = sPage.getSite().getCharset();
 		}
		String content = "";
		
		

			content = sPage.getContent();
		
		//复制模块
		TableUtil tu = new TableUtil();
		String Sql = "select * from page_module where Page=" + sPage.getId();
		ResultSet Rs = tu.executeQuery(Sql);
		while(Rs.next())
		{
			int moduleid = Rs.getInt("id");
			
			PageModule pm = new PageModule(moduleid);
			
			if(pm.getType()==PageModule.ModuleDirectEdit)
			{
				//直接维护数据
				pm.setPage(newPage.getId());
				pm.Add();
				
				content = content.replace("<!-- TideCMS Module " + moduleid + " begin -->", "<!-- TideCMS Module " + pm.getId() + " begin -->");
				content = content.replace("<!-- TideCMS Module " + moduleid + " end   -->", "<!-- TideCMS Module " + pm.getId() + " end   -->");
			}
			else if(pm.getType()==PageModule.ModuleChannelTemplate)
			{
				//数据从频道中获取
				pm.setPage(newPage.getId());
				
				int newChannelID = 0;
				int newChannelTemplateID = 0;
				TableUtil tutu = new TableUtil();
				ChannelTemplate ct = new ChannelTemplate(pm.getTemplate());
				//Channel oldChannel = CmsCache.getChannel(ct.getChannelID());
				//Channel parentChannel = newPage.getParentChannel();
				String sql = "select id from channel where CopyFromID=" + ct.getChannelID() + " and ChannelCode like '" + parentChannel.getChannelCode() + "%'";
				
				ResultSet rs = tutu.executeQuery(sql);
				if(rs.next())
					newChannelID = rs.getInt("id");
				
				tutu.closeRs(rs);
				
				int new_templateid = 0;
				
				if(newTemplateFile)
				{
					for(int j = 0;j<TempTemplates.size();j++)
					{
						int j1[] = (int[])TempTemplates.get(j);
						//System.out.println(ct1.getTemplateID()+","+j1[0]+","+j1[1]);
						if(j1[0]==ct.getTemplateID())
						{
							new_templateid = j1[1];
							break;
						}
					}
				}
				else
					new_templateid = ct.getTemplateID();
					
				sql = "select id from channel_template where Channel="+newChannelID+ " and TemplateID=" + new_templateid;
				print(sql);
				rs = tutu.executeQuery(sql);
				if(rs.next())
					newChannelTemplateID = rs.getInt("id");
				tutu.closeRs(rs);
				
				pm.setTemplate(newChannelTemplateID);
				pm.Add();
				
				content = content.replace("<!-- TideCMS Module " + moduleid + " begin -->", "<!-- TideCMS Module " + pm.getId() + " begin -->");
				content = content.replace("<!-- TideCMS Module " + moduleid + " end   -->", "<!-- TideCMS Module " + pm.getId() + " end   -->");
				
				String s1 = "<!-- TideCMS Module " + pm.getId() + " begin -->";
				String s2 = "<!-- TideCMS Module " + pm.getId() + " end   -->";
				String s3 = "";
				try {
					s3 = pm.getContent() + "";
				} catch (IOException e) {
					e.printStackTrace();
				}
				int index1 = content.indexOf(s1);
				int index2 = content.indexOf(s2);
				if(index1!=-1 && index2!=-1)
					content = content.substring(0,index1+s1.length()) + s3 + content.substring(index2);
			}
		}
		tu.closeRs(Rs);
		
		//增加关键词和描述
		content = insertKeywrodDescription(content);
		
		newPage.setActionUser(getActionUser());
		newPage.setContent(content);
		newPage.savePage();
		
		return newPage.getId();
	}
	
	//增加关键词和描述
	private String insertKeywrodDescription(String s)
	{
		//读取<head>和<body>之前的内容
		int ii = s.indexOf("<head>");
		int jj = s.indexOf("</head>");
		if(ii!=-1 && jj!=-1)
		{
			String s1 = s.substring(0, ii+6);
			String s2 = s.substring(ii+6,jj);
			String s3 = s.substring(jj);
			
			String s2_ = "";
			boolean haskeyword = false;
			boolean hasdesc = false;
			String[] ss = Util.StringToArray(s2, "\r\n");
			for(int i = 0;i<ss.length;i++)
			{
				String ss_ = ss[i];
				if(ss[i].indexOf("<meta name=\"keywords\"")!=-1)
				{
					ss_ = "<meta name=\"keywords\" content=\""+getKeyword()+"\"/>";
					haskeyword = true;
				}
				if(ss[i].indexOf("<meta name=\"description\"")!=-1)
				{
					ss_ = "<meta name=\"description\" content=\""+getDescription()+"\"/>";
					hasdesc = true;
				}
				s2_ += "\r\n"+ss_;
			}
			
			s = s1+"\r\n";
			if(!haskeyword) s+= "\r\n<meta name=\"keywords\" content=\""+getKeyword()+"\"/>";
			if(!hasdesc) s+= "\r\n<meta name=\"description\" content=\""+getDescription()+"\"/>";
			
			s+= s2_+"\r\n"+s3;
		}
		return s;
	}
	
	public void Add() throws SQLException, MessageException {

	}

	public void Delete(int id) throws SQLException, MessageException {
	}

	public void Update() throws SQLException, MessageException {
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

	public int getSourceChannelID() {
		return SourceChannelID;
	}

	public void setSourceChannelID(int sourceChannelID) {
		SourceChannelID = sourceChannelID;
	}

	public String getNewChannelName() {
		return NewChannelName;
	}

	public void setNewChannelName(String newChannelName) {
		NewChannelName = newChannelName;
	}

	public int getNewChannelParentID() {
		return NewChannelParentID;
	}

	public void setNewChannelParentID(int newChannelParentID) {
		NewChannelParentID = newChannelParentID;
	}

	public void setNewFolder(String newFolder) {
		NewFolder = newFolder;
	}

	public String getNewFolder() {
		return NewFolder;
	}

	public int getActionUser() {
		return actionUser;
	}

	public void setActionUser(int actionUser) {
		this.actionUser = actionUser;
	}

	public void setNewTemplateFile(boolean newTemplateFile) {
		this.newTemplateFile = newTemplateFile;
	}

	public boolean isNewTemplateFile() {
		return newTemplateFile;
	}

	public String getKeyword() {
		return keyword;
	}

	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}

	public String getDescription() {
		return Description;
	}

	public void setDescription(String description) {
		Description = description;
	}
}
