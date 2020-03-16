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

//静态文件功能：所有分享页的阅读数，发布时间改为由appConfig.json读取配置
%>

<%
/*
//升级3.5.0
//1.功能说明：启动图增加字段，视频，动图
//老版本影响说明：不影响
channelId = getChannelId("s53_b");
createField("gif","动图","file", "", channelId, "", 0, 0,"格式gif;建议大小：3M以内;建议时长：2-3秒g",0,0);
createField("video","视频","file", "", channelId, "", 0, 0,"格式mp4;建议大小：3M以内;建议时长：2-3秒",0,0);
createField("type","启动页面样式","radio", "", channelId, "图片(1)\n动画(2)\n视频(3)", 1, 0,"",0,0);
createField("countdown","倒计时","switch", "", channelId, "", 0, 0,"",0,0);
createField("skip","跳过","switch", "", channelId, "", 0, 0,"",0,0);

//2.功能说明：app配置可视化
//channelId = getChannelId("s53");//获取站点频道id
//channelId = createChannel("APP配置",channelId,0,"s53_app_config","");//创建频道
channelId = getChannelId("s53_app_config");
tu.executeUpdate("update channel set application='app_config' where id="+channelId);

//3.功能说明：问政功能完善
//老版本影响说明：不影响
channelId = getChannelId("s66_a");
createField("wz_id","问政原id","number", "", channelId, "", 0, 1,"",0,0);
createField("probstatus","问题状态","radio", "", channelId, "未审核(1)\n审核未通过(2)\n未受理(3)\n已受理(4)\n平台回复(5)\n已回复(6)\n已完结(7)", 1, 0,"",0,0);
tu.executeUpdate("update field_desc set Description='处理状态' where FieldName='Status2' and ChannelID="+channelId);

//4.功能说明：APP打包可视化
//老版本影响说明：不影响
parent = getChannelId("s53");
parent = createChannel("APP打包",parent,0,"","");
tu.executeUpdate("update channel set application=\"app_package\" where id="+parent);//设置application
channelId = createChannel("Android自动打包",parent,0,"","");//创建频道
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);//隐藏字段
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Photo' and ChannelID="+channelId);
createField("version","打包版本","radio", "0", channelId, "3.2(5)\n3.2.1(6)\n3.2.2(7)\n3.2.3(8)\n3.2.4(9)\n3.3(10)\n3.4.0(11)\n3.4.1(12)", 1, 0,"",0,0);//创建字段
createField("package","包名","text", "tidemedia.app.xxx", channelId, "", 0, 0,"必填，包名请自行修改",1,0);
createField("HOME_URL","标准版站点地址","text", "http://123.56.71.230:32776/", channelId, "", 0, 0,"必填，静态接口地址(结尾带/)",1,0);
createField("PHP_URL","互动信息管理站点","text", "http://123.56.71.230:32772/", channelId, "", 0, 0,"动态接口地址(结尾带/)",1,0);
createField("SITE","标准版站点编号","text", "53", channelId, "", 0, 0,"必填，标准版站点编号",1,0);
createField("home_style","首页头部样式","radio", "0", channelId, "左图标右搜索(0)\nlogo+搜索+个人中心(1)\n个人中心+logo+搜索(2)", 1, 0,"",0,0);
createField("main_bottom","一级栏目名称","textarea", "", channelId, "", 0, 0,"至少填写1个，最多填写4个",0,0);
createField("THEME_COLOR","主题色","text", "#0066cc", channelId, "", 0, 0,"首页顶部栏，一级导航栏等颜色",0,0);
createField("THEME_TOP_COLOR","顶部主题色","text", "#0066cc", channelId, "", 0, 0,"手机状态栏颜色",0,0);
createField("UMENG_APP","友盟APP","text", "", channelId, "", 0, 0,"不填写则无法正常使用分享功能",0,0);
createField("WECHAT_APP","微信APP","text", "", channelId, "", 0, 0,"不填写则无法正常使用分享功能",0,0);
createField("QQ_APP","腾讯开放平台App","text", "", channelId, "", 0, 0,"不填写则无法正常使用分享功能、第三方登录功能",0,0);
createField("SINA_APP","新浪APP","textarea", "", channelId, "", 0, 0,"不填写则无法正常使用分享功能",0,0);
createField("MIPUSH_APP","小米推送App","text", "", channelId, "", 0, 0,"不填写无法使用后台推送功能",0,0);
createField("BUGLY","Bugly","text", "", channelId, "", 0, 0,"",0,0);
createField("baidu","百度统计","text", "", channelId, "", 0, 0,"",0,0);
createField("baidu_map","百度地图App","text", "", channelId, "", 0, 0,"",0,0);
createField("JUXIAN","聚现","textarea", "", channelId, "", 0, 0,"",0,0);
createField("packagestatus","打包状态","radio", "0", channelId, "未打包(0)\n打包中(1)\n打包完成(2)\n打包失败(3)", 1, 0,"",0,0);
createField("download","客户端下载地址","text", "", channelId, "", 0, 0,"",0,0);
createField("pgydownload","蒲公英二维码分享","text", "", channelId, "", 0, 0,"",0,0);

int groupid = createGroup(channelId,"分辨率480*800的图片",0);
createField("hdpi_logo","logo图标","image", "", channelId, "", 0, 0,"必填，手机桌面logo，建议尺寸：1024*1024，格式png，大小不超过500k",1,groupid);
createField("hdpi_launcher_pic","启动图","image", "", channelId, "", 0, 0,"必填，App启动时展示的图片，建议尺寸：1242*2208，格式png，大小不超过50k",1,groupid);
createField("hdpi_logo_home","首页logo","image", "", channelId, "", 0, 0,"必填，首页头部logo,建议尺寸：98*45，格式png",1,groupid);
createField("hdpi_column","栏目状态图标","textarea", "", channelId, "", 0, 0,"",0,groupid);
createField("hdpi_default_pic","列表页文章默认加载图","image", "", channelId, "", 0, 0,"",0,groupid);
createField("hdpi_ic_mine_home_black","顶部左上角图标","image", "", channelId, "", 0, 0,"",0,groupid);
createField("hdpi_ic_search_home_black","顶部右上角图标","image", "", channelId, "", 0, 0,"",0,groupid);
groupid = createGroup(channelId,"分辨率720*1280的图片",0);
createField("xhdpi_logo","logo图标","image", "", channelId, "", 0, 0,"必填，手机桌面logo，建议尺寸：1024*1024，格式png，大小不超过500k",1,groupid);
createField("xhdpi_launcher_pic","启动图","image", "", channelId, "", 0, 0,"必填，App启动时展示的图片，建议尺寸：1242*2208，格式png，大小不超过50k",1,groupid);
createField("xhdpi_logo_home","首页logo","image", "", channelId, "", 0, 0,"必填，首页头部logo,建议尺寸：98*45，格式png",1,groupid);
createField("xhdpi_column","栏目状态图标","textarea", "", channelId, "", 0, 0,"",0,groupid);
createField("xhdpi_default_pic","列表页文章默认加载图","image", "", channelId, "", 0, 0,"",0,groupid);
createField("xhdpi_ic_mine_home_black","顶部左上角图标","image", "", channelId, "", 0, 0,"",0,groupid);
createField("xhdpi_ic_search_home_black","顶部右上角图标","image", "", channelId, "", 0, 0,"",0,groupid);
groupid = createGroup(channelId,"分辨率1080*1920的图片",0);
createField("xxhdpi_logo","logo图标","image", "", channelId, "", 0, 0,"必填，手机桌面logo，建议尺寸：1024*1024，格式png，大小不超过500k",1,groupid);
createField("xxhdpi_launcher_pic","启动图","image", "", channelId, "", 0, 0,"必填，App启动时展示的图片，建议尺寸：1242*2208，格式png，大小不超过50k",1,groupid);
createField("xxhdpi_logo_home","首页logo","image", "", channelId, "", 0, 0,"必填，首页头部logo,建议尺寸：98*45，格式png",1,groupid);
createField("xxhdpi_column","栏目状态图标","textarea", "", channelId, "", 0, 0,"",0,groupid);
createField("xxhdpi_default_pic","列表页文章默认加载图","image", "", channelId, "", 0, 0,"",0,groupid);
createField("xxhdpi_ic_mine_home_black","顶部左上角图标","image", "", channelId, "", 0, 0,"",0,groupid);
createField("xxhdpi_ic_search_home_black","顶部右上角图标","image", "", channelId, "", 0, 0,"",0,groupid);

//createField("main_bottom_bar_str_1","一级栏目名称1","text", "", channelId, "", 0, 0,"至少填写1个，最多填写4个",0,0);
//createField("main_bottom_bar_str_2","一级栏目名称2","text", "", channelId, "", 0, 0,"",0,0);
//createField("main_bottom_bar_str_3","一级栏目名称3","text", "", channelId, "", 0, 0,"",0,0);
//createField("main_bottom_bar_str_4","一级栏目名称4","text", "", channelId, "", 0, 0,"",0,0);
//createField("UMENG_APPID","友盟APPID","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("UMENG_APPKEY","友盟AppKey","text", "", channelId, "", 0, 0,"不填写则无法正常使用分享功能",0,groupid);
//createField("WECHAT_APPID","微信APPid","text", "", channelId, "", 0, 0,"不填写则无法正常使用分享功能",0,groupid);
//createField("WECHAT_APPKEY","微信APPSecrect","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("QQ_APPID","腾讯开放平台AppId","text", "", channelId, "", 0, 0,"不填写则无法正常使用分享功能、第三方登录功能",0,groupid);
//createField("QQ_APPKEY","腾讯开放平台AppKey","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("SINA_APPID","新浪 APPID","text", "", channelId, "", 0, 0,"不填写则无法正常使用分享功能",0,groupid);
//createField("SINA_APPKEY","新浪 Secrect","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("SINA_BACK_URL","新浪回调URL","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("MIPUSH_APP_ID","小米推送AppId","text", "", channelId, "", 0, 0,"不填写无法使用后台推送功能",0,groupid);
//createField("MIPUSH_APP_KEY","小米推送AppKey","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("BUGLY_ID","Bugly ID","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("BuglyKey","Bugly密钥","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("baidu_stat_id","百度统计appid","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("baidu_stat_key","百度统计appSecrect","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("baidu_map_id","百度地图Appid","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("baidu_map_key","百度地图Appkey","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("JUXIAN_ACCESSTOKEN","聚现ACCESSTOKEN","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("JUXIAN_COMPANYKEY","聚现企业码","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("JUXIAN_SERVICEPROTOCAL_URL","聚现服务协议地址","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("juxian_sdk_maincolor","聚现创作端按钮主题色","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("juxian_name","媒体号命名","text", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_default_1","栏目1未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_on_1","栏目1选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_default_2","栏目2未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_on_2","栏目2选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_default_3","栏目3未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_on_3","栏目3选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_default_4","栏目4未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_on_4","栏目4选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_default_5","栏目5未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_on_5","栏目5选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_default_6","栏目6未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("hdpi_column_on_6","栏目6选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_default_1","栏目1未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_on_1","栏目1选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_default_2","栏目2未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_on_2","栏目2选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_default_3","栏目3未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_on_3","栏目3选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_default_4","栏目4未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_on_4","栏目4选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_default_5","栏目5未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_on_5","栏目5选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_default_6","栏目6未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xhdpi_column_on_6","栏目6选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_default_1","栏目1未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_on_1","栏目1选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_default_2","栏目2未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_on_2","栏目2选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_default_3","栏目3未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_on_3","栏目3选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_default_4","栏目4未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_on_4","栏目4选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_default_5","栏目5未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_on_5","栏目5选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_default_6","栏目6未选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
//createField("xxhdpi_column_on_6","栏目6选中状态图标","image", "", channelId, "", 0, 0,"",0,groupid);
channelId = createChannel("Ios自动打包",parent,0,"","");

//5.功能说明：栏目管理增加字段，广告关闭
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
createField("allowadvert","广告开关","switch", "1", channelId, "", 0, 0,"",0,0);

//6.功能说明：网站管理设置application
//老版本影响说明：不影响
channelId = getChannelId("s53_d");
tu.executeUpdate("update channel set application=\"web\" where id="+channelId);

//7.功能说明：启动页面增加预加载图片
//老版本影响说明：不影响
channelId = getChannelId("s53_b");
createField("preloadPhoto","预加载图片","image", "", channelId, "", 0, 0,"",0,0);

//8.功能说明：客户端背景设置后台添加字段
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("background","客户端背景设置","radio", "", channelId, "背景颜色(1)\n背景图片(2)", 1, 0,"",0,0);
createField("background_color","背景颜色","text", "", channelId, "", 0, 0,"",0,0);
createField("background_photo","背景图片","image", "", channelId, "", 0, 0,"",0,0);
createField("mandatoryLogin","仅登录后允许提问","switch", "1", channelId, "", 0, 0,"",0,0);
createField("selectionDepartment","用户提问时允许选择部门","switch", "1", channelId, "", 0, 0,"",0,0);


//9.功能说明：广告投放设置application
//老版本影响说明：不影响
channelId = getChannelId("s53_h_a");
tu.executeUpdate("update channel set application=\"app_advert\" where id="+channelId);
*/
//10.功能说明：增加租户产品权限表
//老版本影响说明：不影响
//tu_user.executeUpdate("CREATE TABLE company_product (id int(10) unsigned NOT NULL auto_increment,companyId int(11) default 0,ModifyDate datetime,productIds varchar(255),PRIMARY KEY  (`id`))");
/*
//11.功能说明:爆料界面改版
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
createField("baoliao_localtion","爆料人位置","text", "", channelId, "", 0, 0,"",0,0);
createField("jd","经度","text", "", channelId, "", 0, 0,"",0,0);
createField("wd","纬度","text", "", channelId, "", 0, 0,"",0,0);
createField("showbaoliaouser","是否匿名","switch", "0", channelId, "", 0, 0,"",0,0);

//12.底栏维护频道增加字段，区分是爆料
//老版本影响说明：不影响
channelId = getChannelId("s53_appbot");
createField("baoliao","是否爆料","switch", "0", channelId, "", 1, 0,"",0,0);

//13.修改栏目管理-看电视频道标识
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a_b_f");
tu.executeUpdate("update channel set SerialNo=\"s53_nav_tv\" where id="+channelId);
channelId = getChannelId("s53_a_a_b_g");
tu.executeUpdate("update channel set SerialNo=\"s53_nav_radio\" where id="+channelId);

//14.APP配置-基础设置 频道增加电视直播/广播背景图上传字段
//老版本影响说明：不影响
//channelId = getChannelId("s53_config");
//createField("tv_background_photo","直播/广播背景","image", "", channelId, "", 0, 0,"",0,0);

//15.功能说明:爆料界面改版增加爆料图片
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


//16.APP配置-基础设置 是否开启APP统计
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("tongji","数据分析","switch", "0", channelId, "", 1, 0,"",0,0);

//17.APP配置-基础设置 是否开启bugly
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("bugly","开启bugly","switch", "1", channelId, "", 1, 0,"",0,0);

//18.互动管理-用户管理 增加字段：金币
//老版本影响说明：不影响
channelId = getChannelId("register");
createField("gold","金币","number", "0", channelId, "", 1, 0,"",0,0);

//19.媒体号审核增加聚现终端用户编号
//老版本影响说明：不影响
channelId = getChannelId("company_s53_info");
createField("juxian_userid","聚现用户id","number", "0", channelId, "", 1, 0,"",0,0);
channelId = getChannelId("company_s53_manager");
createField("juxian_userid","聚现用户id","number", "0", channelId, "", 1, 0,"",0,0);
*/

//20.APP配置-基础设置 是否开启百度统计
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("baidu_tongji","百度统计","switch", "0", channelId, "", 1, 0,"",0,0);


//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();

%>
<br>Over!
