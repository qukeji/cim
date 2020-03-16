<%@ page import="tidemedia.cms.system.*,tidemedia.cms.util.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int ChannelID	= getIntParameter(request,"ChannelID");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/tidecms.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="../common/common.js"></script>
<script type="text/javascript">
var ChannelID = <%=ChannelID%>;
function show(type){
		switch(type){
		case "photo":
			this.location="fieldgroup_add.jsp?Type=4&Submit=Submit&ChannelID="+ChannelID;
			break;
		case "video":
			this.location="fieldgroup_add.jsp?Type=5&Submit=Submit&ChannelID="+ChannelID;
			break;
		case "relation":
			this.location="fieldgroup_add.jsp?Type=3&ChannelID="+ChannelID;
			break;	
		case "relation2":
			this.location="fieldgroup_add.jsp?Type=6&ChannelID="+ChannelID;
			break;	
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
    <td valign="middle"><input name="Submit" type="button" class="tidecms_btn2" value="关联组(关联表)"  onclick="show('relation')"></td>
	<td valign="middle"><input name="Submit" type="button" class="tidecms_btn2" value="关联组(Parent字段)"  onclick="show('relation2')"></td>
    <td valign="middle"><input name="Button" type="button" class="tidecms_btn2" value="图片集" onclick="show('photo')"></td>
    <td valign="middle"><input name="Button" type="button" class="tidecms_btn2" value="视频管理" onclick="show('video')"></td>
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