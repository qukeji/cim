<%@ page import="tidemedia.cms.system.*,org.json.JSONArray,org.json.JSONObject,java.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
/**
  *		修改人		日期		备注
  *
  *		wanghailong	2014/2/8	取消sys_channelid_poll_option参数 改为channel_poll
  *
  *
  */
int itemid			= getIntParameter(request,"itemid");
int globalid		= getIntParameter(request,"globalid");
int channelid_poll_option = getIntParameter(request,"channel_poll");
String	Submit	= getParameter(request,"Submit");
if(!Submit.equals(""))
{
	//int channelid_poll_option = CmsCache.getParameter("sys_channelid_poll_option").getIntValue();
	//if(channelid_poll_option==0) channelid_poll_option = 4;//如果没有定义投票选项频道编号，则编号为4
        
	String	Title				= getParameter(request,"Title");

	HashMap map = new HashMap();
	map.put("Title",Title);
	map.put("Parent",globalid+"");
	map.put("User",userinfo_session.getId()+"");
	map.put("tidecms_addGlobal", "1");

	int tt = ItemUtil.addItemGetID(channelid_poll_option,map);
	out.println("<script>top.TideDialogClose({refresh:'showTab(2);'});</script>");
	return;
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<style>
label{margin:0 0 0 2px;}
</style>
<script type="text/javascript" src="../common/jquery.js"></script>
<script type="text/javascript" src="../common/common.js"></script>
<script language="javascript">
function check()
{
	if(isEmpty(document.form.Title,"请输入选项标题."))
		return false;

   return true;
}
</script>
</head>
<body>
<form name="form" method="post" action="poll_add.jsp" onsubmit="return check();">
<div class="iframe_form">
	<div class="form_top">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
    <div class="form_main">
    	<div class="form_main_m">
<table  border="0" width="100%">
      <tr>
        <td>选项标题：</td>
        <td><input type="text" name="Title" size="40" class="textfield"><input type="hidden" name="channel_poll" value="<%=channelid_poll_option %>"></td>
      </tr>
</table>
		</div>
    </div>
    <div class="form_bottom">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
</div>
<div class="form_button">
	<input name="startButton" type="submit" class="tidecms_btn2" value="确定" id="startButton"/>
	<input name="btnCancel1" type="button" class="tidecms_btn2" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose();"/>
	<input type="hidden" name="Submit" value="Submit"><input type="hidden" name="globalid" value="<%=globalid%>">
</div>
</form>
</body>
</html>
