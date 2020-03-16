<%@ page import="tidemedia.cms.system.*,
				tidemedia.cms.*,
				tidemedia.cms.base.*,
				java.sql.*,
				java.util.concurrent.*,
				java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
     /**
	  * 用途 ：频道迁移
	  * 
	  */
	if(!userinfo_session.isAdministrator())
	{response.sendRedirect("../noperm.jsp");return;}
	
	int channelid=0;
	int parentid=0;
	String Submit="";
	channelid=getIntParameter(request,"channelid");
	parentid=getIntParameter(request,"parentid");
	Submit = getParameter(request,"Submit");
	if(channelid!=0&&parentid!=0&&Submit.length()>0){
		//out.println("在迁移");
		Channel channel = CmsCache.getChannel(parentid);
		int siteid = channel.getSiteID();
		String sql = "update channel set Parent="+parentid+",Site="+siteid+" where id="+channelid;
		TableUtil tu = new TableUtil();
		tu.executeUpdate(sql);
		ConcurrentHashMap channels = CmsCache.getChannels();
		channels.clear();

		//20130306 修改迁移后的channelcode.必须放在clear后，否则channelcode修改不过来
		CmsCache.getChannel(parentid).UpdateChannelCode(parentid);
		//update channel set Site=27 where ChannelCode like '15445%';
		Channel pch = new Channel(parentid);
		sql="update channel set Site="+siteid+" where ChannelCode like '"+pch.getChannelCode()+"%'";
		TableUtil tu2 = new TableUtil();
		tu2.executeUpdate(sql);
		
		ConcurrentHashMap channels_ = CmsCache.getChannels();
		channels_.clear();

		//处理文档中的ChannelCode
		Channel ch = CmsCache.getChannel(channelid);
		tu2.executeUpdate("update "+ch.getTableName()+" as a,channel as b set a.ChannelCode=b.ChannelCode where a.Category=b.id");
		ArrayList array = ch.listAllSubChannels();
		for(int i = 0;i<array.size();i++)
		{
			Channel ch_ = (Channel)array.get(i);
			out.println(ch_.getName());
			if(ch_.getType()==Channel.Channel_Type)
			{
				//独立表单
				//out.println(":"+ch_.getName());
				tu2.executeUpdate("update "+ch_.getTableName()+" as a,channel as b set a.ChannelCode=b.ChannelCode where a.Category=b.id");
			}
		}

		out.println("<script>top.TideDialogClose({refresh:'right'});</script>");
		return;

	}else {
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS 系统工具</title>
<link href="../style/tidecms7.css" type="text/css" rel="stylesheet" />
<link href="../style/smoothness/jquery-ui-1.8.2.custom.css" type="text/css" rel="stylesheet"/>
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script>
function check(){
	//alert("check");
	var channelid=$("#channelid").val();
	var parentid = $("#parentid").val();
	var msg = "确认要迁移频道吗?";
	if(channelid==0){
		alert("输入要迁移的频道编号");
	}else if(parentid==0){
		alert("输入迁移到的频道编号");
	}else if(parentid==channelid){
		alert("两个频道编号不能相同");
		return false;
	}else{
		if(confirm(msg)){
			return true;
		}else{
			return false;
		}
	}
}
</script>
</head>

<body>
<form name="form" action="channel_tools.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
  <tr>
    <td align="right" valign="middle">要迁移的频道编号:</td>
    <td valign="middle"><input type="text" name="channelid" id="channelid"></td>
  </tr>

  <tr>
    <td align="right" valign="middle">迁移到的频道编号:</td>
    <td valign="middle"><input type="text" name="parentid" id="parentid"></td>
  </tr>

</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div class="form_button">
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
<input type="hidden" name="Submit" value="Submit">
</div>
<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>
<%}%>
