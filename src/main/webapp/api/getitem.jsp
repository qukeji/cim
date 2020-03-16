 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
int itemid = getIntParameter(request,"itemid");
int channelid = getIntParameter(request,"channelid");
String Token = getParameter(request,"Token");

//获取当前时间戳
long time = System.currentTimeMillis();
String date = Util.FormatDate("yyyy-MM-dd HH:mm:ss",time);

Channel channel = CmsCache.getChannel(channelid);

int user_id = UserInfoUtil.AuthUserByToken(Token);
UserInfo userinfo = new UserInfo(user_id);

int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);
if(login!=1)
{
	JSONObject o = new JSONObject();
	o.put("status",0);
	o.put("message","登录失败");
	
	Log.SystemLog("接口调用", "用户："+userinfo.getName()+";接口地址：api/getitem.jsp;参数：itemid:"+itemid+",Token:"+Token+",channelid:"+channelid+";频道名："+channel.getName()+";请求时间："+date+";请求结果：登录失败");

	out.println(o.toString());
	return;
}
//验证用户权限
Boolean isShow = userinfo.hasChannelShowRight(channelid);
if(!isShow){
	JSONObject o = new JSONObject();
	o.put("status",0);
	o.put("message","用户无权限访问此频道");

	Log.SystemLog("接口调用", "用户："+userinfo.getName()+";接口地址：api/getitem.jsp;参数：itemid:"+itemid+",Token:"+Token+",channelid:"+channelid+";频道名："+channel.getName()+";请求时间："+date+";请求结果：用户无权限访问此频道");

	out.println(o.toString());
	return;
}


String SiteAddress = channel.getSite().getUrl();//站点地址
TideJson photo_config = CmsCache.getParameter("sys_config_photo").getJson();//图片及图片库配置
String inner_url = "",outer_url="";
if(photo_config != null)
{
	int sys_channelid_image = photo_config.getInt("channelid");
	Site img_site = CmsCache.getChannel(sys_channelid_image).getSite();
	inner_url = img_site.getUrl();
	outer_url = img_site.getExternalUrl();
}

Document item = new Document(itemid,channelid);

JSONObject o = new JSONObject();
o.put("id",item.getId());
o.put("Title",item.getTitle());


JSONArray o2 = new JSONArray();  
for(int i = 1;i<=item.getTotalPage();i++)
{
	item.setCurrentPage(i);
	JSONObject o3 = new JSONObject();
	
	String content = item.getContent().replaceAll(outer_url,inner_url);
	content = content.replaceAll("src=\"\\/", "src=\""+SiteAddress+"\\/") ;
	content = content.replaceAll("video:\"\\/", "video:\""+SiteAddress+"\\/") ;

	o3.put("Content",content);
	o2.put(o3);
}

String Photo = item.getValue("Photo");
if(!Photo.startsWith("http")){
	Photo = SiteAddress + Photo;
}
o.put("Photo",Photo);
o.put("Summary",item.getSummary());
o.put("PublishDate",item.getPublishDate());
o.put("IsPhotoNews",item.getIsPhotoNews());
o.put("DocFrom",item.getDocFrom());
o.put("Contents",o2);

Log.SystemLog("接口调用", "用户："+userinfo.getName()+";接口地址：api/getitem.jsp;参数：itemid:"+itemid+",Token:"+Token+",channelid:"+channelid+";频道名："+channel.getName()+";请求时间："+date+";请求结果：成功");

out.println(o.toString());
%>