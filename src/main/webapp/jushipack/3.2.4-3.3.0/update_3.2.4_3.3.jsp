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
<%@ include file="update_api.jsp"%>

<%

if(!userinfo_session.isAdministrator())
{ response.sendRedirect("../noperm.jsp");return;}

String Sql = "";
ResultSet Rs;
TableUtil tu = new TableUtil();
TableUtil tu_user = new TableUtil("user");
int channelId = 0 ;
int parent = 0 ;
String html = "";

String dirPath = "";//站点目录
String realPath = request.getSession().getServletContext().getRealPath("")+request.getServletPath();//文件路径
File file = new File(realPath);
String filePath = file.getParent();
int templateId = 0;//模板id
String filecontent = "";//模板内容

%>

<%
//文件更新
Site site = new Site(53);
dirPath = site.getSiteFolder();
if(dirPath.equals("")){
	out.println("站点目录未填写，请先进入系统配置填写站点目录。");
	return ;
}
File dir=new File(dirPath);
if(!dir.exists()){
	out.println("目录不存在，请先创建目录");
	return ;
}
out.println(dirPath);

//静态文件功能：所有分享页的阅读数，发布时间改为由appConfig.json读取配置

//js
//FileUtil.copyFile(filePath+"/js/js.zip",dirPath+"/js/js.zip");
//unZipFiles(new File(dirPath+"/js/js.zip"),dirPath+"/js");
//css
//FileUtil.copyFile(filePath+"/css/css.zip",dirPath+"/css/css.zip");
//unZipFiles(new File(dirPath+"/css/css.zip"),dirPath+"/css");
//images
//FileUtil.copyFile(filePath+"/images/images.zip",dirPath+"/images/images.zip");
//unZipFiles(new File(dirPath+"/images/images.zip"),dirPath+"/images");
//share
//FileUtil.copyFile(filePath+"/share/share.zip",dirPath+"/share/share.zip");
//unZipFiles(new File(dirPath+"/share/share.zip"),dirPath+"/share");
%>

<%
//升级3.3.0
//1.功能说明：媒体号审核中增加媒体号内容页地址字段
//老版本影响说明：不影响
channelId = getChannelId("company_s53_info");
createField("listurl","频道列表地址","text", "", channelId, "", 0, 0);
html = "\nlisturl=listurl";
tu.executeUpdate("update channel set RecommendOutRelation=concat(RecommendOutRelation,'"+html+"') where id="+channelId);
tu.executeUpdate("update channel set ListProgram='../content/media_content2018.jsp',DocumentProgram='../content/document_media.jsp' where id="+channelId);

//2.功能说明：媒体号审核频道编号增加系统参数
//老版本影响说明：不影响
try{
	createParameter("媒体号内容管理","company_source",2,15913,0,"");
}catch(Exception e){
	
}

//3.增加系统参数:智能裁剪
//老版本影响说明：不影响
try{
	createParameter("智能裁剪","cropimage_",0,0,1,"{\"cropimage_channel\":\"15892_15893_15894*\",\n\"cropimage_path\":\"/mnt/tclip/tclip-master/soft/tclip\",\n\"open\":1}");
}catch(Exception e){
	
}
//4.功能说明：新建频道:互动信息-社区管理-主播互动模块
//老版本影响说明：不影响
parent = getChannelId("community");
channelId = createChannel("主播互动模块",parent,0,"community_s53_recommend","community_recommend");
//新建字段
createField("companyid","企业编号","text", "", channelId, "", 0, 0);

tu.executeUpdate("update field_desc set Description='媒体号名称(非前端显示)' where FieldName='Title' and ChannelID="+channelId);

//5.功能说明：信息推送字段修改：摘要、跳转类型、推送平台中、注册码、源ID、源地址
//老版本影响说明：不影响
channelId = getChannelId("s53_push");
tu.executeUpdate("update field_desc set IsHide=0 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("delete from field_options where ChannelID=" + channelId + " and FieldName='jumptype'");
tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','jumptype','文章详情(0)')");
tu.executeUpdate("delete from field_options where ChannelID=" + channelId + " and FieldName='platform'");
tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','platform','所有(0)'),('"+channelId+"','platform','ios(1)'),('"+channelId+"','platform','android(2)')");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='registration' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='源文章GlobalID' where FieldName='source_gid' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='源文章内容页地址' where FieldName='source_url' and ChannelID="+channelId);
//信息推送列表页、内容页地址修改
tu.executeUpdate("update channel set ListProgram='../content/push_message_content2018.jsp',DocumentProgram='../util/push_document2018.jsp' where id="+channelId);

//6.功能说明：主播互动模块字段隐藏
//老版本影响说明：不影响
channelId = getChannelId("community_s53_recommend");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);

//7.功能说明：媒体号管理频道增加字段
//老版本影响说明：不影响
channelId = getChannelId("company_s53_manager");
createField("model_control","媒体号模块设置","checkbox", "1,5,6,7", channelId, "动态(1)\n互动(2)\n帖子(3)\n相册(4)\n直播(5)\n视频(6)\n图文(7)", 1, 0);
createField("userid","关联社区用户编号","number", "", channelId, "", 0, 0);
createField("topic_category","话题分类编号","number", "0", channelId, "", 0, 0);
tu.executeUpdate("update field_desc set Description='媒体号简介',IsHide=0 where FieldName='Summary' and ChannelID="+channelId);

//8.功能说明:栏目管理-直播状态字段增加选项
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','state','直播关闭(3)')");

//9.功能说明:增加频道:h5编辑器图片库
//老版本影响说明：不影响
parent = getChannelId("s53_e");
channelId = createChannel("H5资源维护",parent,0,"","");
createField("sourceid","资源编号","number", "", channelId, "", 0, 0);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
//创建子频道
int channelid1 	 = createChannel("标题",channelId,1,"","");
int channelid1_1 = createChannel("文字标题",channelid1,1,"","");
int channelid1_2 = createChannel("线框标题",channelid1,1,"","");
int channelid1_3 = createChannel("底色标题",channelid1,1,"","");
int channelid1_4 = createChannel("编号标题",channelid1,1,"","");
int channelid2   = createChannel("内容",channelId,1,"","");
int channelid2_1 = createChannel("边框内容",channelid2,1,"","");
int channelid2_2 = createChannel("底色内容",channelid2,1,"","");
int channelid2_3 = createChannel("序号/轴线",channelid2,1,"","");
int channelid2_4 = createChannel("分割线",channelid2,1,"","");
int channelid2_5 = createChannel("左右分栏",channelid2,1,"","");
int channelid3   = createChannel("图文",channelId,1,"","");
int channelid3_1 = createChannel("左右图文",channelid3,1,"","");
int channelid3_2 = createChannel("上下图文",channelid3,1,"","");
int channelid3_3 = createChannel("背景图/信纸",channelid3,1,"","");
int channelid3_4 = createChannel("纯图片",channelid3,1,"","");
int channelid4   = createChannel("场景",channelId,1,"","");
int channelid4_1 = createChannel("关注引导",channelid4,1,"","");
int channelid4_2 = createChannel("签名",channelid4,1,"","");
int channelid4_3 = createChannel("阅读原文引导",channelid4,1,"","");
int channelid5   = createChannel("节日",channelId,1,"","");
int channelid5_1 = createChannel("春节",channelid5,1,"","");
int channelid5_2 = createChannel("七夕",channelid5,1,"","");
int channelid5_3 = createChannel("其他",channelid5,1,"","");
//h5编辑器增加系统参数
try{
	createParameter("h5图片库","relation_h5_source",0,0,1,"{\n\"4241\":"+channelid1_1+",\n\"4175\":"+channelid1_2+",\n\"4176\":"+channelid1_3+",\n\"4174\":"+channelid1_4+",\n\"4177\":"+channelid2_1+",\n\"4179\":"+channelid2_2+",\n\"4180\":"+channelid2_3+",\n\"4181\":"+channelid2_4+",\n\"12075\":"+channelid2_5+",\n\"4185\":"+channelid3_1+",\n\"4186\":"+channelid3_2+",\n\"4187\":"+channelid3_3+",\n\"12102\":"+channelid3_4+",\n\"4148\":"+channelid4_1+",\n\"12005\":"+channelid4_2+",\n\"4189\":"+channelid4_3+",\n\"39695\":"+channelid5_1+",\n\"32277\":"+channelid5_2+",\n\"39525\":"+channelid5_3+"\n}");
}catch(Exception e){
	
}

//11.功能说明:App管理频道-栏目管理增加字段:爆料文章审核状态
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
createField("baoliaostatus","爆料文章审核状态","radio", "0", channelId, "待审核(0)\n审核通过(1)\n审核驳回(2)", 1, 0);

//12.功能说明:App管理频道-爆料按钮控制组管理频道修改字段描述
//老版本影响说明：不影响
channelId = getChannelId("s53_baoliao_button_control");
tu.executeUpdate("update field_desc set Description='爆料内容入库栏目' where FieldName='serial' and ChannelID="+channelId);

//13.功能说明:App配置字段修改
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
tu.executeUpdate("update field_desc set IsHide=0,Description='媒体号，个人主页及我的背景图' where FieldName='Photo' and ChannelID="+channelId);

//16.功能说明:APP管理---栏目管理 模板修改(微信分享不取title作为摘要)
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"content_wap.shtml",2);
file = new File(filePath+"/template/app/content_wap.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

templateId = getTemplateID(channelId,"pic_wap_content.shtml",2);
file = new File(filePath+"/template/app/pic_wap_content.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

templateId = getTemplateID(channelId,"live_wap.html",2);
file = new File(filePath+"/template/wap/live_wap.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

templateId = getTemplateID(channelId,"video_wap.html",2);
file = new File(filePath+"/template/wap/video_wap.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//18.功能说明:媒体号管理：修改‘媒体号模块设置’字段默认值
//老版本影响说明：不影响
channelId = getChannelId("company_s53_manager");
tu.executeUpdate("update field_desc set DefaultValue='1,5,6,7' where FieldName='model_control' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='关联内容频道' where FieldName='listurl' and ChannelID="+channelId);
tu.executeUpdate("update channel set DocumentProgram='../content/document_company.jsp' where id="+channelId);
ChannelUtil.updateSubChannelsAttribute(channelId,8,"../content/document_company.jsp");//应用到子频道

//21.功能说明:互动管理-->社区管理-->“评论管理”改为“帖子评论管理”
//老版本影响说明：不影响
channelId = getChannelId("community_comment");
tu.executeUpdate("update channel set Name='帖子评论管理' where id="+channelId);

//22.功能说明:互动管理-->评论管理”改为“文章评论管理”
//老版本影响说明：不影响
channelId = getChannelId("comment");
tu.executeUpdate("update channel set Name='文章评论管理' where id="+channelId);

//23.功能说明:用户管理→用户行为→社区积分记录(修改字段类型)
//老版本影响说明：不影响
channelId = getChannelId("community_s53_score");
tu.executeUpdate("update field_desc set DefaultValue='0',FieldType='radio' where FieldName='readstatus' and ChannelID="+channelId);
tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','readstatus','未读(0)'),('"+channelId+"','readstatus','已读(1)')");

//24.功能说明:用户管理→用户行为→收藏记录(修改字段类型)
//老版本影响说明：不影响
channelId = getChannelId("collect");
tu.executeUpdate("update channel_collect set filed_type=null where filed_type=''");
tu.executeUpdate("alter table channel_collect modify column filed_type int(11)");
tu.executeUpdate("update field_desc set FieldType='radio',DataType=1 where FieldName='filed_type' and ChannelID="+channelId);
tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','filed_type','图文(1)'),('"+channelId+"','filed_type','视频(2)'),('"+channelId+"','filed_type','图集(3)'),('"+channelId+"','filed_type','专题(4)'),('"+channelId+"','filed_type','聚现直播(5)'),('"+channelId+"','filed_type','PDF文档(6)'),('"+channelId+"','filed_type','栏目跳转(7)'),('"+channelId+"','filed_type','外链(8)'),('"+channelId+"','filed_type','直播(9)')");

//25.功能说明:信息推送频道中增加字段
//老版本影响说明：不影响
channelId = getChannelId("s53_push");
createField("juxian_liveid","聚现直播ID","number", "0", channelId, "", 0, 0);
createField("shareliveurl","聚现直播分享链接","text", "", channelId, "", 0, 0);
tu.executeUpdate("delete from field_options where ChannelID=" + channelId + " and FieldName='audience_type'");
tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','audience_type','所有人(0)'),('"+channelId+"','audience_type','别名(1)'),('"+channelId+"','audience_type','序列号(2)')");

//26.功能说明:新建频道:用户行为记录-用户推送删除记录
//老版本影响说明：不影响
parent = getChannelId("s53_g_a");
channelId = createChannel("用户推送删除记录",parent,0,"s53_messagedelete","b");
createField("push_id","推送记录编号","number", "0", channelId, "", 0, 0);
createField("userid","用户编号","number", "0", channelId, "", 0, 0);
tu.executeUpdate("update field_desc set Description='用户名称' where FieldName='Title' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='记录创建时间' where FieldName='PublishDate' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Photo' and ChannelID="+channelId);

//27.功能说明:聚现直播修改列表页地址
//老版本影响说明：不影响
channelId = getChannelId("s53_juxianlive");
tu.executeUpdate("update channel set ListProgram='../content/content_juxianLive2018.jsp' where id="+channelId);

//28.功能说明:注册用户信息列表页地址
//老版本影响说明：不影响
channelId = getChannelId("register");
tu.executeUpdate("update channel set ListProgram='../content/content_user.jsp' where id="+channelId);

//29.功能说明:视频库修改列表页地址
//老版本影响说明：不影响
channelId = getChannelId("s4_a");
tu.executeUpdate("update channel set ListProgram='' where id="+channelId);

//30.功能说明:信息推送频道修改引用对应关系
//老版本影响说明：不影响
channelId = getChannelId("s53_push");
html = "Title=Title\ndoc_type=doc_type\nsource_gid=getGlobalID()\n";
html += "source_url=template:#if($item.getValue(\"doc_type\")==0||$item.getValue(\"doc_type\")==1||$item.getValue(\"doc_type\")==8)$item.getFullHref(\"app\")#elseif($item.getValue(\"doc_type\")==2)$item.getFullHref(\"pic\")#elseif($item.getValue(\"doc_type\")==7)$item.getValue(\"href_app\")#else#end\n";
html += "sharepicurl=template:#if($item.getValue(\"doc_type\")==2)$item.getFullHref(\"picwap\")#else#end\n";
html += "audio=isAudio\njuxian_liveid=juxian_liveid\nshareliveurl=live_shareurl\n";
tu.executeUpdate("update channel set Attribute2='"+html+"' where id="+channelId);

//31.功能说明:app管理--栏目管理  修改页面json中用于微信分享的字段url
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"content.shtml",2);
file = new File(filePath+"/template/app/content.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//32.功能说明:app管理--app配置  新增pohto字段
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
templateId = getTemplateID(channelId,"appconfig.json",3);
file = new File(filePath+"/template/app/appconfig.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//33.功能：app管理--栏目管理  针对爆料内容，设置未公开的话，让它不会呈现出
//老版本影响：
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"list_1_0.shtml",1);
file = new File(filePath+"/template/app/list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//34.功能：app管理--媒体号内容管理  针对爆料内容，设置未公开的话，让它不会呈现出
//老版本影响：
channelId = getChannelId("company_s53_source");
templateId = getTemplateID(channelId,"live_list_1_0.shtml",1);
file = new File(filePath+"/template/company/live_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

templateId = getTemplateID(channelId,"textimage_list_1_0.shtml",1);
file = new File(filePath+"/template/company/textimage_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

templateId = getTemplateID(channelId,"video_list_1_0.shtml",1);
file = new File(filePath+"/template/company/video_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//35.功能说明:栏目管理下增加字段
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
createField("baoliao_userid","爆料提交用户编号","number", "0", channelId, "", 0, 0);
createField("baoliao_ispublic","爆料是否公开","radio", "0", channelId, "不公开(0)\n公开(1)", 1, 0);
tu.executeUpdate("update field_desc set Description='客户端内容标识' where FieldName='doc_type' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='自定义内容标识' where FieldName='content_type' and ChannelID="+channelId);

//36.功能说明:爆料频道中默认增加列表页程序，用于显示爆料审核和爆料驳回按钮
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a_a_h");
tu.executeUpdate("update channel set ListProgram='../content/content2018_baoliao.jsp' where id="+channelId);

//37.功能说明:app管理--app配置  字段修改
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
tu.executeUpdate("update field_desc set Description='文章评论数' where FieldName='showcomment' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='自定义内容标识' where FieldName='showtype' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='文章评论功能' where FieldName='allowcomment' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='文章发布时间' where FieldName='showtime' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='阅读量' where FieldName='showread' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='订阅栏目' where FieldName='customcategory' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='社区相关信息' where FieldName='showcommunity' and ChannelID="+channelId);

//38.功能说明:直播防盗链频道  字段修改
//老版本影响说明：不影响
channelId = getChannelId("s53_token");
tu.executeUpdate("update field_desc set Description='授权开始时间' where FieldName='start_time' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='授权到期时间' where FieldName='end_time' and ChannelID="+channelId);

//39.功能说明:用户行为记录 / 用户订阅栏目信息记录  字段修改
//老版本影响说明：不影响
channelId = getChannelId("category_s53_personinfo");
tu.executeUpdate("update field_desc set Description='用户订阅栏目编号' where FieldName='categoryinfo' and ChannelID="+channelId);

//40:功能说明:互动管理-->评论/贴子审核设置：图片字段隐藏
//老版本影响说明：不影响
channelId = getChannelId("checkmodel");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Photo' and ChannelID="+channelId);
delGroup(channelId);

//41:功能说明:媒体号管理字段增加说明
//老版本影响说明：不影响
channelId = getChannelId("company_s53_manager");
tu.executeUpdate("update field_desc set Caption='不超过56个字' where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Caption='结合“PGC移动创作平台”使用。' where FieldName='token' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Caption='开通互动、帖子、相册功能必须关联。' where FieldName='userid' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Caption='开通互动功能必须关联。' where FieldName='topic_category' and ChannelID="+channelId);

//42.功能：APP管理-栏目管理  给图片加上完整域名
//老版本影响：
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"list_slide_1_0.json",1);
file = new File(filePath+"/template/app/list_slide_1_0.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//44.互动-周边频道隐藏
//老版本影响：不影响
channelId = getChannelId("s53_a_a_c_c");
tu.executeUpdate("update channel set IsDisplay=0 where id="+channelId);

//45.修改调度程序地址
tu.executeUpdate("update quartz_manager set Program='http://127.0.0.1:889/cms/util/sync_juxian.jsp' where title='同步聚现资源'");
tu.executeUpdate("update quartz_manager set Program='http://127.0.0.1:889/cms/util/juxian_company_message.jsp' where title='同步聚现企业'");

//46.按钮内容
channelId = getChannelId("s53_button");
ChannelUtil.updateSubChannelsAttribute(channelId,6,"");

//47.功能说明：媒体号管理频道修改推荐关系
//老版本影响说明：不影响
channelId = getChannelId("company_s53_manager");
html = "Title=Title\nPublishDate=PublishDate\nSummary=Summary\nPhoto=Photo\nphone=phone\ncompanyid=company_id\nparent=parent\ntoken=token\naddress=address";
tu.executeUpdate("update channel set RecommendOutRelation='"+html+"' where id="+channelId);
tu.executeUpdate("update channel set RecommendOut='community_s53_recommend' where id="+channelId);
ChannelUtil.updateSubChannelsAttribute(channelId,4,html);//应用到子频道
ChannelUtil.updateSubChannelsAttribute(channelId,3,"community_s53_recommend");//应用到子频道

//48:功能说明:图片库定制列表页
//老版本影响说明:不影响
channelId = getChannelId("photo");
tu.executeUpdate("update channel set ListProgram='../photo/photos_content2018.jsp' where id="+channelId);

//49:功能说明:APP版本信息修改目录名
//老版本影响说明:不影响
channelId = getChannelId("s53_a_b");
updateChannel("app",channelId);

//50:功能说明:解决相关文章不取大图
//频道：APP管理-栏目管理 app/list_1_0.shtml
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"list_1_0.shtml",1);
file = new File(filePath+"/template/app/list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
//频道：媒体号内容管理
channelId = getChannelId("company_s53_source");
templateId = getTemplateID(channelId,"live_list_1_0.shtml",1);
file = new File(filePath+"/template/company/live_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
templateId = getTemplateID(channelId,"textimage_list_1_0.shtml",1);
file = new File(filePath+"/template/company/textimage_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
templateId = getTemplateID(channelId,"video_list_1_0.shtml",1);
file = new File(filePath+"/template/company/video_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

PublishManager publishmanager = PublishManager.getInstance();
//15.功能说明:协议与须知频道目录名Agreement 改成agreement 
//老版本影响说明：不影响
channelId = getChannelId("s53_a_e");
updateChannel("agreement",channelId);
publishmanager.ChannelPublish(channelId,1,userinfo_session.getId(),1);
//16.功能说明:协议与须知-----邀请分享频道目录名/Agreement/share/改成share
//老版本影响说明：不影响
channelId = getChannelId("share");
updateChannel("share",channelId);
publishmanager.ChannelPublish(channelId,1,userinfo_session.getId(),1);
//模板修改:
//老版本影响说明：不影响
//模板share_pc.html生成文件名share_pc.html改成 pc.html
templateId = getTemplateID(channelId,"share_pc.html",3);
tu.executeUpdate("update channel_template set TargetName='pc.html' where TemplateID="+templateId+" and Channel="+channelId);
//模板share_pc.html生成文件名share_app.html改成 app.html
templateId = getTemplateID(channelId,"share_app.html",3);
tu.executeUpdate("update channel_template set TargetName='app.html' where TemplateID="+templateId+" and Channel="+channelId);
//17.功能说明:协议与须知---邀请分享页 模板修改(优化app下载页)
//老版本影响说明：不影响
channelId = getChannelId("share");
templateId = getTemplateID(channelId,"pc.html",3);
file = new File(filePath+"/template/wap/share_pc.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
templateId = getTemplateID(channelId,"app.html",3);
file = new File(filePath+"/template/wap/share_app.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//18.功能说明:模板配置修改
//关于我们
channelId = getChannelId("s53_a_e_a");
templateId = getTemplateID(channelId,"about.html",2);
UpdateTemplate(templateId,3,"filename");
//用户隐私协议
channelId = getChannelId("s53_a_e_b");
templateId = getTemplateID(channelId,"policy.html",2);
UpdateTemplate(templateId,3,"filename");
//媒体号注册须知
channelId = getChannelId("s53_a_e_d");
templateId = getTemplateID(channelId,"notes.html",2);
UpdateTemplate(templateId,3,"filename");

/*
//20.功能说明:工作流
//老版本影响说明：不影响
//20.1  channel表增加ApproveScheme字段
tu.executeUpdate("alter table channel add ApproveScheme text");
*/
/*
//43.增加下载提示频道(3.2.4数据库安装包有问题,需删除此频道重新创建)
//老版本影响：
parent = getChannelId("s53_a");
channelId = createChannel("下载提示",parent,0,"Downloadprompt","Downloadprompt");
//新建字段
createField("AndroidDownload","安卓下载地址","text", "", channelId, "", 0, 0);
createField("IosDownload","苹果下载地址","text", "", channelId, "", 0, 0);
//字段修改
tu.executeUpdate("update field_desc set Description='客户端logo' where FieldName='Photo' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='app名称' where FieldName='Title' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
//新增模板
templateId = 1621;//createTemplate(filePath+"/template/wap/down.html","down.html","分享页下载信息",205);
useTemplate(channelId , templateId, "","down.html",3,0,"");
*/
//19.功能说明:field_desc表增加Caption字段(重复)
//老版本影响说明：不影响
//tu.executeUpdate("alter table field_desc add Caption text");


//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();

%>
<br>Over!
