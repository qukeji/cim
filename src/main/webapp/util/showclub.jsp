<%@ page import="java.io.File,tidemedia.cms.util.Util,
				tidemedia.cms.system.*"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
String		Status	=	getParameter(request,"Status");
String		vid	=	getParameter(request,"vid");
String		itemid	=	getParameter(request,"itemid");
String		filepath	=	getParameter(request,"filepath");
if(!filepath.contains("http://")){
	filepath="http://upclubv.vodone.com/"+filepath;
}
if(!vid.equals(""))
{
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
<%if(Status.equals("0")){%>
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="480" height="420" id="photo" align="middle">
<param name="movie" value="http://122.11.50.144:8080/player3.swf?flv=<%=filepath%>"/>
<param name="quality" value="high" />
<param name="allowFullScreen" value="true" />
<embed src="http://122.11.50.144:8080/player3.swf?flv=<%=filepath%>" quality="high" width="480" height="420" name="photo" align="middle" type="application/x-shockwave-flash" allowFullScreen="true" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
<%}else if(Status.equals("1")){%>
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0" width="480" height="420" id="photo" align="middle"> 
<param name="movie" value="http://club.vodone.com/images/flashplayer/vodoneplayer.swf?site=http://club.vodone.com&vid=<%=vid%>&itemid=<%=itemid%>" /> 
<param name="quality" value="high" /> 
<param name="allowFullScreen" value="true" /> 
<embed src="http://club.vodone.com/images/flashplayer/vodoneplayer.swf?site=http://club.vodone.com&vid=<%=vid%>&itemid=<%=itemid%>" quality="high" width="480" height="420" name="photo" align="middle" type="application/x-shockwave-flash" allowFullScreen="true" pluginspage="http://www.macromedia.com/go/getflashplayer" /> 
</object>
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