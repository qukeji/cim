<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
//if(!userinfo_session.isAdministrator())
//{ response.sendRedirect("../noperm.jsp");return;}
if((userinfo_session.isAdministrator() || userinfo_session.isSiteAdministrator()) && userinfo_session.hasPermission("ManageChannel")){}
else{ response.sendRedirect("../noperm.jsp");return;}

request.setCharacterEncoding("utf-8");

String	ChannelID		=	Util.getParameter(request,"ChannelID");
String Type			=	Util.getParameter(request,"Type");
String ChannelName	=	Util.getParameter(request,"ChannelName");

int		SpecialTemplate			= getIntParameter(request,"SpecialTemplate");

if(SpecialTemplate>0)
{
	String	NewChannelName			= getParameter(request,"NewChannelName");
	int		Parent					= getIntParameter(request,"Parent");

	SpecialChannelUtil channelUtil = new SpecialChannelUtil();
	
	channelUtil.setSourceChannelID(SpecialTemplate);
	channelUtil.setNewChannelName(NewChannelName);
	channelUtil.setNewChannelParentID(Parent);
	channelUtil.generateSpecial();

	out.println("<script>top.TideDialogClose({refresh:'left'});</script>");
}
%>
<html>
<head>
<title>TideCMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript" src="../common/jquery.js"></script>
<script language=javascript>
function init()
{

}

function check()
{
	return true;
}

function isEmpty(field,msg)
{	
	if(field.value == "")
	{
		alert(msg);
		field.focus();
		return true;
	}
	return false;
}

function showStep(step)
{
	if(step==2)
	{
		document.getElementById("step1").style.display = "none";
		document.getElementById("step2").style.display = "";

		document.getElementById("stepButton2").style.display = "none";
		document.getElementById("submitButton").style.display = "";
	}
}
</script>
</head>
<body onload="init();" scroll="no">
<form name="form" action="channel_special_add.jsp" method="post" onSubmit="return check();">

<table width="100%" border="0" height="100%" >
  <tr height="100%"><td>
<table border="0" height="100%" width="100%" cellspacing="0" cellpadding="0">
<tr height="8"><td height="8"><div class="form_top"><div class="left"></div><div class="right"></div></div></td></tr>
<tr><td valign="center">
    <div class="form_main" style="height:100%">

<!-- content -->
<div class="content" id="step1">
<div class="viewpane">
<div class="viewpane_tbdoy">
<table width="90%" border="0" class="view_table">
<thead>
		<tr>
    				<th class="v1" width="25" align="center" valign="middle">选择</th>
    				<th class="v3" style="padding-left:10px;text-align:left;">模板名称</th>
    				<th class="v1"	align="center" valign="middle">描述</th>
    				<th class="v8"  align="center" valign="middle">预览</th>
  				</tr>
</thead>
 <tbody> 

  <tr>
    <td class="v1" width="25" align="center" valign="middle"><input type="radio" name="SpecialTemplate" value="4114"></td>
    <td class="v3" style="font-weight:700;">测试</td>
	<td class="v1" align="center" valign="middle">示例专题模板</td>
	<td class="v9">
    <div class="v9_button" onclick="Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></div>
	</td>
  </tr>

  <tr>
    <td class="v1" width="25" align="center" valign="middle"><input type="radio" name="SpecialTemplate" value="4205"></td>
    <td class="v3" style="font-weight:700;">前沿讲座专题</td>
	<td class="v1" align="center" valign="middle">前沿讲座专题</td>
	<td class="v9">
    <div class="v9_button" onclick="Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></div>
	</td>
  </tr>
  <tr>
    <td class="v1" width="25" align="center" valign="middle"><input type="radio" name="SpecialTemplate" value="4227"></td>
    <td class="v3" style="font-weight:700;">长安论坛</td>
	<td class="v1" align="center" valign="middle">长安论坛</td>
	<td class="v9">
    <div class="v9_button" onclick="Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></div>
	</td>
  </tr>
  <tr>
    <td class="v1" width="25" align="center" valign="middle"><input type="radio" name="SpecialTemplate" value="4301"></td>
    <td class="v3" style="font-weight:700;">酷吧熊</td>
	<td class="v1" align="center" valign="middle">酷吧熊</td>
	<td class="v9">
    <div class="v9_button" onclick="Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></div>
	</td>
  </tr>
  <tr>
    <td class="v1" width="25" align="center" valign="middle"><input type="radio" name="SpecialTemplate" value="4335"></td>
    <td class="v3" style="font-weight:700;">中国音乐排行榜</td>
	<td class="v1" align="center" valign="middle">中国音乐排行榜</td>
	<td class="v9">
    <div class="v9_button" onclick="Preview2();"><img src="../images/v9_button_2.gif" title="预览" /></div>
	</td>
  </tr>
 </tbody> 
</table>
</div>
</div>
</div>

<div class="form_main_m">
<div id="step2" style="display:none">
<table  width="90%" border="0">
    <tr>
    <td align="right" valign="middle">专题名称：</td>
    <td valign="middle"><input type="text" name="NewChannelName" id="NewChannelName" class="textfield"/></td>
  </tr>
</table>
</div>
</div>

    </div>
</td></tr>
<tr height="8"><td>
    <div class="form_bottom">
    	<div class="left"></div>
        <div class="right"></div>
    </div>
</td></tr>
</table>
</td></tr><tr><td>
<div class="form_button">
<!-- <input name="startButton" type="button" class="button" value=" 下一步 " id="stepButton2" onClick="showStep(2)"/>
<input name="startButton" type="submit" class="button" value=" 确定 " id="submitButton" onClick="showStep(2)" style="display:none"/>
      &nbsp; <input name="Submit2" type="button" class="button" value="  取  消  " onclick="top.TideDialogClose();">
 -->
<input name="startButton" type="button" class="tidecms_btn2" value=" 下一步 "  id="stepButton2" onClick="showStep(2)"/>
<input name="startButton" type="submit" class="tidecms_btn2" value=" 确定 "  id="submitButton" onClick="showStep(2)" style="display:none"/>
      &nbsp; <input name="Submit2" type="button" class="tidecms_btn2" value="  取  消  " onclick="top.TideDialogClose();"/>
<input type="hidden" name="Parent" value="<%=ChannelID%>">
<input type="hidden" name="ChannelID" value="<%=ChannelID%>">
</div>
</td></tr></table>
</form>
</body>
</html>
