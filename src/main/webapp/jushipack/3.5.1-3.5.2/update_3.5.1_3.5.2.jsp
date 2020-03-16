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
//media
FileUtil.copyFile(filePath+"/media/media.zip",dirPath+"/media/media.zip");
unZipFiles(new File(dirPath+"/media/media.zip"),dirPath+"/media");
*/
%>
<%

//1.功能说明：聚视演示版 ==>互动管理==>社区管理==>帖子管理 频道标识community_topic改为s53_community_topic(手动修改)
//老版本影响说明：不影响

//2.功能说明：用户隐私协议修改
//老版本影响说明：不影响
//频道标识修改：app管理 ==>协议与须知==>隐私协议 s53_a_e_b_a改为privacy(手动修改)
//栏目名修改： APP管理/协议与须知/用户隐私协议  ----->  APP管理/协议与须知/隐私协议
channelId = getChannelId("privacy");
tu.executeUpdate("update channel set Name='隐私协议' where id = "+channelId);
//APP管理-协议与须知下 新增用户协议栏目，栏目目录为user 
channelId = getChannelId("s53_a_e_e");
int userAgreement = createChannel("用户协议",channelId,1,"","user");
//添加模板app/policy.html  
//模板生成文件命名规则：系统默认0 以标题做文件名1 时间戳加随机数2 按文档指定文件名3 定制规则4 条件：filename
templateId = createTemplate(filePath+"/template/app/policy.html","policy.html","用户隐私协议",203);
useTemplate(userAgreement, templateId, "", "policy.html", 2, 3, "","filename");//TemplateType: 索引页模板1 内容页模板2  附加页面模板3

//3.功能说明：栏目管理频道模板（包含子频道）  增加video拓展属性 模板：app/channel_list_1_0.json
//老版本影响说明：不影响
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"channel_list_1_0.json",1);
file = new File(filePath+"/template/app/channel_list_1_0.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//4.功能说明：组件管理栏目，修改频道属性--列表设置--勾选包含子频道(手动操作)
//老版本影响说明：不影响
channelId = getChannelId("s53_module");
tu.executeUpdate("update channel set IsListAll=1 where id = "+channelId);

//5.功能说明：组件管理下新增公告维护栏目    频道标识s53_module_notice  更新模板app/advert.shtml
//老版本影响说明：不影响
channelId = getChannelId("s53_module");
createChannel("公告维护",channelId,1,"s53_module_notice","");
//模板更新：app/advert.shtml
templateId = getTemplateID(channelId,"advert.shtml",3);
file = new File(filePath+"/template/app/advert.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//6.功能说明：更改取标题，摘要，来源的模板方法
//老版本影响说明：不影响
//频道：APP管理-栏目管理（含所有子频道） 
//模板更新：app/list_slide_1_0.json
channelId = getChannelId("s53_a_a");
templateId = getTemplateID(channelId,"list_slide_1_0.json",1);
file = new File(filePath+"/template/app/list_slide_1_0.json");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
//模板更新： app/list_1_0.shtml
templateId = getTemplateID(channelId,"list_1_0.shtml",1);
file = new File(filePath+"/template/app/list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
///频道：媒体号内容管理及其子频道
//模板更新：company/live_list_1_0.shtml
channelId = getChannelId("company_s53_source");
templateId = getTemplateID(channelId,"live_list_1_0.shtml",1);
file = new File(filePath+"/template/company/live_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
//模板更新：company/textimage_list_1_0.shtml
templateId = getTemplateID(channelId,"textimage_list_1_0.shtml",1);
file = new File(filePath+"/template/company/textimage_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());
//模板更新：company/video_list_1_0.shtml
templateId = getTemplateID(channelId,"video_list_1_0.shtml",1);
file = new File(filePath+"/template/company/video_list_1_0.shtml");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

//7.功能说明：媒体号注册流程
channelId = getChannelId("company_s53_info");
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='phone' and ChannelID="+channelId);//隐藏字段
createField("Site","客户端归属","number", "0", channelId, "", 1, 0,"",0,0);

//8.功能说明：头像审核、昵称审核频道修改标识（手动处理）
	
//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();


%>
<br>Over!
