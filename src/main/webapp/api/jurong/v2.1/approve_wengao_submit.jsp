<%@ page import="tidemedia.cms.system.*,java.util.*,org.json.JSONArray,org.json.JSONObject,tidemedia.cms.util.*,java.net.*,java.sql.*,tidemedia.cms.base.*,tidemedia.cms.scheduler.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="appconfig.jsp"%>
<%!
//判断频道是否是选题的子频道（选题父频道，当前频道）
public boolean isTopicChannel(int channelid,int channelid_) throws tidemedia.cms.base.MessageException, java.sql.SQLException,org.json.JSONException{
    boolean flag = false ;

	Channel channel = CmsCache.getChannel(channelid_);
	Channel channel1 = CmsCache.getChannel(channelid);

	String code = channel.getChannelCode();
	String code1 = channel1.getChannelCode();
	if(code.contains(code1)){
		flag = true ;
	}
    return flag ;
}
%>
<%
/**
* 用途：提交审核
*/
int gid = getIntParameter(request,"globalid");
String title = getParameter(request,"title");
title = URLDecoder.decode(title,"utf-8");
int action = getIntParameter(request,"action");
int approveId = getIntParameter(request,"approveId");
int endApprove = getIntParameter(request,"endApprove");
String actionMessage = getParameter(request,"actionMessage");
String user = getParameter(request,"user");//有审核权限的用户
String[] users = user.split(",");


ApproveItems approve_item = new ApproveItems(approveId);
String name = approve_item.getTitle();



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

Document document = new Document(gid);
document.Approve(document.getId()+"",document.getChannelID());
System.out.println("endApprove"+endApprove);
System.out.println("gid"+gid);
System.out.println("action"+action);
System.out.println("approveId"+approveId);
if(endApprove==1){
    
    //改变状态为通过审核
        TableUtil tu = new TableUtil();
        String sql = "UPDATE "+document.getChannel().getTableName()+" SET task_status = 1 WHERE id = "+document.getId();
        int rs = tu.executeUpdate(sql);
    

}
if(action==1){
    //改变状态为通过bigao
        TableUtil tu = new TableUtil();
        String sql = "UPDATE "+document.getChannel().getTableName()+" SET task_status = 2 and Status=0 WHERE id = "+document.getId();
        int rs = tu.executeUpdate(sql);
        System.out.println("改变状态为通过bigao"+sql);
    
}
System.out.println("Cmsuserid:"+userid);
out.println(userid);
%>
