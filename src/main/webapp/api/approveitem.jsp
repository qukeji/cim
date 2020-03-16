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
String ItemID = "";
String Token = "";
String ChannelID="";
int channelid = 0;
int globalid = 0;
boolean b_itemid = false;
boolean b_channelid = false;

HashMap map = new HashMap();

Enumeration paramNames = request.getParameterNames();
while (paramNames.hasMoreElements()) {  
      String p = (String) paramNames.nextElement(); 
	  String v = getParameter(request,p);
	  if(p.equals("ItemID") && v.length()>0) b_itemid = true;
	  if(p.equals("ChannelID") && v.length()>0) b_channelid = true;
	  if(p.equals("Token") && v.length()>0) Token = v;
	  if(p.equals("GlobalID") && v.length()>0) globalid = Integer.parseInt(v);
	  map.put(p,v);
}

int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);
channelid = Util.parseInt((String)map.get("ChannelID"));
JSONObject o = new JSONObject();
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
else if(globalid>0)
{
	Document document = new Document(globalid);
	//document.setUser(16);
	document.Approve(document.getId()+"",document.getChannelID());

	o.put("status",1);
	o.put("message","success");
}
else
{	
	 if(!b_itemid)
	{
		o.put("status",0);
		o.put("message","缺少ItemID");
	}
	 else if(!b_channelid)
	{
		o.put("status",0);
		o.put("message","缺少ChannelID");
	}
	else if(channelid<=0)
	{
		o.put("status",0);
		o.put("message","ChannelID不正确");
	} 
	else{
		//int gid=0;
		//gid = Util.parseInt(GlobalID);
		//Document doc = new Document(gid);
		
		Document document = new Document();
		//document.setUser(16);
		document.Approve((String)map.get("ItemID"),channelid);


		o.put("status",1);
		o.put("message","success");
	}
}

out.println(o.toString());
%>
