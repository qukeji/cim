<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		channelid	=	getIntParameter(request,"ChannelID");
String	sns_tablename	=	getParameter(request,"sns_tablename");
String	ids		=	getParameter(request,"ids");
String	target		=	getParameter(request,"Target");
int  userid		=getIntParameter(request,"userid");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/form-common.css" rel="stylesheet" />
<link href="../style/dialog.css" type="text/css" rel="stylesheet" />

<script language="javascript">  
var ids = "<%=ids%>";
var sns_tablename = "<%=sns_tablename%>";

function next()
{
	if (window.frames["treeFrame"].tree.getSelected())
	{
		var channelid = window.frames["treeFrame"].getChannelID();
		var channeltype = window.frames["treeFrame"].getChannelType();
		//alert(channeltype);
		if(channelid=="" || (channeltype!=1 && channeltype!=0))
		{
			alert("请选择频道.");
			return false;
		}

		var url = "sns_recommend_out_items_submit.jsp?ChannelID=" + channelid 
							+"&RecommendItemID="+ids
							+"&sns_tablename="+sns_tablename
							+"&userid="+<%=userid%>;
		
		document.location = url;
		

		
	}
	else
	{
		alert("请选择频道.");
		return false;
	}
}

</script>
</head>

<body>
<form name="form" action="newfile.jsp" method="post" onSubmit="return check();">
<div class="form_top"><div class="left"></div><div class="right"></div></div>

<div class="form_main">
<div class="form_main_m">
<table  border="0">
<tr>
    <td valign="middle" width="500" height="310"><iframe frameborder=0 scrolling=auto src="sns_recommend_out_channel_tree.jsp?ChannelID=<%=channelid%>" style="height:100%;visibility:inherit;width:100%;" id="treeFrame" name="treeFrame"></iframe></td>
  </tr>
</table>
</div>
</div>

<div class="form_bottom">
    <div class="left"></div>
    <div class="right"></div>
</div>
<div class="form_button">
	<input name="submitButton" type="button" class="button" value="确定" id="submitButton" onClick="next();"/>
	<input name="btnCancel1" type="button" class="button" value="取消"  id="btnCancel1"  onclick="top.TideDialogClose('');"/>
</div>
</form>
</body>
</html>