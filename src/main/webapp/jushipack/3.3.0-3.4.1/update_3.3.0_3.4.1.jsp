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
//include\pc
FileUtil.copyFile(filePath+"/include/pc/header.zip",dirPath+"/include/pc/header.zip");
unZipFiles(new File(dirPath+"/include/pc/header.zip"),dirPath+"/include/pc");
*/
%>

<%
/*
//升级3.4.1
//1.功能说明：修改后台内容类型显示
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
tu.executeUpdate("update channel set ListProgram='../content/content_ziyuan.jsp' where id="+channelId);
ChannelUtil.updateSubChannelsAttribute(channelId,7,"../content/content_ziyuan.jsp");

//2.功能说明：隐藏h5资源维护频道字段
//老版本影响说明：不影响
channelId = getChannelId("s53_e_a");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);

//3.功能说明：订阅栏目管理频道 -- 栏目类型字段 去掉 '爆料频道' 选项
//老版本影响说明：不影响
channelId = getChannelId("category_s53_manager");
tu.executeUpdate("delete from field_options where ChannelID=" + channelId + " and FieldName='channeltype' and OptionValue='爆料频道(2)'");

//4.功能说明：爆料按钮控制组频道 -- 提交页标题，展示页标题 字段隐藏
//老版本影响说明：不影响
channelId = getChannelId("s53_baoliao_button_control");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='baoliaotitle' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='mybaoliaotitle' and ChannelID="+channelId);

//5.功能说明：注册用户信息频道 -- 序列号 字段隐藏
//老版本影响说明：不影响
channelId = getChannelId("register");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='serial' and ChannelID="+channelId);

//6.功能说明：收藏记录频道 -- 用户名，收藏类型 字段隐藏
//老版本影响说明：不影响
channelId = getChannelId("collect");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='author' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='filed_type' and ChannelID="+channelId);

//7.功能说明：帖子管理频道 -- 视频地址 字段隐藏
//老版本影响说明：不影响
channelId = getChannelId("community_topic");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='videourl' and ChannelID="+channelId);

//8.功能说明：第三方平台密钥设置频道 -- android密钥，ios密钥 字段修改描述
//老版本影响说明：不影响
channelId = getChannelId("threadmanager");
tu.executeUpdate("update field_desc set Description='安卓-AppSecret' where FieldName='android_secrect_key' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='苹果-AppSecret' where FieldName='ios_secrect_key' and ChannelID="+channelId);

//9.功能说明：新建频道：APP管理-底栏维护
//老版本影响说明：不影响
//parent = getChannelId("s53_a");
channelId = getChannelId("s53_appbot");//createChannel("底栏维护",parent,0,"s53_appbot","");
tu.executeUpdate("update field_desc set Description='底栏标题' where FieldName='Title' and ChannelID="+channelId);
createField("column_href","链接地址","text", "", channelId, "", 0, 0,"如果跳转外链，请填写包含http或https的完整url地址。");
createField("column_id","栏目编号","number", "", channelId, "", 0, 0,"");
createField("company","发现栏目","switch", "", channelId, "", 0, 0,"");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Photo' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);


//10.功能说明：新建频道：互动管理-广告投放
//老版本影响说明：不影响
parent = getChannelId("s53_h");
channelId = createChannel("广告投放",parent,0,"","");
tu.executeUpdate("update field_desc set Description='广告标题' where FieldName='Title' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='图一' where FieldName='Photo' and ChannelID="+channelId);
createField("onlinetime","上线时间","datetime", "", channelId, "", 0, 0,"");
createField("Revoketime","下线时间","datetime", "", channelId, "", 0, 0,"");
createField("position","显示位置","radio", "0", channelId, "列表页广告(0)\n内容页广告(1)", 1, 0,"列表页广告显示在列表页上某一特定位置，内容页广告显示在文章内容页中关键词与相关新闻之间");
createField("listposition","列表页广告显示位置","number", "", channelId, "", 0, 0,"输入数字，控制广告显示在频道列表页具体位置");
createField("dropchannel_id","投放频道","text", "", channelId, "", 0, 0,"");
createField("dropchannel_name","投放频道名","text", "", channelId, "", 0, 0,"");
createField("item_type","展现形式","radio", "0", channelId, "单图(0)\n三图(1)\n大图(2)", 1, 0,"单图尺寸（220*164）、三图中的单张图片尺寸（220*164）、大图（690*390）");
createField("Photo1","图二","image", "", channelId, "", 0, 0,"");
createField("Photo2","图三","image", "", channelId, "", 0, 0,"");
createField("href","链接","text", "", channelId, "", 0, 0,"");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);


//11.功能说明：新建频道：App管理-我的界面
//老版本影响说明：不影响
parent = getChannelId("s53_a");
channelId = createChannel("我的界面",parent,0,"s53_menumanagement","myinterface");
tu.executeUpdate("update field_desc set Description='名称' where FieldName='Title' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set Description='图标(40)',Caption='尺寸为：40*40px，格式为：png' where FieldName='Photo' and ChannelID="+channelId);
createField("Photo1","图标 (60)","image", "", channelId, "", 0, 0,"尺寸为：60*60px，格式为：png");
createField("href","外链","text", "", channelId, "", 0, 0,"");
createField("code","菜单标识","text", "", channelId, "", 0, 0,"");
createField("device_type","设备类型","checkbox", "", channelId, "安卓(1)\nIOS(2)", 1, 0,"");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
map_doc.put("Title","系统设置");
map_doc.put("code","setup");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548314460991_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548314468943_60.png");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","邀请分享");
map_doc.put("code","share");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548314434301_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548314442235_60.png");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","意见反馈");
map_doc.put("code","feedback");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548314407926_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548314417047_60.png");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","日常任务");
map_doc.put("code","");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548314328816_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548314341090_60.png");
map_doc.put("href","http://39.107.232.220:3680/html/dailytask.html");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","金币明细");
map_doc.put("code","");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548314298322_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548314308700_60.png");
map_doc.put("href","http://39.107.232.220:3680/html/mygold.html");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","金币商城");
map_doc.put("code","");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548314241621_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548314249278_60.png");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","分割线");
map_doc.put("code","cutoffrule");
map_doc.put("device_type","1,2");
map_doc.put("Photo","");
map_doc.put("Photo1","");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","我的粉丝");
map_doc.put("code","myfans");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548314214767_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548314223415_60.png");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","我的关注");
map_doc.put("code","myconcern");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548313646693_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548313654694_60.png");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","个人主页");
map_doc.put("code","homepage");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548313618625_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548313625449_60.png");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","我的听书");
map_doc.put("code","book");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548313540282_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548313548563_60.png");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","发起直播");
map_doc.put("code","live");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548313486597_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548313493952_60.png");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","分割线");
map_doc.put("code","cutoffrule");
map_doc.put("device_type","1,2");
map_doc.put("Photo","");
map_doc.put("Photo1","");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","我的爆料");
map_doc.put("code","baoliao");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548313436256_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548313451567_60.png");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","会员等级");
map_doc.put("code","");
map_doc.put("device_type","1,2");
map_doc.put("Photo","");
map_doc.put("Photo1","/images/2019/1/24/20191241548313411187_60.png");
map_doc.put("href","http://39.107.232.220:3680/d/grade.html");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","帐号管理");
map_doc.put("code","account");
map_doc.put("device_type","1,2");
map_doc.put("Photo","/images/2019/1/24/20191241548313362011_60.png");
map_doc.put("Photo1","/images/2019/1/24/20191241548313380011_60.png");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","分割线");
map_doc.put("code","cutoffrule");
map_doc.put("device_type","1,2");
map_doc.put("Photo","");
map_doc.put("Photo1","");
map_doc.put("href","");
ItemUtil.addItemGetGlobalID(channelId, map_doc);


//12.功能说明：新建频道：互动管理-金币加成
//老版本影响说明：不影响
parent = getChannelId("s53_h");
channelId = createChannel("金币加成",parent,0,"s53_goldaddition","goldaddition");
tu.executeUpdate("update field_desc set Description='动作名称' where FieldName='Title' and ChannelID="+channelId);
createField("description","规则描述","text", "", channelId, "", 0, 0,"");
createField("goldaddition","金币加成","number", "", channelId, "", 0, 0,"");
createField("frequency","限制次数","number", "", channelId, "", 0, 0,"");
createField("period","限制周期","radio", "0", channelId, "时(0)\n天(1)\n周(2)\n月(3)\n无限(4)", 1, 0,"");
createField("code","菜单标识","text", "", channelId, "", 0, 0,"");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Photo' and ChannelID="+channelId);
templateId = createTemplate(filePath+"/template/app/goldaddition.json","goldaddition.json","金币加成",203);
useTemplate(channelId , templateId, "","goldaddition.json",3,0,"");
map_doc.put("Title","签到");
map_doc.put("code","qiandao");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","发布帖子");
map_doc.put("code","invitation");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","发布评论");
map_doc.put("code","comment");
ItemUtil.addItemGetGlobalID(channelId, map_doc);
map_doc.put("Title","绑定手机号");
map_doc.put("code","binding");
ItemUtil.addItemGetGlobalID(channelId, map_doc);


//13.功能说明：APP管理-启动页面
//老版本影响说明：对老版本可能有影响
//channelId= getChannelId("s53_b");
//tu.executeUpdate("update field_desc set Caption='尺寸：1242*2208px；格式：png；建议大小：3M以内' where FieldName='Photo' and ChannelID="+channelId);
//createField("href","链接地址","text", "", channelId, "", 0, 0,"");
//createField("countdown","启动倒计时","checkbox", "0", channelId, "倒计时显示(0)\n跳过按钮显示(1)", 1, 0,"");
//createField("residencetime","停留时长","number", "5", channelId, "", 0, 0,"启动时长，建议范围：5~20秒，如不填写使用默认时长：5秒");
//tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
//tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
//tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
//tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);

//14:功能描述：栏目管理频道添加字段
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
createField("interior_type","应用类型","radio", "0", channelId, "听书屋(1)", 1, 0,"");
createField("interior_id","内部跳转标识","text", "", channelId, "", 0, 0,"打开第三方应用时传递的内容编号");
createField("allowcomment","评论开关","switch", "1", channelId, "", 0, 0,"");
createField("showread","阅读量开关","switch", "1", channelId, "", 0, 0,"");
createField("phone","手机号","text", "", channelId, "", 0, 0,"");
createField("zan_virtual_num","虚拟点赞量","number", "", channelId, "", 0, 0,"");

//15:功能描述：app配置频道添加字段
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("function_switch","功能开关","checkbox", "", channelId, "是否开启爆料中视频提交按钮(1)\n是否开启语音播放功能(2)", 1, 0,"");

//16.功能说明：新建频道：用户行为记录-金币明细
//老版本影响说明：不影响
parent = getChannelId("s53_g_a");
channelId = createChannel("金币明细",parent,0,"s53_golddetail","golddetail");
tu.executeUpdate("update field_desc set Description='动作名称' where FieldName='Title' and ChannelID="+channelId);
createField("userid","操作人用户编号","number", "", channelId, "", 0, 0,"");
createField("code","操作类型","text", "", channelId, "", 0, 0,"");
createField("coins","金币","number", "", channelId, "", 0, 0,"");
createField("itemid","父编号","number", "", channelId, "", 0, 0,"评论操作时是评论编号,发帖操作时是帖子编号");
createField("ip","访问ip","text", "", channelId, "", 0, 0,"");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Photo' and ChannelID="+channelId);


//17.功能说明：栏目管理 爆料字段优化及老数据处理
//老版本影响说明：影响（模板需同时升级）
channelId = getChannelId("s53_a_a");
tu.executeUpdate("update field_desc set FieldType='radio',DefaultValue='1',DataType=1 where FieldName='baoliao_ispublic' and ChannelID="+channelId);
tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','baoliao_ispublic','不公开(0)')");
tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','baoliao_ispublic','公开(1)')");
tu.executeUpdate("update channel_s53_a_a set baoliao_ispublic=2 where baoliao_ispublic=1");
tu.executeUpdate("update channel_s53_a_a set baoliao_ispublic=1 where baoliao_ispublic!=2");
tu.executeUpdate("update channel_s53_a_a set baoliao_ispublic=0 where baoliao_ispublic=2");


//18.功能说明：新建频道：APP管理-新增404页面管理栏目
//老版本影响说明：不影响
parent = getChannelId("s53_a");
channelId = createChannel("404页面管理",parent,0,"","");
createField("filename","文件名","text", "", channelId, "", 0, 0,"");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
templateId = createTemplate(filePath+"/template/app/notfound.html","notfound.html","404页面管理",203);
useTemplate(channelId , templateId, "","notfound.html",2,0,"");


//19.功能说明：新建频道：网站管理-一键换肤
//老版本影响说明：不影响
parent = getChannelId("s53_d");
channelId = createChannel("一键换肤",parent,0,"","");
createField("style","网站风格","radio", "0", channelId, "默认(0)\n网站变灰(1)", 1, 0,"");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='DocFrom' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='IsPhotoNews' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Summary' and ChannelID="+channelId);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='Content' and ChannelID="+channelId);
templateId = createTemplate(filePath+"/template/pc/skin.css","skin.css","一键换肤",204);
useTemplate(channelId , templateId, "","skin.css",3,0,"");

//20.功能说明：新建频道：媒体号-媒体号推荐
//老版本影响说明：不影响
parent = getChannelId("s53_a_d");
channelId = createChannel("媒体号推荐",parent,0,"","");

*/
/*
//模板修改
//1,功能说明:处理双引号和换行所导致的在客户端内提示数据解析异常的问题
//老版本影响说明：不影响
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

//2:功能说明:内容页默认字体设置
//老版本影响说明：做过字体调整的版本都没有影响，3.2.4以前的app，可能字体大小会有问题
//频道：APP管理-栏目管理 app/content.shtml
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"content.shtml",2);
file = new File(filePath+"/template/app/content.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//3:功能说明:提供wap站列表页数据
//老版本影响说明：无
//频道：APP管理-栏目管理 wap站/list_wap.json
channelId = getChannelId("s53_a_a");
templateId = createTemplate(filePath+"/template/wap/list_wap.json","list_wap.json","wap列表页数据",205);
useTemplate(channelId , templateId, "","list_wap.json",1,0,"");

//4:功能说明:启动图增加字段
//老版本影响说明：无
//频道：APP管理-栏目管理 app/start_pic.json
channelId = getChannelId("s53_b");
templateId = createTemplate(filePath+"/template/app/start_pic.json","start_pic.json","启动图",203);
useTemplate(channelId , templateId, "","start_pic.json",3,0,"");

//5:功能说明:底栏维护、我的界面栏目
//老版本影响说明：无
channelId = getChannelId("s53_appbot");
templateId = createTemplate(filePath+"/template/app/appbot.json","appbot.json","底栏维护",203);
useTemplate(channelId , templateId, "","appbot.json",3,0,"");
channelId = getChannelId("s53_menumanagement");
templateId = createTemplate(filePath+"/template/app/my_menu.json","my_menu.json","我的界面",203);
useTemplate(channelId , templateId, "","my_menu.json",3,0,"");

*/

//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();

%>
<br>Over!
