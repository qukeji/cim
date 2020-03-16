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
@tu.executeUpdate("update field_desc set Description='标题' where FieldName='Title' and ChannelID="+channelId);
@tu.executeUpdate("update field_desc set Description='列表页显示位置' where FieldName='listposition' and ChannelID="+channelId);
@tu.executeUpdate("update field_desc set Description='数据来源' where FieldName='href' and ChannelID="+channelId);
@tu.executeUpdate("update field_desc set Caption='封面图的尺寸：69:11' where FieldName='Photo' and ChannelID="+channelId);
@tu.executeUpdate("update field_desc set Caption='填写页面地址' where FieldName='href' and ChannelID="+channelId);
@tu.executeUpdate("update field_desc set Caption='输入数字，固定显示在列表页第几行' where FieldName='listposition' and ChannelID="+channelId);

@updateField("listposition",channelId,"",1);//不允许为空
@updateField("dropchannel_id",channelId,"",1);//不允许为空

//4、功能说明：组件维护创建数据来源频道名字段
//老版本影响说明：不影响
@createField("sourcechannel_name","数据来源频道名","text", "", channelId, "", 0, 0,"",0,0);

//5、功能说明:组件维护频道增加内容页地址字段
//老版本影响说明：不影响
tu.executeUpdate("update channel set DocumentProgram='../jushi/documentModule.jsp' where parent="+channelId);
ChannelUtil.updateSubChannelsAttribute(channelId,8,"../jushi/documentModule.jsp");//内容页应用到子频道
ChannelUtil.updateSubChannelsAttribute(channelId,7,"../jushi/content_advert.jsp");//列表页应用到子频道

//6、功能说明，一键封号后台功能
//老版本影响说明：不影响
channelId = getChannelId("s53_config");
createField("globalBanned","全局禁言","switch", "0", channelId, "", 1, 0,"",0,0);
createField("BanInteract","禁止交互","switch", "0", channelId, "", 1, 0,"",0,0);
channelId = getChannelId("register");
createField("Status2","当前状态","radio", "0", channelId, "未封号(0)\n已封号(1)", 1, 0,"",0,0);
createField("Banned","禁言","radio", "0", channelId, "否(0)\n是(1)", 1, 0,"",0,0);
createField("sealDate","封号时间","datetime", "", channelId, "", 0, 0,"",0,0);
tu.executeUpdate("update field_desc set IsHide=1 where FieldName='password' and ChannelID="+channelId);//隐藏字段

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



//初始化缓存
ConcurrentHashMap channels = CmsCache.getChannels();
channels.clear();

%>
<br>Over!
