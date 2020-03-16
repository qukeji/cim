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
int id = getIntParameter(request,"id");
int pages = getIntParameter(request,"page");
int pagesize = getIntParameter(request,"pagesize");
String Token = getParameter(request,"Token");

//获取当前时间戳
long time = System.currentTimeMillis();
String date = Util.FormatDate("yyyy-MM-dd HH:mm:ss",time);

Channel channel = CmsCache.getChannel(id);

int user_id = UserInfoUtil.AuthUserByToken(Token);
UserInfo userinfo = new UserInfo(user_id);

int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);

if(login!=1)
{
	JSONObject o = new JSONObject();
	o.put("status",0);
	o.put("message","登录失败");

	Log.SystemLog("接口调用", "用户："+userinfo.getName()+";接口地址：api/getitems.jsp;参数：page:"+pages+",pagesize:"+pagesize+",Token:"+Token+",id:"+id+";频道名："+channel.getName()+";请求时间："+date+";请求结果：登录失败");

	out.println(o.toString());
	return;
}

//验证用户权限
Boolean isShow = userinfo.hasChannelShowRight(id);
if(!isShow){
	JSONObject o = new JSONObject();
	o.put("status",0);
	o.put("message","用户无权限访问此频道");

	Log.SystemLog("接口调用", "用户："+userinfo.getName()+";接口地址：api/getitems.jsp;参数：page:"+pages+",pagesize:"+pagesize+",Token:"+Token+",id:"+id+";频道名："+channel.getName()+";请求时间："+date+";请求结果：用户无权限访问此频道");

	out.println(o.toString());
	return;
}

if(pages<=0) pages = 1;
if(pagesize<=0 || pagesize>500) pagesize = 50;

PageControl p = new PageControl();
p.setCurrentPage(pages);
p.setRowsPerPage(pagesize);

ArrayList<Document> items = channel.listItems(p,"","");
JSONArray jsonArray = new JSONArray();  
for(int i = 0;i < items.size();i++)
{
	Document item = items.get(i);
	JSONObject o = new JSONObject();
	o.put("id",item.getId());
	o.put("Title",item.getTitle());
	o.put("Href",item.getFullHref());
	jsonArray.put(o);
}

Log.SystemLog("接口调用", "用户："+userinfo.getName()+";接口地址：api/getitems.jsp;参数：page:"+pages+",pagesize:"+pagesize+",Token:"+Token+",id:"+id+";频道名："+channel.getName()+";请求时间："+date+";请求结果：成功");

out.println(jsonArray.toString());
%>