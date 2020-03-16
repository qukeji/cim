<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String ChannelID			=Util.getParameter(request,"ChannelID");
String Type					=Util.getParameter(request,"Type");
String ChannelName			=Util.getParameter(request,"ChannelName");
String QueryString	="&ChannelID="+ChannelID+"&Type="+Type+"&ChannelName="+ChannelName;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript">
function show(type){
		var	dialog = new top.TideDialog();
		switch(type){
		case "channel":
			dialog.setWidth(600);
			dialog.setHeight(450);
			dialog.setUrl("channel/channel_add.jsp?<%=QueryString%>");
			dialog.setTitle("普通频道");
			dialog.show();break;
		case "channel2":
			dialog.setWidth(600);
			dialog.setHeight(450);
			dialog.setUrl("channel/channel_add.jsp?<%=QueryString%>&Type2=2");
			dialog.setTitle("普通频道");
			dialog.show();break;
		case "MirrorChannel":
			dialog.setWidth(600);
			dialog.setHeight(500);
			dialog.setUrl("channel/mirror_channel_add.jsp?<%=QueryString%>");
			dialog.setTitle("镜像频道");
			dialog.show();break;	
		case "Page":
			tidecms.dialog("page/page_add.jsp?<%=QueryString%>",500,400,"新建页面");
			break;
		case "App":
			dialog.setWidth(500);
			dialog.setHeight(400);
			dialog.setUrl("channel/app_add.jsp?<%=QueryString%>");
			dialog.setTitle("应用程序");
			dialog.show();break;
		case "Photo":
			dialog.setWidth(600);
			dialog.setHeight(450);
			dialog.setUrl("channel/channel_add.jsp?Type2=1<%=QueryString%>");
			dialog.setTitle("图片频道");
			dialog.show();break;
		case "PhotoCollect":
			dialog.setWidth(600);
			dialog.setHeight(450);
			dialog.setUrl("channel/channel_add.jsp?Type2=2<%=QueryString%>");
			dialog.setTitle("图片集频道");
			dialog.show();break;
		case "Special":
			dialog.setWidth(500);
			dialog.setHeight(500);
			dialog.setUrl("channel/channel_special_add.jsp?Type2=2<%=QueryString%>");
			dialog.setTitle("专题频道");
			dialog.show();break;
		}
}

function setReturnValue(o){
	if(o.close==1){
		top.TideDialogClose({refresh:'left'});
	}

	if(o.close==2){
		top.TideDialogClose({});
	}
}
</script>
</head>
<body>
<form>
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m add_channel">
<table  border="0">
<tr>
    <td valign="middle"><input name="Button" type="button" class="tidecms_btn2" value="普通频道" onclick="show('channel')"></td>
    <td valign="middle"><input name="Submit" type="button" class="tidecms_btn2" value="镜像频道"  onclick="show('MirrorChannel')"></td>
  	<td valign="middle"><input name="Button3" type="button" class="tidecms_btn2" value="页面"  onclick="show('Page')"></td>
  	<td valign="middle"><input name="Submit3" type="button" class="tidecms_btn2" value="应用程序"  onclick="show('App')"></td>
  </tr>
 <tr>
    <td valign="middle"><input name="Submit3" type="button" class="tidecms_btn2" value="图片频道"  onclick="show('Photo')"></td>
    <td valign="middle"><input name="Submit3" type="button" class="tidecms_btn2" value="图片集频道"  onclick="show('PhotoCollect')"></td>
  	<td valign="middle"><input name="Submit3" type="button" class="tidecms_btn2" value="专题频道"  onclick="show('Special')"></td>
  	<td valign="middle"><input name="Button" type="button" class="tidecms_btn2" value="数据源频道" onclick="show('channel2')"></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>

<div id="ajax_script" style="display:none;"></div>
</form>
</body>
</html>