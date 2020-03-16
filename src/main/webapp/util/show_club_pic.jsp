<%@ page import="tidemedia.cms.util.Util"%>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ include file="../config.jsp"%>
<%
	String		vid		= getParameter(request,"vid");
	int		piccount	= getIntParameter(request,"piccount");
%>
<html>
<head>
<title>视频截图</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link href="../style/9/css.css" rel="stylesheet" type="text/css">
<STYLE>

.tab	{	border-top:1px solid buttonshadow;
			border-right:1px solid buttonshadow;
			border-left:1px solid buttonhighlight;
			border-bottom:1px solid buttonshadow;
			font-family:宋体;
			font-size:9pt;
			text-align:center;
			font-weight:normal}

.selTab	{	border-left:1px solid buttonhighhight;
			border-top:none;
			border-right:1px solid black;
			border-bottom:1px solid buttonshadow;
			text-align:center;
			font-family:宋体;
			font-size:9pt;}
.video_player{
	width:607px;
	float:left;
	height: 445px;
}
.img_content{algin:center;}
</STYLE>
</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
  <tr valign="top"> 
    <td align="center">
<div class="img_content">
<%for(int c=0;c<piccount;c++){%>
<img src="http://clubpic.vodone.com/ssvideo/thumb/<%=vid%>/<%=c+1%>.jpg" width="608" height="448"/>
<%}%>
<br>
</div>
	  </td>
  </tr>
</table>
</body>
</html>
