<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.base.*,
				tidemedia.cms.util.*,
				tidemedia.cms.user.*,
				java.util.*,			
				org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%

 

String Token = "";
int userid=0;
JSONObject o = new JSONObject();
try{
int globalid=getIntParameter(request,"globalid");
String token=getParameter(request,"Token");
Token=token;
 JSONArray array=new JSONArray();
/*
int login = 0;
if(Token.length()>0)
{ 
	login = UserInfoUtil.AuthByToken(Token);
    userid=UserInfoUtil.AuthUserByToken(Token);
}*/



if(globalid<=0)
{
	//if(globalid==null||globalid.equals("")){
	o.put("status",0);
	o.put("message","缺少内容编号");
}
/*if(Token.length()==0)
{
	o.put("status",0);
	o.put("message","缺少登录令牌");
}
else if(login!=1)
{
	o.put("status",0);
	o.put("message","登录失败");
}*/
else
{
        Document doc = new Document(globalid);
        if(doc!=null)
        {
        	doc.Delete(doc.getId()+"",doc.getChannelID());
        	o.put("status",1);
			o.put("message","删除成功！");
        }
        else
        {
        	o.put("status",0);
			o.put("message","删除失败！");
        }
		 
}
}catch(Exception e){
	o.put("status",0);
	o.put("message","调用接口失败！");
	
}
out.println(o.toString());
%>
