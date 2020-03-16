<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.util.concurrent.*,
				java.util.*,
				tidemedia.cms.publish.*,
				org.json.JSONException,
				org.json.JSONObject,
				org.apache.commons.io.FileUtils,
				org.apache.tools.zip.ZipFile,
				org.apache.tools.zip.ZipEntry,
				java.io.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%!
//获取站点频道编号
public int getDescChannelId(int DestSiteId){
	int DestChannelId=0;
	try{
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery("select * from channel where site="+DestSiteId+" and parent=-1 ");
		while(rs.next()){
			DestChannelId=rs.getInt("id");
		}
		tu.closeRs(rs);
	}catch (Exception e) {
		System.out.println(e.getMessage());
	}
	return DestChannelId ;
}
//频道是否存在
public int getChannelId(String SerialNo){
	int channelId_ = 0;
	try{
		String sql = "select id from channel where SerialNo='"+SerialNo+"'";
		TableUtil tu=new TableUtil();
		ResultSet rs=tu.executeQuery(sql);
		if(rs.next()){
			channelId_ = rs.getInt("id");
		}
		tu.closeRs(rs);
	}catch (Exception e) {
		System.out.println(e.getMessage());
	}
	return channelId_ ;
}
//创建字段
public void createField(String FieldName,String FieldDesc,String FieldType,String Default,int ChannelID,String Options,int DataType,int isHide) throws MessageException, SQLException{
	try{
		ArrayList <FieldGroup> fieldGroupArray = CmsCache.getChannel(ChannelID).getFieldGroupInfo();
		if(fieldGroupArray.size()>0){
			FieldGroup Gourp = fieldGroupArray.get(0);//内容编辑分组
			int GroupId = Gourp.getId();
			Field field = new Field();
			field.setChannelID(ChannelID);
			field.setGroupID(GroupId);
			field.setIsHide(isHide);
			field.setName(FieldName);
			field.setDescription(FieldDesc);
			field.setFieldType(FieldType);
			field.setOptions(Options);
			field.setDefaultValue(Default);
			field.setDataType(DataType);//单选、多选 、下拉列表    0字符Or 1数字
			field.Add();
		}
	}catch(Exception e){
		
	}
}
//增加系统参数createParameter("是否开启租户","zuhu",2,1,0,"");
public void createParameter(String Name,String Code,int type,int value,int json,String Content) throws SQLException, MessageException{
	Parameter p = new Parameter();
	p.setName(Name);
	p.setCode(Code);
	p.setType2(type);
	p.setIsJson(json);
	if(type==2){
		p.setIntValue(value);
	}else{
		p.setContent(Content);
	}
	p.Add();
}
%>

<%
if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}
%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="noindex, nofollow">
<title>站点升级结果</title>
<link rel="stylesheet" href="../style/2018/bracket.css">
</head>

<body>
<div class="container">

<div class="modal-body modal-body-btn pd-20 overflow-y-auto">
	<div class="config-box mg-t-15">	       	  
	   						        
<%

int Action = getIntParameter(request,"Action");
if(Action==0){
	out.println("<div class=\"row\"><h5>升级融合媒体新界面步骤：</h5></div>");
	out.println("<div class=\"row\"><h5>1.升级多租户相关数据表</h5></div>");
	out.println("<div class=\"row\"><h5>2.手动更新后台程序</h5></div>");
	out.println("<div class=\"row\"><h5>3.手动上传zip文件到/tomcat/webapps/cms/temp/import</h5></div>");
	out.println("<div class=\"row\"><h5>4.再次执行本程序传参Action=2</h5></div>");
	out.println("<div class=\"row\"><h5>5.创建站点</h5></div>");
	out.println("<div class=\"row\"><h5>6.导入频道</h5></div>");
	out.println("<div class=\"row\"><h5>7.创建系统参数</h5></div>");
	out.println("<div class=\"row\"><h5>8.创建产品</h5></div>");
	out.println("<div class=\"row\"><a href=\"update_tcenter9_tcenter20.jsp?Action=1\" class=\"btn btn-info mg-r-5 mg-b-10\">确定升级？</a></div>");
	return ;
}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
TableUtil tu_user = new TableUtil("user");

Site site = new Site();//创建站点
int siteId = 0 ;//站点编号
int parent = 0 ;//站点频道编号
ChannelImport channel_import = new ChannelImport();//频道导入
%>

<%
//升级融合媒体新界面

if(Action==1){
	//1.多租户相关
	//租户对应的表在tidemedia_user库下的company
	tu_user.executeUpdate("CREATE TABLE company (id int(10) unsigned NOT NULL auto_increment,Name varchar(255),ExpireDate datetime, Status int(11) default 0,jurong int(11) default 0,JuxianID int(11) default 0,PRIMARY KEY  (`id`))");
	//租户表新建字段:联系人，联系人电话，logo，空间
	tu_user.executeUpdate("alter table company add user varchar(255),add phone varchar(255),add logo varchar(255),add space int(11) default 0");
	out.println("<div class=\"row\"><h5>company租户表创建成功</h5></div>");

	//用户表，用户组表，站点表，频道表 都增加一个company字段，对应租户编号
	tu_user.executeUpdate("alter table userinfo add company int(11) default 0,add jurong int(11) default 0");
	tu_user.executeUpdate("alter table user_group add company int(11) default 0");
	tu.executeUpdate("alter table site add company int(11) default 0");//cms库
	out.println("<div class=\"row\"><h5>用户表，用户组表，站点表增加company字段</h5></div>");
	//频道表增加application字段,区分频道类型(cms库)
	tu.executeUpdate("alter table channel add company int(11) default 0,add application varchar(255)");//cms库
	out.println("<div class=\"row\"><h5>频道表增加company，application字段</h5></div>");

	//tide_products表增加group,logo,Tye,newpage,OrderNumber
	tu_user.executeUpdate("alter table tide_products add logo varchar(255),add groupId tinyint,add Type tinyint,add newpage tinyint,add OrderNumber int(11) default 0");
	out.println("<div class=\"row\"><h5>tide_products表增加group,logo,Tye,newpage</h5></div>");
	//tide_products表设置id主键
	tu_user.executeUpdate("alter table tide_products change id id int(10) unsigned NOT NULL auto_increment, auto_increment=100");
	out.println("<div class=\"row\"><h5>tide_products表设置id主键</h5></div>");

	//创建user_product表
	tu_user.executeUpdate("CREATE TABLE user_product (id int(10) unsigned NOT NULL auto_increment,UserId int(11) default 0,ModifyDate datetime, Status int(11) default 0,ProductId int(11) default 0,PRIMARY KEY  (`id`))");
	out.println("<div class=\"row\"><h5>user_product表创建成功</h5></div>");

	//创建操作日志表
	tu_user.executeUpdate("CREATE TABLE tcenter_log (id int(10) unsigned NOT NULL auto_increment,Title varchar(255),Fromtype varchar(255),User int(11) default 0,CreateDate datetime, Item int(11) default 0,LogAction int(11) default 0,PRIMARY KEY  (`id`))");
	out.println("<div class=\"row\"><h5>操作日志表创建成功</h5></div>");

	//创建通知管理表
	tu_user.executeUpdate("CREATE TABLE notice (id int(10) unsigned NOT NULL auto_increment,Title varchar(255),StartDate datetime,EndDate datetime,PRIMARY KEY  (`id`))");
	out.println("<div class=\"row\"><h5>通知管理表创建成功</h5></div>");

	//审核方案表添加是否编辑字段  默认为0   0：不开启编辑  1：开启编辑
	tu.executeUpdate("alter table approve_scheme add editable int(1) default 0");
	//频道是否开启版本号功能字段  默认为1    0：不开启 1：开启
	tu.executeUpdate("alter table channel add Version int(1) default 0");
	//稿件版本库
	tu.executeUpdate("CREATE TABLE article_replica (id int(10) unsigned NOT NULL auto_increment,Title varchar(255),CreateDate datetime, Content text,Summery varchar(255),uid int(11),globailid int(11),channelid int(11),PRIMARY KEY  (`id`))");
	out.println("<div class=\"row\"><h5>稿件版本库表创建成功</h5></div>");
}

if(Action==2){
	//3.创建站点
	site.setName("大屏数据管理系统");
	site.setActionUser(userinfo_session.getId());
	site.Add();
	siteId = site.getId();
	parent = getDescChannelId(siteId);
	tu.executeUpdate("update channel set application=\"publishsite\" where id="+parent);
	out.println("<div class=\"row\"><h5>大屏数据管理系统站点创建成功</h5></div>");	

	//4.导入频道
	//大屏--屏幕管理
	channel_import.setChannelid(parent);
	channel_import.setFilename("screen.zip");
	channel_import.setUserid(userinfo_session.getId());
	channel_import.setImport_channel(true);
	channel_import.setImport_template(true);
	channel_import.start();
	//大屏--展示数据发布管理
	channel_import.setChannelid(parent);
	channel_import.setFilename("screen_show.zip");
	channel_import.setUserid(userinfo_session.getId());
	channel_import.setImport_channel(true);
	channel_import.setImport_template(true);
	channel_import.start();
	//大屏--屏幕模块
	channel_import.setChannelid(parent);
	channel_import.setFilename("screen_module.zip");
	channel_import.setUserid(userinfo_session.getId());
	channel_import.setImport_channel(true);
	channel_import.setImport_template(true);
	channel_import.start();
	//大屏--屏幕内容源
	channel_import.setChannelid(parent);
	channel_import.setFilename("screen_source.zip");
	channel_import.setUserid(userinfo_session.getId());
	channel_import.setImport_channel(true);
	channel_import.setImport_template(true);
	channel_import.start();
	out.println("<div class=\"row\"><h5>大屏频道创建成功</h5></div>");

	//创建站点
	site.setName("聚融");
	site.setActionUser(userinfo_session.getId());
	site.Add();
	siteId = site.getId();
	parent = getDescChannelId(siteId);
	tu.executeUpdate("update channel set application=\"publishsite\" where id="+parent);
	out.println("<div class=\"row\"><h5>聚融站点创建成功</h5></div>");

	//导入频道
	//聚融--选题
	channel_import.setChannelid(parent);
	channel_import.setFilename("task.zip");
	channel_import.setUserid(userinfo_session.getId());
	channel_import.setImport_channel(true);
	channel_import.setImport_template(true);
	channel_import.start();
	//聚融--移动审片
	channel_import.setChannelid(parent);
	channel_import.setFilename("shenpian.zip");
	channel_import.setUserid(userinfo_session.getId());
	channel_import.setImport_channel(true);
	channel_import.setImport_template(true);
	channel_import.start();
	//聚融--文稿
	channel_import.setChannelid(parent);
	channel_import.setFilename("shengao.zip");
	channel_import.setUserid(userinfo_session.getId());
	channel_import.setImport_channel(true);
	channel_import.setImport_template(true);
	channel_import.start();
	//聚融--PGC
	channel_import.setChannelid(parent);
	channel_import.setFilename("pgc.zip");
	channel_import.setUserid(userinfo_session.getId());
	channel_import.setImport_channel(true);
	channel_import.setImport_template(true);
	channel_import.start();
	out.println("<div class=\"row\"><h5>聚融频道创建成功</h5></div>");

	//视频库(频道已存在，不能用频道导入功能)
	parent = getChannelId("video");
	if(parent!=0){
		createField("juxian_username","聚现用户名","text", "", parent, "", 0, 0);
		createField("juxian_phone","聚现用户手机号","text", "", parent, "", 0, 0);
		createField("position","聚现位置","text", "", parent, "", 0, 0);
		createField("juxian_companyid","聚现企业id","number", "", parent, "", 0, 0);
		createField("juxian_user","聚现用户id","number", "", parent, "", 0, 0);
		createField("juxian_sourceid","聚现资源id","number", "", parent, "", 0, 0);
		createField("ModifyDate","聚现修改时间","number", "", parent, "", 0, 0);

		ArrayList <FieldGroup> fieldGroupArray = CmsCache.getChannel(parent).getFieldGroupInfo();
		if(fieldGroupArray.size()>0){
			FieldGroup Gourp = fieldGroupArray.get(0);//内容编辑分组
			int GroupId = Gourp.getId();
			Sql = "insert into field_desc (";
			Sql += "ChannelID,GroupID,FieldName,Description,FieldType,GroupChannel,RecommendChannel,";
			Sql += "RecommendValue,IsHide,DisableBlank,DisableEdit,FieldLevel,EditorType,OrderNumber,Size,Other,HtmlTemplate,JS,Caption,";
			Sql += "DictCode,DefaultValue,Style,RelationChannelID,DataType";
			Sql += ") values(";
			Sql += parent;
			Sql += "," + GroupId + "";
			Sql += ",'Status2','转码状态','number','','','',0,0,0,2,0,0,0,'','','','','','','',0,0";
			Sql += ")";
			tu.executeUpdate(Sql);
			Sql = "update field_desc set OrderNumber=id*100 where OrderNumber=0";
			tu.executeUpdate(Sql);
		}
		
	}
	out.println("<div class=\"row\"><h5>视频库字段创建成功</h5></div>");


	//5.系统参数
	createParameter("是否开启租户","zuhu",2,1,0,"");
	createParameter("tcenterMedia访问链接","copyright",0,0,0,"泰德网聚 版权所有<span class=\"mg-x-8\">|</span><a class=\"tx-white\" href=\"http://www.tidemedia.com/\" target=\"_blank\">访问官方网站</a>");
	createParameter("用户表id参数","user",0,0,1,"{\"userid\":14263}");
	createParameter("选题id","xuanti",0,0,1,"{\"xuantiid\":16085}");
	createParameter("互动管理","hudong_guanli",0,0,1,"{\"shequ\":14271,\n\"pingjia\":14265,\n\"yijian\":14268,\n\"baoliao\":16019}");
	createParameter("问政","wenzheng",0,0,1,"{\"wenzheng\":16200,\n\"wenzheng_result\":16202,\n\"wenzheng_tongji\":16211}");

	tu_user.executeUpdate("insert into parameter (Name,Code,Content,CreateDate,Type2,IntValue,IsJson) values(\"cms接口地址\",\"cms_api\",\"http://123.56.71.230:889/cms/\",now(),0,0,0)");
	tu_user.executeUpdate("insert into parameter (Name,Code,Content,CreateDate,Type2,IntValue,IsJson) values('tcenterMedia访问链接','copyright','泰德网聚 版权所有<span class=\"mg-x-8\">|</span><a class=\"tx-white\" href=\"http://www.tidemedia.com/\" target=\"_blank\">访问官方网站</a>',now(),0,0,0)");
	tu_user.executeUpdate("insert into parameter (Name,Code,Content,CreateDate,Type2,IntValue,IsJson) values(\"背景图片地址\",\"background_image\",\"img/2017/login_body_bg.jpg\",now(),0,0,0)");
	tu_user.executeUpdate("insert into parameter (Name,Code,Content,CreateDate,Type2,IntValue,IsJson) values(\"tcenter-Logo封面\",\"logo_image\",\"img/2018/login_logo.png\",now(),0,0,0)");

	out.println("<div class=\"row\"><h5>系统参数创建成功</h5></div>");

	//6.创建产品
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('平台管理','/tcenter/main_system2018.jsp',1,0,1,'<i class=\"fa fa-cog\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('大数据展示','/cms/screen/index_tcenter.jsp',1,0,1,'<i class=\"fa fa-eye\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('用户数据','/cms/user/index_tcenter.jsp',1,0,1,'<i class=\"fa fa-users\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('数据统计','/tongji/index_tcenter.jsp',1,0,1,'<i class=\"fa fa-bar-chart\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('选题任务','/cms/task/index_tcenter.jsp',1,0,1,'<i class=\"fa fa-check-square-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('舆情系统','/cms/yuqing/index_tcenter.jsp',1,0,1,'<i class=\"fa fa-commenting\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('OA系统','http://www.tidemedia.com/',1,0,1,'<i class=\"fa fa-tags\"></i>',1)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('指挥调度','http://123.56.71.230:65524/b/b/1541656281751.shtml',1,0,1,'<i class=\"fa fa-street-view\"></i>',1)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('APP管理','/cms/app/index_tcenter.jsp',1,0,2,'<i class=\"fa fa-tablet\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('网站管理','/cms/web/index_tcenter.jsp',1,0,2,'<i class=\"fa fa-laptop\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('微信矩阵','/weixin',1,0,2,'<i class=\"fa fa-comment-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('电子报','/cms/epaper/index_tcenter.jsp',1,0,2,'<i class=\"fa fa-newspaper-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('网络电视','',1,0,2,'<i class=\"fa fa-television\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('问政系统','/cms/wenzheng/index_tcenter.jsp',1,0,2,'<i class=\"fa fa-heart\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('电子地图','/cms/emap/index_tcenter.jsp',1,0,2,'<i class=\"fa fa-map\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('信息推送','/cms/main_tcenter_social.jsp',1,0,2,'<i class=\"fa fa-bell-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('应用管理','/cms/index_tcenter.jsp',1,0,2,'<i class=\"fa fa-cube\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('PGC内容','/cms/pgc/index_tcenter.jsp',1,0,3,'<i class=\"fa fa-address-card\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('UGC内容','/cms/ugc/index_tcenter.jsp',1,0,3,'<i class=\"fa fa-comment\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('全媒体资源','/vms/index_tcenter.jsp',1,0,3,'<i class=\"fa fa-database\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('内容采集','/cms/collect/index_tcenter.jsp',1,0,3,'<i class=\"fa fa-history\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('云媒资','',1,0,3,'<i class=\"fa fa-compass\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('收录剪辑','/vms/chaitiao/index_tcenter.jsp',1,0,3,'<i class=\"fa fa-refresh\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('云快编','/vms/videoeditor/main_nles.jsp',1,0,4,'<i class=\"fa fa-scissors\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('云导播','',1,0,4,'<i class=\"fa fa-sliders\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('云直播','http://console.juyun.tv/index/countpage/index',1,0,4,'<i class=\"fa fa-play-circle-o\"></i>',1)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('H5云制作','https://xiumi.us',1,0,4,'<i class=\"fa fa-html5\"></i>',1)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('流矩阵管理','/encoder/index_tcenter.jsp',1,0,4,'<i class=\"fa fa-random\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('直播分发','/live/index_tcenter.jsp',1,0,4,'<i class=\"fa fa-youtube-play\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('移动审片','/cms/shenpian/index_tcenter.jsp',1,0,4,'<i class=\"fa fa-film\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('文稿管理','/cms/shengao/index_tcenter.jsp',1,0,4,'<i class=\"fa fa-file-text\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('线索汇聚','/cms/collect/index_tcenter.jsp',1,0,5,'<i class=\"fa fa-binoculars\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('选题策划','/cms/task/index_tcenter.jsp',1,0,5,'<i class=\"fa fa-check-square-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('指挥调度','http://123.56.71.230:65524/b/b/1541656281751.shtml',1,0,5,'<i class=\"fa fa-street-view\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('信息呈现','/cms/screen/daping_guanli.jsp',1,0,5,'<i class=\"fa fa-eye\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('工作流管理','/cms/system/index_2018.jsp?id=11',1,0,5,'<i class=\"fa fa-random\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('远程回传','/cms/pgc/main.jsp',1,0,6,'<i class=\"fa fa-address-book\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('素材上传','/vms2018/lib/webIndex.jsp',1,0,6,'<i class=\"fa fa-cloud-upload\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('互联网汇聚','/cms/collect/Index2018.jsp',1,0,6,'<i class=\"fa fa-jsfiddle\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('信号收录','/vms/chaitiao/main.jsp',1,0,6,'<i class=\"fa fa-camera-retro\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('通讯稿','',1,0,6,'<i class=\"fa fa-file-text\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('云媒资','',1,0,6,'<i class=\"fa fa-cloud-download\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('UGC内容汇聚','/cms/ugc/ugc_main.jsp',1,0,6,'<i class=\"fa fa-comments\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('内容生产','/cms/index_tcenter.jsp',1,0,7,'<i class=\"fa fa-refresh\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('资源入库','',1,0,7,'<i class=\"fa fa-sign-in\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('资源编目','',1,0,7,'<i class=\"fa fa-pencil-square-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('资源管理','',1,0,7,'<i class=\"fa fa-database\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('资源检索','',1,0,7,'<i class=\"fa fa-search\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('资源出库','',1,0,7,'<i class=\"fa fa-sign-out\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('文稿管理','',1,0,7,'<i class=\"fa fa-folder-open\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('移动审片','',1,0,7,'<i class=\"fa fa-film\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('节目素材','/vms2018/lib/index_tcenter.jsp?channelid=13969',1,0,7,'',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('客户端发布','/cms/app/index_tcenter.jsp',1,0,8,'<i class=\"fa fa-mobile\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('网站管理','/cms/web/index_tcenter.jsp',1,0,8,'<i class=\"fa fa-laptop\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('微信矩阵','http://tidetest.vojs.tv/weixin/loginController.do?login',1,0,8,'<i class=\"fa fa-weixin\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('报刊发布','/cms/epaper/index_tcenter.jsp',1,0,8,'<i class=\"fa fa-newspaper-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('网络电视','',1,0,8,'<i class=\"fa fa-tv\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('网络广播','',1,0,8,'<i class=\"fa fa-podcast\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('第三方发布','',1,0,8,'<i class=\"fa fa-paper-plane\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('党建服务','',1,0,9,'<i class=\"fa fa-book\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('政务服务','',1,0,9,'<i class=\"fa fa-briefcase\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('公共服务','',1,0,9,'<i class=\"fa fa-coffee\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('增值服务','',1,0,9,'<i class=\"fa fa-gift\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('互动直播','http://console.juyun.tv/index.php/index/index/index',1,0,10,'<i class=\"fa fa-desktop\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('网络问政','/cms/wenzheng/wenzheng_main.jsp',1,0,10,'<i class=\"fa fa-heart\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('信息推送','/cms/content/push_message_content2018.jsp?id=1594',1,0,10,'<i class=\"fa fa-paper-plane\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('爆料系统','/cms/content/content2018_baoliao.jsp?id=15903',1,0,10,'<i class=\"fa fa-phone\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('社区系统','/cms/app/appIndex2018.jsp?childGroup=3',1,0,10,'<i class=\"fa fa-comments\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('媒体号','/cms/app/appIndex2018.jsp?childGroup=1',1,0,10,'<i class=\"fa fa-feed\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('LBS服务','/cms/emap/main.jsp',1,0,10,'<i class=\"fa fa-map\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('舆情热点','',1,0,11,'<i class=\"fa fa-line-chart\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('传播分析','',1,0,11,'<i class=\"fa fa-podcast\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('用户分析','',1,0,11,'<i class=\"fa fa-users\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('快编生产','/vms2018/vodedit/main.jsp',1,0,12,'<i class=\"fa fa-scissors\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('精编生产','',1,0,12,'<i class=\"fa fa-bars\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('音频生产','',1,0,12,'<i class=\"fa fa-headphones\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('收录剪辑','/vms/chaitiao/main.jsp',1,0,12,'<i class=\"fa fa-camera-retro\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('云导播','http://console.juyun.tv/director/Index/index',1,0,12,'<i class=\"fa fa-sliders\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('智能视频生产','',1,0,12,'<i class=\"fa fa-random\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('直播流检测','',1,0,12,'<i class=\"fa fa-magic\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('AI智能识别','/vms2018/ai/index.html?itemid=413&channelid=13967&title=cctv13',1,0,12,'<i class=\"fa fa-tags\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('H5编辑器','',1,0,13,'<i class=\"fa fa-address-book\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('图片处理','',1,0,13,'<i class=\"fa fa-cloud-upload\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('稿件编辑','',1,0,13,'<i class=\"fa fa-jsfiddle\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('智能写稿','',1,0,13,'<i class=\"fa fa-camera-retro\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('生产协同','',1,0,14,'<i class=\"fa fa-arrows\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('数据分析','',1,0,14,'<i class=\"fa fa-bar-chart\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('智能监测','',1,0,14,'<i class=\"fa fa-spinner\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('数据迁移','',1,0,14,'<i class=\"fa fa-share\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('APP生产','/cms/app/main.jsp',1,0,15,'<i class=\"fa fa-tablet\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('报刊编排','',1,0,15,'<i class=\"fa fa-newspaper-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('微信编辑','http://tidetest.vojs.tv/weixin/loginController.do?login',1,0,15,'<i class=\"fa fa-weixin\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('微博编辑','',1,0,15,'<i class=\"fa fa-weibo\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('租户管理','/tcenter/company/company_index.jsp',1,0,16,'<i class=\"fa fa-bed\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('系统用户管理','/tcenter/main_system2018.jsp',1,0,16,'<i class=\"fa fa-address-card\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('权限管理','/cms/user/index2018.jsp',1,0,16,'<i class=\"fa fa-key\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('计量计费','',1,0,16,'<i class=\"fa fa-hourglass\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('运维管理','/cms/system/index_2018.jsp?id=8',1,0,16,'<i class=\"fa fa-plug\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('绩效管理','',1,0,16,'<i class=\"fa fa-print\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('租户注册','/tcenter/company/company_add.jsp',1,0,16,'<i class=\"fa fa-briefcase\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('统计分析','/tongji/main.jsp',1,0,17,'<i class=\"fa fa-line-chart\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('用户中心','/cms/appuser/main.jsp',1,0,17,'<i class=\"fa fa-address-card\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('用户行为数据','/cms/app/appIndex2018.jsp?childGroup=',1,0,17,'<i class=\"fa fa-street-view\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('用户互动管理','',1,0,17,'<i class=\"fa fa-comments-o\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('PGC用户管理','',1,0,17,'<i class=\"fa fa-address-card\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('教育资源','http://www.jetsen.com.cn/index.php?m=index.technology&cid=10',1,0,18,'<i class=\"fa fa-leaf\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('专业气象服务','http://www.weather.com.cn/',1,0,18,'<i class=\"fa fa-globe\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('影视资源','http://www.huashi.tv/class/view?id=10103',1,0,18,'<i class=\"fa fa-film\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('听书资源','http://www.t1678.com/',1,0,18,'<i class=\"fa fa-music\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('校园体育','http://www.jsports.cn/',1,0,18,'<i class=\"fa fa-bicycle\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('宣传管理服务','',1,0,19,'<i class=\"fa fa-compass\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('内容监管','',1,0,19,'<i class=\"fa fa-crosshairs\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('通联协作','',1,0,20,'<i class=\"fa fa-share\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('内容交换','',1,0,20,'<i class=\"fa fa-refresh\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('培训知识库','',1,0,20,'<i class=\"fa fa-clone\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('资源监控','',1,0,21,'<i class=\"fa fa-database\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('资源应用分析','',1,0,21,'<i class=\"fa fa-truck\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('接口规划','',1,0,22,'<i class=\"fa fa-sitemap\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('接口调度管理','',1,0,22,'<i class=\"fa fa-server\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('接口监控','',1,0,22,'<i class=\"fa fa-tv\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('安全监控','',1,0,23,'<i class=\"fa fa-tv\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('登录日志','',1,0,23,'<i class=\"fa fa-sign-out\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('操作日志','',1,0,23,'<i class=\"fa fa-calendar\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('>错误日志','',1,0,23,'<i class=\"fa fa-ban\"></i>',0)");

	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('AI安全审核','',1,0,24,'<i class=\"fa fa-shield\"></i>',0)");
	tu_user.executeUpdate("insert into tide_products (Name,Url,Status,Type,groupId,logo,newpage) values('敏感词过滤','',1,0,24,'<i class=\"fa fa-tags\"></i>',0)");

	tu_user.executeUpdate("update tide_products set OrderNumber=id*100 where OrderNumber=0");
	out.println("<div class=\"row\"><h5>产品创建成功</h5></div>");
}

//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();

%>
	</div>	                   
</div>

</div>
</body>
</html>