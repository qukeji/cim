<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!	public  String DeCode(String str) {
		if (str == null)
			return "";
		try {
			String temp_p = str;
			byte[] temp_t = temp_p.getBytes("GBK");
			String temp = new String(temp_t, "iso-8859-1");
			return temp;
		} catch (Exception e) {
		}
		return "";
	}
%>
<%/*! public void removeItems(int channelid,TableUtil tu) throws SQLException,MessageException
{
	String Sql = "select * from channel where Parent=" + channelid;
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		removeItems(Rs.getInt("id"),tu);

		if(Rs.getInt("Type")==0 && Rs.getInt("Parent")!=-1)
		{
			tu.executeUpdate("TRUNCATE  channel_"+Rs.getString("SerialNo"));
		}
		System.out.println("<br>"+Rs.getString("SerialNo")+".....clear");
	}
}*/
%>
<%! public void templateFile(java.io.File[] files,int parent,String rootfolder) throws SQLException,MessageException
{
	if(files!=null){
	for(int i = 0;i<files.length;i++)
	{
		//System.out.println(files[i].getName()+"<br>");
		
		if(files[i].isDirectory())
		{
			TemplateGroup tg = new TemplateGroup();
			tg.setName(files[i].getName());
			tg.setParent(parent);
			tg.Add();

			templateFile(files[i].listFiles(),tg.getId(),rootfolder);
		}
		else
		{
			//System.out.println("add template file...");
			TemplateFile tf = new TemplateFile(files[i].getPath().replace(rootfolder,""));

			if(tf.getName().equals("")) tf.setName(files[i].getName());
			tf.setFileName(files[i].getName());
			tf.setGroup(parent);

			String TotalString = "";
			try{
			java.io.BufferedReader in = new java.io.BufferedReader(new java.io.InputStreamReader(new java.io.FileInputStream(files[i]),"utf-8"));
			String LineString;
			while ((LineString = in .readLine())!=null)
			{
				TotalString += LineString+"\r\n";
			}
			}catch(Exception e){System.out.println(e.getMessage());}
			//System.out.println(TotalString);
			tf.setContent(TotalString);

			if(tf.getId()>0)
			{
				tf.Update();
			}
			else
			{
				tf.Add();
			}
			//System.out.println("add template file...end");
		}
	}
	}
}
%>
<%

//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
ResultSet rs;
TableUtil tu = new TableUtil();
TableUtil tutu = new TableUtil();
//Start 清空所有频道的内容
/*
Sql = "select * from channel";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	if(Rs.getInt("Type")==0 && Rs.getInt("Parent")!=-1)
	{
		tu.executeUpdate("TRUNCATE  channel_"+Rs.getString("SerialNo"));
	}
}
*/
//End 清空所有频道的内容


//Start 清空某一频道下所有频道的内容
/*
int channelid = 718;
Sql = "select * from channel where id=" + channelid;
Rs = tu.executeQuery(Sql);
if(Rs.next())
{
	removeItems(channelid,tu);
	if(Rs.getInt("Type")==0 && Rs.getInt("Parent")!=-1)
	{
		tu.executeUpdate("TRUNCATE  channel_"+Rs.getString("SerialNo"));
	}
}
*/
//End 清空某一频道下所有频道的内容

//Start 增加字段OrderNumber
///*
//Sql = "select * from channel where Type=0";
//Rs = tu.executeQuery(Sql);
//while(Rs.next())
//{
/*
	try{
	tu.executeUpdate("ALTER TABLE channel_" + Rs.getString("SerialNo")+" ADD OrderNumber int default 0");
	}
	catch(Exception e)
	{
	}*/
	
	//重新排序
	//tu.executeUpdate("update channel_" + Rs.getString("SerialNo")+" set OrderNumber=id");



	//try{
	//tu.executeUpdate("ALTER TABLE channel_" + Rs.getString("SerialNo")+" CHANGE Category Category INT DEFAULT NULL ");

	//2005-06-04
	//每个频道表增加ModifiedDate字段
	//tu.executeUpdate("ALTER TABLE channel_" + Rs.getString("SerialNo")+" ADD ModifiedDate datetime");

	//2005-06-05
	//每个频道表增加Active字段，值为1
	//tu.executeUpdate("ALTER TABLE channel_" + Rs.getString("SerialNo")+" ADD Active tinyint");
	//tu.executeUpdate("update channel_" + Rs.getString("SerialNo")+" set Active=1");

	//2005-08-18
	//每个频道表修改Content字段为mediumtext
	//tu.executeUpdate("ALTER TABLE channel_" + Rs.getString("SerialNo")+" CHANGE Content Content mediumtext");

	//2005-11-18
	//每个频道表增加GenerateFileDate字段
	//tu.executeUpdate("ALTER TABLE channel_" + Rs.getString("SerialNo")+" ADD GenerateFileDate datetime");

	//}
	//catch(Exception e)
	//{
	//}
//out.println(Rs.getString("SerialNo")+"<br>");
//}
//tu.closeRs(Rs);
//*/
//End 增加字段OrderNumber

//2005-06-04
//channel_template 表增加Charset字段
//tu.executeUpdate("ALTER TABLE channel_template ADD Charset varchar(40)");

//2005-06-07
//channel 表增加Href字段
//tu.executeUpdate("ALTER TABLE channel ADD Href varchar(255)");

//2005-06-17
//counter_visit 表增加PageName字段
//tu.executeUpdate("ALTER TABLE counter_visit ADD PageName varchar(255)");

//2005-07-14
//channel_template 表增加SubFolderType字段
//tu.executeUpdate("ALTER TABLE channel_template ADD SubFolderType tinyint");

//2005-07-26
//channel_template 表增加Category字段
//tu.executeUpdate("ALTER TABLE channel_template ADD Category int");

//2005-09-07
//channel_template 表增加Category字段
//tu.executeUpdate("ALTER TABLE channel_template ADD Rows int");

//2005-09-07
//channel_template 表增加Category字段
//tu.executeUpdate("ALTER TABLE page_module ADD ModuleType tinyint");
//tu.executeUpdate("ALTER TABLE page_module ADD Content text");

//2005-09-27
//userinfo 表增加GroupID字段
//tu.executeUpdate("ALTER TABLE userinfo ADD GroupID int DEFAULT 0");

//2005-11-02
//shortcut 表增加Icon字段
//tu.executeUpdate("ALTER TABLE shortcut ADD Icon varchar(250)");

//2005-11-17
//设置根频道表单
//Channel ch = new Channel();
//ch.setName("网站");ch.setParent(-1);ch.setSerialNo("webroot");ch.setFolderName("/");ch.setImageFolderName("/images");ch.Add();

//2005-11-17
//v4.5 修改根频道表单
//Channel ch = new Channel(0);
//ch.setSerialNo("webroot");ch.setFolderName("/");ch.setImageFolderName("/images");ch.Update();ch.createChannelTable();
//tu.executeUpdate("update channel set FolderName='/',SerialNo='webroot' where Parent=-1");

//2005-11-18
//publish_task 表增加PublishAllItems字段
//tu.executeUpdate("ALTER TABLE publish_task ADD PublishAllItems tinyint");

//2005-11-21
//v4.5 channel_template 表增加IsInherit字段
//tu.executeUpdate("ALTER TABLE channel_template ADD IsInherit tinyint");

//2005-11-22
//v4.5 channel_template 表处理,取消分类
//tu.executeUpdate("update channel_template set Channel=Category where Category>0");

//2005-11-22
//v4.5 处理原分类的索引页和内容页模板
/*
Sql = "select * from channel where Type=1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
				ChannelTemplate ct = new ChannelTemplate();
				ct.setTemplate("");
				ct.setTemplateType(1);
				ct.setChannelID(Rs.getInt("id"));
				ct.setIsInherit(1);
				ct.Add();

				ct.setTemplate("");
				ct.setTemplateType(2);
				ct.setChannelID(Rs.getInt("id"));
				ct.setIsInherit(1);
				ct.Add();
}
*/

//2005-11-23
//v4.5 更新原分类的目录
//tu.executeUpdate("update channel set FolderName=SerialNo where Type=1");

//2006-02-21
//v4.5 field_desc 表增加IsNull字段
//tu.executeUpdate("ALTER TABLE field_desc ADD IsNull tinyint");

//2006-02-23
//channel_template 表增加TitleWord字段
//tu.executeUpdate("ALTER TABLE channel_template ADD TitleWord int");

//2006-03-24
//tidemedia_comment 表增加Url字段
//tu.executeUpdate("ALTER TABLE tidemedia_comment ADD Url varchar(255)");

//2007-09-1
//field_desc 表增加ChannelID字段
//tu.executeUpdate("ALTER TABLE field_desc ADD ChannelID int");

//2007-09-1
//field_options 表增加ChannelID字段
//tu.executeUpdate("ALTER TABLE field_options ADD ChannelID int");

//2007-09-1
//为field_desc表中ChannelID为0的记录设置正确的ChannelID值
/*
Sql = "select field_desc.id,channel.id from field_desc left join channel on field_desc.Channel=channel.SerialNo where field_desc.ChannelID=0 or field_desc.ChannelID is null";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int fieldid = Rs.getInt("field_desc.id");
	int channelid = Rs.getInt("channel.id");

	Sql = "update field_desc set ChannelID=" + channelid + " where id=" + fieldid;
	tu.executeUpdate(Sql);
}
tu.closeRs(Rs);

Sql = "select field_options.id,channel.id from field_options left join channel on field_options.Channel=channel.SerialNo where field_options.ChannelID=0 or field_options.ChannelID is null";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int fieldid = Rs.getInt("field_options.id");
	int channelid = Rs.getInt("channel.id");

	Sql = "update field_options set ChannelID=" + channelid + " where id=" + fieldid;
	tu.executeUpdate(Sql);
}
tu.closeRs(Rs);
*/
//2007-09-1
//为field_desc表字段设置序号
//Sql = "update field_desc set OrderNumber=id where OrderNumber=0";
//tu.executeUpdate(Sql);

//2007-10-11
//增加page_module_content 表
//Sql = "CREATE TABLE `page_module_content` (  `id` int(11) NOT NULL auto_increment,  `Page` int(11) NOT NULL default '0',  `Module` int(11) NOT NULL default '0',  `Content` text,  CreateDate datetime, UNIQUE KEY `id` (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
//tu.executeUpdate(Sql);

//2007-10-15
//增加tidecms_log 表
//Sql = "CREATE TABLE `tidecms_log` (  `id` int(11) NOT NULL auto_increment,  LogType varchar(255),  Title varchar(255),  `Content` text,  Item int(11),  FromType varchar(255),FromKey varchar(255),  Key1 varchar(100),  Key2 varchar(100),  Key3 varchar(100),User int(11), `CreateDate` datetime,  UNIQUE KEY `id` (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
//tu.executeUpdate(Sql);

//2007-10-29
//publish_scheme 表增加IncludeFolders,ExcludeFolders字段
//tu.executeUpdate("ALTER TABLE publish_scheme ADD IncludeFolders text");
//tu.executeUpdate("ALTER TABLE publish_scheme ADD ExcludeFolders text");

//2007-11-21
//page_module 表增加TemplateFile字段
//tu.executeUpdate("ALTER TABLE page_module ADD TemplateFile varchar(255)");

//2007-12-05
//channel 表增加LinkChannel字段
//tu.executeUpdate("ALTER TABLE channel ADD LinkChannel int");

//2007-12-07
//page_module_content 表增加LinkChannel字段
//tu.executeUpdate("ALTER TABLE page_module_content ADD User int");

//2008-3-31
//增加field_group 表
//Sql = "CREATE TABLE field_group (id int(11) NOT NULL auto_increment,  Name varchar(255),  Channel int(11),OrderNumber int,CreateDate datetime,  UNIQUE KEY `id` (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
//tu.executeUpdate(Sql);

//2008-04-02
//field_desc 表增加GroupID字段
//tu.executeUpdate("ALTER TABLE field_desc ADD GroupID int default 0");

//2008-4-28
//增加site 表
//Sql = "CREATE TABLE site (  id int(11) NOT NULL auto_increment,  Name		varchar(20) not null,  SiteFolder	varchar(250),  Url		varchar(250),  TemplateFolder varchar(250),  BackupFolder	varchar(250),  FileExt	varchar(100),  Charset	varchar(100),  OtherModuleAddress	varchar(250),  SleepTime	int,  CreateDate	DateTime,  Status	tinyint,  Type		tinyint,  UNIQUE KEY id (id)) AUTO_INCREMENT=1 ;";
//tu.executeUpdate(Sql);

//Sql = "insert into site(Name,Type,CreateDate) values ('default site',1,now())";
//tu.executeUpdate(Sql);

//2008-05-06
//channel 表增加Site字段
//tu.executeUpdate("ALTER TABLE channel ADD Site int");
/*Site s = new Site();
s.setName("default");
s.setType(1);
s.Add();*/

//2008-05-16
//channel 表增加Site字段
//tu.executeUpdate("ALTER TABLE publish_scheme ADD Site int");

//2008-05-26
//tidecms_log 表增加Site字段
//tu.executeUpdate("ALTER TABLE tidecms_log ADD Site int");

//2008-07-15
//channel_template 表增加WhereSql,LinkTemplate字段
//tu.executeUpdate("ALTER TABLE channel_template ADD WhereSql varchar(255)");
//tu.executeUpdate("ALTER TABLE channel_template ADD LinkTemplate int");

//2008-07-15
//channel_video 表增加Video5,Video6字段
//tu.executeUpdate("ALTER TABLE channel_video ADD Video5 varchar(255)");
//tu.executeUpdate("ALTER TABLE channel_video ADD Video6 varchar(255)");

//2008-07-16
//field_desc 表增加RecommendChannel,RecommendValue字段
//tu.executeUpdate("ALTER TABLE field_desc ADD RecommendChannel varchar(255)");
//tu.executeUpdate("ALTER TABLE field_desc ADD RecommendValue varchar(255)");

//2008-07-17
//channel_template 表增加Lable字段
//tu.executeUpdate("ALTER TABLE channel_template ADD Lable varchar(255)");

//2008-09-10
//site 表增加ContentChannelSerialNo字段
//tu.executeUpdate("ALTER TABLE site ADD ContentChannelSerialNo varchar(255)");



//2008-09-13
//设置ChannelCode
//tu.executeUpdate("update Channel set ChannelCode=id where Parent=-1");

/*
Sql = "select * from channel where Parent=-1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	new Channel().UpdateChannelCode(channelid);
}
*/

//更新item_snap的ChannelCode
/*
Sql = "select * from item_snap";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int gid = Rs.getInt("GlobalID");
	int channelid = Rs.getInt("ChannelID");
	int itemid = Rs.getInt("ItemID");

	try{
	Channel ch = CmsCache.getChannel(channelid);

	Sql = "update item_snap set ChannelCode='" + ch.getChannelCode() + "' where GlobalID=" + gid;
	new TableUtil().executeUpdate(Sql);
	Sql = "update item_snap set OrderNumber=" + new Document(itemid,channelid).getOrderNumber() + " where GlobalID=" + gid;
	new TableUtil().executeUpdate(Sql);
	}catch(Exception e){}
}
*/

//更新item_snap
/*
Sql = "select * from channel where 	Type=0";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	new Channel().UpdateItemSnap(channelid);
} */

//2008-09-13
//增加GlobalID字段

/*
Sql = "select * from channel where Parent=-1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	new Channel().UpdateField(channelid," add GlobalID int");
}
*/

//2008-09-13
//增加SubTitle字段	   insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(181,'SubTitle','ff','text',1,0)

/*
Sql = "select * from channel where Parent=-1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	new Channel().UpdateField(channelid," add SubTitle varchar(255)");
}


Sql = "select * from channel where Parent=-1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	new Channel().UpdateField(channelid," add Tag varchar(255)");
}

Sql = "select * from channel where Parent=-1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	new Channel().UpdateField(channelid," add Keyword varchar(255)");
}
*/
//2008-09-15
//field_group 表增加Extra字段
//tu.executeUpdate("ALTER TABLE field_group ADD Extra text");

//2008-09-16
//增加related_doc表
//tu.executeUpdate("CREATE TABLE related_doc (id int(10) unsigned NOT NULL auto_increment,RelatedGlobalID int(10) unsigned default NULL,  `RelatedOrder` int(10) unsigned default NULL,  `RelatedStatus` int(10) unsigned default NULL,  `RelatedTitle` varchar(255) default NULL,RelatedChannelID int(10),RelatedItemID int(10),GlobalID int(10) unsigned default NULL,ChannelID int(10),  PRIMARY KEY  (`id`))");

//2008-09-18
//设置GlobalID的值

/*
Sql = "select * from channel where Type=0";
rs = tutu.executeQuery(Sql);
while(rs.next())
{
	int channelid = rs.getInt("id");
	Channel ch = new Channel(channelid);
	Sql = "SELECT * FROM " + ch.getTableName() + " where GlobalID is null;";
	Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		int itemid = Rs.getInt("id");
		//tidemedia.cms.video.Item item = new tidemedia.cms.video.Item(itemid);
		//if(item.getModifiedDate().equals("")) item.setModifiedDate("2008-9-18");
		//new ItemSnap().Add(item);

		Document document = new Document(itemid,channelid);
		new ItemSnap().Add(document);//加入全局库
	}
	tu.closeRs(Rs);
}
tutu.closeRs(rs);
*/

/*
Sql = "SELECT * FROM item_snap where ChannelCode like '1_304_32%'";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int gid = Rs.getInt("GlobalID");
	int itemid = Rs.getInt("ItemID");
	tidemedia.cms.video.Item item = new tidemedia.cms.video.Item(itemid);
	
	tutu.executeUpdate("update item_snap set Status=" + item.getStatus() + ",OrderNumber="+item.getOrderNumber() + " where GlobalID=" + gid);
}
*/

//2008-12-30
//增加图片新闻字段描述

/*
Sql = "select * from channel where Type=0";
rs = tutu.executeQuery(Sql);
while(rs.next())
{
	int channelid = rs.getInt("id");
	
	Sql = "insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(";
	Sql += channelid + ",'IsPhotoNews','图片新闻','text',1,0)";
	tu.executeUpdate(Sql);

	CmsCache.delChannel(channelid);

}
tutu.closeRs(rs);
*/

//2008-12-30
//补充parent_child_item的ChannelCode字段

/*
Sql = "select * from parent_child_item";
rs = tutu.executeQuery(Sql);
while(rs.next())
{
	int itemid = rs.getInt("id");
	int pid = rs.getInt("Parent");
	int cid = rs.getInt("Child");
	
	Document pd = new Document(pid);
	Document cd = new Document(cid);

	Sql = "update parent_child_item set ParentChannelCode='" + pd.getChannel().getChannelCode() + "',ChildChannelCode='"+cd.getChannel().getChannelCode()+"' where id="+itemid;
	tu.executeUpdate(Sql);
}
tutu.closeRs(rs);
*/

//2009-01-04
//转模板文件到数据库

/*
tu.executeUpdate("delete from template_group where Parent>0");
String TemplateFolder = defaultSite.getTemplateFolder();
String RealPath = (TemplateFolder);
java.io.File file = new java.io.File(RealPath);
java.io.File[] files = file.listFiles();
templateFile(files,0,file.getPath());
*/

//2009-01-05
//模板转换完毕，对应频道的模板配置

/*
Sql = "select * from channel_template";
rs = tutu.executeQuery(Sql);
while(rs.next())
{
	String t = tutu.convertNull(rs.getString("Template"));
	int i = rs.getInt("id");
	int c = rs.getInt("Channel");

	if(!t.equals(""))
	{
		TemplateFile tf = new TemplateFile(t);

		if(tf.getId()>0)
			tu.executeUpdate("update channel_template set TemplateID="+tf.getId()+" where id="+i);
		else
			out.println("Channel:"+c+",Template:"+t+" error.<br>");
	}
}
tutu.closeRs(rs);
*/

//2009-02-10
//增加Random字段

/*
Sql = "select * from channel where Parent=-1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	new Channel().UpdateField(channelid," add Random int");
}
*/

//2009-03-03
//增加Weight字段
/*
Sql = "select * from channel where Parent=-1";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	new Channel().UpdateField(channelid," add Weight int","权重","Weight","text",1,1);
}
*/

//2009-03-12
//增加CreateDateBak,ModifiedDateBak,PublishDateBak,GenerateFileDateBak字段
//把日期转成数字存储

/*
Sql = "select * from channel where Type=10 or Type=5";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	Channel ch = CmsCache.getChannel(channelid);
	tutu.executeUpdate("ALTER TABLE " + ch.getTableName() + " add CreateDateBak datetime");
	tutu.executeUpdate("ALTER TABLE " + ch.getTableName() + " add ModifiedDateBak datetime");
	tutu.executeUpdate("ALTER TABLE " + ch.getTableName() + " add PublishDateBak datetime");
	tutu.executeUpdate("ALTER TABLE " + ch.getTableName() + " add GenerateFileDateBak datetime");
}
tu.closeRs(Rs);


Sql = "select * from channel where Type=10 or Type=5";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	Channel ch = CmsCache.getChannel(channelid);
	tutu.executeUpdate("update " + ch.getTableName() + " set CreateDateBak=CreateDate,ModifiedDateBak=ModifiedDate,PublishDateBak=PublishDate,GenerateFileDateBak=GenerateFileDate");
}
tu.closeRs(Rs);


Sql = "select * from channel where Type=10 or Type=5";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	Channel ch = CmsCache.getChannel(channelid);
	tutu.executeUpdate("alter table " + ch.getTableName() + " DROP COLUMN CreateDate,DROP COLUMN ModifiedDate,DROP COLUMN PublishDate,DROP COLUMN GenerateFileDate");
}
tu.closeRs(Rs);


Sql = "select * from channel where Type=10 or Type=5";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	Channel ch = CmsCache.getChannel(channelid);
	System.out.println(ch.getTableName());
	tutu.executeUpdate("alter table " + ch.getTableName() + " add CreateDate INTEGER(11) UNSIGNED default 0,add ModifiedDate INTEGER(11) UNSIGNED default 0,add PublishDate INTEGER(11) UNSIGNED default 0,add GenerateFileDate INTEGER(11) UNSIGNED default 0");
}
tu.closeRs(Rs);



Sql = "select * from channel where Type=10 or Type=5";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int channelid = Rs.getInt("id");
	Channel ch = CmsCache.getChannel(channelid);
	tutu.executeUpdate("update " + ch.getTableName() + " set CreateDate=UNIX_TIMESTAMP(CreateDateBak),ModifiedDate=UNIX_TIMESTAMP(ModifiedDateBak),PublishDate=UNIX_TIMESTAMP(PublishDateBak),GenerateFileDate=UNIX_TIMESTAMP(GenerateFileDateBak)");
}
tu.closeRs(Rs);
*/

//new Channel().UpdateTheChannelCode(4328);
//new Channel().UpdateChannelCode(4328);


/*item_snap字段修改*/
/*
tutu.executeUpdate("ALTER TABLE item_snap add CreateDateBak datetime");
tutu.executeUpdate("ALTER TABLE item_snap add ModifiedDateBak datetime");
tutu.executeUpdate("update item_snap set CreateDateBak=CreateDate,ModifiedDateBak=ModifiedDate");
tutu.executeUpdate("alter table item_snap DROP COLUMN CreateDate,DROP COLUMN ModifiedDate");
tutu.executeUpdate("alter table item_snap add CreateDate INTEGER(11) UNSIGNED default 0,add ModifiedDate INTEGER(11) UNSIGNED default 0");
tutu.executeUpdate("update item_snap set CreateDate=UNIX_TIMESTAMP(CreateDateBak),ModifiedDate=UNIX_TIMESTAMP(ModifiedDateBak)");
*/

//new Channel().UpdateTheChannelCode(4048);
//new Channel().UpdateChannelCode(4048);


	int channelid = 6699;
	Channel ch = new Channel(channelid);
	Sql = "SELECT * FROM " + ch.getTableName() + "";
	Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		int itemid = Rs.getInt("id");
		Document document = new Document(itemid,channelid);
		new tidemedia.cms.system.ItemSnap().Add(document);//加入全局库
		out.println(document.getTitle()+"<br>");
	}
	tu.closeRs(Rs);

%>
<br>Over!