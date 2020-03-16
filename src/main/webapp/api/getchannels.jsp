 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
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
String Token = getParameter(request,"Token");
int id = getIntParameter(request,"id");
JSONArray jsonArray = new JSONArray();  

int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);

if(login==1 && id>0)
{
	Channel channel = CmsCache.getChannel(id);
	ArrayList<Channel> subchannels = channel.listSubChannels();
	for(int i = 0;i < subchannels.size();i++)
	{
		Channel subchannel=subchannels.get(i);
		JSONObject o = new JSONObject();
		o.put("id",subchannel.getId());
		o.put("name",subchannel.getName());
		o.put("subchannel",getSubChannel(subchannel));
		jsonArray.put(o);
	}
}
out.println(jsonArray.toString());
%>