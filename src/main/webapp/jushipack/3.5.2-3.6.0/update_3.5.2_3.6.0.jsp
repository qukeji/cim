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
//1、功能说明：主播互动模块增加短视频选项
//老版本影响说明：不影响
channelId = getChannelId("company_s53_manager");
//tu.executeUpdate("insert into field_options (ChannelID,FieldName,OptionValue) values('"+channelId+"','model_control','短视频(8)')");

//2.功能说明：修改微信sdk js为相对协议引入 
//频道：APP管理-栏目管理（含所有子频道）
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

templateId = getTemplateID(channelId,"video_wap.html",2);
file = new File(filePath+"/template/wap/video_wap.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());

templateId = getTemplateID(channelId,"live_wap.html",2);
file = new File(filePath+"/template/wap/live_wap.html");
filecontent = org.apache.commons.io.FileUtils.readFileToString(file);
UpdateContent(templateId,filecontent,userinfo_session.getId());


//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();


%>
<br>Over!
