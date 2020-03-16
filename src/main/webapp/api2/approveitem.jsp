 <%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.user.*,
				tidemedia.cms.util.*,
				java.sql.*,
				org.json.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%!
	  public static boolean existglobalid(int globalid) throws MessageException, SQLException{
             Document doc=new Document(globalid);
             if(doc.getGlobalID()==0){
                   return false;
             }else{
                   return true;
             }
        }
%>
<%
String ItemID = "";
String Token = "";
String ChannelID="";
int channelid = 0;
int globalid = 0;
boolean b_itemid = false;
boolean b_channelid = false;
boolean e_globalid=true;
HashMap map = new HashMap();
JSONObject o = new JSONObject();
try{
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
e_globalid=existglobalid(globalid);
int login = 0;
if(Token.length()>0) login = UserInfoUtil.AuthByToken(Token);
channelid = Util.parseInt((String)map.get("ChannelID"));

if(Token.length()==0)
{
	o.put("status",0);
	o.put("message","缺少登录令牌");
}
else if(login!=1)
{
	o.put("status",0);
	o.put("message","登录失败");
}else if(!e_globalid){
	o.put("status",0);
	o.put("message","该全局编号不存在");
	
}
else if(globalid>0&&e_globalid)
{
	Document document = new Document(globalid);
	//document.setUser(16);
	document.Approve(document.getId()+"",document.getChannelID());

	o.put("status",1);
	o.put("message","success");
}
/*else
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
}*/
}catch(Exception e){
		o.put("status",0);
		o.put("message","调用接口失败！");
}
out.println(o.toString());
%>
