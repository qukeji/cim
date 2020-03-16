<%@ page import="java.io.File,tidemedia.cms.util.Util,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
int		ChannelID	=	getIntParameter(request,"ChannelID");
int		ItemID		=	getIntParameter(request,"ItemID");
int		GlobalID	=	getIntParameter(request,"GlobalID");

if(GlobalID!=0)
{
	ItemSnap snap = new ItemSnap(GlobalID);
	ChannelID = snap.getChannelID();
	ItemID = snap.getItemID();
}

String videoid="";
String contentid="";
String catalogcode="";
String		vid	="";
String		itemid2	="";
String		filepath	="";
if(ChannelID!=0 && ItemID!=0)
{
	Document item = new Document(ItemID,ChannelID);
		
	videoid=item.getValue("videoid");
	contentid=item.getValue("contentid");
	catalogcode=item.getValue("catalogcode");
	vid=item.getValue("vid");
	itemid2=item.getValue("itemid");
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>TideCMS</title>
<link href="../style/9/form-common.css" rel="stylesheet" />
<link href="../style/9/form-iframe.css" rel="stylesheet" />
</head>

<body>
<table width="100%" border="0" height="100%" >
  <tr height="100%"><td>
<table border="0" height="100%" width="100%" cellspacing="0" cellpadding="0">
<tr height="8"><td height="8"><div class="form_top"><div class="left"></div><div class="right"></div></div></td></tr>
<tr><td>
    <div class="form_main" style="height:100%">
    	<div class="form_main_m">
<table  border="0">
    <tr>
    <td align="right" valign="middle"></td>
    <td valign="middle">
<%if(ChannelID==4373){%>
<script type="text/javascript">
var _setVideoID="<%=contentid%>"; //设定节目的ID
var _setCatalogCode="<%=catalogcode%>"; //设定节目的栏目code（可选）
//var _setAutoPlay=false; //设定是否自动播放（可选，默认为true）
</script>
<script type="text/javascript" src="http://v.vodone.com/js/player/showConetntPlayer.js"></script>
<%}else if(ChannelID==5017){%>
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="480" height="420" id="photo" align="middle"> 
<param name="movie" value="http://club.vodone.com/images/flashplayer/vodoneplayer.swf?site=http://club.vodone.com&vid=<%=vid%>&itemid=<%=itemid2%>" /> 
<param name="quality" value="high" /> 
<param name="allowFullScreen" value="true" /> 
<embed src="http://club.vodone.com/images/flashplayer/vodoneplayer.swf?site=http://club.vodone.com&vid=<%=vid%>&itemid=<%=itemid2%>" quality="high" width="480" height="420" name="photo" align="middle" type="application/x-shockwave-flash" allowFullScreen="true" pluginspage="http://www.macromedia.com/go/getflashplayer" /> 
</object>
<%}else{%>
<script>
var video_contentid ="<%=videoid%>";
</script>
<script src="http://uflv.vodone.com/qinglv/video.js"></script>
<%}%>
</td>
  </tr>
</table>
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
</div>
</td></tr></table>
</body>
</html>
<%}%>