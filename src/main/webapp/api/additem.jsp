 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	  public static boolean existchannel(int channelid) throws MessageException, SQLException{
             Channel channel =CmsCache.getChannel(channelid);
             if(channel==null){
                   return false;
             }else{
                   return true;
             }
        }

%>
<%
String Title = "";
String Token = "";
int channelid = 0;

boolean b_title = false;
boolean b_channelid = false;
boolean e_channelid=false;//判断频道编号是否存在

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
		  e_channelid=existchannel(channelid);
	  }
	  map.put(p,v);
}
JSONObject o =new JSONObject();
int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token); 


//JSONObject o = new JSONObject();

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
}
else if(!e_channelid){
        o.put("status",0);
	o.put("message","该频道编号不存在");
}
else
{
	ItemUtil util = new ItemUtil();
	map.put("tidecms_addGlobal","1");
	Document doc = util.addItem(channelid,map);
	int id = doc.getId();
	int gid = doc.getGlobalID();

	o.put("status",1);
	o.put("itemid",id);
	o.put("globalid",gid);
	o.put("message","success");
}

out.println(o.toString());
%>
