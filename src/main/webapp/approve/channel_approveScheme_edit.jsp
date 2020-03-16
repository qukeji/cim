<%@ page import="java.sql.*,tidemedia.cms.util.*,tidemedia.cms.base.*,tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>

<%
if(!userinfo_session.isAdministrator())
{out.close();return;}

int id = getIntParameter(request,"id");//方案id
int ChannelID = getIntParameter(request,"ChannelID");//频道id
TableUtil tu = new TableUtil();
Channel channel = new Channel(ChannelID);
channel.setActionUser(userinfo_session.getId());
channel.setApproveScheme(id);
channel.Update();
if(id == 0){
	//增加删除审核方案日志（操作类型，频道id，用户id，站点id）
	new Log().ChannelLog(LogAction.channel_del_examine, ChannelID, userinfo_session.getId(),channel.getSiteID());
}else{
	//增加应用审核方案日志（操作类型，频道id，用户id，站点id）
	new Log().ChannelLog(LogAction.channel_appl_examine, ChannelID, userinfo_session.getId(),channel.getSiteID());
}

//清空终审未通过的操作记录
String gids = "";
String ListSql = "select id,GlobalID from "+channel.getTableName();
if(channel.getType()==Channel.Category_Type){
	ListSql += " where Category=" + channel.getId();
}
out.println(ListSql+"<br>");

ResultSet Rs = tu.executeQuery(ListSql);
while(Rs.next())
{
	int GlobalID=Rs.getInt("GlobalID");
	ApproveAction approve = new ApproveAction(GlobalID,0);//最近一次审核操作
	int id_aa = approve.getId();//审核操作id
	int action	= approve.getAction();//是否通过
	int end = approve.getEndApprove();//是否终审
	if(id_aa==0){//未提交审核
		continue ;
	}

	if(action==1||end==0){//不通过或者不是终审
		if(!gids.equals("")){
			gids += ",";
		}
		gids += GlobalID;
	}
}

tu.closeRs(Rs);
out.println(gids+"<br>");
String[] ids = Util.StringToArray(gids, ",");
if (ids != null && ids.length > 0) {
	for (int i = 0; i < ids.length; i++) {
		int id_ = Util.parseInt(ids[i]);
		new ApproveAction().Delete(id_);
	}
}
if (ids != null && ids.length > 0) {
    ApproveDocument.DeleteByGid(gids);
}

out.println("success");
%>
