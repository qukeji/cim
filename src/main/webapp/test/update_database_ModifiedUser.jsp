<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				tidemedia.cms.base.MessageException,
 tidemedia.cms.base.TableUtil,
java.io.File,
 java.io.FileInputStream,
 java.io.IOException,
 java.sql.ResultSet,
 java.sql.SQLException,
 java.util.ArrayList,
 java.util.HashMap,
 java.util.List,
tidemedia.cms.system.Parameter,
org.json.JSONException,
org.json.JSONObject,
 java.sql.SQLException,
java.util.ArrayList,
tidemedia.cms.base.MessageException,
tidemedia.cms.system.Channel,
tidemedia.cms.system.CmsCache,
tidemedia.cms.system.Field,
tidemedia.cms.system.FieldGroup,
 java.util.Map"%>
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
<%! public void UpdateChannelCode(int channelid) throws SQLException,MessageException
{
	TableUtil tu = new TableUtil();
	String Sql = "select * from channel where Parent=" + channelid;
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		String channelcode = Util.convertNull(Rs.getString("ChannelCode"));
		int id_ = Rs.getInt("id");
		channelcode = channelcode + "_" + id_;
		UpdateChannelCode(id_);

		TableUtil tu1 = new TableUtil();
		tu1.executeUpdate("update channel set ChannelCode='" + channelcode + "' where id=" + id_);
		tu1 = null;
	}
}

	/**
	 * 创建频道
	 * @param SourceChannelID
	 * @param title
	 * @param serialnoCustom
	 * @throws MessageException
	 * @throws SQLException
	 */
	public int CreateChannel(int SourceChannelID,String title,String serialnoCustom) throws MessageException, SQLException{
		Channel p = CmsCache.getChannel(SourceChannelID);// 聚现直播根频道
		String content_url = p.getListProgram();
		String document_url = p.getDocumentProgram();
		String serialno = p.getAutoSerialNo();
		int ii = serialno.lastIndexOf("_");
		String foldername = serialno.substring(ii + 1);
		Channel channel = new Channel();
		channel.setName(title);
		channel.setParent(SourceChannelID);
		// channel.setFolderName(foldername );
		channel.setFolderName(foldername);
		channel.setImageFolderName(p.getImageFolderName());
		channel.setSerialNo(!serialnoCustom.equals("")?serialnoCustom:serialno);
		channel.setIsDisplay(p.getIsDisplay());
		channel.setIsWeight(p.getIsWeight());
		channel.setIsComment(p.getIsComment());
		channel.setIsClick(p.getIsClick());
		channel.setIsShowDraftNumber(p.getIsShowDraftNumber());
		channel.setType(0);
		channel.setHref(p.getHref());
		channel.setExtra1("");
		channel.setListJS(p.getListJS());
		channel.setDocumentJS(p.getDocumentJS());
		channel.setListProgram(content_url);
		channel.setDocumentProgram(document_url);
		channel.setTemplateInherit(p.getTemplateInherit());
		channel.setActionUser(1);
		channel.Add();
		int thisChannelid = channel.getId();
		CmsCache.delChannel(thisChannelid);// 清理频道缓存
		return thisChannelid;
	}
	
	public void createField(String FieldName,String FieldDesc,String FieldType,String Default,int ChannelID,String Options,int DataType,int isHide) throws MessageException, SQLException{
		try{
			ArrayList <FieldGroup> fieldGroupArray = CmsCache.getChannel(ChannelID).getFieldGroupInfo();
			if(fieldGroupArray.size()>0){
				FieldGroup Gourp=fieldGroupArray.get(0);
				int GroupId=Gourp.getId();
				Field field = new Field();
				field.setChannelID(ChannelID);
				field.setGroupID(GroupId);
				field.setIsHide(isHide);
				field.setName(FieldName);
				field.setDescription(FieldDesc);
				field.setFieldType(FieldType);
				field.setOptions(Options);
				field.setDefaultValue(Default);
				field.setDataType(DataType);//单选、多选 、下拉列表       0字符Or 1数字
				field.Add();
			}
		}catch(Exception e){
			
		}
	}
	
//更新系统管理员权限
public void UpdateUserPerm() throws SQLException,MessageException
{
	TableUtil tu = new TableUtil("user");
	String Sql = "select * from userinfo where Role=1";
	ResultSet Rs = tu.executeQuery(Sql);
	while(Rs.next())
	{
		int id_ = Rs.getInt("id");
		tidemedia.cms.user.UserInfo ui = new tidemedia.cms.user.UserInfo(id_);
		if(!ui.hasPermission("ManageSystem")){			
			TableUtil tu1 = new TableUtil();
			tu1.executeUpdate("insert into user_perm(PermName,PermValue,User) values ('ManageChannel',1,"+id_+"),('ManageFile',1,"+id_+"),('ManageSystem',1,"+id_+")");
		}
	}
	tu.closeRs(Rs);
}
	
%>
<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
TableUtil tu2 = new TableUtil();
TableUtil tu_user = new TableUtil("user");
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
//tu.executeUpdate("ALTER TABLE field_desc ADD RecommendValue text");

//2008-07-17
//channel_template 表增加Lable字段
//tu.executeUpdate("ALTER TABLE channel_template ADD Lable varchar(255)");

//2008-09-10
//site 表增加ContentChannelSerialNo字段
//tu.executeUpdate("ALTER TABLE site ADD ContentChannelSerialNo varchar(255)");

//2008-09-12
//channel 表增加ContentChannelSerialNo字段
//tu.executeUpdate("ALTER TABLE channel ADD TemplateInherit int");

//2008-09-13
//增加item_snap表
//Sql += "CREATE TABLE item_snap (GlobalID int(11) NOT NULL auto_increment,Title	varchar(255) not null,ChannelCode varchar(255),ChannelID int,ItemID int,Keyword varchar(255),Tag varchar(255),Active int,Status int,User int,CreateDate datetime,ModifiedDate datetime,unique key id(GlobalID))";
//tu.executeUpdate(Sql);

//2008-09-13
//channel 表增加ChannelCode字段
//tu.executeUpdate("ALTER TABLE channel ADD ChannelCode varchar(255)");

//2008-09-13
//设置ChannelCode
//tu.executeUpdate("update Channel set ChannelCode=id where Parent=-1");


//2008-09-13
//增加SubTitle字段	   insert into field_desc(ChannelID,FieldName,Description,FieldType,FieldLevel,IsHide) values(181,'SubTitle','ff','text',1,0)


//2008-09-15
//field_group 表增加Extra字段
//tu.executeUpdate("ALTER TABLE field_group ADD Extra text");

//2008-09-16
//增加related_doc表
//tu.executeUpdate("CREATE TABLE related_doc (id int(10) unsigned NOT NULL auto_increment,RelatedGlobalID int(10) unsigned default NULL,  `RelatedOrder` int(10) unsigned default NULL,  `RelatedStatus` int(10) unsigned default NULL,  `RelatedTitle` varchar(255) default NULL,RelatedChannelID int(10),RelatedItemID int(10),GlobalID int(10) unsigned default NULL,ChannelID int(10),  PRIMARY KEY  (`id`))");


//2008-09-22
//field_desc 表修改IsNull为DisableBlank字段
//tu.executeUpdate("ALTER TABLE field_desc change column IsNull DisableBlank tinyint");

//2008-09-23
//field_desc 表修改Other为text
//tu.executeUpdate("ALTER TABLE field_desc modify column Other text");

//2008-10-09
//channel_template 表增加IncludeChildChannel字段
//tu.executeUpdate("ALTER TABLE channel_template ADD IncludeChildChannel tinyint");

//2008-10-09
//item_snap 表增加OrderNumber字段
//tu.executeUpdate("ALTER TABLE item_snap ADD OrderNumber int");

//2008-11-29
//site 表增加License字段
//tu.executeUpdate("ALTER TABLE site ADD License varchar(255)");

//2008-12-27
//field_desc 表增加GroupChannel字段
//tu.executeUpdate("ALTER TABLE field_desc ADD GroupChannel varchar(255)");

//2008-12-27
//增加parent_child_item表
//tu.executeUpdate("CREATE TABLE parent_child_item (id int(10) unsigned NOT NULL auto_increment,Parent int(10) unsigned default NULL,  Child int(10) unsigned default NULL,  Field varchar(255) default NULL,PRIMARY KEY  (`id`))");

//2008-12-30
//parent_child_item 表增加ParentChannelCode,ChildChannelCode字段
//tu.executeUpdate("ALTER TABLE parent_child_item ADD ParentChannelCode varchar(255)");
//tu.executeUpdate("ALTER TABLE parent_child_item ADD ChildChannelCode varchar(255)");

//2009-01-04
//template_files表增加Content字段
//tu.executeUpdate("ALTER TABLE template_files ADD Content text");
//tu.executeUpdate("ALTER TABLE template_files ADD GroupID int");
//tu.executeUpdate("alter table template_files add ModifiedDate datetime");
//tu.executeUpdate("alter table template_files add Name varchar(255)");
//tu.executeUpdate("alter table template_files add FileName varchar(255)");

//2009-01-04
//增加template_group表
//tu.executeUpdate("CREATE TABLE template_group (id int(10) unsigned NOT NULL auto_increment,Parent int(10), Name varchar(255) default NULL,OrderNumber int,GroupID int,CreateDate datetime,Status tinyint,PRIMARY KEY  (`id`))");
//tu.executeUpdate("insert into template_group(Parent,Name) values(-1,'模板')");

//2009-01-05
//channel_template表增加TemplateID字段
//tu.executeUpdate("ALTER TABLE channel_template ADD TemplateID int");

//2009-02-10	cmy	
//channel_template表增加FileNameType字段
//tu.executeUpdate("ALTER TABLE channel_template ADD FileNameType int");

//2009-02-10
//channel_template表增加Parent字段
//tu.executeUpdate("ALTER TABLE channel_template ADD Parent int");

//2009-02-21
//增加recommend表
//tu.executeUpdate("CREATE TABLE recommend (id int(10) unsigned NOT NULL auto_increment,GlobalID int(10), ChildGlobalID int(10),CreateDate long,User int,Type tinyint,PRIMARY KEY  (`id`))");

//2009-02-21
//channel表增加RecommendOut,RecommendOutRelation字段
//tu.executeUpdate("ALTER TABLE channel ADD RecommendOut mediumtext");
//tu.executeUpdate("ALTER TABLE channel ADD RecommendOutRelation mediumtext");

//2009-02-23
//channel表增加Type2字段
//tu.executeUpdate("ALTER TABLE channel ADD Type2 int");

//2009-02-25
//channel表增加Extra1,Extra2字段
//tu.executeUpdate("ALTER TABLE channel ADD Extra1 mediumtext");
//tu.executeUpdate("ALTER TABLE channel ADD Extra2 mediumtext");

//2009-02-26
//site 表增加ImageFolder字段
//tu.executeUpdate("ALTER TABLE site ADD ImageFolder varchar(255)");
//tu.executeUpdate("ALTER TABLE site ADD ImageFolderType tinyint");

//2009-03-01
//增加generate_files表
//tu.executeUpdate("CREATE TABLE generate_files (id int(10) unsigned NOT NULL auto_increment,FileName varchar(255),GlobalID int(10), ChannelID int(10),CreateDate long,Template int(10),TemplateType tinyint,PRIMARY KEY  (`id`))");

//2009-03-03
//site 表增加ExternalUrl字段
//tu.executeUpdate("ALTER TABLE site ADD ExternalUrl varchar(255)");

//2009-03-03
//publish_item 表增加Site字段
//tu.executeUpdate("ALTER TABLE publish_item ADD Site int");

//2009-03-03
//channel 表增加IsWeight,IsComment,IsClick字段
//tu.executeUpdate("ALTER TABLE channel ADD IsWeight tinyint");
//tu.executeUpdate("ALTER TABLE channel ADD IsComment tinyint");
//tu.executeUpdate("ALTER TABLE channel ADD IsClick tinyint");
//tu.executeUpdate("ALTER TABLE channel ADD IsShowDraftNumber tinyint");
//tu.executeUpdate("ALTER TABLE channel ADD ListJS mediumtext");
//tu.executeUpdate("ALTER TABLE channel ADD DocumentJS mediumtext");
//2009-4-19
//tu.executeUpdate("ALTER TABLE channel ADD ListProgram varchar(255)");
//tu.executeUpdate("ALTER TABLE channel ADD DocumentProgram varchar(255)");
//tu.executeUpdate("ALTER TABLE recommend ADD ChannelID int,add SourceID int");

//2009-05-25
//增加page_content表
//tu.executeUpdate("CREATE TABLE page_content (id int(10) unsigned NOT NULL auto_increment,Page int(10), Content mediumtext,CreateDate long,User int,PRIMARY KEY  (`id`))");

//2009-06-11
//field_desc 表增加HtmlTemplate字段
//tu.executeUpdate("ALTER TABLE field_desc ADD HtmlTemplate text");

//2009-06-16
//channel 表增加DataSource字段
//tu.executeUpdate("ALTER TABLE channel ADD DataSource varchar(100)");

//2009-06-22
//template_group表增加SerialNo字段
//tu.executeUpdate("ALTER TABLE template_group ADD SerialNo varchar(100)");
//tu.executeUpdate("ALTER TABLE template_group ADD Type int");

//2009-06-24
//channel 表增加CopyFromID字段
//tu.executeUpdate("ALTER TABLE channel ADD CopyFromID int");

//2009-07-01
//增加dict_group,dict表
//tu.executeUpdate("CREATE TABLE dict_group (id int(10) unsigned NOT NULL auto_increment,Name varchar(255), Code varchar(255),CreateDate long,PRIMARY KEY  (`id`))");
//tu.executeUpdate("CREATE TABLE dict (id int(10) unsigned NOT NULL auto_increment,Name varchar(255), GroupID int,CreateDate long,PRIMARY KEY  (`id`))");

//2009-07-02
//field_desc 表增加DictCode字段
//tu.executeUpdate("ALTER TABLE field_desc ADD DictCode varchar(255)");

//2009-07-27
//field_group 表增加Url字段
//tu.executeUpdate("ALTER TABLE field_group ADD Url varchar(255)");
//tu.executeUpdate("ALTER TABLE parent_child_item ADD Type tinyint");

//2009-10-11
//login_log 表增加User字段
//tu.executeUpdate("ALTER TABLE login_log ADD User int");

//2009-10-11
//login_log 表增加IsCookie字段
//tu.executeUpdate("ALTER TABLE login_log ADD IsCookie tinyint");

//2009-10-11
//parent_child_item 表增加OrderNumber字段
//tu.executeUpdate("ALTER TABLE parent_child_item ADD OrderNumber int");

//2009-11-2
//publish_scheme 表增加IncludeFolders,ExcludeFolders字段
//tu.executeUpdate("ALTER TABLE publish_scheme ADD FtpMode tinyint");

//2009-12-7
//publish_item 表增加AddTime,CanCopyTime,CopyedTime字段
//tu.executeUpdate("ALTER TABLE publish_item ADD AddTime int,Add CanCopyTime int,Add CopyedTime int");

//2009-12-18
//增加parameter表
//tu.executeUpdate("CREATE TABLE parameter (id int(10) unsigned NOT NULL auto_increment,Name varchar(255), Code varchar(255),CreateDate long,Content text,SystemContent text,Type tinyint,Type2 tinyint,IntValue int,PRIMARY KEY  (`id`))");

//2010-3-23
//field_desc 表增加DataType字段
//tu.executeUpdate("ALTER TABLE field_desc ADD DataType tinyint");

//2010-4-8
//field_desc 表增大OrderNumber
//tu.executeUpdate("update field_desc set OrderNumber=OrderNumber*100");

//2010-5-11
//更新用户表status
//tu.executeUpdate("update userinfo set Status=1");

//2010-5-18
//用户表增加最后登录时间
//tu.executeUpdate("alter table userinfo add LastLoginDate datetime");

//2010-527
//增加视频处理任务表
//tu.executeUpdate("CREATE TABLE  video_task (  `id` int(11) NOT NULL auto_increment,  `GlobalID` int(11) default NULL,  `Title` varchar(255) NOT NULL,  `SubTitle` varchar(255) NOT NULL,  `PublishDate` int(11) unsigned default '0',  `DocFrom` varchar(255) default NULL,  `Content` mediumtext,  `Summary` text,  `Keyword` varchar(255) NOT NULL,  `Tag` varchar(255) NOT NULL,  `Category` int(11) default NULL,  `User` int(11) default NULL,  `TotalPage` int(11) default '1',  `OrderNumber` int(11) default '0',  `Status` int(11) default NULL,Status2 tinyint,  `Active` tinyint(4) default NULL,  `IsPhotoNews` tinyint(4) default NULL,  `Random` int(11) default NULL,  `CreateDate` int(11) unsigned default '0',  `ModifiedDate` int(11) unsigned default '0',  `GenerateFileDate` int(11) unsigned default '0',  `Photo` varchar(250) default NULL,  `video_source` varchar(250) default NULL,  `video_dest` varchar(250) default NULL,  UNIQUE KEY `id` (`id`),  KEY `Category` (`Category`),  KEY `Index_5` USING BTREE (`Category`,`Active`,`OrderNumber`),  KEY `Index_6` USING BTREE (`Active`,`OrderNumber`)) ENGINE=InnoDB DEFAULT CHARSET=utf8");

//2010-6-17
//generate_files表增加site
//tu.executeUpdate("alter table generate_files add Site tinyint");

//2010-6-28
//parameter表增加IsTemplate
//tu.executeUpdate("alter table parameter add IsTemplate tinyint");

//2010-12-24
//publish_item 表增加ToFileName字段
//tu.executeUpdate("ALTER TABLE publish_item ADD ToFileName varchar(255)");

//2010-12-27
//channel 表增加Sql字段
//tu.executeUpdate("ALTER TABLE channel ADD ListSql varchar(255)");

//tu.executeUpdate("update channel set ListSql=\" cartoon_type='故事漫画'\" where id=145 ");
//tu.executeUpdate("update channel set ListSql=\" (cartoon_type='四格' or cartoon_type='绘本')\" where id=146");
//tu.executeUpdate("update channel set ListSql=\" cartoon_type='单幅'\" where id=147 ");

//2011-2-20
//channel_template表增加Active
//tu.executeUpdate("alter table channel_template add Active tinyint default 1");

//2011-3-1
//template_files表增加Comment
//tu.executeUpdate("alter table template_files add Comment text");

//2011-3-25
//增加spider表
//tu.executeUpdate("CREATE TABLE spider (id int(10) unsigned NOT NULL auto_increment,Name varchar(255), Url varchar(255),CreateDate long,ListStart text,ListEnd text,ListReg text,Charset varchar(100),ItemCharset varchar(100),HrefReg varchar(255),ImageFolder varchar(255),User int,Channel int,Status tinyint default 1,PRIMARY KEY  (`id`))");
//tu.executeUpdate("alter table spider add User int");

//2011-3-27
//增加spider_field表
//tu.executeUpdate("CREATE TABLE spider_field (id int(10) unsigned NOT NULL auto_increment,Parent int,Name varchar(255), Field varchar(255),CreateDate long,CodeStart text,CodeEnd text,CodeReg text,PRIMARY KEY  (`id`))");
//tu.executeUpdate("CREATE TABLE spider_item (id int(10) unsigned NOT NULL auto_increment,Url varchar(255),CreateDate long,PRIMARY KEY  (`id`))");

//2011-4-12
//error_log改为system_log
//tu.executeUpdate("RENAME TABLE error_log TO system_log");
//tu.executeUpdate("alter table system_log add Type tinyint default 0");

//2011-4-17
//tu.executeUpdate("alter table item_snap add PublishDate integer(11) unsigned default 0");
//tu.executeUpdate("update item_snap set PublishDate=ModifiedDate");

//2011-6-6
//tu.executeUpdate("alter table channel add Icon varchar(50)");

//2011-7-16
//tu.executeUpdate("alter table channel add ImageFolderType tinyint");

//2011-7-30
//增加channelcode,初始化channelcode值
//tu2.executeUpdate("update channel set ChannelCode=concat(ChannelCode,'_')");
/*
Sql = "select * from channel where Type=0 ";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	Channel ch = CmsCache.getChannel(Rs.getInt("id"));
	try{
	ch.getTableUtil().executeUpdate("ALTER TABLE channel_" + Rs.getString("SerialNo")+" ADD ChannelCode varchar(255)");
	}catch(Exception e){System.out.println(e.getMessage());}
	
}
tu.closeRs(Rs);
*/

/*
Sql = "select * from channel where Type=0";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	Channel channel = CmsCache.getChannel(Rs.getInt("id"));
	try{channel.getTableUtil().executeUpdate("update channel_" + Rs.getString("SerialNo")+" set ChannelCode='" + channel.getChannelCode() + "' where Category=0");
	
	channel.getTableUtil().executeUpdate("update channel_" + Rs.getString("SerialNo")+" as a,tidemedia_cms_liangyou.channel as b set a.ChannelCode=b.ChannelCode where a.Category=b.id");
	out.println(channel.getName()+"<br>");
	}catch(Exception e)
	{System.out.println(e.getMessage());}
}
tu.closeRs(Rs);
*/

//tu2.executeUpdate("update item_snap as a,channel as b set a.ChannelCode=b.ChannelCode where a.ChannelID=b.id");

//2011-8-2
//修正频道的channelcode，后面加_

//2011-9-9
//channel_template增加Href字段
//tu.executeUpdate("alter table channel_template add Href varchar(255)");

//2011-9-22
//userinfo增加ExpireDate字段
//tu.executeUpdate("alter table userinfo add ExpireDate datetime");

//2011-10-21
//channel_template增加FileNameField字段
//tu.executeUpdate("alter table channel_template add FileNameField varchar(255)");

//2011-11-30
//template_files增加Type字段
//tu.executeUpdate("alter table template_files add Type int default 0");

//2012-1-4
//channel增加IsListAll,ViewType字段
//tu.executeUpdate("alter table channel add IsListAll int,add ViewType int default 0");

//2012-3-7
//field_desc增加DisableEdit字段
//tu.executeUpdate("alter table field_desc add DisableEdit int default 0");

//2012-3-24
//增加tidecms_system_log 表
//Sql = "CREATE TABLE `tidecms_system_log` (  `id` int(11) NOT NULL auto_increment,Source varchar(255),  `Content` text, `CreateDate` datetime,  UNIQUE KEY `id` (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
//tu.executeUpdate(Sql);

//2012-3-27
//增加quartz_manager表
//Sql = "CREATE TABLE `quartz_manager` (  `id` int(11) NOT NULL AUTO_INCREMENT,  `title` varchar(255),  `program` varchar(255),  `jobtime` varchar(255),  `type` int DEFAULT '0',  `status` int DEFAULT '1',  `createdate` datetime,  `remark` text,  PRIMARY KEY (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;";
//tu.executeUpdate(Sql);

//2012-3-30
//field_group增加LinkChannel,Type字段
//tu.executeUpdate("alter table field_group add LinkChannel int default 0,add Type int default 0");

//2012-4-5
//spider_item增加Spider字段
//tu.executeUpdate("alter table spider_item add Spider int");

//2012-5-22
//field_desc增加RelationChannelID字段
//tu.executeUpdate("alter table field_desc add RelationChannelID int");

//2012-6-3
//spider增加Url_First,Program,GroupID字段
//tu.executeUpdate("alter table spider add Url_First text,add Program varchar(255),ADD GroupID int DEFAULT 0");

//2012-6-3
//增加spider_group表
//tu.executeUpdate("CREATE TABLE spider_group (id int(10) unsigned NOT NULL auto_increment,Parent int(10), Name varchar(255) ,OrderNumber int,CreateDate datetime,Status tinyint,PRIMARY KEY  (`id`))");
//tu.executeUpdate("insert into spider_group(Parent,Name) values(-1,'采集')");

//2012-7-4
//template_files 表修改Photo为varchar(255)
//tu.executeUpdate("ALTER TABLE template_files drop column Photo");
//tu.executeUpdate("ALTER TABLE template_files add Photo varchar(255)");

//2012-8-1
//spider增加ItemStatus,IsDownloadImage字段
//tu.executeUpdate("alter table spider add ItemStatus int default 0,add IsDownloadImage int default 0");

//2012-8-18
//publish_task增加PublishBegin,PublishEnd字段
//tu.executeUpdate("alter table publish_task add PublishBegin long,add PublishEnd long");

//2012-11-29
//parameter增加IsJson,Comment字段
//tu.executeUpdate("alter table parameter add IsJson tinyint,add Comment text");

//2012-12-4
//item_snap 表修改OrderNumber为bigint
//tu.executeUpdate("ALTER TABLE item_snap modify column OrderNumber bigint unsigned");

//2013-1-4
//增加transcode_server表
//tu.executeUpdate("create table transcode_server (id int(10) unsigned NOT NULL auto_increment,Name varchar(255), Url varchar(255) ,SourceUrl varchar(255),Destfolder varchar(255),ffmpeg varchar(255),flvmdi varchar(255),mp4box varchar(255),PublishScheme int,Number tinyint,CreateDate datetime,Status tinyint,PRIMARY KEY  (`id`))");

//2013-1-26
//userinfo 表增加Token字段
//tu.executeUpdate("alter table userinfo add Token varchar(255)");

//2013-4-29
//channel_transcode 表增加PublishStatus字段
//tu.executeUpdate("alter table channel_transcode add PublishStatus tinyint");

//2013-6-15
//server 表增加Number字段
//tu.executeUpdate("alter table transcode_server add Number tinyint");

//2013-10-31
//publish_item 表增加UsedTime字段
//tu.executeUpdate("alter table publish_item add UsedTime int default 0");

//2013-11-18
//channel 表增加IsTop字段
//tu.executeUpdate("alter table channel add IsTop int default 0");

//2013-12-16
//spider增加TitleKeyword字段
//tu.executeUpdate("alter table spider add TitleKeyword text");

//2013-12-30
//spider增加Interval字段
//tu.executeUpdate("alter table spider add Interval text,add Period int default 0");

//2013-12-30
//spider增加Period字段
//tu.executeUpdate("alter table spider add Period int default 0");


//2014-1-2
//tidecms_system_log增加SourceType字段
//tu.executeUpdate("alter table tidecms_system_log add SourceType tinyint default 0");

//2014-1-2
//tidecms_log增加LogAction字段
//tu.executeUpdate("alter table tidecms_log add LogAction int default 0");

//2014-1-16
//transcode_server修改PublishScheme字段
//tu.executeUpdate("alter table transcode_server modify column PublishScheme varchar(255)");

//2014-8-2 
//增加转码配置表
//tu.executeUpdate("create table transcode_birate (id int(10) unsigned NOT NULL auto_increment,Name varchar(255),code varchar(255),value varchar(255),type int ,content varchar(255),create_date mediumtext,PRIMARY KEY  (`id`))");


//2014-5-1
//field_desc增加JS字段
//tu.executeUpdate("alter table field_desc add JS varchar(255)");

//2014-6-3
//channel表增加IsPublishFile
//tu.executeUpdate("alter table channel add IsPublishFile tinyint default 0");

//2014-7-6
//增加产品表
//tu.executeUpdate("create table tide_products (id int(10) unsigned not null auto_increment,Name varchar(255),Code varchar(255),Status tinyint default 0,License mediumtext,CreateDate int(10),primary key (id))");

//2014-11-16
//tide_products表增加Url
//tu_user.executeUpdate("alter table tide_products add Url varchar(255)");

//2014-11-20
//files_info表增加ChannelID字段
//tu.executeUpdate("ALTER TABLE files_info ADD ChannelID int(11)");

//2015-01-23
//王海龙增加 一键转载
//spider表增加transfer_href
//tu.executeUpdate("alter table spider add transfer_href varchar(255)");
 //spider_field表增加rule
 //tu.executeUpdate("alter table spider_field add rule varchar(255)");

 //2015-03-18
//channel表增加ListSearchField,ListShowField字段
//tu.executeUpdate("ALTER TABLE channel ADD ListSearchField text,add  ListShowField text");

//tu
//tu.executeUpdate("CREATE TABLE photo_scheme (id int(10) unsigned NOT NULL auto_increment,Name varchar(255) default NULL,Width int(11) default 0,Height int(11) default 0,PRIMARY KEY  (id))  DEFAULT CHARSET=utf8");

//2015-9-22
//channel增加IsImportWord,IsExportExcel字段
//tu.executeUpdate("alter table channel add IsImportWord int,add IsExportExcel int default 0");

//2015-10-13
//channel_template增加PublishInterval字段
//tu.executeUpdate("alter table channel_template add PublishInterval int default 0,add LastPublishDate int default 0");

//2015-10-17
//publish_task增加ChannelTemplateID,CanPublishTime字段
//tu.executeUpdate("alter table publish_task add ChannelTemplateID int default 0,add CanPublishTime int default 0");

//2015-10-17
//publish_item增加message字段
//tu.executeUpdate("alter table publish_item add Message text");

//2015-10-27
//spider增加IsGlobalID字段
//tu.executeUpdate("alter table spider add IsGlobalID int default 0");

//2016-03-16
//publish_scheme增加videoHttpHead字段
//tu.executeUpdate("alter table publish_scheme add column videoHttpHead varchar(255)");

 

//2016-6-2
//增加ModifiedUser字段
ArrayList arraylist_ = new ArrayList();
Sql = "select * from channel where Type=0";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	int id = Rs.getInt("id");
	arraylist_.add(id);
}
tu.closeRs(Rs);


for (int i = 0; i < arraylist_.size(); i++) {
	Integer integer = (Integer) arraylist_.get(i);
	Channel ch = CmsCache.getChannel(integer);
	try{
	System.out.println("处理:"+ch.getName()+","+ch.getId()+","+"ALTER TABLE "+ch.getTableName()+" ADD ModifiedUser int<br>");
	ch.getTableUtil().executeUpdate("ALTER TABLE "+ch.getTableName()+" ADD ModifiedUser int");
	}catch(Exception e){System.out.println(e.getMessage());}
	CmsCache.delChannel(integer);
}


//2016-07-06 增加置顶、置顶时间字段，每个频道都要加
/* 
Sql = "select * from channel where Type=0 ";
Rs = tu.executeQuery(Sql);
while(Rs.next())
{
	Channel ch = CmsCache.getChannel(Rs.getInt("id"));
	try{
	ch.getTableUtil().executeUpdate("ALTER TABLE channel_" + Rs.getString("SerialNo")+"  add DocTop int default 0, add DocTopTime int");
	}catch(Exception e){System.out.println(e.getMessage());}
	
}
tu.closeRs(Rs);
*/


%> 
<br>Over!