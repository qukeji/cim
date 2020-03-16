<%@ page import="tidemedia.cms.util.Push,
				tidemedia.cms.system.Document,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
 
<%@ include file="../config.jsp"%>
<%
	/**
	  *消息推送 
	  *王海龙
	  */
	int gid = getIntParameter(request,"globalid");
	
	HashMap<String,String> map = new HashMap<String,String>();
	Document document = new Document(gid);
	int type = document.getIntValue("type");
	//if(type==1)
	//{//通知
	
	//}
	if(type==2)
	{
		//消息
		map.put("content",document.getContent());//消息内容
	}
	
	int audience_type = document.getIntValue("audience_type");
	
	String audience_type_ = "all";
	String audience = "all";
	
	if(audience_type==2)
	{
		audience = document.getValue("device_tag");
		audience_type_ = "tag";
	}
	else if(audience_type==3)
	{
		audience = document.getValue("device_alias");
		audience_type_ = "alias";
	}
	else if(audience_type==4)
	{
		audience = document.getValue("registration");
		audience_type_ = "registration";
	}
	map.put("id", document.getIntValue("source_gid")+"");//源文章的gid
	map.put("title", document.getTitle());//源文章的标题或推送的标题
	map.put("url", document.getValue("souce_url"));//源文章的url
	map.put("alert", document.getTitle());//推送消息展示，可以为推送频道中文章的标题也可以是源文章的标题
	map.put("platform", document.getValue("platform"));
	map.put("audience_type", audience_type_);//对象类型，值为all,tag,alias registration
	map.put("audience", audience);
	
	boolean result = Push.send(map,type,gid);
	 
%>