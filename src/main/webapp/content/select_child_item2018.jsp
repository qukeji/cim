<%@ page import="tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		LinkChannelID	=	getIntParameter(request,"LinkChannelID");
int		GlobalID		= getIntParameter(request,"GlobalID");
int		fieldgroup		= getIntParameter(request,"fieldgroup");

Channel channel = CmsCache.getChannel(ChannelID);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="Shortcut Icon" href="favicon.ico">
<title>TideCMS 7 <%=CmsCache.getCompany()%></title>
<style>
html,body{height:100%;}
</style>
<link href="../style/9/menu.css" type="text/css" rel="stylesheet" />
<script type="text/javascript">
var FieldID = "";
var ChannelID = <%=ChannelID%>;

/*
function addDocument(r_itemid,r_channelid)
{
	if(FieldID>0)
	{
		opener.recommendItemJS(r_itemid,r_channelid,0);
		top.close();
	}
	else
	{
		this.location = "document.jsp?ItemID=0&ChannelID=" + <%=ChannelID%> + "&RecommendItemID=" + r_itemid + "&RecommendChannelID=" + r_channelid;
	}
}
*/
</script>
</head>

<body>

<table width="100%" border="0" height="100%">
  <tr height="100%">
    <td width="194" valign="top" id="leftTd"><iframe frameborder="0" src="select_child_channel_tree2018.jsp?ChannelID=<%=ChannelID%>&LinkChannelID=<%=LinkChannelID%>&GlobalID=<%=GlobalID%>&fieldgroup=<%=fieldgroup%>" style="width:100%;height:100%;" name="ifm_left" id="ifm_left"></iframe></td>
    <td width="14" align="center" valign="middle"><a onmousedown="did('split')" id="split" style="cursor:e-resize"><img src="../images/menu_right.png" /></a></td>
    <td valign="top" id="rightTd"><iframe frameborder="0" src="select_child_content2018.jsp?ChannelID=<%=ChannelID%>&LinkChannelID=<%=LinkChannelID%>&GlobalID=<%=GlobalID%>&fieldgroup=<%=fieldgroup%>" style="width:100%;height:100%;" name="ifm_right" id="ifm_right"></iframe></td>
  </tr>
</table>
</body>
</html>