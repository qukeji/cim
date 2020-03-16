<%@ page import="tidemedia.cms.system.*,java.util.*,tidemedia.cms.util.*,java.net.*,java.sql.*,tidemedia.cms.base.*,tidemedia.cms.scheduler.*,org.json.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../../../config1.jsp"%>

<%
/**
* 用途：提交审核
*/

JSONObject json = new JSONObject();
//判断用户是否登录
tidemedia.cms.user.UserInfo userinfo_session = new tidemedia.cms.user.UserInfo();
if(session.getAttribute("CMSUserInfo")!=null)
{
	userinfo_session = (tidemedia.cms.user.UserInfo)session.getAttribute("CMSUserInfo");
}
if(userinfo_session==null || userinfo_session.getId()==0)
{
	json.put("status",500);
	json.put("message","请先登录");
	out.println(json);
	return ;
}

//接收参数
int gid = getIntParameter(request,"globalid");
if(gid==0){
	json.put("status",500);
	json.put("message","请先保存稿件");
	out.println(json);
	return ;
}

String title = getParameter(request,"title");
//title = URLDecoder.decode(title,"utf-8");
int action = getIntParameter(request,"action");
int approveId = getIntParameter(request,"approveId");
int endApprove = getIntParameter(request,"endApprove");
String actionMessage = getParameter(request,"actionMessage");
String user = getParameter(request,"user");//有审核权限的用户
String[] users = user.split(",");
int userid = userinfo_session.getId();//当前用户

try{
	ApproveItems approve_item = new ApproveItems(approveId);
	String name = approve_item.getTitle();

	if(!Arrays.asList(users).contains(userid+"")){
		json.put("status",500);
		json.put("message","当前用户无此环节的审核权限");
		out.println(json);
		return ;
	}

	ApproveAction aa = new ApproveAction();
	aa.setTitle(title);
	aa.setParent(gid);
	aa.setUserid(userid);
	aa.setAction(action);
	aa.setApproveId(approveId);
	aa.setApproveName(name);
	aa.setEndApprove(endApprove);
	aa.setActionMessage(actionMessage);
	aa.Add();

	if(endApprove==1){
		Document document = new Document(gid);
		document.Approve(document.getId()+"",document.getChannelID());
	}

	json.put("status",200);
	json.put("message","提交成功");
	out.println(json);

}catch(Exception e){
	e.printStackTrace();

	json.put("status",200);
	json.put("message","程序异常");
	out.println(json);
} 
%>
