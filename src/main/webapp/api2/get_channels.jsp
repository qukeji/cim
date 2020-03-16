 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*,
				java.util.regex.Pattern"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
public JSONArray getSubChannel(Channel c)
{
	JSONArray jsonArray;
	try{
	ArrayList<Channel> subchannels = c.listSubChannels();
	jsonArray = new JSONArray(); 
	
	for(int i = 0;i < subchannels.size();i++)
	{
		Channel subchannel=subchannels.get(i);
		JSONObject o = new JSONObject();
		o.put("id",subchannel.getId());
		o.put("name",subchannel.getName());
		o.put("subchannel",getSubChannel(subchannel));
		jsonArray.put(o);
	}
	}catch(Exception e)
	{
		return null;
	}
	return jsonArray;
}
%>
<%
JSONObject o = new JSONObject();
try{
	String Token = getParameter(request,"Token");
	int id = getIntParameter(request,"id"); 

	int login = 0;
	

	if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);
	Channel channel = CmsCache.getChannel(id);

	if(Token.length()==0)
	{
		o.put("status",0);
		o.put("message","缺少登录令牌");
	}
	else if(login!=1)
	{
		o.put("status",0);
		o.put("message","登录失败");
	}
	else if(channel==null){
        o.put("status",0);
	    o.put("message","该频道编号不存在");
	}
	else if(id==0){
		o.put("status",0);
	    o.put("message","该频道编号不存在");
	}
	else  
	{
		o.put("status",1);
		o.put("message","ok");
		o.put("channels",getSubChannel(channel));
	}
}catch(Exception e){
		o.put("status",0);
		o.put("message","调用接口失败");
}
	out.println(o.toString());
%>
