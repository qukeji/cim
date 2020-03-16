 <%@ page import="tidemedia.cms.system.Document,
				tidemedia.cms.user.UserInfoUtil,
				org.json.JSONObject,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config1.jsp"%>
<%
//通过globalid发布
int globalid = getIntParameter(request,"GlobalID");
String token = getParameter(request,"Token");
int login =UserInfoUtil.AuthByToken(token);
JSONObject o = new JSONObject();
if(login!=1)
{
	o.put("status",0);
	o.put("message","登录失败,请确认Token值是否正确！");
}else if(globalid>0)
{
	Document document = new Document(globalid);
	//document.setUser(16);
	document.Approve(document.getId()+"",document.getChannelID());
	o.put("status",1);
	o.put("message","success");
}

out.println(o.toString());
%>