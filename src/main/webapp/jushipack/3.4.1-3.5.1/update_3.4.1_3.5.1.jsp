<%@ page import="java.sql.*,
				tidemedia.cms.base.*,
				tidemedia.cms.system.*,
				tidemedia.cms.util.*,
				java.util.concurrent.*,
				java.util.*,
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
String table = "" ; //表名
HashMap map_doc = new HashMap();
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
/*
//静态文件功能：
//js
FileUtil.copyFile(filePath+"/js/js.zip",dirPath+"/js/js.zip");
unZipFiles(new File(dirPath+"/js/js.zip"),dirPath+"/js");
//css
FileUtil.copyFile(filePath+"/css/css.zip",dirPath+"/css/css.zip");
unZipFiles(new File(dirPath+"/css/css.zip"),dirPath+"/css");
//wenzheng
FileUtil.copyFile(filePath+"/wenzheng/wenzheng.zip",dirPath+"/wenzheng/wenzheng.zip");
unZipFiles(new File(dirPath+"/wenzheng/wenzheng.zip"),dirPath+"/wenzheng");
//html
FileUtil.copyFile(filePath+"/html/html.zip",dirPath+"/html/html.zip");
unZipFiles(new File(dirPath+"/html/html.zip"),dirPath+"/html");
//images
FileUtil.copyFile(filePath+"/images/images.zip",dirPath+"/images/images.zip");
unZipFiles(new File(dirPath+"/images/images.zip"),dirPath+"/images");
//map
FileUtil.copyFile(filePath+"/map/map.zip",dirPath+"/map/map.zip");
unZipFiles(new File(dirPath+"/map/map.zip"),dirPath+"/map");
//share
FileUtil.copyFile(filePath+"/share/share.zip",dirPath+"/share/share.zip");
unZipFiles(new File(dirPath+"/share/share.zip"),dirPath+"/share");
//include
FileUtil.copyFile(filePath+"/include/include.zip",dirPath+"/include/include.zip");
unZipFiles(new File(dirPath+"/include/include.zip"),dirPath+"/include");

*/
%>

<%
/*
//升级3.5.0
//1.功能说明：app配置可视化
//channelId = getChannelId("s53");//获取站点频道id
//channelId = createChannel("APP配置",channelId,0,"s53_app_config","");//创建频道
channelId = getChannelId("s53_app_config");
tu.executeUpdate("update channel set application='app_config' where id="+channelId);

//2.功能说明：启动图增加字段，视频，动图
//老版本影响说明：不影响
channelId = getChannelId("s53_b");
createField("gif","动图","file", "", channelId, "", 0, 0,"格式gif;建议大小：3M以内;建议时长：2-3秒g",0,0);
createField("video","视频","file", "", channelId, "", 0, 0,"格式mp4;建议大小：3M以内;建议时长：2-3秒",0,0);
createField("type","启动页面样式","radio", "", channelId, "图片(1)\n动画(2)\n视频(3)", 1, 0,"",0,0);
createField("countdown","倒计时","switch", "", channelId, "", 0, 0,"",0,0);
createField("skip","跳过","switch", "", channelId, "", 0, 0,"",0,0);
createField("preloadPhoto","预加载图片","image", "", channelId, "", 0, 0,"",0,0);

//3.功能说明：客户端背景设置后台添加字段
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("background","客户端背景设置","radio", "", channelId, "背景颜色(1)\n背景图片(2)", 1, 0,"",0,0);
createField("background_color","背景颜色","text", "", channelId, "", 0, 0,"",0,0);
createField("background_photo","背景图片","image", "", channelId, "", 0, 0,"",0,0);
createField("mandatoryLogin","仅登录后允许提问","switch", "1", channelId, "", 0, 0,"",0,0);
createField("selectionDepartment","用户提问时允许选择部门","switch", "1", channelId, "", 0, 0,"",0,0);

//4.功能说明：APP配置-基础设置 频道增加电视直播/广播背景图上传字段
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("tv_background_photo","直播/广播背景","image", "", channelId, "", 0, 0,"",0,0);

//5.功能说明：APP配置-基础设置 是否开启APP统计
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("tongji","数据分析","switch", "0", channelId, "", 1, 0,"",0,0);

//6.功能说明：APP配置-基础设置 是否开启bugly
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("bugly","开启bugly","switch", "1", channelId, "", 1, 0,"",0,0);

//7.功能说明：APP配置-基础设置 是否开启百度统计
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("baidu_tongji","百度统计","switch", "0", channelId, "", 1, 0,"",0,0);

//8、功能说明，一键封号后台功能
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("globalBanned","全局禁言","switch", "0", channelId, "", 1, 0,"",0,0);
createField("BanInteract","禁止交互","switch", "0", channelId, "", 1, 0,"",0,0);
channelId = getChannelId("register");
createField("Status2","当前状态","radio", "0", channelId, "未封号(0)\n已封号(1)", 1, 0,"",0,0);
createField("Banned","禁言","radio", "0", channelId, "否(0)\n是(1)", 1, 0,"",0,0);
createField("sealDate","封号时间","datetime", "", channelId, "", 0, 0,"",0,0);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='password' and ChannelID="+channelId);//隐藏字段

//9、功能说明：创建敏感词库
//老版本影响说明：不影响
channelId = 2;
createChannel("敏感词库",channelId,0,"sensitive_word","");	
channelId = getChannelId("s53_config");
createField("sensitive_word","敏感词","switch", "0", channelId, "", 1, 0,"",0,0);

//10.功能说明：栏目管理增加字段，广告关闭
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
createField("allowadvert","广告开关","switch", "1", channelId, "", 0, 0,"",0,0);

//11.功能说明：网站管理设置application
//老版本影响说明：不影响
channelId = getChannelId("s53_d");
tu.executeUpdate("update channel set application=\"web\" where id="+channelId);


//12.功能说明：广告投放设置application
//老版本影响说明：不影响
channelId = getChannelId("s53_h_a");
tu.executeUpdate("update channel set application=\"app_advert\" where id="+channelId);


//13.功能说明:爆料界面改版
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
createField("baoliao_localtion","爆料人位置","text", "", channelId, "", 0, 0,"",0,0);
createField("jd","经度","text", "", channelId, "", 0, 0,"",0,0);
createField("wd","纬度","text", "", channelId, "", 0, 0,"",0,0);
createField("showbaoliaouser","是否匿名","switch", "0", channelId, "", 0, 0,"",0,0);

//14.底栏维护频道增加字段，区分是爆料
//老版本影响说明：不影响
channelId = getChannelId("s53_appbot");
createField("baoliao","是否爆料","switch", "0", channelId, "", 1, 0,"",0,0);

//15.修改栏目管理-看电视频道标识
//老版本影响说明：不影响
//channelId = getChannelId("s53_a_a_b_f");
//tu.executeUpdate("update channel set SerialNo=\"s53_nav_tv\" where id="+channelId);
//channelId = getChannelId("s53_a_a_b_g");
//tu.executeUpdate("update channel set SerialNo=\"s53_nav_radio\" where id="+channelId);
channelId = getChannelId("s53_a_a_b");
createChannel("看电视",channelId,1,"s53_nav_tv","");
createChannel("听广播",channelId,1,"s53_nav_radio","");


//16.功能说明:爆料界面改版增加爆料图片
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
createField("baoliao_photo2","爆料图片2","image", "", channelId, "", 0, 0,"",0,0);
createField("baoliao_photo3","爆料图片3","image", "", channelId, "", 0, 0,"",0,0);
createField("baoliao_photo4","爆料图片4","image", "", channelId, "", 0, 0,"",0,0);
createField("baoliao_photo5","爆料图片5","image", "", channelId, "", 0, 0,"",0,0);
createField("baoliao_photo6","爆料图片6","image", "", channelId, "", 0, 0,"",0,0);
createField("baoliao_photo7","爆料图片7","image", "", channelId, "", 0, 0,"",0,0);
createField("baoliao_photo8","爆料图片8","image", "", channelId, "", 0, 0,"",0,0);
createField("baoliao_photo9","爆料图片9","image", "", channelId, "", 0, 0,"",0,0);


//17.互动管理-用户管理 增加字段：金币
//老版本影响说明：不影响
//channelId = getChannelId("register");
//createField("gold","金币","number", "0", channelId, "", 1, 0,"",0,0);

//18.媒体号审核增加聚现终端用户编号
//老版本影响说明：不影响
channelId = getChannelId("company_s53_info");
createField("juxian_userid","聚现用户id","number", "0", channelId, "", 1, 0,"",0,0);
channelId = getChannelId("company_s53_manager");
createField("juxian_userid","聚现用户id","number", "0", channelId, "", 1, 0,"",0,0);


//3.5.0-3.5.1=================================================================================================

//1、功能说明:广告投放频道迁移至APP管理频道下，修改频道名和标识名（手动修改：组件维护、s53_module）
//老版本影响说明：不影响
channelId = getChannelId("s53_module");

//2、功能说明：组件维护下新建继承频道
//老版本影响说明：不影响
createChannel("广告投放",channelId,1,"s53_advert","");
createChannel("专题维护",channelId,1,"s53_module_special","");
createChannel("精品推荐",channelId,1,"s53_module_recommen","");
createChannel("媒体号推荐",channelId,1,"","");
createChannel("按钮组维护",channelId,1,"","");

//3、功能说明:组件维护频道更改字段
//老版本影响说明：不影响
tu.executeUpdate("update field_desc set Description='标题' where FieldName='Title' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='列表页显示位置' where FieldName='listposition' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='数据来源' where FieldName='href' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Caption='封面图的尺寸：69:11' where FieldName='Photo' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Caption='填写页面地址' where FieldName='href' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Caption='输入数字，固定显示在列表页第几行' where FieldName='listposition' and ChannelID="+channelId);
updateField("listposition",channelId,"",1);//不允许为空
updateField("dropchannel_id",channelId,"",1);//不允许为空

//4、功能说明：组件维护创建数据来源频道名字段
//老版本影响说明：不影响
createField("sourcechannel_name","数据来源频道名","text", "", channelId, "", 0, 0,"",0,0);

//5、功能说明:组件维护频道增加内容页地址字段
//老版本影响说明：不影响
tu.executeUpdate("update channel set DocumentProgram='../jushi/documentModule.jsp' where parent="+channelId);
ChannelUtil.updateSubChannelsAttribute(channelId,8,"../jushi/documentModule.jsp");//内容页应用到子频道
ChannelUtil.updateSubChannelsAttribute(channelId,7,"../jushi/content_advert.jsp");//列表页应用到子频道

//7、功能说明：媒体号管理添加人气字段
//老版本影响说明：不影响
channelId = getChannelId("company_s53_manager");
createField("popularity","人气","switch","",channelId,"",0,0,"",0,0);

//8、功能说明：验证码增加次数限制
//老版本影响说明：不影响
channelId = getChannelId("code");
createField("num","验证次数","number", "", channelId, "", 0, 0,"",0,0);

//9、功能说明：创建敏感词库
//老版本影响说明：不影响
channelId = 2;
createChannel("敏感词库",channelId,0,"sensitive_word","");	
channelId = getChannelId("s53_config");
createField("sensitive_word","敏感词","switch", "0", channelId, "", 1, 0,"",0,0);

//10、功能说明：底栏管理增加字段
//老版本影响说明：不影响
channelId = getChannelId("s53_appbot");
createField("type","底栏类型","radio", "0", channelId, "听书屋(1)", 1, 0,"",0,0);



//模板修改========================================================================================

//1,功能说明:聚视启动图模板接口增加字段
//老版本影响说明：不影响
//频道：APP配置-启动页面 app/start_pic.json
channelId = getChannelId("s53_b");
templateId = getTemplateID(channelId,"start_pic.json",3);
file = new File(filePath+"/template/app/start_pic.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//2:功能说明:新增广告投放模板
//老版本影响说明：无
//频道：APP管理-组件维护 app/advert.json
channelId = getChannelId("s53_module");
templateId = createTemplate(filePath+"/template/app/advert.json","advert.json","广告投放",203);
useTemplate(channelId , templateId, "","advert.json",3,0,"");
templateId = createTemplate(filePath+"/template/app/advert.shtml","advert.shtml","广告投放",203);
useTemplate(channelId , templateId, "","advert.shtml",3,0,"");

//3:功能说明:列表页模板取特殊字符，按钮组取外链条件更改
//老版本影响说明：需测试确认
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

//4:功能说明:app配置模板，新增客户端背景、问政控制
//老版本影响说明：无
//频道：APP配置-基础配置 app/appconfig.json
channelId = getChannelId("s53_config");
templateId = getTemplateID(channelId,"appconfig.json",3);
file = new File(filePath+"/template/app/appconfig.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//5:功能说明:聚视二次分享
//老版本影响说明：需测试确认
//频道：APP管理-栏目管理 app/content_wap.shtml
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"content_wap.shtml",2);
file = new File(filePath+"/template/app/content_wap.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
templateId = getTemplateID(channelId,"pic_wap_content.shtml",2);
file = new File(filePath+"/template/app/pic_wap_content.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
templateId = getTemplateID(channelId,"video_wap.html",2);
file = new File(filePath+"/template/wap/video_wap.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
templateId = getTemplateID(channelId,"live_wap.html",1);
file = new File(filePath+"/template/wap/live_wap.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//6:功能说明:内容页广告
//老版本影响说明：需测试确认
//频道：APP管理-栏目管理 app/content.shtml
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"content.shtml",2);
file = new File(filePath+"/template/app/content.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//7:功能说明:新增tv字段
//老版本影响说明：不影响
//频道：APP管理-栏目管理 app/channel_list_1_0.json
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"channel_list_1_0.json",1);
file = new File(filePath+"/template/app/channel_list_1_0.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//8:功能说明:媒体号相关
//老版本影响说明：不影响
//频道：APP管理-媒体号-媒体号推荐（标识company_s53_recommend） company/company_recommend.json
channelId = getChannelId("company_s53_recommend");
templateId = createTemplate(filePath+"/template/company/company_recommend.json","company_recommend.json","媒体号推荐",206);
useTemplate(channelId , templateId, "","company_recommend.json",3,0,"");

//9:功能说明:主播秀相关
//老版本影响说明：不影响
//频道：APP管理-媒体号-主播秀
channelId = getChannelId("s53_anchor_a");
templateId = createTemplate(filePath+"/template/company/anchor_lunbo.json","anchor_lunbo.json","主播秀首页轮播图",206);
useTemplate(channelId , templateId, "","anchor_lunbo.json",3,0,"");
channelId = getChannelId("s53_anchor_b");
templateId = createTemplate(filePath+"/template/company/anchor_recommend.json","anchor_recommend.json","主播秀推荐",206);
useTemplate(channelId , templateId, "","anchor_recommend.json",3,0,"");
channelId = getChannelId("s53_anchor_c");
templateId = createTemplate(filePath+"/template/company/anchor_intro.shtml","anchor_intro.shtml","主播秀首页轮播图",206);
useTemplate(channelId , templateId, "","anchor_intro.shtml",2,0,"");
*/
//10:功能说明:底栏维护
//老版本影响说明：不影响
//频道：APP管理-底栏维护 app/appbot.json
channelId = getChannelId("s53_appbot");
templateId = getTemplateID(channelId,"appbot.json",3);
file = new File(filePath+"/template/app/appbot.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());


//3.5.1===================================================================

//1:功能说明:app配置模板，新增百度统计字段
//老版本影响说明：无
//频道：APP配置-基础配置 app/appconfig.json
channelId = getChannelId("s53_config");
templateId = getTemplateID(channelId,"appconfig.json",3);
file = new File(filePath+"/template/app/appconfig.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//2:功能说明:栏目管理增加模板
//老版本影响说明：不影响
//频道：APP管理-栏目管理 app/good_recommen.shtml
channelId = getChannelId("s53_a_a");
templateId = createTemplate(filePath+"/template/app/good_recommen.shtml","good_recommen.shtml","精品推荐",203);
useTemplate(channelId , templateId, "","good_recommen.shtml",1,0,"");

//3:功能说明:新增爆料列表页模板，爆料轮播图模板,爆料内容页模板
//老版本影响说明：不影响
//频道：app管理--首页--爆料
channelId = getChannelId("s53_nav_baoliao_a_a_a_h");
templateId = createTemplate(filePath+"/template/app/content_baoliao.shtml","content_baoliao.shtml","爆料详情页",203);
useTemplate(channelId , templateId, "baoliao","content_baoliao.shtml",1,0,"");
templateId = createTemplate(filePath+"/template/app/baoliao_list_1_0.shtml","baoliao_list_1_0.shtml","爆料列表页",203);
useTemplate(channelId , templateId, "","list_1_0.shtml",1,0,"");
templateId = createTemplate(filePath+"/template/app/baoliao_list_slide_1_0.json","baoliao_list_slide_1_0.json","爆料轮播图",203);
useTemplate(channelId , templateId, "","list_slide_1_0.json",1,0,"");

//4:功能说明:爆料有单独的模板，其他列表页和轮播图模板的爆料条件去掉
//老版本影响说明：无
//频道：APP管理-栏目管理 
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"list_slide_1_0.json",1);
file = new File(filePath+"/template/app/list_slide_1_0.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
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

//5:功能说明:等级页面
//老版本影响说明：不影响
//频道：互动信息管理--社区积分规则
channelId = getChannelId("community_s53_levelrule");
templateId = getTemplateID(channelId,"grade_rules.html",3);
file = new File(filePath+"/template/app/grade_rules.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//6:功能说明:直播分享页
//老版本影响说明：不影响
//频道：APP管理-栏目管理
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"live_wap.html",2);
file = new File(filePath+"/template/wap/live_wap.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
ChannelTemplate ct = new ChannelTemplate(templateId);
ct.setWhereSql("and doc_type=8");
ct.Update();


//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();

%>
<br>Over!
