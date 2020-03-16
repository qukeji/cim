 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
String Title = "";
int channelid = 0;
int GlobalID = 0;

boolean b_title = false;
boolean b_channelid = false;
boolean b_globalid = false;
String Token = "";

HashMap map = new HashMap();

Enumeration paramNames = request.getParameterNames();
while (paramNames.hasMoreElements()) {  
      String p = (String) paramNames.nextElement(); 
	  String v = getParameter(request,p);
	  if(p.equals("Title") && v.length()>0) b_title = true;
	  if(p.equals("Token") && v.length()>0) Token = v;
	  if(p.equals("ChannelID") && v.length()>0){
		  channelid = getIntParameter(request,p);
		  b_channelid = true;
	  }
	  if(p.equals("GlobalID") && v.length()>0){
		  GlobalID = getIntParameter(request,p);
		  b_globalid = true;
	  }
	  //out.println(p);

	  map.put(p,v);
}

int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);


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
else if(!b_title)
{
	o.put("status",0);
	o.put("message","缺少标题");
}
else if(!b_channelid)
{
	o.put("status",0);
	o.put("message","缺少频道编号");
}else if(!b_globalid){

	o.put("status",0);
	o.put("message","缺少全局编号");
}
else
{
	ItemUtil util = new ItemUtil();
	util.updateItem(channelid,map,GlobalID,0);
	Document doc = new Document(GlobalID);
	o.put("itemid",doc.getId());
	o.put("channelid",doc.getChannelID());
	o.put("status",1);
}

out.println(o.toString());
%>
