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





Document document = new Document(gid);
document.Approve(document.getId()+"",document.getChannelID());

int channelid = 14271 ;//选题频道编号
    int type=1;
    if(endApprove==1){
        //改变状态为通过审核
        if(isTopicChannel(channelid,document.getChannelID())){
            TableUtil tu = new TableUtil();
            String sql = "UPDATE "+document.getChannel().getTableName()+" SET rwzt = 1 WHERE id = "+document.getId();
            int rs = tu.executeUpdate(sql);
            type=2;
        }
    }
    if(action==1){//改变状态为通过bigao
        if(isTopicChannel(channelid,document.getChannelID())){
            TableUtil tu = new TableUtil();
            String sql = "UPDATE "+document.getChannel().getTableName()+" SET rwzt = 2 WHERE id = "+document.getId();
            int rs = tu.executeUpdate(sql);
            type=3;
        }
    }
    //小米推送
    TideJson jurong = CmsCache.getParameter("jurong").getJson();//聚融接口信息
    String push_url = jurong.getString("push_url");
    if(!push_url.equals("")){
        push_url = push_url+"?type="+type+"&id="+gid;
        push_url = Util.ClearPath(push_url);
        Util.connectHttpUrl(push_url);
    }
System.out.println("Cmsuserid:"+userid);
out.println(userid);
%>
