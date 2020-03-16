<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

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


//2014-12-6
//增加`login_log`表
//tu.executeUpdate("CREATE TABLE `login_log` (  `id` int(11) NOT NULL AUTO_INCREMENT,  `Username` varchar(20) NOT NULL DEFAULT '',  `IsSuccess` tinyint(4) DEFAULT NULL,  `IP` varchar(20) DEFAULT NULL,  `Host` varchar(60) DEFAULT NULL,  `Date` datetime DEFAULT NULL,  `User` int(11) DEFAULT NULL,  `IsCookie` tinyint(4) DEFAULT NULL,  UNIQUE KEY `id` (`id`))");

//2014-12-6
//更新tide_products表
//SET NAMES utf8;
//SET character_set_client = utf8;
//INSERT INTO `tide_products` VALUES (1,'内容汇聚发布系统','TideCMS','3c6c6963656e73653e3c70726f647563743e54696465434d533c2f70726f647563743e3c70726f6475637445646974696f6e3e456e74657270726973653c2f70726f6475637445646974696f6e3e3c636f6d70616e793ee6b3b0e5beb7e7bd91e8819ae6bc94e7a4bae7b3bbe7bb9f203c2f636f6d70616e793e3c6c6963656e7365547970653e4576616c756174696f6e3c2f6c6963656e7365547970653e3c76657273696f6e3e382e303c2f76657273696f6e3e3c65787069726573446174653e313433303439323430303030303c2f65787069726573446174653e3c637265617465446174653e323031342d31322d30343c2f637265617465446174653e3c6d61633e3c2f6d61633e3c2f6c6963656e73653etide302c021424ef8a20188cf91f18d1cbe5b2a09f300405278002142e4a445610c1a2e0f7688a9de4496e2f4d3c2ef0',NULL,1,NULL,'/cms/'),(2,'全媒体资源管理系统','TideVMS','3c6c6963656e73653e3c70726f647563743e54696465564d533c2f70726f647563743e3c70726f6475637445646974696f6e3e456e74657270726973653c2f70726f6475637445646974696f6e3e3c636f6d70616e793ee6b3b0e5beb7e6bc94e7a4bae5aa92e8b584e7b3bbe7bb9f203c2f636f6d70616e793e3c6c6963656e7365547970653e4576616c756174696f6e3c2f6c6963656e7365547970653e3c76657273696f6e3e382e303c2f76657273696f6e3e3c65787069726573446174653e313432333337363133303230373c2f65787069726573446174653e3c637265617465446174653e323031342d30372d32333c2f637265617465446174653e3c6d61633e313233343c2f6d61633e3c2f6c6963656e73653etide302c021470c5c447a7f63a1892b62bcc6d1b8987aaad1e7602145e19483045049fa30ed9cc3e00281c05aa648293',NULL,1,NULL,'/vms/'),(3,'音视频收录剪辑系统','TideAIR',NULL,NULL,1,NULL,'/air/'),(4,'直播管理发布系统','TideLive',NULL,NULL,0,NULL,'/live/'),(5,'统计数据营销系统','TideTongji',NULL,NULL,0,NULL,'/analisy/'),(6,'用户交互中心系统','TideUser',NULL,NULL,0,NULL,'/user/'),(7,'云资源采集系统','TideCloud',NULL,NULL,0,NULL,'/spider/'),(8,'APP运营管理系统','TideApp',NULL,NULL,0,NULL,'/app/');


//2014-11-16
//tide_products表增加Url
//tu_user.executeUpdate("alter table tide_products add Url varchar(255)");

//2015-6-24
//tide_products表增加company,licensetype,expiresdate
//tu_user.executeUpdate("alter table tide_products add company varchar(255),add licenseType varchar(255),add expiresDate varchar(255)");

//2015-7-3
//增加表api_token
//tu_user.executeUpdate("create table api_token (id int(10) unsigned not null auto_increment,Token varchar(255),Name varchar(255),CreateDate int(10),primary key (id))");

//2016-3-15
//增加表 tidecms_log
//tu_user.executeUpdate("CREATE TABLE `tidecms_log` (  `id` int(11) NOT NULL auto_increment,  `LogType` varchar(255) default NULL,  `Title` varchar(255) default NULL,  `Content` text,  `Item` int(11) default NULL,  `FromType` varchar(255) default NULL,  `FromKey` varchar(255) default NULL,  `Key1` varchar(100) default NULL,  `Key2` varchar(100) default NULL,  `Key3` varchar(100) default NULL,  `User` int(11) default NULL,  `CreateDate` datetime default NULL,  `Site` int(11) default NULL,  `LogAction` int(11) default '0',  UNIQUE KEY `id` (`id`)) ENGINE=InnoDB DEFAULT CHARSET=utf8");

//tu_user.executeUpdate("INSERT INTO `tide_products` VALUES (10,'视频快编系统','TideVideoEditor',NULL,NULL,0,NULL,'/vms/videoeditor/','','','')");

//2018-10-11
//tidemedia_user.parameter 建表语句
//tu_user.executeQuery("CREATE TABLE parameter (id int(10) unsigned NOT NULL auto_increment,Name varchar(255), Code varchar(255),CreateDate long,Content text,SystemContent text,Type tinyint,Type2 tinyint,IsTemplate tinyint,IsJson tinyint,Comment text,IntValue int,PRIMARY KEY  (`id`))");

//2018-10-12:
//parameter表添加记录
//tu_user.executeUpdate("insert into parameter (Name,Code,CreateDate,Type2,IntValue,IsJson) values('是否显示融合媒体首页','media_ronghe',now(),2,1,0)");

//2018-12-14
//多租户相关
//租户对应的表在tidemedia_user库下的company
//tu_user.executeUpdate("CREATE TABLE company (id int(10) unsigned NOT NULL auto_increment,Name varchar(255),ExpireDate datetime, Status int(11) default 0,jurong int(11) default 0,JuxianID int(11) default 0,PRIMARY KEY  (`id`))");

//用户表，用户组表，站点表，频道表 都增加一个company字段，对应租户编号
//tu_user.executeUpdate("alter table userinfo add company int(11) default 0,add jurong int(11) default 0");
//tu_user.executeUpdate("alter table user_group add company int(11) default 0");
//tu.executeUpdate("alter table site add company int(11) default 0");//cms库
//tu.executeUpdate("alter table channel add company int(11) default 0");//cms库

//频道表增加application字段,区分频道类型(cms库)
//tu.executeUpdate("alter table channel add application varchar(255)");
//tu.executeUpdate("update channel set application='pgc_video' where id=16540");
//tu.executeUpdate("update channel set application='pgc_doc' where id=16541");
//tu.executeUpdate("update channel set application='pgc_live' where id=16548");
//tu.executeUpdate("update channel set application='screen' where id=16176");
//tu.executeUpdate("update channel set application='screen_charts' where id=16178");
//tu.executeUpdate("update channel set application='screen_zd' where id=16179");
//tu.executeUpdate("update channel set application='task_doc' where id=16085");
//tu.executeUpdate("update channel set application='task_car' where id=16532");
//tu.executeUpdate("update channel set application='task_device' where id=16534");
//tu.executeUpdate("update channel set application='task_score' where id=16535");
//tu.executeUpdate("update channel set application='shenpian' where id=16502");
//tu.executeUpdate("update channel set application='shengao' where id=16506");
//公共站点
//tu.executeUpdate("update channel set application='publishsite' where id=16175");
//tu.executeUpdate("update channel set application='publishsite' where id=16492");

//频道表增加application字段,区分频道类型(vms库)
//tu.executeUpdate("alter table channel add application varchar(255),add company int(11) default 0");
//tu.executeUpdate("update channel set application='pgc_video' where id=15189");

//tide_products表增加group,logo,Tye,newpage
//tu_user.executeUpdate("alter table tide_products add logo varchar(255),add groupId tinyint,add Type tinyint,add newpage tinyint");

//tide_products表设置id主键
//tu_user.executeUpdate("alter table tide_products change id id int(10) unsigned NOT NULL auto_increment");
//tu_user.executeUpdate("alter table tide_products AUTO_INCREMENT=11");

//创建user_product表
//tu_user.executeUpdate("CREATE TABLE user_product (id int(10) unsigned NOT NULL auto_increment,UserId int(11) default 0,ModifyDate datetime, Status int(11) default 0,ProductId int(11) default 0,PRIMARY KEY  (`id`))");

//创建操作日志表
//tu_user.executeUpdate("CREATE TABLE tcenter_log (id int(10) unsigned NOT NULL auto_increment,Title varchar(255),Fromtype varchar(255),User int(11) default 0,CreateDate datetime, Item int(11) default 0,LogAction int(11) default 0,PRIMARY KEY  (`id`))");

//创建通知管理表
//tu_user.executeUpdate("CREATE TABLE notice (id int(10) unsigned NOT NULL auto_increment,Title varchar(255),StartDate datetime,EndDate datetime,PRIMARY KEY  (`id`))");

//2019-04-04
//tide_products表增加OrderNumber
tu_user.executeUpdate("alter table tide_products add OrderNumber int(11) default 0");
tu_user.executeUpdate("update tide_products set OrderNumber=id*100");
%> 
<br>Over!